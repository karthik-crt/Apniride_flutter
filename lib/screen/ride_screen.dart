import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // import 'package:apniride_flutter/Bloc/CancelRide/cancel_ride_cubit.dart';
// import 'package:apniride_flutter/model/booking_status.dart';
// import 'package:apniride_flutter/model/cancel_ride.dart';
// import 'package:apniride_flutter/screen/payment_screen.dart';
// import 'package:apniride_flutter/utils/app_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../Bloc/CancelRide/cancel_ride_state.dart';
//
// class RideTrackingScreen extends StatefulWidget {
//   final BookingStatus bookingStatus;
//   final int rideId;
//
//   const RideTrackingScreen(
//       {super.key, required this.bookingStatus, required this.rideId});
//
//   @override
//   _RideTrackingScreenState createState() => _RideTrackingScreenState();
// }
//
// class _RideTrackingScreenState extends State<RideTrackingScreen> {
//   GoogleMapController? _mapController;
//   LatLng? _pickupLocation;
//   LatLng? _dropoffLocation;
//   final Set<Marker> _markers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     print(widget.bookingStatus.data.fare);
//     _initializeLocationsAndMarkers();
//   }
//
//   Future<void> _initializeLocationsAndMarkers() async {
//     try {
//       List<Location> pickupLocations =
//           await locationFromAddress(widget.bookingStatus.data.pickup);
//       List<Location> dropoffLocations =
//           await locationFromAddress(widget.bookingStatus.data.drop);
//
//       if (pickupLocations.isNotEmpty && dropoffLocations.isNotEmpty) {
//         _pickupLocation = LatLng(
//             pickupLocations.first.latitude, pickupLocations.first.longitude);
//         _dropoffLocation = LatLng(
//             dropoffLocations.first.latitude, dropoffLocations.first.longitude);
//
// // Create markers
//         final pickupMarker = Marker(
//           markerId: const MarkerId('pickup'),
//           position: _pickupLocation!,
//           infoWindow: InfoWindow(title: widget.bookingStatus.data.pickup),
//           icon: await BitmapDescriptor.defaultMarkerWithHue(
//               BitmapDescriptor.hueGreen),
//         );
//
//         final dropoffMarker = Marker(
//           markerId: const MarkerId('dropoff'),
//           position: _dropoffLocation!,
//           infoWindow: InfoWindow(title: widget.bookingStatus.data.drop),
//           icon: await BitmapDescriptor.defaultMarkerWithHue(
//               BitmapDescriptor.hueRed),
//         );
//
//         setState(() {
//           _markers.addAll([pickupMarker, dropoffMarker]);
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading map coordinates: $e')),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _mapController?.dispose();
//     super.dispose();
//   }
//
//   Future<void> makePhoneCall(String phoneNumber) async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
//     try {
//       if (await canLaunchUrl(phoneUri)) {
//         await launchUrl(phoneUri);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not launch phone dialer')),
//         );
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   Future<void> _cancelRide() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Cancel Ride'),
//           content: const Text('Are you sure you want to cancel this ride?'),
//           actions: [
//             TextButton(
//               child: const Text('No'),
//               onPressed: () => Navigator.of(context).pop(false),
//             ),
//             TextButton(
//               child: const Text('Yes'),
//               onPressed: () => Navigator.of(context).pop(true),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (confirmed == true) {
//       context.read<CancelRideCubit>().cancelRides(context, widget.rideId);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<CancelRideCubit, CancelRideState>(
//       listener: (context, state) {
//         if (state is CancelRideSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.cancelRide.statusMessage),
//               backgroundColor: Colors.green,
//             ),
//           );
//           Navigator.pop(context);
//         } else if (state is CancelRideError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.message),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
// // Full-screen Google Map
//             GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: _pickupLocation ?? const LatLng(28.7041, 77.1025),
//                 zoom: 10,
//               ),
//               markers: _markers,
//               onMapCreated: (GoogleMapController controller) {
//                 _mapController = controller;
//               },
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//             ),
//             SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.all(10.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.arrow_back),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                             Text(
//                               "Back",
//                               style: TextStyle(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.notifications_none),
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             DraggableScrollableSheet(
//               initialChildSize: 0.5,
//               minChildSize: 0.3,
//               maxChildSize: 0.9,
//               builder: (context, scrollController) {
//                 return Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey,
//                         spreadRadius: 0,
//                         blurRadius: 5,
//                         offset: Offset(0, -2),
//                       ),
//                     ],
//                   ),
//                   child: SingleChildScrollView(
//                     controller: scrollController,
//                     child: SizedBox(
//                       height: 500.h,
//                       child: Padding(
//                         padding: EdgeInsets.all(10.w),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   height: 10.h,
//                                   width: 90.w,
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(left: 20, top: 20),
//                               child: Text(
//                                 "Your driver is coming in 3:35",
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             if (widget.bookingStatus.data.otp != null)
//                               Padding(
//                                 padding: EdgeInsets.only(left: 20, top: 20),
//                                 child: Text(
//                                   "Your OTP: ${widget.bookingStatus.data.otp}",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium
//                                       ?.copyWith(
//                                         fontSize: 15.sp,
//                                         color: AppColors.background,
//                                       ),
//                                 ),
//                               ),
//                             SizedBox(height: 12.h),
//                             const Divider(),
// // Driver info card
//                             Padding(
//                               padding: const EdgeInsets.all(10),
//                               child: Row(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: widget.bookingStatus.data
//                                                 .driverPhoto !=
//                                             null
//                                         ? Image.network(
//                                             widget.bookingStatus.data
//                                                 .driverPhoto!,
//                                             width: 80.w,
//                                             height: 60.h,
//                                             fit: BoxFit.cover,
//                                             errorBuilder:
//                                                 (context, error, stackTrace) =>
//                                                     Image.asset(
//                                               'assets/driver.png',
//                                               width: 80.w,
//                                               height: 60.h,
//                                               fit: BoxFit.cover,
//                                             ),
//                                           )
//                                         : Image.asset(
//                                             'assets/driver.png',
//                                             width: 80.w,
//                                             height: 60.h,
//                                             fit: BoxFit.cover,
//                                           ),
//                                   ),
//                                   SizedBox(width: 10.w),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           widget.bookingStatus.data
//                                                   .driverName ??
//                                               "Unknown Driver",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyMedium
//                                               ?.copyWith(
//                                                 fontSize: 13.sp,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                         ),
//                                         Text(
//                                           "Vehicle Info: ${widget.bookingStatus.data.vechicleName ?? 'Unknown'}",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyMedium
//                                               ?.copyWith(
//                                                 fontSize: 10.sp,
//                                                 color: Colors.grey.shade700,
//                                               ),
//                                         ),
//                                         Text(
//                                           "Vehicle Number: ${widget.bookingStatus.data.vehicleNumber ?? 'Unknown'}",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyMedium
//                                               ?.copyWith(
//                                                 fontSize: 10.sp,
//                                                 color: Colors.grey.shade700,
//                                               ),
//                                         ),
//                                         Text(
//                                           "Contact: ${widget.bookingStatus.data.driverNumber ?? 'Unknown'}",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyMedium
//                                               ?.copyWith(
//                                                 fontSize: 10.sp,
//                                                 color: Colors.grey.shade700,
//                                               ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Image.asset(
//                                     'assets/car.png',
//                                     width: 50.w,
//                                     height: 50.h,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const Divider(),
//                             SizedBox(height: 20.h),
// // Payment method section
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 20, right: 20),
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     "Payment method",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyMedium
//                                         ?.copyWith(fontSize: 15.sp),
//                                   ),
//                                   const Spacer(),
//                                   Text(
//                                     "₹${widget.bookingStatus.data.fare.toStringAsFixed(2)}",
//                                     style: TextStyle(
//                                       fontSize: 18.sp,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: 4.h),
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => PaymentsScreen()),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 10.w, vertical: 5.h),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         padding: EdgeInsets.all(8.w),
//                                         decoration: BoxDecoration(
//                                           border: Border.all(
//                                               color: Colors.grey.shade300),
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             Image.asset('assets/razerpay.png',
//                                                 width: 30.w),
//                                             SizedBox(width: 8.w),
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   "**** **** **** 8970",
//                                                   style: TextStyle(
//                                                       fontSize: 15.sp),
//                                                 ),
//                                                 Text(
//                                                   "Expires: 12/26",
//                                                   style: TextStyle(
//                                                     fontSize: 12.sp,
//                                                     color: Colors.grey,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10.w),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 20.h),
// // Buttons
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 10.w, vertical: 5.h),
//                               child: Row(
//                                 children: [
//                                   if (widget.bookingStatus.data.driverNumber !=
//                                       null)
//                                     GestureDetector(
//                                       onTap: () {
//                                         makePhoneCall(widget
//                                             .bookingStatus.data.driverNumber!);
//                                       },
//                                       child: CircleAvatar(
//                                         radius: 25.r,
//                                         backgroundColor: Colors.grey.shade200,
//                                         child: Icon(Icons.call,
//                                             color: AppColors.background),
//                                       ),
//                                     ),
//                                   SizedBox(width: 10.w),
//                                   CircleAvatar(
//                                     radius: 25.r,
//                                     backgroundColor: Colors.grey.shade200,
//                                     child: Icon(Icons.message,
//                                         color: AppColors.background),
//                                   ),
//                                   const Spacer(),
//                                   ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.red,
//                                       foregroundColor: Colors.white,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                     ),
//                                     onPressed: _cancelRide,
//                                     child: const Text("Cancel Ride"),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: 20.h),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:math';
import 'package:apniride_flutter/Bloc/CancelRide/cancel_ride_cubit.dart';
import 'package:apniride_flutter/Bloc/CancelRide/cancel_ride_state.dart';
import 'package:apniride_flutter/model/booking_status.dart';
import 'package:apniride_flutter/screen/payment_screen.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import '../Bloc/BookingStatus1/booking_status1_cubit.dart';
import '../Bloc/BookingStatus1/booking_status1_state.dart';
import 'bottom_bar.dart';

