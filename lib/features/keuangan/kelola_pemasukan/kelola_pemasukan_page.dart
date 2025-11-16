import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tabs/jenis_iuran_tab.dart';
import 'tabs/tagihan_tab.dart';
import 'tabs/lainnya_tab.dart';
import 'tagih_iuran_page.dart';
import 'pemasukan_non_iuran_page.dart';
import 'widgets/kelola_pemasukan_widgets.dart';
import '../widgets/keuangan_constants.dart';

class KelolaPemasukanPage extends StatefulWidget {
  const KelolaPemasukanPage({super.key});

  @override
  State<KelolaPemasukanPage> createState() => _KelolaPemasukanPageState();
}

class _KelolaPemasukanPageState extends State<KelolaPemasukanPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B82F6),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KelolaPemasukanHeader(
                      onBack: () => Navigator.pop(context),
                      onFilter: () {},
                    ),
                    const SizedBox(height: KeuanganSpacing.xxl),
                    KelolaPemasukanStatsCard(
                      totalPemasukan: 'Rp 20.000.000',
                      totalTransaksi: '12 Items',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: KelolaPemasukanTabbedContent(
                tabController: _tabController,
                onTabChange: () => setState(() {}),
                tabs: const [
                  PemasukanTabItem(icon: Icons.list_alt_rounded, label: 'Jenis Iuran'),
                  PemasukanTabItem(icon: Icons.receipt_rounded, label: 'Tagihan'),
                  PemasukanTabItem(icon: Icons.more_horiz_rounded, label: 'Lainnya'),
                ],
                views: const [
                  JenisIuranTab(),
                  TagihanTab(),
                  LainnyaTab(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? null
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: _showAddDialog,
                backgroundColor: const Color(0xFF3B82F6),
                elevation: 0,
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
                label: Text(
                  'Tambah',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }

  void _showAddDialog() {
    final currentIndex = _tabController.index;

    // Jika tab Tagihan (index 1), langsung buka halaman Tagih Iuran
    if (currentIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TagihIuranPage(),
        ),
      );
      return;
    }

    // Jika tab Lainnya (index 2), langsung buka halaman Pemasukan Non Iuran
    if (currentIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PemasukanNonIuranPage(),
        ),
      );
      return;
    }

    // Untuk tab lainnya, tampilkan dialog
    final tabNames = ['Jenis Iuran', 'Tagihan', 'Lainnya'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF3B82F6).withValues(alpha: 0.05),
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF3B82F6),
                      const Color(0xFF2563EB),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.add_circle_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Tambah ${tabNames[currentIndex]}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Fitur untuk menambahkan data ${tabNames[currentIndex]} akan segera hadir.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  height: 1.5,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Mengerti',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
