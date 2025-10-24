import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare/core/config/assets/app_images.dart';

import '../bloc/auth_bloc.dart';
import 'otp_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 80.h,),
                  Center(child: Image.asset(AppImages.logo)),
                  SizedBox(height: 10.h),
                  // Header
                  Text(
                    'Welcome to PetCare',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Enter your phone number to get started',
                    style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 14.sp,
                    )
                  ),
                  SizedBox(height: 60.h),

                  // Login Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: GoogleFonts.inter(
                                color: Color(0xff90A0B7),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                            hintText: 'Enter your 10-digit number',
                            hintStyle: GoogleFonts.inter(
                              color: Color(0xff90A0B7),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500
                            ),
                            filled: true,
                            fillColor: Color(0xffF1F1F1),

                            prefixIcon: const Icon(Icons.phone_android,color: Colors.grey,),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length != 10) {
                              return 'Please enter a valid 10-digit number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 40.h),

                        // Send OTP Button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              height: 56.h,
                              child: ElevatedButton(
                                onPressed:() {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      SendOtpEvent(_phoneController.text),
                                    );
                                    Navigator.push(context, MaterialPageRoute(builder: (_)=>OtpVerificationPage(phoneNumber: _phoneController.text)));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  elevation: 4,
                                ),
                                child:Text(
                                  'Send OTP',
                                  style: GoogleFonts.inter(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
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
    _phoneController.dispose();
    super.dispose();
  }
}