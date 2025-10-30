// import 'package:apniride_flutter/Bloc/RidesHistory/rides_history_cubit.dart';
// import 'package:apniride_flutter/model/rides_history_data.dart';
// import 'package:apniride_flutter/utils/app_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
//
// import '../Bloc/RidesHistory/rides_history_state.dart'; // Added import for DateFormat
//
// class RidesHistories extends StatefulWidget {
//   const RidesHistories({Key? key}) : super(key: key);
//
//   @override
//   State<RidesHistories> createState() => _RidesHistoriesState();
// }
//
// class _RidesHistoriesState extends State<RidesHistories> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<RidesHistoryCubit>().fetchRidesHistory(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme.bodyMedium;
//
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back_ios, size: 22),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   const SizedBox(width: 5),
//                   Text(
//                     "Back",
//                     style: textTheme?.copyWith(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: BlocBuilder<RidesHistoryCubit, RidesHistoryState>(
//                 builder: (context, state) {
//                   if (state is RidesHistoryLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is RidesHistorySuccess) {
//                     final rides = state.ridesHistory.rides;
//                     if (rides.isEmpty) {
//                       return const Center(
//                           child: Text("No ride history available"));
//                     }
//                     return ListView.builder(
//                       itemCount: rides.length,
//                       itemBuilder: (context, index) {
//                         final ride = rides[index];
//
//                         // Parse the UTC createdAt and convert to IST explicitly
//                         String formattedDate;
//                         try {
//                           final utcDateTime = DateTime.parse(ride.createdAt);
//                           // Explicitly convert to IST (UTC+5:30) for reliable display
//                           final int istOffsetHours = 5;
//                           final int istOffsetMinutes = 30;
//                           final istDateTime = utcDateTime.add(
//                             Duration(
//                                 hours: istOffsetHours,
//                                 minutes: istOffsetMinutes),
//                           );
//
//                           // Debug log (remove in production)
//                           print("Original UTC createdAt: ${ride.createdAt}");
//                           print("Parsed UTC: $utcDateTime");
//                           print("Converted IST: $istDateTime");
//
//                           formattedDate = DateFormat(
//                             'MMM dd, yyyy - hh:mm a',
//                           ).format(istDateTime); // Now formats in IST
//                         } catch (e) {
//                           // Fallback if parsing fails
//                           formattedDate = 'Invalid date';
//                           print(
//                               "Date parsing error for ride ${ride.bookingId}: $e");
//                         }
//
//                         return Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 14.w, vertical: 10.h),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Icon(Icons.directions_car,
//                                       size: 28, color: Colors.grey),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       "${ride.vehicleType} (Booking ID: ${ride.bookingId})",
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyMedium
//                                           ?.copyWith(
//                                             fontSize: 13.sp,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                     ),
//                                   ),
//                                   Text(
//                                     "₹${ride.fare.toStringAsFixed(2)}",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyMedium
//                                         ?.copyWith(
//                                           fontSize: 13.sp,
//                                           color: Colors.grey.shade800,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                   ),
//                                 ],
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "From: ${ride.pickup}",
//                                       style: textTheme?.copyWith(
//                                         fontSize: 14.sp,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     Text(
//                                       "To: ${ride.drop}",
//                                       style: textTheme?.copyWith(
//                                         fontSize: 14.sp,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     Text(
//                                       "Status: ${ride.status}",
//                                       style: textTheme?.copyWith(
//                                         fontSize: 15.sp,
//                                         fontWeight: FontWeight.bold,
//                                         color: ride.status == 'completed'
//                                             ? AppColors.background
//                                             : AppColors.primary,
//                                       ),
//                                     ),
//                                     Text(
//                                       "Date: $formattedDate", // Now correctly in IST
//                                       style: textTheme?.copyWith(
//                                         fontSize: 14,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Divider(),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   } else if (state is RidesHistoryError) {
//                     return Center(child: Text(state.message));
//                   }
//                   return const Center(child: Text("No ride history available"));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:apniride_flutter/Bloc/RidesHistory/rides_history_cubit.dart';
import 'package:apniride_flutter/model/rides_history_data.dart';
import 'package:apniride_flutter/screen/bottom_bar.dart';
import 'package:apniride_flutter/screen/ride_screen.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:apniride_flutter/model/booking_status.dart'; // Import BookingStatus
import 'package:apniride_flutter/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../Bloc/RidesHistory/rides_history_state.dart';

class RidesHistories extends StatefulWidget {
  const RidesHistories({Key? key}) : super(key: key);

