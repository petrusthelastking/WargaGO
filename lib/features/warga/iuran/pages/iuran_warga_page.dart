import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/providers/iuran_warga_provider.dart';
import '../widgets/iuran_header_card.dart';
import '../widgets/iuran_menu_grid.dart';
import '../widgets/iuran_list_section.dart';

class IuranWargaPage extends StatefulWidget {
  const IuranWargaPage({super.key});

  @override
  State<IuranWargaPage> createState() => _IuranWargaPageState();
}

class _IuranWargaPageState extends State<IuranWargaPage> {
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    if (_isInitialized) return;

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        setState(() {
          _errorMessage = 'Anda belum login';
        });
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        setState(() {
          _errorMessage = 'Data user tidak ditemukan';
        });
        return;
      }

      final userData = userDoc.data();
      final keluargaId = userData?['keluargaId'] as String?;

      if (keluargaId == null || keluargaId.isEmpty) {
        setState(() {
          _errorMessage = 'Anda belum memiliki Keluarga ID.\nSilakan hubungi admin.';
        });
        return;
      }

      if (mounted) {
        final provider = context.read<IuranWargaProvider>();
        await provider.initialize(keluargaId);

        setState(() {
          _isInitialized = true;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Iuran Warga',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
      ),
      body: Consumer<IuranWargaProvider>(
        builder: (context, provider, child) {
          // Loading
          if (provider.isLoading && !_isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (_errorMessage != null || provider.errorMessage != null) {
            return _buildErrorScreen(_errorMessage ?? provider.errorMessage!);
          }

          // Empty
          if (provider.totalTagihan == 0 && _isInitialized) {
            return _buildEmptyScreen();
          }

          // Main Content
          return RefreshIndicator(
            onRefresh: () async {
              await provider.refresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  IuranHeaderCard(provider: provider),
                  const SizedBox(height: 20),
                  IuranMenuGrid(provider: provider),
                  const SizedBox(height: 24),
                  IuranListSection(provider: provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isInitialized = false;
                  _errorMessage = null;
                });
                _initializeProvider();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 60, color: Colors.blue.shade400),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Tagihan',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Saat ini Anda belum memiliki tagihan iuran',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                setState(() => _isInitialized = false);
                _initializeProvider();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}

