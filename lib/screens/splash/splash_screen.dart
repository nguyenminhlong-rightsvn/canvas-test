import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as Vector;

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInBack);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 2.0, end: 1.5).animate(_animation),
          child: const CanvasLoadingIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CanvasLoadingIndicator extends StatefulWidget {
  const CanvasLoadingIndicator({
    this.size = 48,
    this.color = Colors.red,
    super.key,
  });

  final double size;
  final Color color;

  @override
  _CanvasLoadingIndicatorState createState() => _CanvasLoadingIndicatorState();
}

class _CanvasLoadingIndicatorState extends State<CanvasLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late _CanvasLoadingIndicatorPainter _painter;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad);
    _controller.repeat(period: Duration(milliseconds: 600));
    _painter = _CanvasLoadingIndicatorPainter(
      _animation,
      widget.color,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _CanvasLoadingIndicatorPainter extends CustomPainter {
  _CanvasLoadingIndicatorPainter(this.animation, Color color)
      : super(repaint: animation) {
    _circlePaint = Paint()..color = color;
  }

  static const fractionSpawnPointRadius = 0.31;
  static const fractionMaxCircleRadius = 0.29;
  static const fractionInnerRingRadius = 1 / 3.0;
  static const circleCount = 8;

  final Animation<double> animation;
  double _lastProgress = -1.0;
  int _iteration = 0;
  late Paint _circlePaint;

  @override
  void paint(Canvas canvas, Size size) {
    if (animation.value < _lastProgress) _iteration++;
    _lastProgress = animation.value;

    Path clipPath = Path();
    clipPath.addOval(Rect.fromPoints(
        size.topLeft(Offset.zero), size.bottomRight(Offset.zero)));
    canvas.clipPath(clipPath);

    var offset = 360.0 / circleCount;
    if ((_iteration + 1) % 4 != 0) offset = -offset;

    var center = size.center(Offset.zero);
    var maxRingRadius = center.dx;
    var spawnPointRadius = maxRingRadius * fractionSpawnPointRadius;
    var maxCircleRadius = maxRingRadius * fractionMaxCircleRadius;

    void _drawCircle(
        double radius, double angleRadians, double distanceFromCenter) {
      double x = center.dx + distanceFromCenter * cos(angleRadians);
      double y = center.dy + distanceFromCenter * sin(angleRadians);
      canvas.drawCircle(Offset(x, y), radius, _circlePaint);
    }

    void _drawCircleRing(double angleOffset, double growthPercent) {
      double radius = growthPercent * maxCircleRadius;
      double ringRadius = spawnPointRadius +
          (growthPercent * (maxRingRadius - spawnPointRadius));
      for (int i = 0; i < circleCount; i++) {
        _drawCircle(radius, Vector.radians(i * 45 + angleOffset), ringRadius);
      }
    }

    if (_iteration % 2 == 0) {
      double innerRingPercentage = animation.value * fractionInnerRingRadius;
      double outerRingPercentage = fractionInnerRingRadius +
          animation.value * (1 - fractionInnerRingRadius);
      double exitingRingPercentage = 1 + animation.value;
      _drawCircleRing(offset, innerRingPercentage);
      if (_iteration >= 1) _drawCircleRing(0, outerRingPercentage);
      if (_iteration >= 3) _drawCircleRing(0, exitingRingPercentage);
    } else {
      offset = offset * (1 - animation.value);
      _drawCircleRing(offset, fractionInnerRingRadius);
      if (_iteration >= 2) _drawCircleRing(0, 1);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
