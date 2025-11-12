import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara/features/data_warga/data_penduduk/data_penduduk_page.dart';
import '../../../core/widgets/app_bottom_navigation.dart';
import '../../data_warga/kelola_pengguna/kelola_pengguna_page.dart';
import '../../data_warga/terima_warga/terima_warga_page.dart';
import 'detail_data_mutasi_page.dart';
import 'tambah_data_mutasi_page.dart';

class DataMutasiWargaPage extends StatefulWidget {
  const DataMutasiWargaPage({super.key});

  @override
  State<DataMutasiWargaPage> createState() => _DataMutasiWargaPageState();
}

class _DataMutasiWargaPageState extends State<DataMutasiWargaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER dengan Gradient Modern
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2F80ED),
                    Color(0xFF1E6FD9),
                    Color(0xFF0F5FCC),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2F80ED).withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title dengan icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.swap_horiz_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Data Mutasi",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Kelola mutasi masuk & keluar",
                              style: GoogleFonts.poppins(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Modern Card Menu dengan Glassmorphism
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildModernCard(
                          context,
                          title: "Data\nPenduduk",
                          icon: Icons.people_alt_rounded,
                          subtitle: "100 Data",
                          isActive: false,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DataWargaPage())),
                        ),
                        const SizedBox(width: 12),
                        _buildModernCard(
                          context,
                          title: "Data\nMutasi",
                          icon: Icons.swap_horiz_rounded,
                          subtitle: "100 Data",
                          isActive: true,
                          onTap: () {},
                        ),
                        const SizedBox(width: 12),
                        _buildModernCard(
                          context,
                          title: "Kelola\nPengguna",
                          icon: Icons.admin_panel_settings_rounded,
                          subtitle: "100 Data",
                          isActive: false,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KelolaPenggunaPage())),
                        ),
                        const SizedBox(width: 12),
                        _buildModernCardWithBadge(
                          context,
                          title: "Terima\nWarga",
                          icon: Icons.how_to_reg_rounded,
                          subtitle: "5 Pending",
                          badge: "5",
                          isActive: false,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TerimaWargaPage())),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // STATS SECTION
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF11998E).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.arrow_circle_down_rounded, color: Colors.white, size: 28),
                          const SizedBox(height: 8),
                          Text("15", style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                          Text("Mutasi Masuk", style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.9), fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEE0979), Color(0xFFFF6A00)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEE0979).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.arrow_circle_up_rounded, color: Colors.white, size: 28),
                          const SizedBox(height: 8),
                          Text("8", style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                          Text("Mutasi Keluar", style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.9), fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // MAIN CONTENT
            Expanded(child: const DataMutasiList()),
          ],
        ),
      ),

      // FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TambahDataMutasiPage()));
        },
        backgroundColor: const Color(0xFF2F80ED),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // NAVIGATION BAR
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
    );
  }

  Widget _buildModernCard(BuildContext context, {required String title, required IconData icon, required String subtitle, required bool isActive, required VoidCallback onTap}) {
    return SizedBox(
      width: 115,
      child: Container(
        decoration: BoxDecoration(
          gradient: isActive ? const LinearGradient(colors: [Colors.white, Color(0xFFF5F8FF)]) : null,
          color: isActive ? null : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.2), width: isActive ? 2 : 1.5),
          boxShadow: [
            BoxShadow(
              color: isActive ? Colors.white.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.1),
              blurRadius: isActive ? 20 : 16,
              offset: const Offset(0, 8),
              spreadRadius: isActive ? 2 : 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white.withValues(alpha: 0.2),
            onTap: onTap,
            child: _ModernHeaderCard(title: title, icon: icon, subtitle: subtitle, isActive: isActive),
          ),
        ),
      ),
    );
  }

  Widget _buildModernCardWithBadge(BuildContext context, {required String title, required IconData icon, required String subtitle, required String badge, required bool isActive, required VoidCallback onTap}) {
    return SizedBox(
      width: 115,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 16, offset: const Offset(0, 8))],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.white.withValues(alpha: 0.2),
                onTap: onTap,
                child: _ModernHeaderCard(title: title, icon: icon, subtitle: subtitle, isActive: isActive),
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFEB5757)]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: const Color(0xFFEB5757).withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Text(badge, style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}

// === MODERN HEADER CARD ===
class _ModernHeaderCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  final bool isActive;

  const _ModernHeaderCard({required this.title, required this.icon, required this.subtitle, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF2F80ED).withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isActive ? const Color(0xFF2F80ED).withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Icon(icon, color: isActive ? const Color(0xFF2F80ED) : Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w700, height: 1.1, color: isActive ? const Color(0xFF2F80ED) : Colors.white)),
          const SizedBox(height: 4),
          Text(subtitle, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.w600, color: isActive ? const Color(0xFF2F80ED).withValues(alpha: 0.7) : Colors.white.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}

// === DATA MUTASI LIST ===
class DataMutasiList extends StatelessWidget {
  const DataMutasiList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: 8,
      itemBuilder: (context, index) {
        final isMasuk = index % 2 == 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 8, offset: Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMasuk ? const Color(0xFF11998E).withValues(alpha: 0.1) : const Color(0xFFEE0979).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(isMasuk ? Icons.arrow_circle_down_rounded : Icons.arrow_circle_up_rounded, color: isMasuk ? const Color(0xFF11998E) : const Color(0xFFEE0979), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rendha Putra Rahmadya", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(isMasuk ? "Mutasi Masuk" : "Mutasi Keluar", style: GoogleFonts.poppins(fontSize: 12, color: isMasuk ? const Color(0xFF11998E) : const Color(0xFFEE0979), fontWeight: FontWeight.w600)),
                    Text("12 Nov 2024", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailDataMutasiPage())),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2F80ED)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: const Size(80, 36),
                ),
                child: const Text("Details", style: TextStyle(color: Color(0xFF2F80ED), fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }
}

