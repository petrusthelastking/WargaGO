// ============================================================================
// HOME FEATURE LIST WIDGET
// ============================================================================
// List fitur tambahan (Pengajuan Keringanan, Semua Pengumuman, dll)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeFeatureList extends StatelessWidget {
  const HomeFeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FeatureListItem(
          icon: Icons.description_outlined,
          title: 'Pengajuan Keringanan',
          subtitle: 'Ajukan keringanan iuran',
          onTap: () {
            // TODO: Navigate to pengajuan keringanan
          },
        ),
        const SizedBox(height: 12),
        _FeatureListItem(
          icon: Icons.list_alt_outlined,
          title: 'Semua Pengumuman',
          subtitle: 'Lihat riwayat pengumuman',
          onTap: () {
            // TODO: Navigate to all pengumuman
          },
        ),
      ],
    );
  }
}

class _FeatureListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureListItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

