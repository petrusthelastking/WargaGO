import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

/// Service untuk mengambil resep dari website terpercaya
class RecipeWebService {
  static final RecipeWebService _instance = RecipeWebService._internal();
  factory RecipeWebService() => _instance;
  RecipeWebService._internal();

  /// Get recipes from Cookpad Indonesia
  Future<List<ExternalRecipe>> getCookpadRecipes(String vegetableName) async {
    try {
      // Cookpad Indonesia search URL
      final searchQuery = Uri.encodeComponent(vegetableName);
      final url = 'https://cookpad.com/id/cari/$searchQuery';

      if (kDebugMode) {
        print('🔍 Searching Cookpad for: $vegetableName');
        print('📍 URL: $url');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Accept-Language': 'id-ID,id;q=0.9,en-US;q=0.8,en;q=0.7',
        },
      ).timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print('📥 Cookpad response status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        // Parse HTML dengan package html
        final document = html_parser.parse(response.body);
        final recipes = _parseCookpadHTML(document, vegetableName);

        if (kDebugMode) {
          print('✅ Found ${recipes.length} recipes from Cookpad');
          if (recipes.isEmpty) {
            print('⚠️  No recipes found - HTML structure might have changed');
          }
        }

        return recipes;
      } else {
        if (kDebugMode) {
          print('⚠️  Cookpad returned status: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching from Cookpad: $e');
      }
      return [];
    }
  }

  /// Parse Cookpad HTML using html package
  List<ExternalRecipe> _parseCookpadHTML(dom.Document document, String vegetableName) {
    final recipes = <ExternalRecipe>[];

    try {
      // Try multiple selectors (Cookpad structure might vary)

      // Method 1: Search for recipe cards with class
      var recipeElements = document.querySelectorAll('.recipe-preview');

      if (recipeElements.isEmpty) {
        // Method 2: Try alternative class names
        recipeElements = document.querySelectorAll('[class*="recipe"]');
      }

      if (recipeElements.isEmpty) {
        // Method 3: Find all links to /resep/
        final allLinks = document.querySelectorAll('a[href*="/resep/"]');

        for (final link in allLinks.take(3)) {
          final href = link.attributes['href'] ?? '';
          final title = link.text.trim();

          if (title.isNotEmpty && href.isNotEmpty && !recipes.any((r) => r.url.contains(href))) {
            recipes.add(ExternalRecipe(
              name: _cleanText(title),
              url: href.startsWith('http') ? href : 'https://cookpad.com$href',
              source: 'Cookpad Indonesia',
              sourceIcon: 'https://cookpad.com/favicon.ico',
              verified: true,
            ));

            if (recipes.length >= 3) break;
          }
        }
      } else {
        // Parse recipe elements
        for (final element in recipeElements.take(3)) {
          final linkElement = element.querySelector('a[href*="/resep/"]');
          final titleElement = element.querySelector('.recipe-title, [class*="title"]') ?? linkElement;

          if (linkElement != null && titleElement != null) {
            final href = linkElement.attributes['href'] ?? '';
            final title = titleElement.text.trim();

            if (title.isNotEmpty && href.isNotEmpty) {
              recipes.add(ExternalRecipe(
                name: _cleanText(title),
                url: href.startsWith('http') ? href : 'https://cookpad.com$href',
                source: 'Cookpad Indonesia',
                sourceIcon: 'https://cookpad.com/favicon.ico',
                verified: true,
              ));
            }
          }
        }
      }

      if (kDebugMode && recipes.isEmpty) {
        print('⚠️  Debug: Trying to find any recipe links in HTML...');
        final allText = document.body?.text ?? '';
        print('📄 Page contains "${vegetableName}": ${allText.toLowerCase().contains(vegetableName.toLowerCase())}');
      }

    } catch (e) {
      if (kDebugMode) {
        print('❌ Error parsing Cookpad HTML: $e');
      }
    }

    return recipes;
  }

