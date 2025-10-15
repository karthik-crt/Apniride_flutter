import 'package:apniride_flutter/screen/payment_optinal.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bottom_bar.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  // bool locationGranted = false;
  // bool phoneGranted = false;

  void requestPermissions() {
    // setState(() {
    //   locationGranted = true;
    //   phoneGranted = true;
    // });

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Permissions granted successfully")),
    // );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavBar(currentindex: 0),
      ),
      (Route<dynamic> route) => false, // removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            // Image
            Center(
              child: Image.asset(
                'assets/permission_image.png',
                height: 250,
              ),
            ),
            SizedBox(height: 20.h),
            // Title
            const Text(
              "Welcome to ApniRide",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10.h),
            // Subtitle
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Enjoy a smooth and secure ride booking experience by allowing the following permissions.",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h),
            permissionItem(
              "Location (for finding available rides)",
            ),
            const SizedBox(height: 15),
            permissionItem(
              "Phone (for account security verification)",
            ),
            const Spacer(),
            // Allow Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: requestPermissions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Allow",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget permissionItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 45.w),
      child: Row(
        children: [
          Container(
            height: 10.h,
            width: 10.h,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black87,
              ),
            ),
          )
        ],
      ),
    );
  }
}