  @override
  State<RidesHistories> createState() => _RidesHistoriesState();
}

class _RidesHistoriesState extends State<RidesHistories> {
  @override
  void initState() {
    super.initState();
    context.read<RidesHistoryCubit>().fetchRidesHistory(context);
  }

  Future<void> _onRefresh() async {
    await context.read<RidesHistoryCubit>().fetchRidesHistory(context);
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
                  // IconButton(
                  //   icon: const Icon(Icons.arrow_back_ios, size: 22),
                  //   onPressed: () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               BottomNavBar(currentindex: 0))),
                  // ),
                  const SizedBox(width: 5),
                  Text(
                    "Rides",
                    style: textTheme?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primary,
                child: BlocBuilder<RidesHistoryCubit, RidesHistoryState>(
                  builder: (context, state) {
                    if (state is RidesHistoryLoading) {
                      print("LoadingStage...");
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RidesHistorySuccess) {
                      print("SuccessStage...");
                      final rides = state.ridesHistory.rides;
                      if (rides.isEmpty) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 100.h,
                            child: const Center(
                              child: Text("No ride history available"),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: rides.length,
                        itemBuilder: (context, index) {
                          final ride = rides[index];

                          String formattedDate;
                          try {
                            final utcDateTime = DateTime.parse(ride.createdAt);
                            const int istOffsetHours = 5;
                            const int istOffsetMinutes = 30;
                            final istDateTime = utcDateTime.add(
                              const Duration(
                                hours: istOffsetHours,
                                minutes: istOffsetMinutes,
                              ),
                            );
                            print("Original UTC createdAt: ${ride.createdAt}");
                            print("Parsed UTC: $utcDateTime");
                            print("Converted IST: $istDateTime");

                            formattedDate = DateFormat(
                              'MMM dd, yyyy - hh:mm a',
                            ).format(istDateTime);
                          } catch (e) {
                            formattedDate = 'Invalid date';
                            print(
                              "Date parsing error for ride ${ride.bookingId}: $e",
                            );
                          }

                          // Determine if the arrow icon should be shown
                          bool showArrow = ride.status == 'accepted' ||
                              ride.status == 'arrived' ||
                              ride.status == 'ongoing';

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.directions_car,
                                      size: 28,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "${ride.vehicleType} (Booking ID: ${ride.bookingId})",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "₹${ride.fare.toStringAsFixed(2)}",
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
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 30.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "From: ${ride.pickup}",
                                        style: textTheme?.copyWith(
                                          fontSize: 14.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "To: ${ride.drop}",
                                        style: textTheme?.copyWith(
                                          fontSize: 14.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "Status: ${ride.status}",
                                        style: textTheme?.copyWith(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ride.status == 'completed'
                                              ? AppColors.background
                                              : AppColors.primary,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Date: $formattedDate",
                                            style: textTheme?.copyWith(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          if (showArrow) ...[
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                final bookingStatus =
                                                    BookingStatus(
                                                  data: Data(
                                                    bookingId: ride.bookingId,
                                                    pickup: ride.pickup,
                                                    drop: ride.drop,
                                                    fare: ride.fare,
                                                    status: ride.status,
                                                    otp: ride.otp,
                                                    driverName:
                                                        ride.driverName ??
                                                            'Unknown Driver',
                                                    driverNumber:
                                                        ride.driverNumber,
                                                    vehicleNumber:
                                                        ride.driverVehicleNumber ??
                                                            '',
                                                    vechicleName:
                                                        ride.vehicleName ?? '',
                                                    driverPhoto:
                                                        ride.driverImage,
                                                    // ride.driverPhoto,
                                                    // distanceKm: ride.distanceKm,
                                                    // createdAt: ride.createdAt,
                                                    pickupTime: ride.pickupTime,
                                                    completed: ride.completed,
                                                    paid: ride.paid,
                                                    vehicleType:
                                                        ride.vehicleType,
                                                  ),
                                                  statusCode: "",
                                                  StatusMessage: '',
                                                );

                                                // Navigate to RideTrackingScreen
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RideTrackingScreen(
                                                      bookingStatus:
                                                          bookingStatus,
                                                      rideId: ride.id,
                                                      distance: ride.distanceKm,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: AppColors.background,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.arrow_forward,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is RidesHistoryError) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 100.h,
                          child: Center(child: Text(state.message)),
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 100.h,
                        child: const Center(
                          child: Text("No ride history available"),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
