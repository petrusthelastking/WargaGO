// ============================================================================
// WARGA HOME PAGE
// ============================================================================
// Halaman utama untuk warga dengan akses cepat ke berbagai fitur
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_welcome_card.dart';
import '../widgets/home_quick_access_grid.dart';
import '../widgets/home_feature_list.dart';

class WargaHomePage extends StatelessWidget {
  const WargaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Column(
          children: [
            const HomeAppBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                },
                color: const Color(0xFF2F80ED),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const HomeWelcomeCard(
                        userName: 'Ibu Rafa Fadil Aras',
                      ),
                      const SizedBox(height: 28),
                      _buildSectionTitle('Akses cepat'),
                      const SizedBox(height: 16),
                      const HomeQuickAccessGrid(),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Lainnya'),
                      const SizedBox(height: 16),
                      const HomeFeatureList(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
        letterSpacing: -0.2,
      ),
    );
  }
}

