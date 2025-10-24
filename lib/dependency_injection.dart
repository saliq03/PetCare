import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/helpers/UserPrefrences.dart';

final sL = GetIt.instance;

Future<void> setupDependencies() async {
  // External packages
  sL.registerSingleton<UserPreferences>(UserPreferences());

}