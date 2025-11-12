import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_bottom_navigation.dart';
import 'detail_terima_warga_page.dart';

/// Page untuk menampilkan daftar pendaftaran warga yang perlu diproses
class TerimaWargaPage extends StatefulWidget {
  const TerimaWargaPage({super.key});

  @override
  State<TerimaWargaPage> createState() => _TerimaWargaPageState();
}

class _TerimaWargaPageState extends State<TerimaWargaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  bool _isLoading = false;

  // Dummy data for demonstration
  final List<Map<String, dynamic>> _allRegistrations = [
    {
      'id': '1',
      'nama': 'Ahmad Fauzi',
      'nik': '3201012345678901',
      'email': 'ahmad.fauzi@email.com',
      'jenisKelamin': 'Laki-laki',
      'identitas': 'KTP',
      'tanggalDaftar': DateTime.now().subtract(const Duration(hours: 2)),
      'statusRegistrasi': 'Menunggu',
    },
    {
      'id': '2',
      'nama': 'Siti Nurhaliza',
      'nik': '3201012345678902',
      'email': 'siti.nurhaliza@email.com',
      'jenisKelamin': 'Perempuan',
      'identitas': 'KTP',
      'tanggalDaftar': DateTime.now().subtract(const Duration(hours: 5)),
      'statusRegistrasi': 'Menunggu',
    },
    {
      'id': '3',
      'nama': 'Budi Santoso',
      'nik': '3201012345678903',
      'email': 'budi.santoso@email.com',
      'jenisKelamin': 'Laki-laki',
      'identitas': 'KTP',
      'tanggalDaftar': DateTime.now().subtract(const Duration(days: 1)),
      'statusRegistrasi': 'Disetujui',
    },
    {
      'id': '4',
      'nama': 'Dewi Lestari',
      'nik': '3201012345678904',
      'email': 'dewi.lestari@email.com',
      'jenisKelamin': 'Perempuan',
      'identitas': 'KTP',
      'tanggalDaftar': DateTime.now().subtract(const Duration(days: 2)),
      'statusRegistrasi': 'Ditolak',
    },
    {
      'id': '5',
      'nama': 'Rudi Hermawan',
      'nik': '3201012345678905',
      'email': 'rudi.hermawan@email.com',
      'jenisKelamin': 'Laki-laki',
      'identitas': 'KTP',
      'tanggalDaftar': DateTime.now().subtract(const Duration(hours: 8)),
      'statusRegistrasi': 'Menunggu',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredRegistrations(String status) {
    return _allRegistrations.where((reg) {
      final matchesStatus = status == 'Semua' || reg['statusRegistrasi'] == status;
      final matchesSearch = _searchQuery.isEmpty ||
          reg['nama'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          reg['nik'].contains(_searchQuery);
      return matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final menungguCount = _getFilteredRegistrations('Menunggu').length;
    final disetujuiCount = _getFilteredRegistrations('Disetujui').length;
    final ditolakCount = _getFilteredRegistrations('Ditolak').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Terima Warga',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
        // TabBar Section - Enhanced Design
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFF5F7FA),
                const Color(0xFFF5F7FA).withValues(alpha: 0.8),
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  const Color(0xFFF8F9FF),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF2F80ED).withValues(alpha: 0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2F80ED).withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(5),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2F80ED), Color(0xFF1E6FD9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2F80ED).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF6B7280),
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.all(0),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.schedule_rounded, size: 16),
                      SizedBox(width: 6),
                      Text('Menunggu'),
                      if (menungguCount > 0) ...[
                        SizedBox(width: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$menungguCount',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 16),
                      SizedBox(width: 6),
                      Text('Disetujui'),
                      if (disetujuiCount > 0) ...[
                        SizedBox(width: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$disetujuiCount',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cancel_rounded, size: 16),
                      SizedBox(width: 6),
                      Text('Ditolak'),
                      if (ditolakCount > 0) ...[
                        SizedBox(width: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$ditolakCount',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content
        // Content
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRegistrationList('Menunggu'),
                    _buildRegistrationList('Disetujui'),
                    _buildRegistrationList('Ditolak'),
                  ],
                ),
        ),
      ],
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
    );
  }


  Widget _buildRegistrationList(String status) {
    final registrations = _getFilteredRegistrations(status);

    if (registrations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2F80ED).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getEmptyIcon(status),
                size: 64,
                color: const Color(0xFF2F80ED).withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyMessage(status),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptySubMessage(status),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF2F80ED),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: registrations.length,
        itemBuilder: (context, index) {
          final registration = registrations[index];
          return _RegistrationCard(
            registration: registration,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailTerimaWargaPage(
                    registration: registration,
                  ),
                ),
              );

              if (result == true) {
                _loadData();
              }
            },
          );
        },
      ),
    );
  }

  IconData _getEmptyIcon(String status) {
    switch (status) {
      case 'Menunggu':
        return Icons.schedule_rounded;
      case 'Disetujui':
        return Icons.check_circle_outline_rounded;
      case 'Ditolak':
        return Icons.cancel_outlined;
      default:
        return Icons.inbox_rounded;
    }
  }

  String _getEmptyMessage(String status) {
    switch (status) {
      case 'Menunggu':
        return 'Tidak ada pendaftaran menunggu';
      case 'Disetujui':
        return 'Belum ada yang disetujui';
      case 'Ditolak':
        return 'Belum ada yang ditolak';
      default:
        return 'Tidak ada data';
    }
  }

  String _getEmptySubMessage(String status) {
    switch (status) {
      case 'Menunggu':
        return 'Pendaftaran baru akan muncul di sini';
      case 'Disetujui':
        return 'Warga yang disetujui akan muncul di sini';
      case 'Ditolak':
        return 'Pendaftaran yang ditolak akan muncul di sini';
      default:
        return '';
    }
  }
}


