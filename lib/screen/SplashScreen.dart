import 'dart:async';
import 'package:apniride_flutter/screen/home_screen.dart';
import 'package:apniride_flutter/utils/shared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
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
    if (token != null) {
      print("tokentoken ${token}");
      Timer(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const BottomNavBar(
                    currentindex: 0,
                  )),
        );
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Navigator.push(
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
            height: 500,
            width: 500,
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
  Future<bool> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    if (status.isGranted) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>?> getCurrentLocation() async {
    if (await requestLocationPermission()) {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
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
    return null;
  }
}
