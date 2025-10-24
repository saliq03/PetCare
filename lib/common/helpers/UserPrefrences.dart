import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  setLoginKey(bool loginKey) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('isLogin', loginKey);
  }


  Future<bool?> getLoginKey() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final isLogin = sp.getBool("isLogin");
    return isLogin;
  }

  setSelectedLocation (String selectedLocation) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('selectedLocation', selectedLocation);
  }


  Future<String?> getSelectedLocation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final selectedLocation = sp.getString('selectedLocation');
    return selectedLocation;
  }

  setIsCurrentLocation(bool isCurrentLocation) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('isCurrentLocation', isCurrentLocation);
  }


  Future<bool?> getIsCurrentLocation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final isCurrLoc = sp.getBool('isCurrentLocation');
    return isCurrLoc;
  }




  void removeUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}