class RideTrackingScreen extends StatefulWidget {
  final BookingStatus bookingStatus;
  final int rideId;

  const RideTrackingScreen({
    super.key,
    required this.bookingStatus,
    required this.rideId,
  });

  @override
  _RideTrackingScreenState createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> {
  GoogleMapController? _mapController;
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  LatLng? _driverLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  IOWebSocketChannel? _webSocketChannel;
  double? _previousBearing;
  bool _isPickupComplete = false;
  BitmapDescriptor? driverIcon;
  Timer? _statusTimer;
  late ConfettiController _confettiController;
  @override
  void initState() {
    super.initState();
    _initializeLocationsAndMarkers();
    _connectWebSocket();
    _loadMarkerIcon();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _startStatusCheck();
  }

  void _startStatusCheck() {
    _statusTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        context.read<BookingStatusCubit1>().fetchBookingStatus(
            context, widget.bookingStatus.data.bookingId.toString());
      }
    });
  }

  Future<void> _loadMarkerIcon() async {
    driverIcon = await getResizedMarker('assets/track1.png', 100);

    /* print("vfvf");
    driverIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size.fromHeight(0),
      ),
      'assets/track1.png',
    );*/

    setState(() {});
  }

  Future<BitmapDescriptor> getResizedMarker(String assetPath, int width) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? resizedData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
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

        setState(() {
          _markers.addAll([
            Marker(
              markerId: const MarkerId('pickup'),
              position: _pickupLocation!,
              infoWindow: InfoWindow(title: widget.bookingStatus.data.pickup),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            ),
            Marker(
              markerId: const MarkerId('dropoff'),
              position: _dropoffLocation!,
              infoWindow: InfoWindow(title: widget.bookingStatus.data.drop),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
            ),
          ]);
        });

        if (_driverLocation != null) {
          await _fetchRoute();
        }
        _updateCameraBounds();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading map coordinates: $e')),
      );
    }
  }

  Future<void> _fetchRoute() async {
    if (_pickupLocation == null ||
        (_driverLocation == null && !_isPickupComplete)) return;
    if (_isPickupComplete && _dropoffLocation == null) return;

    const String googleApiKey = 'AIzaSyDuMya4zkiRrzmh66-P-9_--Mfek8SXIHI';
    String url;
    if (_isPickupComplete) {
      url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_pickupLocation!.latitude},${_pickupLocation!.longitude}&destination=${_dropoffLocation!.latitude},${_dropoffLocation!.longitude}&key=$googleApiKey';
    } else {
      url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_driverLocation!.latitude},${_driverLocation!.longitude}&destination=${_pickupLocation!.latitude},${_pickupLocation!.longitude}&key=$googleApiKey';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          final points = data['routes'][0]['overview_polyline']['points'];
          final List<LatLng> polylineCoordinates = _decodePolyline(points);

          setState(() {
            _polylines.clear();
            _polylines.add(Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.black,
              width: 5,
            ));
          });
        }
      }
    } catch (e) {
      print("Error fecthing route");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error fetching route: $e')),
      // );
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _connectWebSocket() {
    try {
      _webSocketChannel = IOWebSocketChannel.connect(
        'ws://192.168.0.12:8000/ws/ride/${widget.rideId}/location/',
      );

      _webSocketChannel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          if (data['status'] == 'pickup_completed') {
            setState(() {
              _isPickupComplete = true;
            });
            _fetchRoute();
            return;
          }

          final double lat = double.parse(data['lat'].toString());
          final double lng = double.parse(data['lng'].toString());
          final LatLng newDriverLocation = LatLng(lat, lng);
          print("getting driver location ${newDriverLocation}");
          double bearing = _previousBearing ?? 0;
          if (_driverLocation != null) {
            bearing = _calculateBearing(_driverLocation!, newDriverLocation);
          }

          setState(() {
            _driverLocation = newDriverLocation;
            _markers.removeWhere((m) => m.markerId.value == 'driver');
            _markers.add(
              Marker(
                markerId: const MarkerId('driver'),
                position: newDriverLocation,
                icon: driverIcon ??
                    BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                rotation: bearing,
              ),
            );
            _previousBearing = bearing;
          });

          if (!_isPickupComplete) {
            _fetchRoute();
          }
          _updateCameraBounds();
        },
        onError: (error) {
          print('WebSocket error: $error');
          _reconnectWebSocket();
        },
        onDone: () {
          print('WebSocket closed');
          _reconnectWebSocket();
        },
      );
    } catch (e) {
      print('WebSocket connection error: $e');
      _reconnectWebSocket();
    }
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final double deltaLng = end.longitude - start.longitude;
    final double y = sin(deltaLng * pi / 180) * cos(end.latitude * pi / 180);
    final double x =
        cos(start.latitude * pi / 180) * sin(end.latitude * pi / 180) -
            sin(start.latitude * pi / 180) *
                cos(end.latitude * pi / 180) *
                cos(deltaLng * pi / 180);
    double bearing = atan2(y, x) * 180 / pi;
    return (bearing + 360) % 360;
  }

  void _reconnectWebSocket() async {
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      _connectWebSocket();
    }
  }

  void _updateCameraBounds() {
    if (_driverLocation != null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _driverLocation!,
            zoom: 18.0,
            bearing: _previousBearing ?? 0,
          ),
        ),
      );
      return;
    }
    if (_pickupLocation == null || _dropoffLocation == null) return;

    final bounds = _driverLocation != null
        ? LatLngBounds(
            southwest: LatLng(
              [
                _pickupLocation!.latitude,
                _driverLocation!.latitude,
                _dropoffLocation!.latitude
              ].reduce(min),
              [
                _pickupLocation!.longitude,
                _driverLocation!.longitude,
                _dropoffLocation!.longitude
              ].reduce(min),
            ),
            northeast: LatLng(
              [
                _pickupLocation!.latitude,
                _driverLocation!.latitude,
                _dropoffLocation!.latitude
              ].reduce(max),
              [
                _pickupLocation!.longitude,
                _driverLocation!.longitude,
                _dropoffLocation!.longitude
              ].reduce(max),
            ),
          )
        : LatLngBounds(
            southwest: LatLng(
              min(_pickupLocation!.latitude, _dropoffLocation!.latitude),
              min(_pickupLocation!.longitude, _dropoffLocation!.longitude),
            ),
            northeast: LatLng(
              max(_pickupLocation!.latitude, _dropoffLocation!.latitude),
              max(_pickupLocation!.longitude, _dropoffLocation!.longitude),
            ),
          );

    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 20));
  }

  @override
  void dispose() {
    _webSocketChannel?.sink.close();
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

  void _showSuccessDialog(BuildContext context) {
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(currentindex: 0),
              ),
              (route) => false,
            );
          }
        });
        return Stack(
          alignment: Alignment.center,
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Text(
                "Trip Completed!",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              content: Text(
                "Your trip has been successfully completed!",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.purple,
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CancelRideCubit, CancelRideState>(
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
        ),
        BlocListener<BookingStatusCubit1, BookingStatusState1>(
          listener: (context, state) {
            if (state is BookingStatusSuccess1) {
              if (state.bookingStatus.data.status == 'completed') {
                print("This trip is completed successfully");
                _statusTimer?.cancel();
                _showSuccessDialog(context);
              }
              setState(() {
                widget.bookingStatus.data = state.bookingStatus.data;
              });
            } else if (state is BookingStatusError1) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(28.7041, 77.1025),
                zoom: 17.0,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _updateCameraBounds();
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
                              onPressed: () => Navigator.pop(context),
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
                              padding: EdgeInsets.only(left: 20.w, top: 20.h),
                              child: Text(
                                _isPickupComplete
                                    ? "Heading to destination"
                                    : "Your driver is coming in 3:35",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (widget.bookingStatus.data.otp != null)
                              Padding(
                                padding: EdgeInsets.only(left: 20.w, top: 20.h),
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
                            Padding(
                              padding: EdgeInsets.all(10.w),
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
                            Padding(
                              padding: EdgeInsets.only(left: 20.w, right: 20.w),
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
                                      builder: (context) =>
                                          const PaymentsScreen()),
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              child: Row(
                                children: [
                                  if (widget.bookingStatus.data.driverNumber !=
                                      null)
                                    GestureDetector(
                                      onTap: () => makePhoneCall(widget
                                          .bookingStatus.data.driverNumber!),
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
