import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../widgets/splash_cloud_background.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSplashTimer();
    });
  }

  Future<void> _startSplashTimer() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    _navigateToHome();
  }

  void _navigateToHome() {
    Get.offAllNamed(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: _navigateToHome,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SplashCloudBackground(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  SizedBox(
                    width: mediaWidth * 0.45,
                    height: mediaWidth * 0.45,
                    child: Image.asset(
                      'assets/images/logo_intro.webp',
                      fit: BoxFit.contain,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                      .scale(
                        begin: const Offset(0.92, 0.92),
                        end: const Offset(1, 1),
                        duration: 600.ms,
                        curve: Curves.easeOutCubic,
                      ),
                  const Gap(8),
                  Text(
                    'EXSENSE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.5,
                      color: const Color(0xFF0F172A),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 800.ms)
                      .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
