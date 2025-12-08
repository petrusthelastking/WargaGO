// ============================================================================
// IURAN DETAIL PAGE
// ============================================================================
// Halaman detail ringkasan iuran dengan tombol bayar
// ✅ UPDATED: Now using TagihanModel from Firestore
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/tagihan_model.dart';
import '../widgets/iuran_status_card.dart';
import '../widgets/iuran_info_card.dart';
import '../widgets/iuran_keterangan_card.dart';
import '../widgets/iuran_payment_button.dart';

class IuranDetailPage extends StatelessWidget {
  final TagihanModel tagihan;

  const IuranDetailPage({
    super.key,
    required this.tagihan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Iuran',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  IuranStatusCard(status: tagihan.status),
                  
                  const SizedBox(height: 24),
                  
                  // Info Card
                  IuranInfoCard(
                    namaIuran: tagihan.jenisIuranName,
                    jumlah: tagihan.nominal.toInt(),
                    tanggal: tagihan.formattedPeriodeTanggal,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Keterangan if available
                  if (tagihan.catatan != null && tagihan.catatan!.isNotEmpty)
                    IuranKeteranganCard(keterangan: tagihan.catatan!),
                ],
              ),
            ),
          ),
          
          // Bottom Payment Button (only if not lunas)
          if (tagihan.status != 'Lunas')
            IuranPaymentButton(
              tagihan: tagihan,
            ),
        ],
      ),
    );
  }
}

