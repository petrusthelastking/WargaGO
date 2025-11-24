import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Unified Bottom Navigation Bar untuk semua halaman
/// Menggunakan desain modern dengan gradient pada active state
class AppBottomNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AppBottomNavigation({super.key, required this.navigationShell});

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _fade = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.easeOutSine,
      reverseCurve: Curves.easeInSine,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(opacity: _fade, child: widget.navigationShell),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Bottom nav bar dengan curved notch
        CustomPaint(
          painter: _BottomNavPainter(),
          child: Container(
            height: 70,
            padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag_rounded,
                  label: 'Marketplace',
                ),
                // Spacer untuk scan button yang floating
                const SizedBox(width: 60),
                _buildNavItem(
                  index: 2,
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long_rounded,
                  label: 'Iuran',
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Akun',
                ),
              ],
            ),
          ),
        ),
        // Scan button floating di tengah atas
        Positioned(top: -25, child: _buildScanButton()),
      ],
    );
  }

  Widget _buildScanButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Implement scan functionality
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Fitur Scan dalam pengembangan',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFF2F80ED),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5B8DEF), Color(0xFF2F80ED)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2F80ED).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final currentIndex = widget.navigationShell.currentIndex;
    final isActive = currentIndex == index;

    return SizedBox(
      width: 65,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _goTo(index);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  size: 24,
                  color: isActive
                      ? const Color(0xFF2F80ED)
                      : const Color(0xFF9CA3AF),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive
                        ? const Color(0xFF2F80ED)
                        : const Color(0xFF9CA3AF),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goTo(int index) async {
    // Reset the current branch if tapping the active tab.
    final isReselect = index == widget.navigationShell.currentIndex;
    if (_isAnimating && !isReselect) return; // avoid overlapping animations

    if (isReselect) {
      widget.navigationShell.goBranch(index, initialLocation: true);
      return;
    }

    try {
      _isAnimating = true;
      // Fade out current content
      await _controller.forward();
      if (!mounted) return;

      // Switch branch while content is invisible
      widget.navigationShell.goBranch(index, initialLocation: true);

      // Give a frame for the new content to layout before fade-in
      await Future.delayed(const Duration(milliseconds: 16));
    } finally {
      if (mounted) {
        await _controller.reverse(); // Fade in new content
      }
      _isAnimating = false;
    }
  }
}

class _BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final path = Path();

    // Mulai dari kiri bawah
    path.moveTo(0, size.height);

    // Naik ke kiri atas
    path.lineTo(0, 0);

    // Garis horizontal kiri sampai sebelum notch
    path.lineTo(size.width * 0.38, 0);

    // Curve turun ke notch (sisi kiri)
    path.quadraticBezierTo(
      size.width * 0.42, // control point x
      0, // control point y
      size.width * 0.44, // end point x
      15, // end point y (depth of curve)
    );

    // Curve ke tengah notch
    path.quadraticBezierTo(
      size.width * 0.48, // control point x
      25, // control point y (bottom of notch)
      size.width * 0.50, // end point x (center)
      25, // end point y
    );

    // Curve dari tengah ke kanan notch
    path.quadraticBezierTo(
      size.width * 0.52, // control point x
      25, // control point y
      size.width * 0.56, // end point x
      15, // end point y
    );

    // Curve naik dari notch (sisi kanan)
    path.quadraticBezierTo(
      size.width * 0.58, // control point x
      0, // control point y
      size.width * 0.62, // end point x
      0, // end point y
    );

    // Garis horizontal kanan
    path.lineTo(size.width, 0);

    // Turun ke kanan bawah
    path.lineTo(size.width, size.height);

    // Garis bawah
    path.lineTo(0, size.height);

    path.close();

    // Draw shadow first
    canvas.drawPath(path, shadowPaint);

    // Draw main shape on top
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
