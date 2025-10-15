// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:apniride_flutter/utils/app_theme.dart';
//
// class SearchingDriverScreen extends StatefulWidget {
//   final LatLng? pickupLocation;
//   final String? pickupAddress;
//
//   const SearchingDriverScreen({
//     super.key,
//     this.pickupLocation,
//     this.pickupAddress,
//   });
//
//   @override
//   State<SearchingDriverScreen> createState() => _SearchingDriverScreenState();
// }
//
// class _SearchingDriverScreenState extends State<SearchingDriverScreen>
//     with SingleTickerProviderStateMixin {
//   GoogleMapController? _mapController;
//   static const LatLng _defaultLocation = LatLng(17.732000, 83.306839);
//   Set<Marker> _markers = {};
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..repeat(reverse: true);
//     //_updateMarker();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _mapController?.dispose();
//     super.dispose();
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//     _updateCameraPosition();
//   }
//
//   void _updateCameraPosition() {
//     _mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: widget.pickupLocation ?? _defaultLocation,
//           zoom: 16.0,
//         ),
//       ),
//     );
//   }
//
//   // Future<void> _updateMarker() async {
//   //   if (widget.pickupLocation != null) {
//   //     setState(() async {
//   //       _markers = {
//   //         Marker(
//   //           markerId: const MarkerId('pickup'),
//   //           position: widget.pickupLocation!,
//   //           infoWindow:
//   //               InfoWindow(title: widget.pickupAddress ?? 'Pickup Location'),
//   //           // icon: BitmapDescriptor.defaultMarkerWithHue(
//   //           //     BitmapDescriptor.hueGreen),
//   //           icon: await BitmapDescriptor.fromAssetImage(
//   //             const ImageConfiguration(size: Size(15, 15)),
//   //             'assets/cab.png',
//   //           ),
//   //         ),
//   //       };
//   //     });
//   //   } else {
//   //     setState(() {
//   //       _markers = {};
//   //     });
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: widget.pickupLocation ?? _defaultLocation,
//               zoom: 16.0,
//             ),
//             markers: _markers,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             zoomGesturesEnabled: false,
//             scrollGesturesEnabled: false,
//             tiltGesturesEnabled: false,
//             rotateGesturesEnabled: false,
//           ),
//           // Centered Dotted Circle Animation
//           Center(
//             child: CustomPaint(
//               size: const Size(200, 200),
//               painter: DottedCirclePainter(animation: _controller),
//             ),
//           ),
//           Center(
//             child: Image.asset(
//               "assets/cab.png",
//               height: 80.h,
//               width: 80.w,
//             ),
//           ),
//           Positioned(
//             top: 130.h,
//             left: 100.w,
//             child: Text(
//               "Searching for driver....",
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//           ),
//           // Centered "Searching for Driver..." text
//           // Center(
//           //   child: Container(
//           //     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//           //     decoration: BoxDecoration(
//           //       color: Colors.black.withOpacity(0.7),
//           //       borderRadius: BorderRadius.circular(10),
//           //     ),
//           //     child: Text(
//           //       'Searching for Driver...',
//           //       style: TextStyle(
//           //         color: Colors.white,
//           //         fontSize: 20.sp,
//           //         fontWeight: FontWeight.bold,
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           // Cancel Request button at the bottom
//           Positioned(
//             bottom: 20.h,
//             left: 20.w,
//             right: 20.w,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.background,
//                 padding: EdgeInsets.symmetric(vertical: 15.h),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text(
//                 'Cancel Request',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class DottedCirclePainter extends CustomPainter {
//   final AnimationController animation;
//
//   DottedCirclePainter({required this.animation}) : super(repaint: animation);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;
//
//     final double dashWidth = 6;
//     final double gapWidth = 2;
//
//     for (int i = 60; i <= 180; i += 20) {
//       final double radius = i.toDouble();
//       final Offset center = Offset(size.width / 2, size.height / 2);
//       final double opacity = animation.value;
//       paint.color = paint.color.withOpacity(opacity);
//
//       final double circumference = 2 * pi * radius;
//       final int numberOfSegments =
//           (circumference / (dashWidth + gapWidth)).ceil();
//       final double segmentAngle = 2 * pi / numberOfSegments;
//
//       for (int j = 0; j < numberOfSegments; j++) {
//         final double startAngle = j * segmentAngle;
//         final double endAngle = (j + 0.5) * segmentAngle;
//         final Offset startPoint = Offset(
//           center.dx + radius * cos(startAngle),
//           center.dy + radius * sin(startAngle),
//         );
//         final Offset endPoint = Offset(
//           center.dx + radius * cos(endAngle),
//           center.dy + radius * sin(endAngle),
//         );
//         canvas.drawLine(startPoint, endPoint, paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
import 'dart:async';
import 'package:apniride_flutter/Bloc/BookingStatus/booking_status_cubit.dart';
import 'package:apniride_flutter/model/booking_status.dart';
import 'package:apniride_flutter/screen/ride_screen.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