class _RegistrationCard extends StatelessWidget {
  const _RegistrationCard({
    required this.registration,
    required this.onTap,
  });

  final Map<String, dynamic> registration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F80ED).withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Nama dan Status
            Row(
              children: [
                // Foto Identitas (Avatar)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF2F80ED).withValues(alpha: 0.2),
                        const Color(0xFF1E6FD9).withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF2F80ED).withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    registration['jenisKelamin'] == 'Laki-laki'
                        ? Icons.person_rounded
                        : Icons.person_outline_rounded,
                    color: const Color(0xFF2F80ED),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 14),
                // Nama dan Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        registration['nama'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F1F1F),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(registration['statusRegistrasi'])
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getStatusIcon(registration['statusRegistrasi']),
                              size: 14,
                              color: _getStatusColor(registration['statusRegistrasi']),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              registration['statusRegistrasi'],
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(registration['statusRegistrasi']),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Divider
            Container(
              height: 1,
              color: const Color(0xFFE5E7EB),
            ),
            const SizedBox(height: 16),
            // Detail Information
            _buildInfoRow(Icons.badge_rounded, 'NIK', registration['nik']),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.email_rounded, 'Email', registration['email']),
            const SizedBox(height: 10),
            _buildInfoRow(
              registration['jenisKelamin'] == 'Laki-laki'
                ? Icons.male_rounded
                : Icons.female_rounded,
              'Jenis Kelamin',
              registration['jenisKelamin'],
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.credit_card_rounded,
              'Identitas',
              registration['identitas'],
            ),
            const SizedBox(height: 16),
            // Tombol Detail
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.open_in_new, size: 20),
                label: Text(
                  'Lihat Detail',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2F80ED).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: const Color(0xFF2F80ED),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F1F1F),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }


  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return const Color(0xFFFFA755);
      case 'Disetujui':
        return const Color(0xFF10B981);
      case 'Ditolak':
        return const Color(0xFFEB5757);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Menunggu':
        return Icons.schedule_rounded;
      case 'Disetujui':
        return Icons.check_circle_rounded;
      case 'Ditolak':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}
