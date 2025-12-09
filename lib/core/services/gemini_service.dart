import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  GenerativeModel? _model;

  /// Initialize Gemini model with API key from .env
  void initialize() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (kDebugMode) {
      print('🔧 Initializing Gemini Service...');
      print('API Key exists: ${apiKey != null && apiKey.isNotEmpty}');
    }

    if (apiKey == null || apiKey.isEmpty || apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      throw Exception(
        'Gemini API Key tidak ditemukan! Silakan set GEMINI_API_KEY di file .env'
      );
    }

    // List of model names to try (from most specific to most general)
    final modelNames = [
      'gemini-2.5-flash'
    ];

    Exception? lastError;

    for (final modelName in modelNames) {
      try {
        if (kDebugMode) {
          print('Trying model: $modelName');
        }

        _model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
        );

        if (kDebugMode) {
          print('✅ Successfully initialized with model: $modelName');
        }
        return; // Success!

      } catch (e) {
        if (kDebugMode) {
          print('❌ Failed with $modelName: $e');
        }
        lastError = e as Exception;
        continue;
      }
    }

    // If we get here, all models failed
    throw Exception(
      'Gagal initialize Gemini dengan semua model yang dicoba. '
      'Last error: $lastError'
    );
  }

  /// Get recipe recommendations from PHOTO (Gemini Vision)
  Future<VegetableRecipeResponse> getRecipeRecommendationsFromPhoto({
    required String imagePath,
    required String vegetableName,
    int recipeCount = 3,
  }) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Gemini API Key tidak ditemukan!');
    }

    try {
      if (kDebugMode) {
        print('🔍 Using Gemini Vision for $vegetableName');
        print('📷 Analyzing photo: $imagePath');
      }

      // Create vision model (supports image + text)
      final model = GenerativeModel(
        model: 'gemini-2.5-flash', // Supports vision
        apiKey: apiKey,
      );

      // Read image file
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();

      // Build prompt for vision analysis
      final prompt = _buildVisionRecipePrompt(vegetableName, recipeCount);

      // Create content with image + text
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      if (kDebugMode) {
        print('📤 Sending photo to Gemini Vision...');
      }

      final response = await model.generateContent(content);

      if (kDebugMode) {
        print('📥 Response received from Gemini Vision');
      }

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Empty response from Gemini Vision');
      }

      if (kDebugMode) {
        print('✅ Success with Gemini Vision!');
      }

      return VegetableRecipeResponse(
        vegetableName: vegetableName,
        recipes: _parseRecipeResponse(response.text!),
        rawResponse: response.text!,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Gemini Vision error: $e');
      }
      throw Exception('Error analisis foto dengan Gemini Vision: $e');
    }
  }

  /// Get recipe recommendations based on vegetable name (Text-only)
  Future<VegetableRecipeResponse> getRecipeRecommendations({
    required String vegetableName,
    int recipeCount = 3,
  }) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Gemini API Key tidak ditemukan!');
    }

    // List of models to try in order
    // Trying Gemini 2.0 first, fallback to 1.5 if not free
    final modelNames = [
      'gemini-2.5-flash'
    ];

    Exception? lastError;

    for (final modelName in modelNames) {
      try {
        if (kDebugMode) {
          print('🔍 Trying model: $modelName for $vegetableName');
        }

        // Create new model for each attempt
        final model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
        );

        final prompt = _buildRecipePrompt(vegetableName, recipeCount);
        final content = [Content.text(prompt)];

        if (kDebugMode) {
          print('📤 Sending request to Gemini...');
        }

        final response = await model.generateContent(content);

        if (kDebugMode) {
          print('📥 Response received from $modelName');
        }

        if (response.text == null || response.text!.isEmpty) {
          throw Exception('Empty response from Gemini');
        }

        if (kDebugMode) {
          print('✅ Success with model: $modelName');
        }

        // Success! Save this model for future use
        _model = model;

        return VegetableRecipeResponse(
          vegetableName: vegetableName,
          recipes: _parseRecipeResponse(response.text!),
          rawResponse: response.text!,
        );

      } on GenerativeAIException catch (e) {
        if (kDebugMode) {
          print('❌ Model $modelName failed: ${e.message}');
        }

        // Check if it's quota exceeded error
        if (e.message.contains('quota exceeded') || e.message.contains('Quota exceeded')) {
          if (kDebugMode) {
            print('⚠️  Model $modelName has quota limit 0 (not free), trying next model...');
          }
          lastError = Exception('Quota exceeded: ${e.message}');
          continue; // Skip to next model
        }

        lastError = Exception('Gemini API Error: ${e.message}');
        continue; // Try next model

      } catch (e) {
        if (kDebugMode) {
          print('❌ Model $modelName error: $e');
        }
        lastError = Exception('$e');
        continue; // Try next model
      }
    }

    // All models failed
    throw lastError ?? Exception('Semua model Gemini gagal. Silakan cek API key dan koneksi internet.');
  }

  String _buildVisionRecipePrompt(String vegetableName, int recipeCount) {
    return '''
Analisis foto sayuran ini (${vegetableName}) dan berikan $recipeCount rekomendasi resep masakan Indonesia.

PENTING: Perhatikan kondisi sayuran di foto:
- Tingkat kesegaran (segar/layu)
- Tingkat kematangan
- Ukuran dan bentuk
- Kualitas visual

Berikan rekomendasi resep yang COCOK dengan kondisi sayuran di foto ini.

Format response harus PERSIS seperti ini (gunakan ### sebagai separator antar resep):

NAMA_RESEP: [nama resep]
DESKRIPSI: [deskripsi singkat 1-2 kalimat, sebutkan kenapa cocok dengan kondisi sayuran di foto]
TINGKAT_KESULITAN: [Mudah/Sedang/Sulit]
WAKTU_MEMASAK: [estimasi dalam menit, contoh: 30 menit]
PORSI: [jumlah porsi, contoh: 4 porsi]

BAHAN:
- [bahan 1]
- [bahan 2]
- [dst...]

LANGKAH:
1. [langkah 1]
2. [langkah 2]
3. [dst...]

TIPS:
- [tip 1]
- [tip 2]
- [tip khusus berdasarkan kondisi sayuran di foto]

###

[Resep berikutnya dengan format yang sama...]

Pastikan:
1. Resep disesuaikan dengan kondisi sayuran di foto
2. Jika sayuran sangat segar → resep yang menonjolkan kesegaran (salad, tumis cepat)
3. Jika sayuran kurang segar → resep yang dimasak lama (sup, rebusan, kukus)
4. Sebutkan tips khusus sesuai kondisi sayuran
5. HARUS menggunakan format di atas PERSIS, jangan ada variasi format
''';
  }

  String _buildRecipePrompt(String vegetableName, int recipeCount) {
    return '''
Berikan $recipeCount rekomendasi resep masakan Indonesia yang cocok menggunakan $vegetableName.

Format response harus PERSIS seperti ini (gunakan ### sebagai separator antar resep):

NAMA_RESEP: [nama resep]
DESKRIPSI: [deskripsi singkat 1-2 kalimat]
TINGKAT_KESULITAN: [Mudah/Sedang/Sulit]
WAKTU_MEMASAK: [estimasi dalam menit, contoh: 30 menit]
PORSI: [jumlah porsi, contoh: 4 porsi]

BAHAN:
- [bahan 1]
- [bahan 2]
- [dst...]

LANGKAH:
1. [langkah 1]
2. [langkah 2]
3. [dst...]

TIPS:
- [tip 1]
- [tip 2]

###

[Resep berikutnya dengan format yang sama...]

Pastikan:
1. Semua resep menggunakan $vegetableName sebagai bahan utama
2. Resep mudah dipraktikkan untuk masyarakat Indonesia
3. Bahan-bahan mudah didapat
4. Langkah-langkah jelas dan detail
5. HARUS menggunakan format di atas PERSIS, jangan ada variasi format
''';
  }

  List<RecipeRecommendation> _parseRecipeResponse(String response) {
    try {
      final recipes = <RecipeRecommendation>[];
      final recipeSections = response.split('###').where((s) => s.trim().isNotEmpty).toList();

      for (final section in recipeSections) {
        try {
          final recipe = _parseRecipeSection(section.trim());
          if (recipe != null) {
            recipes.add(recipe);
          }
        } catch (e) {
          // Skip jika gagal parse satu resep
          continue;
        }
      }

      return recipes;
    } catch (e) {
      throw Exception('Error parsing recipe response: $e');
    }
  }

  RecipeRecommendation? _parseRecipeSection(String section) {
    try {
      String? name;
      String? description;
      String? difficulty;
      String? cookingTime;
      String? servings;
      List<String> ingredients = [];
      List<String> steps = [];
      List<String> tips = [];

      // Parse setiap line
      final lines = section.split('\n').where((l) => l.trim().isNotEmpty).toList();
      String currentSection = '';

      for (var line in lines) {
        line = line.trim();

        if (line.startsWith('NAMA_RESEP:')) {
          name = line.replaceFirst('NAMA_RESEP:', '').trim();
        } else if (line.startsWith('DESKRIPSI:')) {
          description = line.replaceFirst('DESKRIPSI:', '').trim();
        } else if (line.startsWith('TINGKAT_KESULITAN:')) {
          difficulty = line.replaceFirst('TINGKAT_KESULITAN:', '').trim();
        } else if (line.startsWith('WAKTU_MEMASAK:')) {
          cookingTime = line.replaceFirst('WAKTU_MEMASAK:', '').trim();
        } else if (line.startsWith('PORSI:')) {
          servings = line.replaceFirst('PORSI:', '').trim();
        } else if (line == 'BAHAN:') {
          currentSection = 'BAHAN';
        } else if (line == 'LANGKAH:') {
          currentSection = 'LANGKAH';
        } else if (line == 'TIPS:') {
          currentSection = 'TIPS';
        } else if (currentSection == 'BAHAN' && line.startsWith('-')) {
          ingredients.add(line.substring(1).trim());
        } else if (currentSection == 'LANGKAH' && RegExp(r'^\d+\.').hasMatch(line)) {
          steps.add(line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim());
        } else if (currentSection == 'TIPS' && line.startsWith('-')) {
          tips.add(line.substring(1).trim());
        }
      }

      // Validasi minimal data
      if (name == null || name.isEmpty) return null;
      if (ingredients.isEmpty) return null;
      if (steps.isEmpty) return null;

      return RecipeRecommendation(
        name: name,
        description: description ?? '',
        difficulty: difficulty ?? 'Sedang',
        cookingTime: cookingTime ?? '30 menit',
        servings: servings ?? '4 porsi',
        ingredients: ingredients,
        steps: steps,
        tips: tips,
      );
    } catch (e) {
      return null;
    }
  }
}