  /// Get recipes from Yummy Indonesia (alternative)
  Future<List<ExternalRecipe>> getYummyRecipes(String vegetableName) async {
    try {
      final searchQuery = Uri.encodeComponent(vegetableName);
      final url = 'https://yummy.co.id/search?q=$searchQuery';

      if (kDebugMode) {
        print('🔍 Searching Yummy for: $vegetableName');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final recipes = _parseYummyHTML(document, vegetableName);

        if (kDebugMode) {
          print('✅ Found ${recipes.length} recipes from Yummy');
        }

        return recipes;
      }

      return [];
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching from Yummy: $e');
      }
      return [];
    }
  }

  List<ExternalRecipe> _parseYummyHTML(dom.Document document, String vegetableName) {
    final recipes = <ExternalRecipe>[];

    try {
      // Find recipe links
      final recipeLinks = document.querySelectorAll('a[href*="/recipe/"]');

      for (final link in recipeLinks.take(3)) {
        final href = link.attributes['href'] ?? '';
        final title = link.text.trim();

        if (title.isNotEmpty && href.isNotEmpty && !recipes.any((r) => r.url.contains(href))) {
          recipes.add(ExternalRecipe(
            name: _cleanText(title),
            url: href.startsWith('http') ? href : 'https://yummy.co.id$href',
            source: 'Yummy Indonesia',
            sourceIcon: 'https://yummy.co.id/favicon.ico',
            verified: true,
          ));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error parsing Yummy HTML: $e');
      }
    }

    return recipes;
  }

  /// Get recipes from trusted Indonesian recipe websites (Direct Search Fallback)
  Future<List<ExternalRecipe>> getRecipesFromGoogleSearch(String vegetableName) async {
    try {
      if (kDebugMode) {
        print('🔍 Searching trusted websites for: resep $vegetableName');
      }

      final recipes = <ExternalRecipe>[];

      // Direct search ke website terpercaya (tanpa Google)
      // Method lebih simple dan reliable

      // 1. Try Endeus.tv
      try {
        final endeusRecipes = await _searchEndeusTV(vegetableName);
        recipes.addAll(endeusRecipes);
      } catch (e) {
        if (kDebugMode) print('⚠️  Endeus.tv error: $e');
      }

      // 2. Try ResepKoki.id
      if (recipes.length < 3) {
        try {
          final resepKokiRecipes = await _searchResepKoki(vegetableName);
          recipes.addAll(resepKokiRecipes);
        } catch (e) {
          if (kDebugMode) print('⚠️  ResepKoki error: $e');
        }
      }

      if (kDebugMode) {
        print('✅ Found ${recipes.length} recipes from trusted websites');
      }

      return recipes.take(3).toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in trusted websites fallback: $e');
      }
      return [];
    }
  }

  /// Search Endeus.tv directly
  Future<List<ExternalRecipe>> _searchEndeusTV(String vegetableName) async {
    final recipes = <ExternalRecipe>[];

    try {
      final searchQuery = Uri.encodeComponent(vegetableName);
      final url = 'https://endeus.tv/?s=$searchQuery';

      if (kDebugMode) {
        print('🔍 Searching Endeus.tv: $url');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);

        if (kDebugMode) {
          print('📄 Endeus.tv response received, parsing...');
        }

        // Try multiple selectors
        var links = document.querySelectorAll('article a[href*="endeus.tv"]');

        if (links.isEmpty) {
          links = document.querySelectorAll('a[href*="endeus.tv/resep"]');
        }

        if (links.isEmpty) {
          // Try any link containing endeus.tv
          links = document.querySelectorAll('a[href*="endeus.tv"]');
        }

        if (kDebugMode) {
          print('🔗 Found ${links.length} links from Endeus.tv');
        }

        for (final link in links.take(3)) {
          final href = link.attributes['href'] ?? '';

          // Skip non-recipe links
          if (href.contains('/category/') ||
              href.contains('/tag/') ||
              href == 'https://endeus.tv' ||
              href == 'https://endeus.tv/') {
            continue;
          }

          // Get title from link text or child elements
          var title = link.text.trim();
          if (title.isEmpty) {
            final titleElement = link.querySelector('h2, h3, h4, .title, .entry-title');
            title = titleElement?.text.trim() ?? '';
          }

          if (href.isNotEmpty &&
              title.isNotEmpty &&
              href.startsWith('http') &&
              !recipes.any((r) => r.url == href)) {

            if (kDebugMode) {
              print('✅ Endeus.tv recipe: $title');
              print('🔗 URL: $href');
            }

            recipes.add(ExternalRecipe(
              name: _cleanText(title),
              url: href,
              source: 'Endeus TV',
              sourceIcon: 'https://endeus.tv/favicon.ico',
              verified: true,
            ));

            if (recipes.length >= 2) break;
          }
        }

        if (kDebugMode && recipes.isEmpty) {
          print('⚠️  No recipes extracted from Endeus.tv HTML');
        }
      } else {
        if (kDebugMode) {
          print('⚠️  Endeus.tv returned status: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error searching Endeus.tv: $e');
      }
    }

    return recipes;
  }

  /// Search ResepKoki.id directly
  Future<List<ExternalRecipe>> _searchResepKoki(String vegetableName) async {
    final recipes = <ExternalRecipe>[];

    try {
      final searchQuery = Uri.encodeComponent(vegetableName);
      final url = 'https://resepkoki.id/?s=$searchQuery';

      if (kDebugMode) {
        print('🔍 Searching ResepKoki.id: $url');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);

        if (kDebugMode) {
          print('📄 ResepKoki.id response received, parsing...');
        }

        // Try multiple selectors
        var links = document.querySelectorAll('a[href*="resepkoki.id/resep"]');

        if (links.isEmpty) {
          links = document.querySelectorAll('article a[href*="resepkoki.id"]');
        }

        if (links.isEmpty) {
          // Try any recipe-related link
          links = document.querySelectorAll('a[href*="resepkoki.id"]');
        }

        if (kDebugMode) {
          print('🔗 Found ${links.length} links from ResepKoki');
        }

        for (final link in links.take(3)) {
          final href = link.attributes['href'] ?? '';

          // Skip non-recipe links
          if (href.contains('/category') ||
              href.contains('/tag') ||
              href.contains('/author') ||
              href == 'https://resepkoki.id' ||
              href == 'https://resepkoki.id/') {
            continue;
          }

          // Get title
          var title = link.text.trim();
          if (title.isEmpty) {
            final titleElement = link.querySelector('h2, h3, h4, .title, .entry-title');
            title = titleElement?.text.trim() ?? '';
          }

          // Also try parent element title
          if (title.isEmpty) {
            final parent = link.parent;
            final parentTitle = parent?.querySelector('h2, h3, h4');
            title = parentTitle?.text.trim() ?? '';
          }

          if (href.isNotEmpty &&
              title.isNotEmpty &&
              href.startsWith('http') &&
              href.contains('/resep/') &&
              !recipes.any((r) => r.url == href)) {

            if (kDebugMode) {
              print('✅ ResepKoki recipe: $title');
              print('🔗 URL: $href');
            }

            recipes.add(ExternalRecipe(
              name: _cleanText(title),
              url: href,
              source: 'Resep Koki',
              sourceIcon: 'https://resepkoki.id/favicon.ico',
              verified: true,
            ));

            if (recipes.length >= 2) break;
          }
        }

        if (kDebugMode && recipes.isEmpty) {
          print('⚠️  No recipes extracted from ResepKoki HTML');
        }
      } else {
        if (kDebugMode) {
          print('⚠️  ResepKoki returned status: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error searching ResepKoki: $e');
      }
    }

    return recipes;
  }

  String _getSourceName(String domain) {
    switch (domain) {
      case 'endeus.tv':
        return 'Endeus TV';
      case 'resepkoki.id':
        return 'Resep Koki';
      case 'masakapahariini.com':
        return 'Masak Apa Hari Ini';
      case 'sajian.com':
        return 'Sajian Sedap';
      default:
        return domain;
    }
  }

  /// Get recipes from all sources (parallel) with Google fallback
  Future<List<ExternalRecipe>> getAllRecipes(String vegetableName) async {
    try {
      if (kDebugMode) {
        print('🌐 Fetching recipes from all sources for: $vegetableName');
      }

      // Try primary sources first (Cookpad + Yummy)
      final results = await Future.wait([
        getCookpadRecipes(vegetableName),
        getYummyRecipes(vegetableName),
      ]);

      final allRecipes = <ExternalRecipe>[];
      for (final recipeList in results) {
        allRecipes.addAll(recipeList);
      }

      if (kDebugMode) {
        print('📊 Primary sources found: ${allRecipes.length} recipes');
      }

      // FALLBACK: If no recipes found, try Google Search
      if (allRecipes.isEmpty) {
        if (kDebugMode) {
          print('🔄 No recipes from primary sources, trying Google Search fallback...');
        }

        final googleRecipes = await getRecipesFromGoogleSearch(vegetableName);
        allRecipes.addAll(googleRecipes);

        if (kDebugMode) {
          print('📊 Google Search found: ${googleRecipes.length} recipes');
        }
      }

      if (kDebugMode) {
        print('✅ Total recipes found: ${allRecipes.length}');
      }

      return allRecipes;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting all recipes: $e');
      }
      return [];
    }
  }

  String _cleanText(String text) {
    return text
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
        .replaceAll(RegExp(r'^\s+|\s+$'), '') // Trim
        .trim();
  }
}

/// Model untuk resep dari website external
class ExternalRecipe {
  final String name;
  final String url;
  final String source; // "Cookpad Indonesia", "Yummy", etc
  final String sourceIcon; // URL to favicon/logo
  final bool verified;

  ExternalRecipe({
    required this.name,
    required this.url,
    required this.source,
    required this.sourceIcon,
    this.verified = true,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'url': url,
    'source': source,
    'sourceIcon': sourceIcon,
    'verified': verified,
  };
}

