import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:apniride_flutter/screen/payment_screen.dart';
import 'package:apniride_flutter/screen/rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // import 'package:apniride_flutter/Bloc/CancelRide/cancel_ride_cubit.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:apniride_flutter/Bloc/CancelRide/cancel_ride_cubit.dart';
import 'package:apniride_flutter/model/booking_status.dart';
import 'package:apniride_flutter/screen/add_wallet_screen.dart';
import 'package:apniride_flutter/screen/payment_optinal.dart';
import 'package:apniride_flutter/utils/api_service.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:apniride_flutter/utils/shared_preference.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';

import '../Bloc/BookingStatus1/booking_status1_cubit.dart';
import '../Bloc/BookingStatus1/booking_status1_state.dart';
import '../Bloc/CancelRide/cancel_ride_state.dart';
import '../Bloc/Cashbacks/cashbacks_cubit.dart';
import '../Bloc/Cashbacks/cashbacks_state.dart';
import '../Bloc/ShowOffers/AvailableOffers/availableoffers_cubit.dart';
import '../Bloc/ShowOffers/AvailableOffers/availableoffers_state.dart';
import '../Bloc/Wallets/wallets_cubit.dart';
import '../Bloc/Wallets/wallets_state.dart';
import 'dart:math';

import 'bottom_bar.dart';

class RideTrackingScreen extends StatefulWidget {
  final BookingStatus bookingStatus;
  final int rideId;
  final num distance;

  const RideTrackingScreen(
      {super.key,
      required this.bookingStatus,
      required this.rideId,
      required this.distance});

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
  double _smoothedBearing = 0.0;
  bool _isPickupComplete = false;
  BitmapDescriptor? driverIcon;
  Timer? _statusTimer;
  late ConfettiController _confettiController;
  String? _selectedPaymentMethod;
  Razorpay? _razorpay;
  bool _addingCashback = false;
  int _waterBottles = 0;
  bool _isDialogShowing = false;
  static const double bearingSmoothingFactor = 0.3;
  static const double proximityThresholdKm = 0.05;

