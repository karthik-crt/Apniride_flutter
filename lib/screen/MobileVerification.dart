import 'package:apniride_flutter/screen/CreateAccount.dart';
import 'package:apniride_flutter/utils/shared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/LoginCubit/login_cubit.dart';
import '../Bloc/LoginCubit/login_state.dart';
import 'OTP_Verification.dart';
import 'bottom_bar.dart';

class Mobileverification extends StatefulWidget {
  const Mobileverification({super.key});

  @override
  State<Mobileverification> createState() => _MobileverificationState();
}

class _MobileverificationState extends State<Mobileverification> {
  final TextEditingController mobile = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void validateAndLogin() {
    final data = {
      "mobile": mobile.text,
      "fcm_token": SharedPreferenceHelper.getFcmToken(),
    };
    context.read<LoginCubit>().login(data, context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios_rounded),
              SizedBox(
                width: 10,
              ),
              Text("Back", style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Phone number for verification",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "This number will be used for all ride-related communication. You shall receive an SMS with code for verification.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/Flag.png', // your flag image
                      width: 28,
                      height: 20,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 8),
                  const Text("+91",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: mobile,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Your mobile number",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Please enter a valid mobile number (numbers only)';
                        }

                        if (value.length != 10) {
                          return 'Mobile number must be 10 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            BlocConsumer<LoginCubit, LoginState>(
                listener: (context, loginState) {
              if (loginState is LoginSuccess) {
                SharedPreferenceHelper.setMobile(mobile.text);
                if (loginState.login.isOldUser) {
                  print("herehere");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNavBar(
                                currentindex: 0,
                              )));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Createaccount()));
                }
              }
            }, builder: (context, loginState) {
              if (loginState is LoginLoading) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E7C7B),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: Container(
                          height: 19, child: CircularProgressIndicator())),
                );
              }
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E7C7B),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    validateAndLogin();
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
