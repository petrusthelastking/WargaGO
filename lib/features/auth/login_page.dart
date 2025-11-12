import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara/features/dashboard/dashboard_page.dart';
import 'package:jawara/features/auth/register_page.dart';

const Color _kLoginAccent = Color(0xFF2F80ED);

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.initialProgress = 0.0,
    this.isForward = true,
  });

  final double initialProgress;
  final bool isForward;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  late bool _isForward;

  @override
  void initState() {
    super.initState();
    _isForward = widget.isForward;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addStatusListener(_handleStatus);
    _controller.value = widget.initialProgress.clamp(0.0, 1.0);
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (_isForward) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _handleStatus(AnimationStatus status) {
    if (!mounted) return;
    if (status == AnimationStatus.completed) {
      _isForward = false;
      _controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _isForward = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _progress,
          builder: (context, _) {
            return Stack(
              children: [
                _DecorBackground(progress: _progress.value),
                const _LoginBody(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                _LoginHeader(),
                SizedBox(height: 24),
                _LoginIllustration(),
                SizedBox(height: 32),
                _LoginIntro(),
                SizedBox(height: 28),
                _LoginFields(),
                SizedBox(height: 32),
                _SignupPrompt(),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icons/icon.png',
          height: 54,
          width: 54,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.fingerprint, size: 54, color: _kLoginAccent),
        ),
        const SizedBox(width: 12),
        Text(
          'Jawara',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _kLoginAccent,
          ),
        ),
      ],
    );
  }
}

class _LoginIllustration extends StatelessWidget {
  const _LoginIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/illustrations/LOGIN.png',
        height: 300,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Place your login illustration at:\nassets/illustrations/LOGIN.png',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF8D8D8D),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginIntro extends StatelessWidget {
  const _LoginIntro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LOGIN',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: _kLoginAccent,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Silakan login terlebih dahulu sebagai admin untuk mengakses seluruh fitur dalam aplikasi.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            height: 1.6,
            color: const Color(0xFF777C8E),
          ),
        ),
      ],
    );
  }
}

class _LoginFields extends StatelessWidget {
  const _LoginFields();

  InputDecoration _decoration(String label) {
    return InputDecoration(
      hintText: label,
      hintStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: const Color(0xFFB0B3C0),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE2E4EC), width: 1.4),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: _kLoginAccent, width: 1.6),
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE2E4EC)),
      ),
      isDense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          textInputAction: TextInputAction.next,
          decoration: _decoration('Username'),
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        const SizedBox(height: 24),
        TextField(
          obscureText: true,
          decoration: _decoration('Password'),
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Lupa Kata sandi?',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _kLoginAccent,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _kLoginAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              textStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const DashboardPage()),
                (route) => false,
              );
            },
            child: const Text('Login'),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SignupPrompt extends StatelessWidget {
  const _SignupPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Admin baru? ',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF828696),
          ),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: _kLoginAccent,
                  textStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecorBackground extends StatelessWidget {
  const _DecorBackground({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _BlobPainter(
            baseColor: _kLoginAccent.withValues(alpha: 0.12),
            accentColor: _kLoginAccent.withValues(alpha: 0.35),
            progress: progress,
          ),
        ),
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter({
    required this.baseColor,
    required this.accentColor,
    required this.progress,
  });

  final Color baseColor;
  final Color accentColor;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double t = progress;
    final double wave1 = math.sin(t * 2 * math.pi);
    final double wave2 = math.cos((t + 0.25) * 2 * math.pi);
    final double wave3 = math.sin((t + 0.5) * 2 * math.pi);

    final circle1Center = Offset(
      -size.width * (0.33 + 0.02 * wave2) + wave1 * 32,
      size.height * (0.06 + 0.01 * wave3) + wave2 * 20,
    );
    final circle2Center = Offset(
      size.width * (0.95 + 0.02 * wave3) + wave2 * 42,
      size.height * (-0.2 + 0.015 * wave1) + wave1 * 24,
    );

    final paintBase = Paint()..color = baseColor;
    final paintAccent = Paint()..color = accentColor;

    final circle1Radius = size.width * 0.58 * (0.92 + wave1 * 0.08);
    final circle2Radius = size.width * 0.62 * (0.9 + wave2 * 0.07);

    canvas.drawCircle(circle1Center, circle1Radius, paintBase);
    canvas.drawCircle(circle2Center, circle2Radius, paintBase);

    final smaller1Center = circle1Center.translate(
      140 + wave2 * 26,
      150 + wave1 * 22,
    );
    final smaller2Center = circle2Center.translate(
      -60 + wave1 * 22,
      140 + wave3 * 18,
    );

    final double accentRadius1 = size.width * 0.32 * (0.9 + wave3 * 0.06);
    final double accentRadius2 = size.width * 0.28 * (0.9 + wave2 * 0.06);

    canvas.drawCircle(smaller2Center, accentRadius1, paintAccent);
    canvas.drawCircle(smaller1Center, accentRadius2, paintAccent);
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) =>
      oldDelegate.baseColor != baseColor ||
      oldDelegate.accentColor != accentColor ||
      oldDelegate.progress != progress;
}
