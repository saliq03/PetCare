
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}