import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate to HomePage after the animation completes
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: HeartPainter(progress: _animation.value),
              child: const SizedBox(
                width: 300,
                height: 300,
              ),
            );
          },
        ),
      ),
    );
  }
}

class HeartPainter extends CustomPainter {
  final double progress;
  HeartPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    var path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.5 * progress;

    if (progress < 0.5) {
      // Draw expanding circle
      path.addOval(Rect.fromCircle(center: center, radius: radius));
    } else {
      // Draw heart shape
      double width = size.width;
      double height = size.height;

      double heartScale = (progress - 0.5) * 2.0;
      path.moveTo(0.5 * width, height * 0.45);
      path.cubicTo(0.3 * width, height * 0.14, -0.25 * width, height * 0.6,
          0.5 * width, height * 0.85);
      path.moveTo(0.5 * width, height * 0.45);
      path.cubicTo(0.8 * width, height * 0.15, 1.25 * width, height * 0.6,
          0.5 * width, height * 0.85);
      path = path.transform(
          Matrix4.identity().scaled(heartScale, heartScale, 1.0).storage);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

