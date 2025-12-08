// ============================================================================
// WARGA HOME PAGE
// ============================================================================
// Halaman utama untuk warga dengan desain modern dan menarik
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/services/kyc_service.dart';
import '../../../../core/enums/kyc_enum.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_kyc_alert.dart';
import '../widgets/home_info_cards.dart';
import '../widgets/home_quick_access_grid.dart';
import '../widgets/home_feature_list.dart';
import '../widgets/home_news_carousel.dart';
import '../widgets/home_upcoming_events.dart';
import '../widgets/home_emergency_contacts.dart';

class WargaHomePage extends StatefulWidget {
  const WargaHomePage({super.key});

  @override
  State<WargaHomePage> createState() => _WargaHomePageState();
}

class _WargaHomePageState extends State<WargaHomePage> {
  final KYCService _kycService = KYCService();
  int _refreshCounter = 0; // ⭐ Add refresh counter to force rebuild

  // ⭐ Method to force refresh
  void _forceRefresh() {
    setState(() {
      _refreshCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.userModel;
        final userName = user?.nama ?? 'Warga';
        final userStatus = user?.status ?? 'unverified';
        final userId = user?.id;

        if (kDebugMode) {
          print('🏠 WargaHomePage rebuild');
          print('   User: $userName');
          print('   Status: $userStatus');
          print('   User ID: $userId');
        }

        // If no user ID, show basic UI
        if (userId == null) {
          return _buildBasicScaffold(userName, authProvider);
        }

        // Stream KYC documents to check actual upload status
        return StreamBuilder<QuerySnapshot>(
          stream: _kycService.getUserKYCDocuments(userId),
          builder: (context, snapshot) {
            // Determine KYC status from actual documents
            bool hasKTPDocument = false;
            bool hasKKDocument = false;
            KYCStatus? ktpStatus;
            KYCStatus? kkStatus;

            if (kDebugMode) {
              print('🔍 ========== KYC STATUS CHECK ==========');
              print('📦 Snapshot hasData: ${snapshot.hasData}');
              print('📦 Document count: ${snapshot.data?.docs.length ?? 0}');
            }

            if (snapshot.hasData && snapshot.data != null) {
              for (var doc in snapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                final docTypeStr = data['documentType'] as String?;
                final statusStr = data['status'] as String?;

                if (kDebugMode) {
                  print('📄 Document ID: ${doc.id}');
                  print('   Type: $docTypeStr');
                  print('   Status: $statusStr');
                  print('   Raw data: $data');
                }

                if (docTypeStr == 'ktp') {
                  hasKTPDocument = true;
                  // Case-insensitive status parsing
                  ktpStatus = KYCStatus.values.firstWhere(
                    (e) => e.toString().split('.').last.toLowerCase() == statusStr?.toLowerCase(),
                    orElse: () => KYCStatus.pending,
                  );
                  if (kDebugMode) {
                    print('   ✅ KTP detected - Parsed status: $ktpStatus');
                  }
                } else if (docTypeStr == 'kk') {
                  hasKKDocument = true;
                  // Case-insensitive status parsing
                  kkStatus = KYCStatus.values.firstWhere(
                    (e) => e.toString().split('.').last.toLowerCase() == statusStr?.toLowerCase(),
                    orElse: () => KYCStatus.pending,
                  );
                  if (kDebugMode) {
                    print('   ✅ KK detected - Parsed status: $kkStatus');
                  }
                }
              }
            }

            // Determine overall KYC completion status
            // Complete: KTP is approved (KK is OPTIONAL)
            // Pending: KTP uploaded but not approved yet
            // Incomplete: No KTP uploaded

            // ⭐ UPDATED: KK is optional, only KTP is required
            bool isKycComplete = hasKTPDocument && ktpStatus == KYCStatus.approved;

            // ⭐ UPDATED: Pending if KTP exists but not approved yet
            bool isKycPending = hasKTPDocument &&
                               !isKycComplete &&
                               ktpStatus != KYCStatus.rejected;

            if (kDebugMode) {
              print('🎯 ========== FINAL STATUS ==========');
              print('   👤 User Status: $userStatus');
              print('   📄 Has KTP: $hasKTPDocument (Status: $ktpStatus) - REQUIRED');
              print('   📄 Has KK: $hasKKDocument (Status: $kkStatus) - OPTIONAL');
              print('   🔍 KTP == approved? ${ktpStatus == KYCStatus.approved}');
              print('   ✅ isKycComplete: $isKycComplete (KTP approved = complete)');
              print('   ⏳ isKycPending: $isKycPending');
              print('   🎯 Show KYC Alert: ${!isKycComplete}');
              if (!isKycComplete && hasKTPDocument) {
                print('   ⚠️ ALERT AKAN MUNCUL KARENA:');
                if (!hasKTPDocument) {
                  print('      - KTP belum ada (WAJIB)');
                } else if (ktpStatus != KYCStatus.approved) {
                  print('      - KTP status: $ktpStatus (harus approved)');
                }
              } else if (!isKycComplete && !hasKTPDocument) {
                print('   ⚠️ ALERT AKAN MUNCUL KARENA:');
                print('      - KTP belum di-upload (WAJIB)');
              }
              print('========================================');
            }

            return Scaffold(
              backgroundColor: const Color(0xFFF8F9FD),
              body: SafeArea(
                child: Column(
                  children: [
                    // 1. App Bar (Header)
                    HomeAppBar(
                      notificationCount: 3,
                      userName: userName,
                    ),

                    // 2. Scrollable Content (termasuk KYC Alert di dalamnya)
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          // Refresh user data from Firestore
                          await authProvider.refreshUserData();
                          // ⭐ Force rebuild to ensure fresh data
                          _forceRefresh();
                          // ⭐ Small delay to ensure stream updates
                          await Future.delayed(const Duration(milliseconds: 500));
                        },
                        color: const Color(0xFF2F80ED),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // KYC Alert - Sekarang di dalam scroll (ikut scroll)
                              if (!isKycComplete)
                                Column(
                                  children: [
                                    HomeKycAlert(
                                      isKycComplete: isKycComplete,
                                      isKycPending: isKycPending,
                                      onUploadTap: () {
                                        context.push(AppRoutes.wargaKYC);
                                      },
                                    ),
                                    // ⭐ DEBUG INFO (only in debug mode)
                                    if (kDebugMode && isKycPending) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.orange.withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '🔍 DEBUG INFO (Dev Mode)',
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.orange[800],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'KTP: ${hasKTPDocument ? "Ada ($ktpStatus)" : "Tidak ada"}\n'
                                              'KK: ${hasKKDocument ? "Ada ($kkStatus)" : "Tidak ada"}\n'
                                              'User Status: $userStatus\n'
                                              'Refresh Counter: $_refreshCounter',
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                color: Colors.orange[700],
                                                height: 1.4,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            ElevatedButton.icon(
                                              onPressed: _forceRefresh,
                                              icon: const Icon(Icons.refresh, size: 16),
                                              label: Text(
                                                'Force Refresh',
                                                style: GoogleFonts.poppins(fontSize: 11),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),

                              if (!isKycComplete) const SizedBox(height: 16),

                              // News Carousel - Berita & Pengumuman
                              const HomeNewsCarousel(),
                              const SizedBox(height: 24),


                              // Info Cards
                              const HomeInfoCards(),
                              const SizedBox(height: 28),


                              // Quick Access Section
                              _buildSectionTitle('Akses Cepat'),
                              const SizedBox(height: 16),
                              const HomeQuickAccessGrid(),
                              const SizedBox(height: 28),

                              // Upcoming Events - Kegiatan Mendatang
                              const HomeUpcomingEvents(),
                              const SizedBox(height: 24),

                              // Emergency Contacts - Kontak Darurat
                              const HomeEmergencyContacts(),
                              const SizedBox(height: 24),

                              // Feature List Section
                              _buildSectionTitle('Fitur Lainnya'),
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
          },
        );
      },
    );
  }

  Scaffold _buildBasicScaffold(String userName, AuthProvider authProvider) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Column(
          children: [
            HomeAppBar(
              notificationCount: 3,
              userName: userName,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await authProvider.refreshUserData();
                },
                color: const Color(0xFF2F80ED),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeNewsCarousel(),
                      const SizedBox(height: 24),
                      const HomeInfoCards(),
                      const SizedBox(height: 28),
                      _buildSectionTitle('Akses Cepat'),
                      const SizedBox(height: 16),
                      const HomeQuickAccessGrid(),
                      const SizedBox(height: 28),
                      const HomeUpcomingEvents(),
                      const SizedBox(height: 24),
                      const HomeEmergencyContacts(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Fitur Lainnya'),
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
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2F80ED), Color(0xFF1E6FD9)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}











