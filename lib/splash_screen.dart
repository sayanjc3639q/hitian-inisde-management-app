import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main content animations
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.2, 0.8, curve: Curves.easeOutQuart)),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack)),
    );

    // Progress bar animation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _mainController.forward();
    _progressController.forward();

    // Navigate after 5.5 seconds (giving a little extra for the progress to feel complete)
    Timer(const Duration(milliseconds: 5500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const AuthWrapper(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF630606), // Lighter Maroon
              Color(0xFF4A0404), // Theme Maroon
              Color(0xFF2D0202), // Darker Maroon
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Decorative Circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            
            // Main Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),
                    
                    // Animated Logo & Name
                    AnimatedBuilder(
                      animation: _mainController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: Transform.scale(
                              scale: _scaleAnimation.value,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/HitianINSIDElogo.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'HITian Inside',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'MANAGEMENT',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const Spacer(flex: 2),
                    
                    // Bottom Content (Tagline & Progress)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            '"Somewhere between the better and the best"',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 48),
                          
                          // Custom Progress Bar
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 2,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _progressController,
                                builder: (context, child) {
                                  return FractionallySizedBox(
                                    widthFactor: _progressController.value,
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.2),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