import '../Bloc/BookingStatus/booking_status_state.dart';
import '../Bloc/CancelRide/cancel_ride_cubit.dart';

class SearchingDriverScreen extends StatefulWidget {
  final LatLng? pickupLocation;
  final String? pickupAddress;
  final String bookingId;
  final int rideId;
  final num distance;

  const SearchingDriverScreen({
    super.key,
    this.pickupLocation,
    this.pickupAddress,
    required this.bookingId,
    required this.rideId,
    required this.distance
  });

  @override
  State<SearchingDriverScreen> createState() => _SearchingDriverScreenState();
}

class _SearchingDriverScreenState extends State<SearchingDriverScreen>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  static const LatLng _defaultLocation = LatLng(17.732000, 83.306839);
  Set<Marker> _markers = {};
  late AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _updateMarker();

    // Start polling the booking status every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      context
          .read<BookingStatusCubit>()
          .fetchBookingStatus(context, widget.bookingId);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateCameraPosition();
  }

  void _updateCameraPosition() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: widget.pickupLocation ?? _defaultLocation,
          zoom: 16.0,
        ),
      ),
    );
  }

  Future<void> _updateMarker() async {
    if (widget.pickupLocation != null) {
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('pickup'),
            position: widget.pickupLocation!,
            infoWindow:
                InfoWindow(title: widget.pickupAddress ?? 'Pickup Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
        };
      });
    } else {
      setState(() {
        _markers = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingStatusCubit, BookingStatusState>(
      listener: (context, state) {
        if (state is BookingStatusSuccess &&
            state.bookingStatus.data.status == 'accepted') {
          print("Enter into the Navigation");
          _timer?.cancel(); // Stop polling
          print("Redirecting");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RideTrackingScreen(
                  bookingStatus: state.bookingStatus, rideId: widget.rideId,distance:widget.distance),
            ),
          );
        } else if (state is BookingStatusError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: widget.pickupLocation ?? _defaultLocation,
                zoom: 16.0,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: false,
            ),
            Center(
              child: CustomPaint(
                size: const Size(200, 200),
                painter: DottedCirclePainter(animation: _controller),
              ),
            ),
            Center(
              child: Image.asset(
                "assets/cab.png",
                height: 80.h,
                width: 80.w,
              ),
            ),
            Positioned(
              top: 130.h,
              left: 100.w,
              child: Text(
                "Searching for driver....",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
              child: ElevatedButton(
                onPressed: () {
                  print("Cancel the ride");
                  _timer?.cancel();
                  context
                      .read<CancelRideCubit>()
                      .cancelRides(context, widget.rideId);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Cancel Request',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DottedCirclePainter extends CustomPainter {
  final AnimationController animation;

  DottedCirclePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double dashWidth = 6;
    final double gapWidth = 2;

    for (int i = 60; i <= 180; i += 20) {
      final double radius = i.toDouble();
      final Offset center = Offset(size.width / 2, size.height / 2);
      final double opacity = animation.value;
      paint.color = paint.color.withOpacity(opacity);

      final double circumference = 2 * pi * radius;
      final int numberOfSegments =
          (circumference / (dashWidth + gapWidth)).ceil();
      final double segmentAngle = 2 * pi / numberOfSegments;

      for (int j = 0; j < numberOfSegments; j++) {
        final double startAngle = j * segmentAngle;
        final double endAngle = (j + 0.5) * segmentAngle;
        final Offset startPoint = Offset(
          center.dx + radius * cos(startAngle),
          center.dy + radius * sin(startAngle),
        );
        final Offset endPoint = Offset(
          center.dx + radius * cos(endAngle),
          center.dy + radius * sin(endAngle),
        );
        canvas.drawLine(startPoint, endPoint, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
