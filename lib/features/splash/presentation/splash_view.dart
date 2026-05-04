import 'dart:math';
import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final authManager = getIt<AuthManager>();

  late AnimationController logoController;
  late AnimationController textController;

  late Animation<double> rotation;
  late Animation<double> scale;

  late Animation<double> textOpacity;
  late Animation<Offset> textSlide;
  late Animation<double> textScale;

  @override
  void initState() {
    super.initState();

    logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    rotation = Tween(begin: 0.0, end: 2 * pi).animate(logoController);

    scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.9,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.15,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(logoController);

    textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    textOpacity = Tween(begin: 0.0, end: 1.0).animate(textController);

    textSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: textController, curve: Curves.easeOut));

    textScale = Tween(begin: 0.9, end: 1.0).animate(textController);

    Future.delayed(const Duration(milliseconds: 600), () {
      textController.forward();
    });
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final route = authManager.isLoggedIn
        ? AppRoutesName.home
        : AppRoutesName.login;

    Navigator.pushReplacementNamed(context, route);
  }

  @override
  void dispose() {
    logoController.dispose();
    textController.dispose();
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
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFFF48FB1),
              Color(0xFFF8BBD0),
              Color(0xFFFCE4EC),
              Color(0xFFFFF8F9),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: logoController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: rotation.value,
                    child: Transform.scale(scale: scale.value, child: child),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withAlpha(120),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.yellow.withAlpha(90),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    Assets.assetsImagesAppIcon,
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                ),
              ),

              const SizedBox(height: 40),
              FadeTransition(
                opacity: textOpacity,
                child: SlideTransition(
                  position: textSlide,
                  child: ScaleTransition(
                    scale: textScale,
                    child: Text(
                      AppStrings.appName,
                      style: GoogleFonts.imFellEnglish(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: AppColors.pink,
                        shadows: [
                          Shadow(
                            color: Colors.white.withAlpha(150),
                            blurRadius: 20,
                            offset: const Offset(0, 0),
                          ),
                          Shadow(
                            color: Colors.pinkAccent.withAlpha(100),
                            blurRadius: 30,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