  @override
  void initState() {
    super.initState();
    context.read<AvailableCashbacksCubit>().getCashbacks(context);
    _initializeLocationsAndMarkers();
    _connectWebSocket();
    _loadMarkerIcon();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _startStatusCheck();
    _initializeRazorpay();
    _loadPaymentMethod();
    _initializeFirebase();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.signInAnonymously();
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          rideId: widget.rideId.toString(),
          userType: 'user',
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    context
        .read<RazorpayPaymentCubit>()
        .addWalletAmount(widget.bookingStatus.data.fare.toDouble());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment successful")),
    );
    _completePaymentAndCheckCashback();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("External wallet selected: ${response.walletName}")),
    );
  }

  Future<void> _loadPaymentMethod() async {
    String? savedMethod = await SharedPreferenceHelper.getPaymentMethod();
    if (mounted) {
      setState(() {
        _selectedPaymentMethod = savedMethod ?? 'COD';
      });
    }
    context.read<RazorpayPaymentCubit>().getWalletBalance();
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
    if (mounted) {
      setState(() {});
    }
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
      print("pickupLocations ${pickupLocations}");
      List<Location> dropoffLocations =
          await locationFromAddress(widget.bookingStatus.data.drop);
      print("pickupLocations ${dropoffLocations}");
      if (pickupLocations.isNotEmpty && dropoffLocations.isNotEmpty) {
        _pickupLocation = LatLng(
            pickupLocations.first.latitude, pickupLocations.first.longitude);
        print(_pickupLocation);
        print(_dropoffLocation);
        print("Latlng Values");
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading map coordinates: $e')),
        );
      }
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

          if (mounted) {
            setState(() {
              _polylines.clear();
              _polylines.add(Polyline(
                polylineId: const PolylineId('route'),
                points: polylineCoordinates,
                color: _isPickupComplete
                    ? Colors.green
                    : Colors.black, // Green after pickup
                width: 5,
              ));
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching route: $e");
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

  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadiusKm = 6371;
    double degToRad(double deg) => deg * (pi / 180);
    final double dLat = degToRad(point2.latitude - point1.latitude);
    final double dLng = degToRad(point2.longitude - point1.longitude);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degToRad(point1.latitude)) *
            cos(degToRad(point2.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  void _connectWebSocket() {
    try {
      /*    _webSocketChannel = IOWebSocketChannel.connect(
        'ws://192.168.0.5:9000/ws/ride/${widget.rideId}/location/',
      );*/
      _webSocketChannel = IOWebSocketChannel.connect(
        'wss://api.apniride.org/ws/ride/${widget.rideId}/location/',
      );

      _webSocketChannel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          if (data['status'] == 'pickup_completed') {
            if (mounted) {
              setState(() {
                _isPickupComplete = true;
              });
            }
            _fetchRoute(); // Refetch route to update to green polyline from pickup to drop
            return;
          }
          final double lat = double.parse(data['lat'].toString());
          final double lng = double.parse(data['lng'].toString());
          final LatLng newDriverLocation = LatLng(lat, lng);
          double rawBearing = _previousBearing ?? 0;
          if (_driverLocation != null) {
            rawBearing = _calculateBearing(_driverLocation!, newDriverLocation);
          }

          // Check proximity to pickup if not yet completed
          if (!_isPickupComplete && _pickupLocation != null) {
            final double distanceToPickup =
                _calculateDistance(newDriverLocation, _pickupLocation!);
            if (distanceToPickup <= proximityThresholdKm) {
              print(
                  'Driver reached pickup (distance: ${distanceToPickup * 1000} meters). Switching to drop route.');
              if (mounted) {
                setState(() {
                  _isPickupComplete = true;
                });
              }
              _fetchRoute(); // Switch to green polyline from pickup to drop
              return; // Exit early after switching
            }
          }

          // Smooth the bearing to reduce jittery rotation
          _smoothedBearing = _smoothedBearing +
              (rawBearing - _smoothedBearing) * bearingSmoothingFactor;

          if (mounted) {
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
                  rotation: _smoothedBearing, // Use smoothed bearing
                ),
              );
              _previousBearing = rawBearing;
            });
          }

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

  void _showCancellationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Trip Cancelled',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Your trip has been cancelled by the driver.Try again',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const BottomNavBar(
                            currentindex: 0,
                          )),
                  (route) => false,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: AppColors.background,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
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
    if (_driverLocation == null) {
      if (_pickupLocation == null || _dropoffLocation == null) return;

      final bounds = LatLngBounds(
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
      return;
    }

    // Animate camera to driver location but keep map "straight" (north-up, no tilt/bearing)
    // This prevents the map from rotating continuously
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _driverLocation!,
          zoom: 18.0,
          // bearing: 0.0, // Fixed north-up (uncomment if you want no rotation at all)
          tilt: 0.0, // No tilt for flat view
        ),
      ),
    );

    // Optional: If you want to follow with slight bearing but smoothed, uncomment below
    // _mapController?.animateCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //       target: _driverLocation!,
    //       zoom: 18.0,
    //       bearing: _smoothedBearing,
    //       tilt: 0.0,
    //     ),
    //   ),
    // );
  }

  @override
  void dispose() {
    _webSocketChannel?.sink.close();
    _mapController?.dispose();
    _statusTimer?.cancel();
    _confettiController.dispose();
    _razorpay?.clear();
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
      print('Error launching phone call: $e');
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

  void _completePaymentAndCheckCashback() {
    context.read<CashbacksCubit>().getCashbacks(context);
  }

  void _showCashbackDialog(BuildContext context, double cashback) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      size: 50.sp,
                      color: AppColors.background,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Congratulations!",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                content: Text(
                  "You've earned ₹${cashback.toStringAsFixed(2)} cashback for this ride. Collect it now to add to your wallet!",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.background,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                    ),
                    onPressed: () {
                      setState(() {
                        _addingCashback = true;
                      });
                      context
                          .read<RazorpayPaymentCubit>()
                          .addWalletAmount(cashback);
                    },
                    child: const Text("Collect Now"),
                  ),
                ],
                actionsAlignment: MainAxisAlignment.center, // Center the button
              ),
            ],
          );
        });
  }

  void _showSuccessDialog(BuildContext context, double walletBalance) {
    print("Payment method ${_selectedPaymentMethod}");
    if (_selectedPaymentMethod == 'My Wallet') {
      _handlePayment(walletBalance);
      return;
    }

    setState(() {
      _isDialogShowing = true; // Block sheet gestures
    });

    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            AlertDialog(
              backgroundColor: Colors.white,
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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Your trip has been successfully completed!",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Fare: ₹${widget.bookingStatus.data.fare.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              actions: _selectedPaymentMethod == 'Cash'
                  ? [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _completePaymentAndCheckCashback();
                        },
                        child: const Text("Payment Done"),
                      ),
                    ]
                  : _selectedPaymentMethod == 'Razorpay'
                      ? [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: () {
                              _handlePayment(walletBalance);
                            },
                            child: const Text("Pay Now"),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     Navigator.pop(context);
                          //     _completePaymentAndCheckCashback();
                          //   },
                          //   child: const Text("Pay Later"),
                          // ),
                        ]
                      : [], // No buttons for 'My Wallet'
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
    ).then((_) {
      if (mounted) {
        setState(() {
          _isDialogShowing = false; // Re-enable sheet gestures
        });
      }
    });
  }

  void _handlePayment(double walletBalance) {
    if (_selectedPaymentMethod == 'My Wallet') {
      if (walletBalance >= widget.bookingStatus.data.fare) {
        context
            .read<RazorpayPaymentCubit>()
            .addWalletAmount(-widget.bookingStatus.data.fare);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment successful from wallet")),
        );
        _completePaymentAndCheckCashback();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Insufficient wallet balance. Please add funds.")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddWalletScreen()),
        );
      }
    } else if (_selectedPaymentMethod == 'Razorpay') {
      final options = {
        'key': 'rzp_test_RWneIBNQYQoNVc',
        'amount': (widget.bookingStatus.data.fare * 100).toInt(),
        'name': 'ApniRide',
        'description': 'Ride Payment',
        //'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
        'external': {
          'wallets': ['paytm']
        }
      };

      try {
        _razorpay!.open(options);
        _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error initiating payment: $e")),
        );
      }
    }
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
                double walletBalance = 0.0;
                if (context.read<RazorpayPaymentCubit>().state
                    is RazorpayPaymentWalletFetched) {
                  walletBalance = double.tryParse((context
                              .read<RazorpayPaymentCubit>()
                              .state as RazorpayPaymentWalletFetched)
                          .wallet
                          .data
                          .balance) ??
                      0.0;
                }
                _showSuccessDialog(context, walletBalance);
              }
              if (state.bookingStatus.data.status == 'cancelled') {
                _showCancellationDialog();
              }
              if (mounted) {
                setState(() {
                  widget.bookingStatus.data = state.bookingStatus.data;
                });
              }
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
        BlocListener<RazorpayPaymentCubit, RazorpayPaymentState>(
          listener: (context, state) {
            if (state is RazorpayPaymentWalletFetched && mounted) {
              double walletBalance =
                  double.tryParse(state.wallet.data.balance) ?? 0.0;
              if (_selectedPaymentMethod == 'My Wallet' && walletBalance <= 0) {
                setState(() {
                  _selectedPaymentMethod = 'COD';
                  SharedPreferenceHelper.setPaymentMethod('COD');
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Wallet balance is 0. Payment method set to COD."),
                  ),
                );
              }
            } else if (state is RazorpayPaymentSuccess) {
              if (_addingCashback) {
                _addingCashback = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Cashback added to your wallet")),
                );
                Navigator.pop(context); // Close cashback dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RateExperienceScreen(rideId: widget.rideId)),
                  (route) => false,
                );
              }
            } else if (state is RazorpayPaymentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text("Error fetching wallet balance: ${state.error}"),
                  backgroundColor: Colors.red,
                ),
              );
              if (_addingCashback) {
                _addingCashback = false;
                // Optionally pop or handle
              }
            }
          },
        ),
        BlocListener<CashbacksCubit, CashbacksState>(
          listener: (context, state) {
            if (state is CashbacksSuccess) {
              print("Cashback success");
              double cashbackAmount = 0.0;
              String vehicle = widget.bookingStatus.data.vehicleType ?? '';
              num dist = widget.distance;
              for (var rule in state.cashbacks.data) {
                print("LoopLoop");
                print("For cashbacks");
                print("Dist ${dist}");
                print("rule ${rule.vehicleType} vehicle ${vehicle}");
                if (rule.vehicleType == vehicle &&
                    dist >= rule.minDistance &&
                    dist <= rule.maxDistance) {
                  print('Satisfied');
                  cashbackAmount = rule.cashback.toDouble();
                  break;
                }
              }
              if (cashbackAmount > 0) {
                _showCashbackDialog(context, cashbackAmount);
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RateExperienceScreen(rideId: widget.rideId)),
                  (route) => false,
                );
              }
            } else if (state is CashbacksError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RateExperienceScreen(rideId: widget.rideId)),
                (route) => false,
              );
            }
          },
        ),
        BlocListener<AvailableCashbacksCubit, AvailableCashbacksState>(
          listener: (context, state) {
            if (state is AvailableCashbacksSuccess) {
              print("Cashback success");
              String vehicle = widget.bookingStatus.data.vehicleType ?? '';
              num dist = widget.distance;
              int waterBottles = 0;
              print("dist ${dist}");
              for (var rule in state.cashbacks.data) {
                print("LoopLoop");
                print("rule ${rule.vehicleType} vehicle ${vehicle}");
                if (rule.vehicleType == vehicle &&
                    dist >= rule.minDistance &&
                    dist <= rule.maxDistance) {
                  print("Satisfied");
                  waterBottles = rule.waterBottles.toInt();
                  print("waterBottles ${waterBottles}");
                  break;
                }
              }
              if (mounted) {
                setState(() {
                  _waterBottles = waterBottles;
                  print("_waterBottles ${_waterBottles}");
                });
              }
            } else if (state is AvailableCashbacksError) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text(state.message)),
              // );
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>
              //           RateExperienceScreen(rideId: widget.rideId)),
              //       (route) => false,
              // );
            }
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
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
                          // Row(
                          //   children: [
                          //     IconButton(
                          //       icon: const Icon(Icons.arrow_back),
                          //       onPressed: () => Navigator.pop(context),
                          //     ),
                          //     Text(
                          //       "Back",
                          //       style: TextStyle(
                          //         fontSize: 16.sp,
                          //         fontWeight: FontWeight.w500,
                          //       ),
                          //     ),
                          //   ],
                          // ),
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
              IgnorePointer(
                ignoring: _isDialogShowing,
                child: DraggableScrollableSheet(
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
                                  padding:
                                      EdgeInsets.only(left: 20.w, top: 20.h),
                                  child: Text(
                                    _isPickupComplete
                                        ? "Heading to destination"
                                        : "Distance ${widget.distance} Km",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green),
                                  ),
                                ),
                                if (widget.bookingStatus.data.otp != null)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 20.w, top: 20.h),
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
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
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
                                  padding:
                                      EdgeInsets.only(left: 20.w, right: 20.w),
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
                                BlocBuilder<RazorpayPaymentCubit,
                                    RazorpayPaymentState>(
                                  builder: (context, state) {
                                    String displayMethod =
                                        _selectedPaymentMethod ?? 'COD';
                                    double walletBalance = 0.0;
                                    if (state is RazorpayPaymentWalletFetched) {
                                      walletBalance = double.tryParse(
                                              state.wallet.data.balance) ??
                                          0.0;
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         const PaymentOptinal(),
                                        //   ),
                                        // ).then((_) async {
                                        //   if (mounted) {
                                        //     String? updatedMethod =
                                        //         await SharedPreferenceHelper
                                        //             .getPaymentMethod();
                                        //     if (updatedMethod != null &&
                                        //         updatedMethod !=
                                        //             _selectedPaymentMethod) {
                                        //       setState(() {
                                        //         _selectedPaymentMethod =
                                        //             updatedMethod;
                                        //       });
                                        //     }
                                        //     // Re-fetch wallet balance to ensure accuracy
                                        //     context
                                        //         .read<RazorpayPaymentCubit>()
                                        //         .getWalletBalance();
                                        //   }
                                        // });
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
                                                      color:
                                                          Colors.grey.shade300),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      displayMethod ==
                                                              'Razorpay'
                                                          ? 'assets/razerpay.png'
                                                          : displayMethod ==
                                                                  'My Wallet'
                                                              ? 'assets/wallet.png'
                                                              : 'assets/rupee.png',
                                                      width: 30.w,
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          displayMethod,
                                                          style: TextStyle(
                                                              fontSize: 15.sp),
                                                        ),
                                                        if (displayMethod ==
                                                            'My Wallet')
                                                          Text(
                                                            "Balance: ₹${walletBalance.toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.grey,
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
                                    );
                                  },
                                ),
                                if (_waterBottles > 0) ...[
                                  ListTile(
                                    leading: Image.asset("assets/bottle.png"),
                                    title: const Text(
                                        "Free water bottle Services"),
                                    subtitle:
                                        const Text("Applicable for your rides"),
                                  ),
                                ],
                                SizedBox(height: 20.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  child: Row(
                                    children: [
                                      if (widget.bookingStatus.data
                                              .driverNumber !=
                                          null)
                                        GestureDetector(
                                          onTap: () => makePhoneCall(widget
                                              .bookingStatus
                                              .data
                                              .driverNumber!),
                                          child: CircleAvatar(
                                            radius: 25.r,
                                            backgroundColor:
                                                Colors.grey.shade200,
                                            child: Icon(Icons.call,
                                                color: AppColors.background),
                                          ),
                                        ),
                                      SizedBox(width: 10.w),
                                      // GestureDetector(
                                      //   //onTap: _openChat,
                                      //   onTap: (){
                                      //     print("Chat");
                                      //   },
                                      //   child: CircleAvatar(
                                      //     radius: 25.r,
                                      //     backgroundColor: Colors.grey.shade200,
                                      //     child: Icon(Icons.message,
                                      //         color: AppColors.background),
                                      //   ),
                                      // ),
                                      const Spacer(),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String rideId;
  final String userType;

  const ChatScreen({super.key, required this.rideId, required this.userType});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    _firestore
        .collection('chats')
        .doc(widget.rideId)
        .collection('messages')
        .add({
      'text': _messageController.text.trim(),
      'sender': widget.userType,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(widget.rideId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data() as Map<String, dynamic>;
                    final isMe = msg['sender'] == widget.userType;
                    return ListTile(
                      title: Text(msg['text']),
                      subtitle: Text(isMe
                          ? 'You'
                          : (widget.userType == 'user' ? 'Driver' : 'User')),
                      trailing: isMe ? const Icon(Icons.person) : null,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
