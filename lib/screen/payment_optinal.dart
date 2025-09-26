import 'package:apniride_flutter/screen/home_screen.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:apniride_flutter/screen/add_wallet_screen.dart';
import 'package:apniride_flutter/utils/shared_preference.dart';
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
  String? _selectedPaymentMethod;
  double? _walletBalance;

  @override
  void initState() {
    super.initState();
    _loadSavedPaymentMethod();
    _loadWalletBalance();
  }

  Future<void> _loadSavedPaymentMethod() async {
    String? savedMethod = await SharedPreferenceHelper.getPaymentMethod();
    if (savedMethod != null) {
      setState(() {
        _selectedPaymentMethod = savedMethod;
      });
    }
  }

  Future<void> _loadWalletBalance() async {
    double? balance = await SharedPreferenceHelper.getWalletBalance();
    if (mounted) {
      setState(() {
        _walletBalance = balance ?? 0.0;
        print("Loaded wallet balance: $_walletBalance");
      });
    }
  }

  Future<void> _savePaymentMethod(String method) async {
    await SharedPreferenceHelper.setPaymentMethod(method);
    setState(() {
      _selectedPaymentMethod = method;
    });
    print("Selected payment method: $method, Wallet balance: $_walletBalance");

    if (method == 'My Wallet') {
      if (_walletBalance == null || _walletBalance! <= 0) {
        print(
            "Navigating to AddWalletScreen because balance is $_walletBalance");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddWalletScreen()),
        ).then((_) {
          _loadWalletBalance(); // Reload balance after adding wallet
          if (mounted) {
            setState(() {}); // Refresh UI after returning
          }
          Navigator.pop(context); // Return to draggable sheet
        });
      } else {
        Navigator.pop(context); // Return to draggable sheet
      }
    } else {
      Navigator.pop(context); // Return to draggable sheet
    }
  }

  Widget content(String text, String iconPath, {String? subtitle}) {
    return GestureDetector(
      onTap: () {
        _savePaymentMethod(text);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: _selectedPaymentMethod == text
              ? AppColors.background.withOpacity(0.1)
              : null,
        ),
        child: ListTile(
          leading: Image.asset(iconPath),
          title: Text(text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: _selectedPaymentMethod == text
                        ? AppColors.background
                        : null,
                  )),
          subtitle: text == 'My Wallet' && subtitle != null
              ? Text(
                  subtitle.replaceAll(
                      '₹${SharedPreferenceHelper.getWalletBalance() ?? 0}',
                      '₹${_walletBalance ?? 0}'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                )
              : subtitle != null
                  ? Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    )
                  : null,
          trailing: _selectedPaymentMethod == text
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context); // Handle back button to return to draggable sheet
        return false;
      },
      child: Scaffold(
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
                Navigator.pop(context); // Return to draggable sheet on skip
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
                  subtitle: "wallet balance :₹${_walletBalance ?? 0}"),
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
      ),
    );
  }
}
