// ============================================================================
// CART SELLER GROUP WIDGET
// ============================================================================
// Widget untuk menampilkan grup produk per seller
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_item_card.dart';

class CartSellerGroup extends StatelessWidget {
  final String sellerName;
  final List<Map<String, dynamic>> items;
  final Function(bool?) onSellerToggle;
  final Function(int, bool?) onItemToggle;
  final Function(int, int) onQuantityChanged;

  const CartSellerGroup({
    super.key,
    required this.sellerName,
    required this.items,
    required this.onSellerToggle,
    required this.onItemToggle,
    required this.onQuantityChanged,
  });

  bool get isAllSelected => items.every((item) => item['isSelected'] == true);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seller Header with Checkbox
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Checkbox(
                  value: isAllSelected,
                  onChanged: onSellerToggle,
                  activeColor: const Color(0xFF2F80ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F80ED).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.store,
                    size: 20,
                    color: Color(0xFF2F80ED),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sellerName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          
          // Items List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFE5E7EB),
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return CartItemCard(
                productName: item['name'],
                price: item['price'],
                quantity: item['quantity'],
                imageUrl: item['image'],
                isSelected: item['isSelected'],
                onCheckboxChanged: (value) => onItemToggle(index, value),
                onQuantityChanged: (newQuantity) => onQuantityChanged(index, newQuantity),
              );
            },
          ),
        ],
      ),
    );
  }
}
