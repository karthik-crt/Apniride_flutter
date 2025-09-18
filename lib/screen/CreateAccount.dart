import 'package:apniride_flutter/Bloc/UserRegister/register_cubit.dart';
import 'package:apniride_flutter/Bloc/UserRegister/register_state.dart';
import 'package:apniride_flutter/screen/permission_screen.dart';
import 'package:apniride_flutter/utils/shared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_theme.dart';

class Createaccount extends StatefulWidget {
  const Createaccount({super.key});

  @override
  State<Createaccount> createState() => _CreateaccountState();
}

class _CreateaccountState extends State<Createaccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize SharedPreferences
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final mobile = await SharedPreferenceHelper.getMobile();
      if (mobile == null || mobile.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mobile number not found')),
        );
        return;
      }
      final data = {
        'mobile': mobile,
        'username': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        "fcm_token": SharedPreferenceHelper.getFcmToken(),
      };
      context.read<RegisterCubit>().login(data, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          SharedPreferenceHelper.setToken(state.register.access);
          print("SharedPreference ${SharedPreferenceHelper.getToken()}");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PermissionScreen()),
          );
        } else if (state is RegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back_ios),
                          Text(
                            "Back",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Set up your ApniRide account",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Your name helps drivers recognize you. Your email keeps you updated with trip receipts and ride details.",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontSize: 11.sp),
                          ),
                          SizedBox(height: 20.h),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: "Full Name",
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your full name';
                              }
                              if (value.trim().length < 2) {
                                return 'Name must be at least 2 characters long';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Email (Optional)",
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                            ),
                            validator: (value) {
                              if (value != null && value.trim().isEmpty) {
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value.trim())) {
                                  return 'Please enter a valid email address';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state is RegisterLoading
                            ? null // Disable button during loading
                            : () => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: state is RegisterLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                "Allow",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
