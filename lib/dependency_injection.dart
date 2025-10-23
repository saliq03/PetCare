import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External packages
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Repository
  // getIt.registerSingleton<AuthRepository>(AuthRepository());
  // getIt.registerSingleton<FacilityRepository>(FacilityRepository());

  // Blocs
  // getIt.registerFactory(() => AuthBloc());
  // getIt.registerFactory(() => HomeBloc());
}