import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apniride_flutter/utils/app_theme.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
          "About Us",
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
                _buildParagraph(
                  context,
                  'Welcome to ApniRide — Apni Sawari, Apni Choice! 🇮🇳',
                  isHeader: true,
                ),
                _buildParagraph(
                  context,
                  'ApniRide is India’s own smart and reliable ride platform designed to make everyday travel simple, safe, and affordable. Whether you need a quick bike ride, a comfortable car, or a convenient auto, ApniRide connects you with nearby verified drivers in just a few taps.',
                ),
                _buildParagraph(
                  context,
                  'We believe travel should never feel complicated — that’s why ApniRide brings transparency, comfort, and convenience together on one platform. No hidden charges, no long waits — just fast, affordable rides powered by local drivers who care.',
                ),
                SizedBox(height: 20.h),
                _buildSectionTitle(context, '🌟 Why Choose ApniRide?'),
                SizedBox(height: 10.h),
                _buildBullet(context,
                    '🚦 Fast & Reliable Rides – Find your ride instantly, anytime, anywhere.'),
                _buildBullet(context,
                    '💸 Affordable Fares – Pay only for what you ride, with zero hidden costs.'),
                _buildBullet(context,
                    '🛡️ Safety First – Every driver is verified, and rides are GPS-tracked for your safety.'),
                _buildBullet(context,
                    '⚙️ Multiple Vehicle Options – Car, Auto, or Bike — choose what suits your day.'),
                _buildBullet(context,
                    '💬 Transparent System – Clear fare, instant driver details, and live tracking.'),
                SizedBox(height: 24.h),
                _buildSectionTitle(context, '💡 Our Vision'),
                _buildParagraph(
                  context,
                  'To revolutionize local travel across India by empowering drivers and riders with a fair, fast, and transparent ride platform. We aim to make mobility accessible, affordable, and Indian at heart.',
                ),
                SizedBox(height: 20.h),
                _buildSectionTitle(context, '🤝 Our Mission'),
                _buildParagraph(
                  context,
                  'To connect every traveler with trusted local drivers, build opportunities for gig workers, and create a ride ecosystem that’s truly “By the People, For the People.”',
                ),
                SizedBox(height: 24.h),
                Center(
                  child: Text(
                    'ApniRide – Because every ride should feel like your own. 🛣️💙',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
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

  Widget _buildParagraph(BuildContext context, String text,
      {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 15.sp,
              height: 1.5,
              fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
              color: Colors.black87,
            ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.background ?? Colors.teal,
          ),
    );
  }

  Widget _buildBullet(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 15.sp,
              height: 1.5,
              color: Colors.black87,
            ),
      ),
    );
  }
}
