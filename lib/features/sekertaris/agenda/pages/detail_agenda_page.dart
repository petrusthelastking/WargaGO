import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargago/features/sekertaris/agenda/pages/edit_agenda_page.dart';
import 'package:wargago/features/sekertaris/agenda/widgets/detail_info_card.dart';
import 'package:wargago/features/sekertaris/agenda/widgets/detail_item.dart';

/// Halaman Detail Agenda Kegiatan
class DetailAgendaPage extends StatelessWidget {
  final String date;
  final String time;
  final String title;
  final String location;
  final String description;
  final String status;
  final int attendees;

  const DetailAgendaPage({
    super.key,
    required this.date,
    required this.time,
    required this.title,
    required this.location,
    required this.description,
    required this.status,
    required this.attendees,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'completed':
        statusColor = const Color(0xFF27AE60);
        statusText = 'Selesai';
        statusIcon = Icons.check_circle;
        break;
      case 'today':
        statusColor = const Color(0xFFF39C12);
        statusText = 'Hari Ini';
        statusIcon = Icons.access_time;
        break;
      default:
        statusColor = const Color(0xFF2F80ED);
        statusText = 'Akan Datang';
        statusIcon = Icons.schedule;
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Detail Agenda',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2F80ED),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (status != 'completed')
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAgendaPage(
                      date: date,
                      time: time,
                      title: title,
                      location: location,
                      description: description,
                      attendees: attendees,
                    ),
                  ),
                );
                
                // Refresh halaman jika ada perubahan
                if (result == true && context.mounted) {
                  // TODO: Refresh data dari database
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Agenda berhasil diperbarui',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: const Color(0xFF27AE60),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              _showOptionsMenu(context, status);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Title and Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusIcon,
                          color: statusColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Date & Time Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: DetailInfoCard(
                      icon: Icons.calendar_today,
                      label: 'Tanggal',
                      value: date,
                      color: const Color(0xFF2F80ED),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DetailInfoCard(
                      icon: Icons.access_time,
                      label: 'Waktu',
                      value: time,
                      color: const Color(0xFF2F80ED),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Kegiatan',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location
                  DetailItem(
                    icon: Icons.location_on,
                    label: 'Lokasi',
                    value: location,
                  ),

                  const SizedBox(height: 16),

                  // Attendees
                  DetailItem(
                    icon: Icons.people,
                    label: 'Jumlah Peserta',
                    value: '$attendees orang',
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Deskripsi',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  if (status != 'completed')
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showCompleteConfirmation(context);
                            },
                            icon: const Icon(Icons.check_circle, size: 20),
                            label: Text(
                              'Tandai Selesai',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF27AE60),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showDeleteConfirmation(context);
                      },
                      icon: const Icon(Icons.delete, size: 20),
                      label: Text(
                        'Hapus Agenda',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, String status) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              if (status != 'completed')
                ListTile(
                  leading: const Icon(Icons.edit, color: Color(0xFF2F80ED)),
                  title: Text(
                    'Edit Agenda',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Edit agenda
                  },
                ),
              ListTile(
                leading: const Icon(Icons.share, color: Color(0xFF2F80ED)),
                title: Text(
                  'Bagikan',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Share agenda
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Hapus Agenda',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showCompleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Tandai Selesai',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Apakah agenda "$title" sudah selesai dilaksanakan?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Update status to completed
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        'Agenda ditandai selesai',
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFF27AE60),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27AE60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Ya, Selesai',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Hapus Agenda',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus agenda "$title"? Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Delete agenda
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        'Agenda berhasil dihapus',
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
