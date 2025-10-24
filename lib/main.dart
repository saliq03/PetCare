
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare/dependency_injection.dart';
import 'package:petcare/presentation/auth/pages/login_page.dart';
import 'package:petcare/presentation/splash/pages/splash.dart';

import 'core/config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // // @override
  // // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'PetCare',
  //     theme: AppTheme.lightTheme,
  //     debugShowCheckedModeBanner: false,
  //     home: SplashPage(),
  //   );
  // // }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) =>MaterialApp(
        title: 'PetCare',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      ),
    );

  }
}