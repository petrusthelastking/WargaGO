import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Script untuk generate dummy data jenis iuran ke Firestore
/// Run this file to populate jenis_iuran collection with dummy data
class GenerateDummyJenisIuran {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> generate({int count = 20}) async {
    try {
      debugPrint('🚀 Starting to generate $count dummy jenis iuran data...');

      // Data jenis iuran yang realistic
      final List<Map<String, dynamic>> jenisIuranData = [
        {
          'namaIuran': 'Iuran Kebersihan Bulanan',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 50000,
          'deskripsi': 'Iuran rutin untuk kebersihan lingkungan RT/RW',
        },
        {
          'namaIuran': 'Iuran Keamanan Bulanan',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 75000,
          'deskripsi': 'Iuran untuk biaya satpam dan keamanan lingkungan',
        },
        {
          'namaIuran': 'Iuran Sampah Bulanan',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 25000,
          'deskripsi': 'Iuran untuk pengangkutan sampah',
        },
        {
          'namaIuran': 'Iuran Listrik Umum',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 30000,
          'deskripsi': 'Iuran untuk listrik fasilitas umum RT',
        },
        {
          'namaIuran': 'Iuran Air PDAM',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 20000,
          'deskripsi': 'Iuran untuk air bersih fasilitas umum',
        },
        {
          'namaIuran': 'Iuran Pemeliharaan Jalan',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 40000,
          'deskripsi': 'Iuran untuk pemeliharaan jalan lingkungan',
        },
        {
          'namaIuran': 'Iuran Pemeliharaan Taman',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 15000,
          'deskripsi': 'Iuran untuk perawatan taman dan tanaman',
        },
        {
          'namaIuran': 'Iuran Kas RT',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 10000,
          'deskripsi': 'Iuran kas untuk operasional RT',
        },
        {
          'namaIuran': 'Iuran Sosial',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 20000,
          'deskripsi': 'Iuran untuk kegiatan sosial warga',
        },
        {
          'namaIuran': 'Iuran Parkir',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 25000,
          'deskripsi': 'Iuran parkir kendaraan di lingkungan RT',
        },
        {
          'namaIuran': 'Iuran 17 Agustus',
          'kategoriIuran': 'khusus',
          'jumlahIuran': 100000,
          'deskripsi': 'Iuran khusus untuk perayaan kemerdekaan',
        },
        {
          'namaIuran': 'Iuran Hari Raya',
          'kategoriIuran': 'khusus',
          'jumlahIuran': 50000,
          'deskripsi': 'Iuran untuk perayaan hari raya keagamaan',
        },
        {
          'namaIuran': 'Iuran Pembangunan Pos RT',
          'kategoriIuran': 'khusus',
          'jumlahIuran': 500000,
          'deskripsi': 'Iuran untuk pembangunan pos RT baru',
        },
        {
          'namaIuran': 'Iuran Pembangunan Masjid',
          'kategoriIuran': 'khusus',
          'jumlahIuran': 300000,
          'deskripsi': 'Iuran untuk renovasi masjid lingkungan',
        },
        {
          'namaIuran': 'Iuran Tahun Baru',
          'kategoriIuran': 'khusus',
          'jumlahIuran': 75000,
          'deskripsi': 'Iuran untuk perayaan tahun baru',
        },
        {
          'namaIuran': 'Iuran Posyandu',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 15000,
          'deskripsi': 'Iuran untuk kegiatan posyandu',
        },
        {
          'namaIuran': 'Iuran PKK',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 10000,
          'deskripsi': 'Iuran untuk kegiatan PKK',
        },
        {
          'namaIuran': 'Iuran Karang Taruna',
          'kategoriIuran': 'bulanan',
          'jumlahIuran': 20000,
          'deskripsi': 'Iuran untuk kegiatan karang taruna',
        },
        {
          'namaIuran': 'Iuran Perbaikan Selokan',
          'kategoriIuran': 'khusus',
          'jumlahIuran': 200000,
          'deskripsi': 'Iuran khusus untuk perbaikan selokan',
        },
        {
          'namaIuran': 'Iuran Pengaspalan Jalan',
          'kategoriIuran': 'khusus',
          'jumlahIuran': 1000000,
          'deskripsi': 'Iuran untuk pengaspalan jalan lingkungan',
        },
      ];

      int successCount = 0;
      int toGenerate = count.clamp(1, jenisIuranData.length);

      for (int i = 0; i < toGenerate; i++) {
        try {
          final data = jenisIuranData[i];

          // Create jenis iuran document
          final docRef = _firestore.collection('jenis_iuran').doc();

          await docRef.set({
            'namaIuran': data['namaIuran'],
            'kategoriIuran': data['kategoriIuran'],
            'jumlahIuran': data['jumlahIuran'],
            'deskripsi': data['deskripsi'],
            'isActive': true,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

          successCount++;

          if ((i + 1) % 5 == 0) {
            debugPrint('✅ Generated ${i + 1}/$toGenerate jenis iuran...');
          }

        } catch (e) {
          debugPrint('❌ Error generating jenis iuran #${i + 1}: $e');
        }
      }

      debugPrint('');
      debugPrint('🎉 Successfully generated $successCount/$toGenerate dummy jenis iuran data!');
      debugPrint('');
      debugPrint('📊 Summary:');
      debugPrint('   - Total records: $successCount');
      debugPrint('   - Bulanan: ${jenisIuranData.where((d) => d['kategoriIuran'] == 'bulanan').length}');
      debugPrint('   - Khusus: ${jenisIuranData.where((d) => d['kategoriIuran'] == 'khusus').length}');
      debugPrint('   - Total nominal: Rp ${jenisIuranData.take(toGenerate).fold(0, (sum, d) => sum + (d['jumlahIuran'] as int))}');
      debugPrint('');

    } catch (e) {
      debugPrint('❌ Fatal error generating dummy data: $e');
    }
  }

  /// Delete all dummy data (cleanup)
  static Future<void> deleteAll() async {
    try {
      debugPrint('🗑️ Deleting all jenis iuran data...');

      final snapshot = await _firestore.collection('jenis_iuran').get();

      int deleteCount = 0;
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
        deleteCount++;
      }

      debugPrint('✅ Deleted $deleteCount jenis iuran records');
    } catch (e) {
      debugPrint('❌ Error deleting data: $e');
    }
  }
}

