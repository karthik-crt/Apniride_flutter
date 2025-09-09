import 'package:apniride_flutter/screen/MobileVerification.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 80.h,
                  width: 80.h,
                  alignment: Alignment.centerLeft,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              child: Image.asset('assets/Home screen.png'),
            ),
            SizedBox(
              height: 70.h,
            ),
            Container(
              padding: EdgeInsets.all(10),
              // margin: EdgeInsets.all(10),
              child: Text(
                  "From doorstep to destination, ride your way with ApniRide",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 15, color: Color(0xFF2A2A2A))),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Mobileverification()));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.background,
                ),
                child: Text(
                  "Continue With Phone Number",
                  style: TextStyle(color: Colors.white, fontSize: 17.5),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                    "By continuing, you agree that you have read and accept our T&Cs and Privacy Policy "))
          ],
        ),
      ),
    );
  }
}
