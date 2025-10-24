import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petcare/common/helpers/UserPrefrences.dart';
import 'package:petcare/core/config/constants/status.dart';
import 'package:petcare/dependency_injection.dart';
import 'package:petcare/presentation/main/pages/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc() : super(AuthState()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  void _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {

    // For demo, always succeed
    emit(state.copyWith(phoneNum: event.phoneNumber));
  }

  void _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {

    emit(state.copyWith(otp: event.otp));

    if (event.otp == '123456') {
      await sL<UserPreferences>().setLoginKey(true);
      emit(state.copyWith(otpStatus: Status.completed));
      Navigator.pushAndRemoveUntil(event.context, MaterialPageRoute(builder: (_)=>MainPage()),
            (route) => false, );

    } else {
      emit(state.copyWith(otpStatus: Status.error));
    }
  }


}