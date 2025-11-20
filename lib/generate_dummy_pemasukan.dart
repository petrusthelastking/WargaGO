import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Script untuk generate dummy data pemasukan ke Firestore
/// Run this file to populate pemasukan_lain collection with dummy data
class GenerateDummyPemasukan {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> generate({int count = 50}) async {
    try {
      debugPrint('🚀 Starting to generate $count dummy pemasukan data...');

      final List<String> categories = [
        'Iuran Warga',
        'Donasi',
        'Dana Pemerintah',
        'Kegiatan',
        'Sewa Fasilitas',
        'Lainnya',
      ];

      final List<String> names = [
        'Iuran Bulanan RT/RW',
        'Iuran Kebersihan',
        'Iuran Keamanan',
        'Donasi Warga',
        'Donasi Pembangunan',
        'Dana Bantuan Pemerintah',
        'Dana Kegiatan 17 Agustus',
        'Dana PKK',
        'Dana Posyandu',
        'Sewa Aula',
        'Sewa Lapangan',
        'Iuran Sampah',
        'Dana Kerja Bakti',
        'Infaq Warga',
        'Sumbangan Pembangunan Pos',
        'Dana Gotong Royong',
        'Iuran Listrik Umum',
        'Dana Peringatan Hari Besar',
        'Sewa Parkir',
        'Dana Sosial',
      ];

      final List<String> sumber = [
        'Warga RT 01',
        'Warga RT 02',
        'Warga RT 03',
        'Ketua RT',
        'Bendahara RT',
        'Sekretaris RT',
        'Donatur Anonim',
        'Kumpulan Warga',
        'Pengurus RT/RW',
        'Pemerintah Kelurahan',
        'Dinas Sosial',
        'Dana Desa',
        'Karang Taruna',
        'PKK',
        'Posyandu',
        'Pengajian Rutin',
        'Arisan RT',
        'Kas RT',
        'Usaha RT',
        'Lain-lain',
      ];

      final List<String> deskripsi = [
        'Pemasukan rutin dari iuran warga RT/RW',
        'Donasi sukarela dari warga untuk pembangunan',
        'Bantuan dana dari pemerintah untuk RT/RW',
        'Dana dari kegiatan kemasyarakatan',
        'Pemasukan dari sewa fasilitas RT',
        'Dana sosial untuk kegiatan warga',
        'Iuran bulanan untuk operasional RT',
        'Sumbangan pembangunan fasilitas umum',
        'Dana kegiatan hari besar nasional',
        'Pemasukan lain-lain untuk kas RT',
      ];

      final now = DateTime.now();
      int successCount = 0;

      for (int i = 0; i < count; i++) {
        try {
          // Random date dalam 6 bulan terakhir
          final randomDays = (i * 180 / count).floor();
          final tanggal = now.subtract(Duration(days: randomDays));

          // Random nominal antara 100k - 10jt
          final baseNominal = [
            100000, 150000, 200000, 250000, 300000,
            500000, 750000, 1000000, 1500000, 2000000,
            3000000, 5000000, 7500000, 10000000
          ];
          final nominal = baseNominal[i % baseNominal.length].toDouble();

          // Random category
          final category = categories[i % categories.length];

          // Random name
          final name = names[i % names.length];

          // Random sumber
          final sumberName = sumber[i % sumber.length];

          // Random deskripsi
          final desc = deskripsi[i % deskripsi.length];

          // Create pemasukan document
          final docRef = _firestore.collection('pemasukan_lain').doc();

          await docRef.set({
            'name': '$name ${i + 1}',
            'category': category,
            'nominal': nominal,
            'deskripsi': desc,
            'tanggal': Timestamp.fromDate(tanggal),
            'sumber': sumberName,
            'createdBy': 'system_generator@admin.com',
            'createdAt': Timestamp.now(),
            'updatedAt': Timestamp.now(),
            'isActive': true,
            'bukti': null,
          });

          successCount++;

          if ((i + 1) % 10 == 0) {
            debugPrint('✅ Generated ${i + 1}/$count pemasukan...');
          }

        } catch (e) {
          debugPrint('❌ Error generating pemasukan #${i + 1}: $e');
        }
      }

      debugPrint('');
      debugPrint('🎉 Successfully generated $successCount/$count dummy pemasukan data!');
      debugPrint('');
      debugPrint('📊 Summary:');
      debugPrint('   - Total records: $successCount');
      debugPrint('   - Categories: ${categories.length} types');
      debugPrint('   - Date range: Last 6 months');
      debugPrint('   - Nominal range: Rp 100.000 - Rp 10.000.000');
      debugPrint('');

    } catch (e) {
      debugPrint('❌ Fatal error generating dummy data: $e');
    }
  }

  /// Delete all dummy data (cleanup)
  static Future<void> deleteAll() async {
    try {
      debugPrint('🗑️ Deleting all pemasukan data...');

      final snapshot = await _firestore.collection('pemasukan_lain').get();

      int deleteCount = 0;
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
        deleteCount++;
      }

      debugPrint('✅ Deleted $deleteCount pemasukan records');
    } catch (e) {
      debugPrint('❌ Error deleting data: $e');
    }
  }

  /// Delete only dummy data (created by system_generator)
  static Future<void> deleteDummyOnly() async {
    try {
      debugPrint('🗑️ Deleting dummy pemasukan data...');

      final snapshot = await _firestore
          .collection('pemasukan_lain')
          .where('createdBy', isEqualTo: 'system_generator@admin.com')
          .get();

      int deleteCount = 0;
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
        deleteCount++;
      }

      debugPrint('✅ Deleted $deleteCount dummy pemasukan records');
    } catch (e) {
      debugPrint('❌ Error deleting dummy data: $e');
    }
  }
}

