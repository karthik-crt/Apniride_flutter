import 'package:apniride_flutter/Bloc/CancelRide/cancel_ride_cubit.dart';
import 'package:apniride_flutter/model/booking_status.dart';
import 'package:apniride_flutter/model/cancel_ride.dart';
import 'package:apniride_flutter/screen/payment_screen.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Bloc/CancelRide/cancel_ride_state.dart';

class RideTrackingScreen extends StatefulWidget {
  final BookingStatus bookingStatus;
  final int rideId;

  const RideTrackingScreen(
      {super.key, required this.bookingStatus, required this.rideId});

  @override
  _RideTrackingScreenState createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> {
  GoogleMapController? _mapController;
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    print(widget.bookingStatus.data.fare);
    _initializeLocationsAndMarkers();
  }

  Future<void> _initializeLocationsAndMarkers() async {
    try {
      List<Location> pickupLocations =
          await locationFromAddress(widget.bookingStatus.data.pickup);
      List<Location> dropoffLocations =
          await locationFromAddress(widget.bookingStatus.data.drop);

      if (pickupLocations.isNotEmpty && dropoffLocations.isNotEmpty) {
        _pickupLocation = LatLng(
            pickupLocations.first.latitude, pickupLocations.first.longitude);
        _dropoffLocation = LatLng(
            dropoffLocations.first.latitude, dropoffLocations.first.longitude);

// Create markers
        final pickupMarker = Marker(
          markerId: const MarkerId('pickup'),
          position: _pickupLocation!,
          infoWindow: InfoWindow(title: widget.bookingStatus.data.pickup),
          icon: await BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen),
        );

        final dropoffMarker = Marker(
          markerId: const MarkerId('dropoff'),
          position: _dropoffLocation!,
          infoWindow: InfoWindow(title: widget.bookingStatus.data.drop),
          icon: await BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed),
        );

        setState(() {
          _markers.addAll([pickupMarker, dropoffMarker]);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading map coordinates: $e')),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone dialer')),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _cancelRide() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Ride'),
          content: const Text('Are you sure you want to cancel this ride?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      context.read<CancelRideCubit>().cancelRides(context, widget.rideId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelRideCubit, CancelRideState>(
      listener: (context, state) {
        if (state is CancelRideSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.cancelRide.statusMessage),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is CancelRideError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
// Full-screen Google Map
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _pickupLocation ?? const LatLng(28.7041, 77.1025),
                zoom: 10,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Text(
                              "Back",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_none),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: SizedBox(
                      height: 500.h,
                      child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 10.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, top: 20),
                              child: Text(
                                "Your driver is coming in 3:35",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (widget.bookingStatus.data.otp != null)
                              Padding(
                                padding: EdgeInsets.only(left: 20, top: 20),
                                child: Text(
                                  "Your OTP: ${widget.bookingStatus.data.otp}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 15.sp,
                                        color: AppColors.background,
                                      ),
                                ),
                              ),
                            SizedBox(height: 12.h),
                            const Divider(),
// Driver info card
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: widget.bookingStatus.data
                                                .driverPhoto !=
                                            null
                                        ? Image.network(
                                            widget.bookingStatus.data
                                                .driverPhoto!,
                                            width: 80.w,
                                            height: 60.h,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Image.asset(
                                              'assets/driver.png',
                                              width: 80.w,
                                              height: 60.h,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/driver.png',
                                            width: 80.w,
                                            height: 60.h,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.bookingStatus.data
                                                  .driverName ??
                                              "Unknown Driver",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          "Vehicle Info: ${widget.bookingStatus.data.vechicleName ?? 'Unknown'}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 10.sp,
                                                color: Colors.grey.shade700,
                                              ),
                                        ),
                                        Text(
                                          "Vehicle Number: ${widget.bookingStatus.data.vehicleNumber ?? 'Unknown'}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 10.sp,
                                                color: Colors.grey.shade700,
                                              ),
                                        ),
                                        Text(
                                          "Contact: ${widget.bookingStatus.data.driverNumber ?? 'Unknown'}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 10.sp,
                                                color: Colors.grey.shade700,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/car.png',
                                    width: 50.w,
                                    height: 50.h,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            SizedBox(height: 20.h),
// Payment method section
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Payment method",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 15.sp),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "₹${widget.bookingStatus.data.fare.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentsScreen()),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset('assets/razerpay.png',
                                                width: 30.w),
                                            SizedBox(width: 8.w),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "**** **** **** 8970",
                                                  style: TextStyle(
                                                      fontSize: 15.sp),
                                                ),
                                                Text(
                                                  "Expires: 12/26",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
// Buttons
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              child: Row(
                                children: [
                                  if (widget.bookingStatus.data.driverNumber !=
                                      null)
                                    GestureDetector(
                                      onTap: () {
                                        makePhoneCall(widget
                                            .bookingStatus.data.driverNumber!);
                                      },
                                      child: CircleAvatar(
                                        radius: 25.r,
                                        backgroundColor: Colors.grey.shade200,
                                        child: Icon(Icons.call,
                                            color: AppColors.background),
                                      ),
                                    ),
                                  SizedBox(width: 10.w),
                                  CircleAvatar(
                                    radius: 25.r,
                                    backgroundColor: Colors.grey.shade200,
                                    child: Icon(Icons.message,
                                        color: AppColors.background),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: _cancelRide,
                                    child: const Text("Cancel Ride"),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