/// Response model untuk rekomendasi resep
class VegetableRecipeResponse {
  final String vegetableName;
  final List<RecipeRecommendation> recipes;
  final String rawResponse;

  VegetableRecipeResponse({
    required this.vegetableName,
    required this.recipes,
    required this.rawResponse,
  });

  bool get hasRecipes => recipes.isNotEmpty;
}

/// Model untuk satu resep
class RecipeRecommendation {
  final String name;
  final String description;
  final String difficulty;
  final String cookingTime;
  final String servings;
  final List<String> ingredients;
  final List<String> steps;
  final List<String> tips;
  final String source; // "AI Generated" atau "Cookpad", "Yummy", dll
  final bool aiGenerated; // true jika dari Gemini AI
  final String? referenceUrl; // URL ke resep asli jika ada

  RecipeRecommendation({
    required this.name,
    required this.description,
    required this.difficulty,
    required this.cookingTime,
    required this.servings,
    required this.ingredients,
    required this.steps,
    required this.tips,
    this.source = 'Gemini AI',
    this.aiGenerated = true,
    this.referenceUrl,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'difficulty': difficulty,
    'cookingTime': cookingTime,
    'servings': servings,
    'ingredients': ingredients,
    'steps': steps,
    'tips': tips,
    'source': source,
    'aiGenerated': aiGenerated,
    'referenceUrl': referenceUrl,
  };
}

