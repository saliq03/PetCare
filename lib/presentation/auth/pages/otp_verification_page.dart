import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare/core/config/constants/status.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/config/assets/app_images.dart';
import '../bloc/auth_bloc.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => AuthBloc(),
  child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              AppImages.loginBg,
              // width: 150.w, // adjust as needed
              // fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              padding:  EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40.r,
                      width: 40.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.grey.shade300
                      ),
                      child: Center(child: Icon(Icons.arrow_back_ios_new, size: 20.r)),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Header
                  Text(
                    'Verify Phone Number',
                    style: GoogleFonts.inter(
                      fontSize: 28.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 8.h),
                  RichText(
                    text: TextSpan(
                      text: ' Enter the OTP sent to ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: '+91 ${widget.phoneNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60.h),

                  // OTP Input Field
                  BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                  return PinCodeTextField(
                    appContext: context,
                    length: 6,
                    autoFocus: true,
                    autoDismissKeyboard: true,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12.r),
                      fieldHeight: 60,
                      fieldWidth: 50,
                      activeBorderWidth: 2,
                      selectedBorderWidth: 2,
                      activeFillColor: Colors.white,
                      activeColor:state.otpStatus==Status.error?Colors.red: Theme.of(context).primaryColor,
                      selectedColor:state.otpStatus==Status.error?Colors.red:  Theme.of(context).primaryColor,
                      inactiveColor:state.otpStatus==Status.error?Colors.red:  Colors.grey[300],
                      inactiveFillColor: Colors.grey[100],
                    ),
                    animationType: AnimationType.fade,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textStyle: GoogleFonts.inter(
                            fontSize: 20.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onCompleted: (value) {
                      // Auto-submit when OTP is complete
                      context.read<AuthBloc>().add(VerifyOtpEvent(value,context));
                    },
                    onChanged: (value) {},
                  );
              },
            ),


                  SizedBox(height: 40.h),



                  // Resend OTP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive code? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text('Resend OTP',
                          style: TextStyle(
                            color:Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                    ],
                  ),

                   SizedBox(height: 40.h),

                  // Demo Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Theme.of(context).primaryColor, size: 20),
                            SizedBox(width: 8.h),
                            Text(
                              'Demo OTP',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Use 123456 as OTP for successful verification',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}