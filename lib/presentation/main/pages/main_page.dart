import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petcare/presentation/profile/pages/profile_page.dart';

import '../../bookings/bloc/bookings_bloc.dart';
import '../../bookings/pages/my_bookings_page.dart';
import '../../home/pages/home_page.dart';
import '../../profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    MyBookingsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.calendar_today_outlined, color: Colors.white),
          Icon(Icons.person_outlined, color: Colors.white),
        ],
        buttonBackgroundColor: Colors.black,
        backgroundColor: Colors.white,
        color: const Color(0xFF3F09AB).withOpacity(.9),
        height: 65,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
