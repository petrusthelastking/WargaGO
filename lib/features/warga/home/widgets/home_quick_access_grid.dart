// ============================================================================
// HOME QUICK ACCESS GRID WIDGET
// ============================================================================
// Grid menu akses cepat (Mini Poling, Pengumuman, Kegiatan, Pengaduan)
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class HomeQuickAccessGrid extends StatelessWidget {
  const HomeQuickAccessGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.0,
      children: [
        _QuickAccessCard(
          icon: Icons.how_to_vote_outlined,
          title: 'Mini Poling',
          onTap: () {},
        ),
        _QuickAccessCard(
          icon: Icons.campaign_outlined,
          title: 'Pengumuman',
          onTap: () {},
        ),
        _QuickAccessCard(
          icon: Icons.event_note_outlined,
          title: 'Kegiatan',
          onTap: () {},
        ),
        _QuickAccessCard(
          icon: Icons.report_problem_outlined,
          title: 'Pengaduan',
          onTap: () {},
        ),
      ],
    );
  }
}
class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _QuickAccessCard({
    required this.icon,
    required this.title,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF2F80ED).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: const Color(0xFF2F80ED),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
