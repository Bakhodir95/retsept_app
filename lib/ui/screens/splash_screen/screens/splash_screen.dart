import 'package:flutter/material.dart';
import 'package:retsept_app/ui/screens/splash_screen/screens/check_registor.dart';
import 'package:retsept_app/ui/screens/splash_screen/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateAfterAnimation();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _logoSlideAnimation = Tween<Offset>(
            begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _textSlideAnimation = Tween<Offset>(
            begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  Future<void> _navigateAfterAnimation() async {
    await Future.delayed(const Duration(seconds: 4)); 

    bool isRegistered = await _checkRegistrationStatus();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isRegistered ? const CheckRegistor() : const OnboardingScreen(),
      ),
      (route) => false,
    );
  }

  Future<bool> _checkRegistrationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstRegistered') ?? false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/splash.png",
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.3),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _logoSlideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SlideTransition(
                    position: _textSlideAnimation,
                    child: const Text(
                      "Meals On\nDemand",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black45,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
