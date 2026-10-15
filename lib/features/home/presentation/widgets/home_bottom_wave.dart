import 'package:flutter/material.dart';

class HomeBottomWave extends StatelessWidget {
  static const double _screenHeightRatio = 0.26;
  static const double _minHeight = 140;
  static const double _maxHeight = 280;
  static const double _contentClearanceRatio = 0.45;

  const HomeBottomWave({super.key});

  static double heightFor(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return (screenHeight * _screenHeightRatio).clamp(_minHeight, _maxHeight);
  }

  static double contentClearanceFor(BuildContext context) {
    return heightFor(context) * _contentClearanceRatio;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: double.infinity,
        height: heightFor(context),
        child: const CustomPaint(
          painter: _CustomBottomWavePainter(),
        ),
      ),
    );
  }
}

class _CustomBottomWavePainter extends CustomPainter {
  const _CustomBottomWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final accentPath = Path()
      ..moveTo(0, height * 0.46)
      ..cubicTo(
        width * 0.16,
        height * 0.56,
        width * 0.36,
        height * 0.68,
        width * 0.52,
        height * 0.65,
      )
      ..cubicTo(
        width * 0.70,
        height * 0.60,
        width * 0.86,
        height * 0.10,
        width,
        height * 0.06,
      )
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    final accentPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Color(0x330F172A),
          Color(0x1F0F172A),
          Color(0x0A0F172A),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(accentPath, accentPaint);

    final mainPath = Path()
      ..moveTo(0, height * 0.54)
      ..cubicTo(
        width * 0.16,
        height * 0.64,
        width * 0.36,
        height * 0.76,
        width * 0.52,
        height * 0.74,
      )
      ..cubicTo(
        width * 0.70,
        height * 0.70,
        width * 0.86,
        height * 0.18,
        width,
        height * 0.14,
      )
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    final mainPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Color(0xFF020617),
          Color(0xFF0F172A),
          Color(0xFF1E293B),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(mainPath, mainPaint);

    final crestPath = Path()
      ..moveTo(0, height * 0.54)
      ..cubicTo(
        width * 0.16,
        height * 0.64,
        width * 0.36,
        height * 0.76,
        width * 0.52,
        height * 0.74,
      )
      ..cubicTo(
        width * 0.70,
        height * 0.70,
        width * 0.86,
        height * 0.18,
        width,
        height * 0.14,
      );

    final crestPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0xFFD3DA53).withValues(alpha: 0.55),
          const Color(0xFFD3DA53).withValues(alpha: 0.20),
          const Color(0xFFD3DA53).withValues(alpha: 0.75),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(crestPath, crestPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
