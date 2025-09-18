import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoicesHistoryScreen extends StatefulWidget {
  const InvoicesHistoryScreen({Key? key}) : super(key: key);

  @override
  State<InvoicesHistoryScreen> createState() => _InvoicesHistoryScreenState();
}

class _InvoicesHistoryScreenState extends State<InvoicesHistoryScreen> {
  // Dummy list of rides
  final List<Map<String, String>> rides = [
    {
      "title": "Sedan, Black, DL 1A B2345",
      "address": "Abayashram, Kattamnallur, Bangalore -560049",
      "time": "9.30AM",
      "price": "₹300.00"
    },
    {
      "title": "Sedan, Black, DL 1A B2345",
      "address": "Abayashram, Kattamnallur, Bangalore -560049",
      "time": "9.30AM",
      "price": "₹300.00"
    },
    {
      "title": "Sedan, Black, DL 1A B2345",
      "address": "Abayashram, Kattamnallur, Bangalore -560049",
      "time": "9.30AM",
      "price": "₹300.00"
    },
    {
      "title": "Sedan, Black, DL 1A B2345",
      "address": "Abayashram, Kattamnallur, Bangalore -560049",
      "time": "9.30AM",
      "price": "₹300.00"
    },
  ];

  void _downloadInvoice(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Downloading Invoice for Ride ${index + 1}...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Back",
                    style: textTheme?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: rides.length,
                //separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final ride = rides[index];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.directions_car,
                                size: 28, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              ride["title"]!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Spacer(),
                            Text(
                              ride["price"]!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 13.sp,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Text(
                            "${ride["address"]}(${ride["time"]})",
                            style: textTheme?.copyWith(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                            _downloadInvoice(index);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 6.h),
                            decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(5.r)),
                            child: Text(
                              "Download Invoice (PDF)",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.white, fontSize: 8.5.sp),
                            ),
                          ),
                        ),
                        //SizedBox(height: 4.h),
                        Divider()
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
