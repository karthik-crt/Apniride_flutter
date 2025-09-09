import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> rideUpdates = [
    {
      "icon": "assets/svg/system_notification.svg",
      "title": "System",
      "message":
          "Your ride is on the way! your driver, Alex will arrive in 5 minutes. Tap to view details.",
      "time": "10.30 AM",
    },
    {
      "icon": "assets/svg/system_notification.svg",
      "title": "System",
      "message":
          "You’ve earned a ₹10 credit for your next ride! Use code APNIRIDE at checkout.",
      "time": "7.30 PM",
    },
  ];

  final List<Map<String, dynamic>> promotions = [
    {
      "icon": "assets/svg/payment_success.svg",
      "title": "Payment Successfully!",
      "message":
          "Your ride has been confirmed. Sit back, relax, and enjoy your journey with ApniRide.",
    },
    {
      "icon": "assets/svg/credit_card.svg",
      "title": "Credit Card added!",
      "message":
          "Your payment method is now ready to use. You're all set for smooth and secure bookings",
    },
    {
      "icon": "assets/svg/add_wallet.svg",
      "title": "Added Money wallet Successfully!",
      "message":
          "Your wallet has been updated. You're all set to book your next ride with ApniRide.",
    },
    {
      "icon": "assets/svg/offer.svg",
      "title": "5% Special Discount!",
      "message":
          "Enjoy a smoother ride for less. This exclusive offer has been applied to your fare automatically.",
    },
  ];

  final List<Map<String, dynamic>> datedNotifications = [
    {
      "icon": "assets/svg/system_notification.svg",
      "title": "Payment Successfully!",
      "message":
          "Your ride has been confirmed. Sit back, relax, and enjoy your journey with ApniRide.",
      "date": "July, 30 2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Notification",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ride Updates
            Text(
              "Ride Updates",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...rideUpdates.map((item) => _buildNotificationCard(
                  icon: item["icon"],
                  title: item["title"],
                  message: item["message"],
                  time: item["time"],
                )),

            const SizedBox(height: 20),

            // Promotions
            Text(
              "Promotions",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...promotions.map((item) => _buildNotificationCard(
                  icon: item["icon"],
                  title: item["title"],
                  message: item["message"],
                )),

            const SizedBox(height: 20),

            // Date Section
            Text(
              "July, 30 2025",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...datedNotifications.map((item) => _buildNotificationCard(
                  icon: item["icon"],
                  title: item["title"],
                  message: item["message"],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String icon,
    required String title,
    required String message,
    String? time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.background,
            child: SvgPicture.asset(
              icon,
              height: 22.h,
              width: 22.w,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (time != null)
                      Text(
                        time,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 11.sp, color: Colors.grey.shade600),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 11.sp, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
