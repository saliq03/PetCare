import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare/presentation/home/pages/home_page.dart';
import 'package:petcare/presentation/main/pages/main_page.dart';

import '../../../core/config/constants/app_constants.dart';
import '../../../core/config/theme/app_theme.dart';
import '../../location/bloc/location_bloc.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // locationBloc.add(LoadLocationsEvent());
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Replace plain backgroundColor with gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B46C1), // purple
              Color(0xFF9B7FE1), // lighter purple
              Color(0xFFB794F4), // soft lavender
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: ScaleTransition(
              scale: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.pets, size: 50, color: Color(0xFF6B46C1)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppConstants.appName,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.appTagline,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
