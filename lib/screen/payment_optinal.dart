import 'package:apniride_flutter/screen/home_screen.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bottom_bar.dart';

class PaymentOptinal extends StatefulWidget {
  const PaymentOptinal({super.key});

  @override
  State<PaymentOptinal> createState() => _PaymentOptinalState();
}

class _PaymentOptinalState extends State<PaymentOptinal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actionsPadding: EdgeInsets.all(10),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
        ),
        titleSpacing: 0,
        title: Text("Back",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14.sp)),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomNavBar(
                            currentindex: 0,
                          )));
            },
            child: Text(
              "Skip",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.background, fontSize: 15.sp),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("How will you pay for your rides?",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp)),
            SizedBox(height: 10.h),
            Text(
              "Choose a digital method here and enjoy fabulous offers on your rides",
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
            SizedBox(
              height: 25.h,
            ),
            content("My Wallet", "assets/wallet.png",
                subtitle: "wallet balance :₹0"),
            SizedBox(height: 10.h),
            content("Cash", "assets/rupee.png"),
            SizedBox(height: 15.h),
            Text("Add payment Methods",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp)),
            SizedBox(height: 10.h),
            content("Razorpay", "assets/razerpay.png")
          ],
        ),
      ),
    );
  }

  Widget content(String text, String iconPath, {String? subtitle}) {
    return GestureDetector(
      onTap: () {
        print("hello");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavBar(currentindex: 0)));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: ListTile(
          leading: Image.asset(iconPath),
          title: Text(text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp)),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                )
              : null,
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
