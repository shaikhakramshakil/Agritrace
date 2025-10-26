import 'dart:math' as math;
import 'package:flutter/material.dart';

// A single, vector-based brand logo with small wrappers for header/splash.
// This removes any dependency on image assets and unifies styling.

const _kBrandPrimary = Color(0xFF2E7D32); // Green 800
const _kBrandAccent = Color(0xFF4CAF50); // Green 500

class _BrandGlyph extends StatelessWidget {
  final double size;
  final Color primary;
  final Color accent;
  final bool glow;

  const _BrandGlyph({
    required this.size,
    required this.primary,
    required this.accent,
    this.glow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: glow
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.25),
                  blurRadius: size * 0.25,
                  spreadRadius: size * 0.05,
                ),
              ],
            )
          : null,
      child: CustomPaint(
        painter: _BrandPainter(primary: primary, accent: accent),
        size: Size.square(size),
      ),
    );
  }
}

class _BrandPainter extends CustomPainter {
  final Color primary;
  final Color accent;

  _BrandPainter({required this.primary, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2.0;

    // Background: rounded hexagon with gradient
    final hex = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60.0 - 30.0) * 3.1415926535 / 180.0;
      final r = radius * 0.95;
  final p = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
      if (i == 0) {
        hex.moveTo(p.dx, p.dy);
      } else {
        hex.lineTo(p.dx, p.dy);
      }
    }
    hex.close();

    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [primary, accent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawPath(hex, bgPaint);

    // Inner white ring
    final ringPaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.12
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius * 0.62, ringPaint);

    // Leaf shape (stylized) in white
    final leaf = Path();
    final leafH = radius * 0.95;
    final leafW = radius * 0.8;
    final base = Offset(center.dx, center.dy + leafH * 0.25);
    final top = Offset(center.dx, center.dy - leafH * 0.55);
    leaf.moveTo(base.dx, base.dy);
    leaf.cubicTo(
      base.dx - leafW * 0.7, base.dy - leafH * 0.25,
      base.dx - leafW * 0.35, base.dy - leafH * 0.72,
      top.dx, top.dy,
    );
    leaf.cubicTo(
      base.dx + leafW * 0.35, base.dy - leafH * 0.72,
      base.dx + leafW * 0.7, base.dy - leafH * 0.25,
      base.dx, base.dy,
    );
    final leafPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, Colors.white.withOpacity(0.85)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromPoints(top, base));
    canvas.drawPath(leaf, leafPaint);

    // Leaf vein
    final vein = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = radius * 0.06
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(top.translate(0, radius * 0.02), base.translate(0, -radius * 0.02), vein);

    // Accent sparkle
    final sparkle = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - radius * 0.28, center.dy - radius * 0.35), radius * 0.06, sparkle);
    canvas.drawCircle(Offset(center.dx + radius * 0.22, center.dy - radius * 0.18), radius * 0.035, sparkle);
  }

  @override
  bool shouldRepaint(covariant _BrandPainter oldDelegate) {
    return oldDelegate.primary != primary || oldDelegate.accent != accent;
  }
}

// Public API (compatible with previous widgets)
class AgriTraceLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showGlow;
  final Color? primaryColor;
  final Color? textColor;

  const AgriTraceLogo({
    super.key,
    this.size = 48.0,
    this.showText = false,
    this.showGlow = false,
    this.primaryColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? _kBrandPrimary;
    final accent = _kBrandAccent;
    final glyph = _BrandGlyph(size: size, primary: primary, accent: accent, glow: showGlow);
    if (!showText) return glyph;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        glyph,
        SizedBox(height: size * 0.16),
        Text(
          'AgriTrace',
          style: TextStyle(
            fontSize: size * 0.28,
            fontWeight: FontWeight.w700,
            color: textColor ?? primary,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class AgriTraceHeaderLogo extends StatelessWidget {
  final double height;
  final bool showGlow;
  final Color? iconColor;
  final Color? textColor; // Unused but kept for compatibility

  const AgriTraceHeaderLogo({
    super.key,
    this.height = 36.0,
    this.showGlow = false,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = iconColor ?? _kBrandPrimary;
    return _BrandGlyph(
      size: height,
      primary: primary,
      accent: _kBrandAccent,
      glow: showGlow,
    );
  }
}

class AgriTraceSplashLogo extends StatelessWidget {
  final double size;
  final bool showTagline;
  final String? tagline;

  const AgriTraceSplashLogo({
    super.key,
    this.size = 120.0,
    this.showTagline = true,
    this.tagline,
  });

  @override
  Widget build(BuildContext context) {
    final glyph = _BrandGlyph(
      size: size,
      primary: _kBrandPrimary,
      accent: _kBrandAccent,
      glow: true,
    );
    if (!showTagline) return glyph;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        glyph,
        SizedBox(height: size * 0.18),
        Text(
          'AgriTrace',
          style: TextStyle(
            fontSize: size * 0.26,
            fontWeight: FontWeight.w800,
            color: _kBrandPrimary,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: size * 0.06),
        Text(
          tagline ?? 'Farm to Fork Transparency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size * 0.12,
            color: _kBrandAccent,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class ModernAgriTraceLogo extends StatelessWidget {
  final double size;
  final Color? primaryColor;
  final Color? accentColor;
  final bool showText;
  final Color? textColor;

  const ModernAgriTraceLogo({
    super.key,
    this.size = 100,
    this.primaryColor,
    this.accentColor,
    this.showText = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? _kBrandPrimary;
    final accent = accentColor ?? _kBrandAccent;
    final circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [primary, accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.25),
            blurRadius: size * 0.25,
            spreadRadius: size * 0.04,
            offset: Offset(0, size * 0.06),
          ),
        ],
      ),
      child: Center(
        child: _BrandGlyph(
          size: size * 0.7,
          primary: Colors.white,
          accent: Colors.white70,
        ),
      ),
    );
    if (!showText) return circle;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        circle,
        SizedBox(height: size * 0.14),
        Text(
          'AgriTrace',
          style: TextStyle(
            fontSize: size * 0.24,
            fontWeight: FontWeight.bold,
            color: textColor ?? primary,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

// (no helpers needed)
