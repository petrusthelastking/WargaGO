import 'package:flutter/material.dart';
import 'package:wargago/features/sekertaris/dashboard/sekretaris_dashboard_page.dart';
import 'package:wargago/features/sekertaris/agenda/pages/sekretaris_agenda_page.dart';
import 'package:wargago/features/sekertaris/notulen/pages/sekretaris_notulen_page.dart';
import 'package:wargago/features/sekertaris/profil/pages/sekretaris_profile_page.dart';
import 'package:wargago/features/sekertaris/widgets/sekretaris_bottom_navbar.dart';

/// Main Page untuk Sekretaris dengan Bottom Navigation
/// Menampung semua halaman sekretaris dan navigasi antar halaman
class SekretarisMainPage extends StatefulWidget {
  const SekretarisMainPage({super.key});

  @override
  State<SekretarisMainPage> createState() => _SekretarisMainPageState();
}

class _SekretarisMainPageState extends State<SekretarisMainPage> {
  int _currentIndex = 0;

  // Fungsi untuk berpindah tab
  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Daftar halaman yang akan ditampilkan
    final List<Widget> _pages = [
      SekretarisDashboardPage(onNavigateToTab: _changeTab), // Index 0: Dashboard
      const SekretarisAgendaPage(), // Index 1: Agenda
      const SekretarisNotulenPage(), // Index 2: Notulen
      const SekretarisProfilePage(), // Index 3: Profil
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SekretarisBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}


