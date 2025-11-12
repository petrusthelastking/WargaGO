import 'package:flutter/material.dart';

import 'package:jawara/features/pre_auth/pre_auth_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _accentColor = Color(0xFF2F80ED);

  static final List<_OnboardingData> _slides = [
    _OnboardingData(
      headlinePrefix: 'Selamat Datang di App',
      headlineAccent: 'Jawara',
      description:
          'Halo, Admin! Selamat datang di Jawara - mari mulai mengelola data dengan cerdas.',
      assetPath: 'assets/illustrations/onboarding_welcome.png',
    ),
    _OnboardingData(
      headlinePrefix: 'Kelola Data dengan Lebih',
      headlineAccent: 'Mudah',
      description:
          'Pantau, ubah, dan kelola informasi langsung dari satu dashboard efisien.',
      assetPath: 'assets/illustrations/onboarding_manage.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final isLast = _currentPage == _slides.length - 1;
    if (isLast) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const PreAuthPage()));
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  // Framer-like custom easing functions
  double _customEase(double t) {
    // Custom cubic bezier similar to Framer's default ease
    return Curves.easeOutQuart.transform(t);
  }

  double _springEase(double t) {
    // Spring-like easing
    return Curves.elasticOut.transform(t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _BrandHeader(
                currentIndex: _currentPage,
                total: _slides.length,
                accentColor: _accentColor,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    final isLast = index == _slides.length - 1;
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double pageOffset = 0.0;
                        if (_pageController.position.haveDimensions) {
                          pageOffset = (_pageController.page ?? 0) - index;
                        }

                        // Framer-like smooth animations with custom curves
                        final double progress = (-pageOffset).clamp(-1.0, 1.0);

                        // Advanced opacity with custom easing
                        final double opacity = (1 - pageOffset.abs() * 0.5).clamp(0.0, 1.0);
                        final easedOpacity = _customEase(opacity);

                        // Scale with spring-like effect
                        final double scale = 1.0 - (pageOffset.abs() * 0.2);
                        final easedScale = _springEase(scale).clamp(0.8, 1.0);

                        // 3D rotation with perspective
                        final double rotation = progress * 0.15; // More dramatic
                        final double rotationY = progress * 0.4;

                        // Parallax slide with ease
                        final double slideX = pageOffset * 120;
                        final double slideY = pageOffset.abs() * 20;

                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001) // perspective
                            ..rotateZ(rotation * 0.05) // Slight Z rotation
                            ..rotateY(rotationY)
                            ..rotateX(progress * 0.05) // Slight X tilt
                            ..setTranslationRaw(slideX, slideY, 0.0),
                          alignment: Alignment.center,
                          child: Transform.scale(
                            scale: easedScale,
                            child: Opacity(
                              opacity: easedOpacity,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: _OnboardingSlide(
                        key: ValueKey(index),
                        data: slide,
                        accentColor: _accentColor,
                        isLast: isLast,
                        onNextPressed: _handleNext,
                        pageController: _pageController,
                        pageIndex: index,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatefulWidget {
  const _OnboardingSlide({
    super.key,
    required this.data,
    required this.accentColor,
    required this.isLast,
    required this.onNextPressed,
    required this.pageController,
    required this.pageIndex,
  });

  final _OnboardingData data;
  final Color accentColor;
  final bool isLast;
  final VoidCallback onNextPressed;
  final PageController pageController;
  final int pageIndex;

  @override
  State<_OnboardingSlide> createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<_OnboardingSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200), // Longer for more dramatic effect
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutExpo),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // More dramatic slide
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.elasticOut, // Spring-like curve
      ),
    );

    // Delay start for smoother entrance
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.pageController,
      builder: (context, child) {
        double parallaxOffset = 0.0;
        if (widget.pageController.position.haveDimensions) {
          final pageOffset = (widget.pageController.page ?? 0) - widget.pageIndex;
          parallaxOffset = pageOffset * 30;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Headline
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _Headline(
                  prefix: widget.data.headlinePrefix,
                  accent: widget.data.headlineAccent,
                  accentColor: widget.accentColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Animated Description
            FadeTransition(
              opacity: CurvedAnimation(
                parent: _animController,
                curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animController,
                    curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
                  ),
                ),
                child: Text(
                  widget.data.description,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Color(0xFF3D3D3D),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Animated Button with Micro-interactions
            FadeTransition(
              opacity: CurvedAnimation(
                parent: _animController,
                curve: const Interval(0.5, 1.0, curve: Curves.easeOutExpo),
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animController,
                    curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
                  ),
                ),
                child: _AnimatedButton(
                  accentColor: widget.accentColor,
                  isLast: widget.isLast,
                  onPressed: widget.onNextPressed,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Animated Illustration with Parallax
            Expanded(
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _animController,
                  curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
                ),
                child: Transform.translate(
                  offset: Offset(parallaxOffset, 0),
                  child: Transform.scale(
                    scale: 1.0,
                    child: _IllustrationPlaceholder(
                      assetPath: widget.data.assetPath,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({
    required this.prefix,
    required this.accent,
    required this.accentColor,
  });

  final String prefix;
  final String accent;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$prefix ',
            style: const TextStyle(
              fontSize: 32,
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
              letterSpacing: -0.3,
            ),
          ),
          TextSpan(
            text: accent,
            style: TextStyle(
              fontSize: 32,
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: accentColor,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// Animated Button with Framer-like interactions
class _AnimatedButton extends StatefulWidget {
  const _AnimatedButton({
    required this.accentColor,
    required this.isLast,
    required this.onPressed,
  });

  final Color accentColor;
  final bool isLast;
  final VoidCallback onPressed;

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _arrowController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: SizedBox(
        height: 44,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.accentColor,
            foregroundColor: Colors.white,
            elevation: _isPressed ? 0 : 2,
            shadowColor: widget.accentColor.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: widget.onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isLast ? 'Mulai' : 'Next',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedBuilder(
                animation: _arrowController,
                builder: (context, child) {
                  final offset = Curves.easeInOut.transform(
                    (_arrowController.value % 1.0),
                  ) * 6 - 3;
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: child,
                  );
                },
                child: const Icon(Icons.arrow_forward, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IllustrationPlaceholder extends StatelessWidget {
  const _IllustrationPlaceholder({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return SizedBox(
          width: width,
          height: height,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              assetPath,
              width: width,
              height: height,
              fit: BoxFit.cover,
              alignment: Alignment.bottomRight,
              errorBuilder: (_, __, ___) {
                return SizedBox(
                  width: width,
                  height: height,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Place your illustration at:\n$assetPath',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5C5C5C),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.headlinePrefix,
    required this.headlineAccent,
    required this.description,
    required this.assetPath,
  });

  final String headlinePrefix;
  final String headlineAccent;
  final String description;
  final String assetPath;
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({
    required this.currentIndex,
    required this.total,
    required this.accentColor,
  });

  final int currentIndex;
  final int total;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/icon.png',
              height: 20,
              width: 20,
              color: accentColor,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.fingerprint, color: accentColor, size: 20),
            ),
            const SizedBox(width: 8),
            Text(
              'Jawara',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(total, (index) {
            final isFilled = index <= currentIndex;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubic,
                height: 6,
                margin: EdgeInsets.only(left: index == 0 ? 0 : 12),
                decoration: BoxDecoration(
                  color: isFilled ? accentColor : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
