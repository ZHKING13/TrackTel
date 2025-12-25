import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeInOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _animationController.forward();
      }
    });

    _checkSessionAndRedirect();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkSessionAndRedirect() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    final authState = ref.read(authProvider);

    if (authState.isCheckingSession) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      _checkSessionAndRedirect();
      return;
    }

    if (authState.isLoggedIn) {
      context.go('/');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'Bienvenue',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF666666),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              final offset = _slideAnimation.value;

              return Stack(
                children: [
                  Positioned(
                    top: -screenHeight * offset,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      size: Size(screenWidth, screenHeight * 0.5),
                      painter: TrianglePainter(
                        color: AppColors.primary,
                        direction: TriangleDirection.top,
                      ),
                    ),
                  ),

                  // Triangle du bas
                  Positioned(
                    bottom: -screenHeight * offset,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      size: Size(screenWidth, screenHeight * 0.5),
                      painter: TrianglePainter(
                        color: AppColors.primary,
                        direction: TriangleDirection.bottom,
                      ),
                    ),
                  ),

                  Positioned(
                    left: -screenWidth * offset,
                    top: 0,
                    bottom: 0,
                    child: CustomPaint(
                      size: Size(screenWidth * 0.5, screenHeight),
                      painter: TrianglePainter(
                        color: AppColors.primary,
                        direction: TriangleDirection.left,
                      ),
                    ),
                  ),

                  Positioned(
                    right: -screenWidth * offset,
                    top: 0,
                    bottom: 0,
                    child: CustomPaint(
                      size: Size(screenWidth * 0.5, screenHeight),
                      painter: TrianglePainter(
                        color: AppColors.primary,
                        direction: TriangleDirection.right,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

enum TriangleDirection { top, bottom, left, right }

class TrianglePainter extends CustomPainter {
  final Color color;
  final TriangleDirection direction;

  TrianglePainter({required this.color, required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();

    switch (direction) {
      case TriangleDirection.top:
        path.moveTo(0, 0); 
        path.lineTo(size.width, 0); 
        path.lineTo(size.width / 2, size.height); 
        path.close();
        break;

      case TriangleDirection.bottom:
        
        path.moveTo(0, size.height); 
        path.lineTo(size.width, size.height); 
        path.lineTo(size.width / 2, 0); 
        path.close();
        break;

      case TriangleDirection.left:
        path.moveTo(0, 0); 
        path.lineTo(0, size.height); 
        path.lineTo(size.width, size.height / 2); 
        path.close();
        break;

      case TriangleDirection.right:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height); 
        path.lineTo(0, size.height / 2); 
        path.close();
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
