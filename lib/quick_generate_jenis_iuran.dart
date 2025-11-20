import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'generate_dummy_jenis_iuran.dart';

/// Quick script to generate dummy jenis iuran
/// Run this with: flutter run -t lib/quick_generate_jenis_iuran.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('\n========================================');
  print('GENERATE DUMMY JENIS IURAN DATA');
  print('========================================\n');

  try {
    print('[1/3] Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized\n');

    print('[2/3] Generating 20 dummy jenis iuran records...');
    await GenerateDummyJenisIuran.generate(count: 20);
    print('✅ Generation complete\n');

    print('[3/3] Done!');
    print('\n========================================');
    print('SUCCESS! 20 jenis iuran records created');
    print('========================================\n');
    print('Check your Firestore console:');
    print('https://console.firebase.google.com\n');
    print('Or open your main app and go to Kelola Pemasukan > Tab Iuran\n');

  } catch (e) {
    print('\n❌ ERROR: $e\n');
  }
}

