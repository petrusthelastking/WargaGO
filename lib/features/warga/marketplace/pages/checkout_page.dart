// ============================================================================
// CHECKOUT PAGE
// ============================================================================
// Halaman ringkasan pesanan untuk checkout
// ============================================================================

import 'package:flutter/material.dart';
import '../widgets/checkout_header.dart';
import '../widgets/checkout_address_card.dart';
import '../widgets/checkout_product_item.dart';
import '../widgets/checkout_message_field.dart';
import '../widgets/checkout_shipping_option.dart';
import '../widgets/checkout_payment_method.dart';
import '../widgets/checkout_bottom_bar.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String messageToSeller = '';
  String selectedShipping = 'Pengiriman Reguler';
  String selectedPayment = 'Transfer Bank';

  // Helper method untuk mendapatkan biaya pengiriman
  String _getShippingCost() {
    switch (selectedShipping) {
      case 'Pengiriman Reguler':
        return 'Gratis';
      case 'Pengiriman Express':
        return 'Rp. 10.000';
      case 'Ambil Sendiri':
        return 'Gratis';
      default:
        return 'Gratis';
    }
  }

  // Helper method untuk mendapatkan total
  String _getTotalPrice() {
    int productPrice = 10000;
    int shippingCost = 0;
    
    String shipping = _getShippingCost();
    if (shipping != 'Gratis') {
      shippingCost = int.parse(shipping.replaceAll(RegExp(r'[^0-9]'), ''));
    }
    
    int total = productPrice + shippingCost;
    return 'Rp. ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const CheckoutHeader(),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Alamat Pengiriman
                    const CheckoutAddressCard(
                      recipientName: 'Rafa',
                      phoneNumber: '(+62) 858-088-9729',
                      address: 'Jl. Soekarno Hatta No 1, Lowokwaru, Kota Malang, Jawa Timur, 65141',
                    ),

                    const SizedBox(height: 16),

                    // Opsi Pengiriman
                    CheckoutShippingOption(
                      selectedOption: selectedShipping,
                      onChanged: (value) {
                        setState(() {
                          selectedShipping = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Product Item
                    CheckoutProductItem(
                      storeName: 'Toko Sayur Rafcol',
                      productName: 'Sayur Wortel',
                      quantity: 1,
                      unit: 'kg',
                      price: 'Rp.10.000',
                      imageUrl: 'https://via.placeholder.com/60',
                      shippingCost: _getShippingCost(),
                      shippingName: selectedShipping,
                    ),

                    const SizedBox(height: 16),

                    // Pesan untuk Penjual
                    CheckoutMessageField(
                      onChanged: (value) {
                        setState(() {
                          messageToSeller = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Metode Pembayaran
                    CheckoutPaymentMethod(
                      selectedMethod: selectedPayment,
                      onTap: () {
                        // TODO: Show payment method selection
                      },
                    ),

                    const SizedBox(height: 80), // Space for bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CheckoutBottomBar(
        totalPrice: _getTotalPrice(),
        onCheckout: () {
          // TODO: Process checkout
        },
      ),
    );
  }
}
