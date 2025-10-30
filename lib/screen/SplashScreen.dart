import 'dart:async';
import 'package:apniride_flutter/screen/home_screen.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:apniride_flutter/utils/shared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';
import 'bottom_bar.dart';
import 'welcome.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final token = SharedPreferenceHelper.getToken();
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
    );
    navigateToScreen();
  }

  Future<void> navigateToScreen() async {
    // 1. First, request notification permission
    final notificationGranted =
        await _locationService.requestNotificationPermission();
    print("Notification permission granted: $notificationGranted");

    // 2. Then, handle location setup (services ON → permission → coordinates)
    final locationData = await _locationService.getCurrentLocation();
    if (locationData != null) {
      print(
          "Location fetched: ${locationData['address']}, Lat: ${locationData['latitude']}, Long: ${locationData['longitude']}");
    } else {
      print("Failed to fetch location, using saved or default values");
      final savedAddress = await SharedPreferenceHelper.getDeliveryAddress();
      final savedLatitude = await SharedPreferenceHelper.getLatitude();
      final savedLongitude = await SharedPreferenceHelper.getLongitude();
      if (savedAddress == null ||
          savedLatitude == null ||
          savedLongitude == null) {
        await SharedPreferenceHelper.setDeliveryAddress(
            'Dwaraka Nagar, Visakhapatnam');
        await SharedPreferenceHelper.setLatitude(17.732000);
        await SharedPreferenceHelper.setLongitude(83.306839);
      }
    }

    // 3. Navigate after 2 seconds
    if (token != null) {
      print("tokentoken ${token}");
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          // Use pushReplacement to avoid back navigation
          context,
          MaterialPageRoute(
              builder: (context) => const BottomNavBar(
                    currentindex: 0,
                  )),
        );
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200, // Reduced size for better mobile UX
            width: double.infinity,
            child: Center(
              child: Image.asset('assets/logo.png'),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationService {
  /// Step 1: Check & prompt to turn ON location services FIRST
  Future<bool> ensureLocationServicesEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Show dialog to prompt user to enable location services
      serviceEnabled = await _showLocationServicesDialog();
      if (!serviceEnabled) {
        print("User denied enabling location services");
        return false;
      }
    }
    return true;
  }

  /// Show dialog asking user to turn on location services
  Future<bool> _showLocationServicesDialog() async {
    return await showDialog<bool>(
          context: navigatorKey
              .currentContext!, // You'll need to add GlobalKey<NavigatorState> navigatorKey
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Location Services Required"),
            content: const Text(
              "Please enable Location Services to continue.\n\n"
              "Go to Settings > Privacy > Location Services > Turn ON",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                  await Geolocator.openLocationSettings();
                },
                child: const Text(
                  "Open Settings",
                  style: TextStyle(color: AppColors.background),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Step 2: Request location permission AFTER services are enabled
  Future<bool> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;

    if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isPermanentlyDenied) {
      await _showPermissionPermanentlyDeniedDialog();
      return false;
    }

    return status.isGranted;
  }

  /// Show dialog for permanently denied permissions
  Future<void> _showPermissionPermanentlyDeniedDialog() async {
    await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Location Permission Required"),
        content: const Text(
          "Location access is permanently denied.\n\n"
          "Please enable it in Settings > Privacy > Location > YOUR_APP",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  /// Step 1: Request notification permission
  Future<bool> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      status = await Permission.notification.request();
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  /// MAIN METHOD: Proper flow - Services ON → Permission → Get Location
  Future<Map<String, dynamic>?> getCurrentLocation() async {
    // STEP 1: Ensure location services are ENABLED first
    if (!await ensureLocationServicesEnabled()) {
      print("Location services not enabled");
      return null;
    }

    // STEP 2: Request permission AFTER services are on
    if (!await requestLocationPermission()) {
      print("Location permission denied");
      return null;
    }

    // STEP 3: Get coordinates
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10), // Add timeout
      );

      // STEP 4: Reverse geocode to get address
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final address = placemarks.isNotEmpty
          ? "${placemarks[0].street ?? ''}, ${placemarks[0].locality ?? ''}, ${placemarks[0].administrativeArea ?? ''} ${placemarks[0].postalCode ?? ''}"
              .trim()
              .replaceAll(RegExp(r',\s*,'), ',')
              .replaceAll(RegExp(r',\s*$'), '')
          : 'Unknown Location';

      // STEP 5: Save to SharedPreferences
      await SharedPreferenceHelper.setLatitude(position.latitude);
      await SharedPreferenceHelper.setLongitude(position.longitude);
      await SharedPreferenceHelper.setDeliveryAddress(address);

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
      };
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }
}
