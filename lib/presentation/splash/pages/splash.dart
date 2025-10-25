import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare/common/helpers/UserPrefrences.dart';
import 'package:petcare/core/config/assets/app_images.dart';
import 'package:petcare/core/config/assets/app_vectors.dart';
import 'package:petcare/presentation/auth/pages/login_page.dart';
import 'package:petcare/presentation/home/pages/home_page.dart';
import 'package:petcare/presentation/main/pages/main_page.dart';

import '../../../core/config/constants/app_constants.dart';
import '../../../core/config/theme/app_theme.dart';
import '../../../dependency_injection.dart';
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
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
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
    final isLogin=await sL<UserPreferences>().getLoginKey();
    if(isLogin==true){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MainPage()));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginPage()));

    }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF150339),
              Color(0xFF3F09AB),
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
                    width: 100.h,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Image.asset(AppImages.logo)
                  ),
                   SizedBox(height: 15.h),
                  Text(
                    AppConstants.appName,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    AppConstants.appTagline,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 16.sp,
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
