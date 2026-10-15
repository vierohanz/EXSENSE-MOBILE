import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashCloudBackground extends StatelessWidget {
  final Widget? child;

  const SplashCloudBackground({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 215,
          child: ClipPath(
            clipper: const TopCloudAccentClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0x220F172A),
                    Color(0x140F172A),
                    Color(0x060F172A),
                  ],
                ),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: -0.08, end: 0, curve: Curves.easeOutCubic),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 195,
          child: ClipPath(
            clipper: const TopCloudClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF020617),
                    Color(0xFF0F172A),
                    Color(0xFF1E293B),
                  ],
                ),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: -0.08, end: 0, curve: Curves.easeOutCubic),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 220,
          child: ClipPath(
            clipper: const BottomCloudAccentClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color(0x220F172A),
                    Color(0x140F172A),
                    Color(0x060F172A),
                  ],
                ),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 200,
          child: ClipPath(
            clipper: const BottomCloudClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF020617),
                    Color(0xFF0F172A),
                    Color(0xFF1E293B),
                  ],
                ),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
        if (child != null) child!,
      ],
    );
  }
}

class TopCloudClipper extends CustomClipper<Path> {
  const TopCloudClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.72);
    path.cubicTo(
      size.width * 0.18,
      size.height * 0.90,
      size.width * 0.38,
      size.height * 0.90,
      size.width * 0.52,
      size.height * 0.74,
    );
    path.cubicTo(
      size.width * 0.68,
      size.height * 0.56,
      size.width * 0.86,
      size.height * 0.84,
      size.width,
      size.height * 0.68,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class TopCloudAccentClipper extends CustomClipper<Path> {
  const TopCloudAccentClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.82);
    path.cubicTo(
      size.width * 0.22,
      size.height * 1.00,
      size.width * 0.44,
      size.height * 0.82,
      size.width * 0.58,
      size.height * 0.84,
    );
    path.cubicTo(
      size.width * 0.72,
      size.height * 0.88,
      size.width * 0.88,
      size.height * 0.66,
      size.width,
      size.height * 0.78,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class BottomCloudClipper extends CustomClipper<Path> {
  const BottomCloudClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.30);
    path.cubicTo(
      size.width * 0.16,
      size.height * 0.14,
      size.width * 0.36,
      size.height * 0.12,
      size.width * 0.50,
      size.height * 0.28,
    );
    path.cubicTo(
      size.width * 0.64,
      size.height * 0.44,
      size.width * 0.82,
      size.height * 0.16,
      size.width,
      size.height * 0.32,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class BottomCloudAccentClipper extends CustomClipper<Path> {
  const BottomCloudAccentClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.42);
    path.cubicTo(
      size.width * 0.20,
      size.height * 0.24,
      size.width * 0.42,
      size.height * 0.32,
      size.width * 0.56,
      size.height * 0.18,
    );
    path.cubicTo(
      size.width * 0.70,
      size.height * 0.06,
      size.width * 0.86,
      size.height * 0.28,
      size.width,
      size.height * 0.20,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
