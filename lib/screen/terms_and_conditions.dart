import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apniride_flutter/utils/app_theme.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black87, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Terms & Conditions",
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  number: 1,
                  text:
                      "If the driver tells you to cancel the ride and promises to take you for a lower fare, you can complain. On valid proof, you’ll receive a 20% discount on your next ride.",
                ),
                _buildSection(
                  number: 2,
                  text:
                      "If the driver asks for extra charges, please report to our toll-free number. Upon verification, the driver’s account will be suspended for 24 hours.",
                ),
                _buildSection(
                  number: 3,
                  text:
                      "For rides over 10 km within the city, you will receive ₹8 cashback redeemable on a water bottle.",
                ),
                _buildSection(
                  number: 4,
                  text:
                      "For long-distance rides, complimentary water and coffee are provided. If unavailable, contact our toll-free number.",
                ),
                _buildSection(
                  number: 5,
                  text: "ApniRide is always ready to serve you.",
                ),
                _buildSection(
                  number: 6,
                  text: "Your ApniRide — India’s ApniRide!",
                ),
                _buildSection(
                  number: 7,
                  text:
                      "If a driver reaches your pickup location and the customer cancels, a cancellation fee will apply to your next ride.",
                ),
                _buildSection(
                  number: 8,
                  text:
                      "Women’s Safety: Instantly alerts the nearest police helpline (112 in India) and shares live location + driver details with your emergency contact.",
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    "Thank you for choosing ApniRide 🚗",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.background ?? Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required int number, required String text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number.",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
              color: Colors.teal,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
