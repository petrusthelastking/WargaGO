// ============================================================================
// CART ITEM CARD WIDGET
// ============================================================================
// Widget untuk menampilkan item produk di keranjang
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItemCard extends StatelessWidget {
  final String productName;
  final String price;
  final int quantity;
  final String? imageUrl;
  final bool isSelected;
  final Function(bool?) onCheckboxChanged;
  final Function(int) onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
    required this.isSelected,
    required this.onCheckboxChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF2F80ED).withValues(alpha: 0.03)
            : Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          Checkbox(
            value: isSelected,
            onChanged: onCheckboxChanged,
            activeColor: const Color(0xFF2F80ED),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Center(
              child: Icon(
                Icons.shopping_basket,
                size: 40,
                color: Colors.grey[400],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2F80ED),
                      ),
                    ),
                    Text(
                      '/kg',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quantity Selector on the right
          Row(
            children: [
              _buildQuantityButton(
                icon: Icons.remove,
                onPressed: quantity > 1
                    ? () => onQuantityChanged(quantity - 1)
                    : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '$quantity',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
              _buildQuantityButton(
                icon: Icons.add,
                onPressed: () => onQuantityChanged(quantity + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onPressed == null
              ? const Color(0xFFF3F4F6)
              : const Color(0xFF2F80ED).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onPressed == null
              ? const Color(0xFF9CA3AF)
              : const Color(0xFF2F80ED),
        ),
      ),
    );
  }
}
