// ============================================================================
// IURAN LIST ITEM WIDGET
// ============================================================================
// Widget item untuk daftar iuran dengan icon, nama, tanggal, dan action buttons
// ✅ UPDATED: Now using TagihanModel from Firestore
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/tagihan_model.dart';
import '../pages/iuran_detail_page.dart';

class IuranListItem extends StatelessWidget {
  final TagihanModel tagihan;

  const IuranListItem({
    super.key,
    required this.tagihan,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to detail page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IuranDetailPage(
              tagihan: tagihan,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: tagihan.statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getStatusIcon(),
                color: tagihan.statusColor,
                size: 24,
            ),
          ),

          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tagihan.jenisIuranName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      tagihan.periode,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tagihan.formattedNominal,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  IconData _getStatusIcon() {
    switch (tagihan.status) {
      case 'Lunas':
        return Icons.check_circle_rounded;
      case 'Belum Dibayar':
        return Icons.account_balance_wallet_rounded;
      case 'Terlambat':
        return Icons.warning_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }
}
