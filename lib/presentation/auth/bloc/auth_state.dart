part of 'auth_bloc.dart';

class AuthState extends Equatable {


  final String phoneNum;
  final String otp;
  final Status otpStatus;

  const AuthState({
    this.phoneNum='',
    this.otp='',
    this.otpStatus=Status.initial
  });
  AuthState copyWith({String? phoneNum,String? otp,Status? otpStatus}){
    return AuthState(
      phoneNum: phoneNum?? this.phoneNum,
      otp: otp ?? this.otp,
      otpStatus: otpStatus ?? this.otpStatus
    );
  }

  @override
  List<Object?> get props => [phoneNum,otp,otpStatus];
}