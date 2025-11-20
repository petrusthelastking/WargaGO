import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'generate_dummy_pemasukan.dart';

/// Quick script to generate dummy pemasukan
/// Run this with: flutter run -t lib/quick_generate_pemasukan.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('\n========================================');
  print('GENERATE DUMMY PEMASUKAN DATA');
  print('========================================\n');

  try {
    print('[1/3] Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized\n');

    print('[2/3] Generating 50 dummy pemasukan records...');
    await GenerateDummyPemasukan.generate(count: 50);
    print('✅ Generation complete\n');

    print('[3/3] Done!');
    print('\n========================================');
    print('SUCCESS! 50 pemasukan records created');
    print('========================================\n');
    print('Check your Firestore console:');
    print('https://console.firebase.google.com\n');
    print('Or open your main app and go to Keuangan page\n');

  } catch (e) {
    print('\n❌ ERROR: $e\n');
  }
}

