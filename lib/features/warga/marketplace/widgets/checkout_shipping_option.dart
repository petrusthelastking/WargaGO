// ============================================================================
// CHECKOUT SHIPPING OPTION WIDGET
// ============================================================================
// Widget untuk memilih opsi pengiriman
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutShippingOption extends StatelessWidget {
  final String selectedOption;
  final Function(String) onChanged;

  const CheckoutShippingOption({
    super.key,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Opsi Pengiriman',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          InkWell(
            onTap: () => _showShippingOptions(context),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2F80ED).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconForShipping(selectedOption),
                      color: const Color(0xFF2F80ED),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedOption,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Lihat Semua',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF2F80ED),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Color(0xFF2F80ED),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForShipping(String option) {
    switch (option) {
      case 'Pengiriman Reguler':
        return Icons.local_shipping_outlined;
      case 'Pengiriman Express':
        return Icons.two_wheeler_outlined;
      case 'Ambil Sendiri':
        return Icons.store_outlined;
      default:
        return Icons.local_shipping_outlined;
    }
  }

  void _showShippingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pilih Opsi Pengiriman',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildShippingOption(
              context,
              icon: Icons.local_shipping_outlined,
              title: 'Pengiriman Reguler',
              subtitle: 'Estimasi 2-3 hari',
              price: 'Gratis',
              value: 'Pengiriman Reguler',
            ),
            const SizedBox(height: 12),
            _buildShippingOption(
              context,
              icon: Icons.two_wheeler_outlined,
              title: 'Pengiriman Express',
              subtitle: 'Estimasi 1 hari',
              price: 'Rp. 10.000',
              value: 'Pengiriman Express',
            ),
            const SizedBox(height: 12),
            _buildShippingOption(
              context,
              icon: Icons.store_outlined,
              title: 'Ambil Sendiri',
              subtitle: 'Ambil di toko',
              price: 'Gratis',
              value: 'Ambil Sendiri',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String price,
    required String value,
  }) {
    final isSelected = selectedOption == value;
    
    return InkWell(
      onTap: () {
        onChanged(value);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF2F80ED).withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF2F80ED)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2F80ED).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2F80ED),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: price == 'Gratis'
                        ? const Color(0xFF10B981)
                        : const Color(0xFF1F2937),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2F80ED),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Dipilih',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
