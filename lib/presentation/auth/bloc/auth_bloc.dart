import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences sharedPreferences;

  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userPhoneKey = 'userPhone';

  AuthBloc({required this.sharedPreferences}) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  FutureOr<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // For demo, always succeed
    emit(OtpSent(event.phoneNumber));
  }

  FutureOr<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    if (event.otp == '123456') {
      // Save login state
      await sharedPreferences.setBool(_isLoggedInKey, true);
      await sharedPreferences.setString(_userPhoneKey, 'user_phone');

      emit(AuthSuccess());
    } else {
      emit(const AuthError('Invalid OTP. Please try again.'));
    }
  }

  FutureOr<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await sharedPreferences.remove(_isLoggedInKey);
    await sharedPreferences.remove(_userPhoneKey);
    emit(AuthLoggedOut());
  }

  FutureOr<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    final isLoggedIn = sharedPreferences.getBool(_isLoggedInKey) ?? false;

    if (isLoggedIn) {
      emit(AuthSuccess());
    } else {
      emit(AuthInitial());
    }
  }
}