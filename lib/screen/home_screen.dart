// import 'dart:convert';
// import 'package:apniride_flutter/Bloc/BookRide/book_ride_cubit.dart';
// import 'package:apniride_flutter/Bloc/DisplayVehicles/display_vehicles_cubit.dart';
// import 'package:apniride_flutter/model/displayVehicles.dart';
// import 'package:apniride_flutter/screen/invoices_screen.dart';
// import 'package:apniride_flutter/screen/notification.dart';
// import 'package:apniride_flutter/screen/profile_screen.dart';
// import 'package:apniride_flutter/screen/search_bar.dart';
// import 'package:apniride_flutter/screen/searching_driver.dart';
// import 'package:apniride_flutter/utils/app_theme.dart';
// import 'package:apniride_flutter/utils/shared_preference.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:http/http.dart' as http;
//
// import '../Bloc/BookRide/book_ride_state.dart';
// import '../Bloc/DisplayVehicles/display_vehicles_state.dart';
// import '../utils/api_service.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int selectedVehicleIndex = -1;
//   GoogleMapController? _mapController;
//   LatLng? _pickupLocation;
//   LatLng? _dropLocation;
//   String? _pickupAddress;
//   String? _dropAddress;
//   Set<Marker> _markers = {};
//   Set<Polyline> _polylines = {};
//   static const LatLng _defaultLocation = LatLng(17.732000, 83.306839);
//   late PolylinePoints polylinePoints;
//   final String apiKey = 'AIzaSyDuMya4zkiRrzmh66-P-9_--Mfek8SXIHI';
//   final FocusNode _pickupFocusNode = FocusNode();
//   final FocusNode _dropFocusNode = FocusNode();
//   final TextEditingController _pickupController = TextEditingController();
//   final TextEditingController _dropController = TextEditingController();
//   bool _isEditingPickup = true;
//   final ApiService apiService = ApiService();
//
//   Future<void> bookingRide() async {
//     // if (_pickupLocation == null ||
//     //     _dropLocation == null ||
//     //     selectedVehicleIndex == -1) {
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     const SnackBar(
//     //         content: Text('Please select pickup, drop, and vehicle type')),
//     //   );
//     //   return;
//     // }
//
//     final data = {
//       "pickup": "maatuthavani",
//       "drop": "Thirumanagalam",
//       "distance_km": 8,
//       "vehicle_type": "Car",
//       "pickup_lat": "9.9171716",
//       "pickup_lng": "78.1319455",
//       "drop_lat": "9.9442",
//       "drop_lng": "78.1562",
//       "pickup_mode": "NOW",
//     };
//
//     if (mounted) {
//       context.read<BookRideCubit>().bookRides(data, context);
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     print("Apikeyy $apiKey");
//     polylinePoints = PolylinePoints(apiKey: apiKey);
//     context.read<DisplayVehiclesCubit>().displayVehicles(context);
//     final double? latitude = SharedPreferenceHelper.getLatitude()?.toDouble();
//     final double? longitude = SharedPreferenceHelper.getLongitude()?.toDouble();
//     if (latitude != null &&
//         longitude != null &&
//         latitude.isFinite &&
//         longitude.isFinite) {
//       _pickupLocation = LatLng(latitude, longitude);
//     } else {
//       _pickupLocation = _defaultLocation;
//     }
//
//     _pickupAddress = SharedPreferenceHelper.getDeliveryAddress();
//     _pickupController.text = _pickupAddress ?? '';
//     _updateMarkers();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _updateCameraPosition(_pickupLocation!);
//     });
//     _pickupFocusNode.addListener(() {
//       if (_pickupFocusNode.hasFocus) {
//         setState(() {
//           _isEditingPickup = true;
//         });
//       }
//     });
//     _dropFocusNode.addListener(() {
//       if (_dropFocusNode.hasFocus) {
//         setState(() {
//           _isEditingPickup = false;
//         });
//       }
//     });
//   }
//
//   updateFcm() async {
//     print("Update fcm");
//     String? token = await FirebaseMessaging.instance.getToken();
//     if (token != null) {
//       print("FCM Token: $token");
//       SharedPreferenceHelper.setFcmToken(token);
//       final data = {"fcm_token": token};
//       apiService.updateFcm(data);
//     }
//   }
//
//   @override
//   void dispose() {
//     _pickupFocusNode.dispose();
//     _dropFocusNode.dispose();
//     _pickupController.dispose();
//     _dropController.dispose();
//     _mapController?.dispose();
//     super.dispose();
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//     _updateCameraPosition(_pickupLocation ?? _defaultLocation);
//   }
//
//   void _updateCameraPosition(LatLng target) {
//     if (_pickupLocation != null && _dropLocation != null) {
//       LatLngBounds bounds = LatLngBounds(
//         southwest: LatLng(
//           _pickupLocation!.latitude < _dropLocation!.latitude
//               ? _pickupLocation!.latitude
//               : _dropLocation!.latitude,
//           _pickupLocation!.longitude < _dropLocation!.longitude
//               ? _pickupLocation!.longitude
//               : _dropLocation!.longitude,
//         ),
//         northeast: LatLng(
//           _pickupLocation!.latitude > _dropLocation!.latitude
//               ? _pickupLocation!.latitude
//               : _dropLocation!.latitude,
//           _pickupLocation!.longitude > _dropLocation!.longitude
//               ? _pickupLocation!.longitude
//               : _dropLocation!.longitude,
//         ),
//       );
//       _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
//     } else {
//       _mapController?.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: target, zoom: 14.0),
//         ),
//       );
//     }
//   }
//
//   Future<String?> _getAddressFromLatLng(LatLng position) async {
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey');
//     try {
//       final response = await http.get(url);
//       print("Geocoding response: ${response.body}");
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['results'].isNotEmpty) {
//           return data['results'][0]['formatted_address'];
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('No address found for this location')),
//           );
//           return 'Unknown location';
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Geocoding error: ${response.statusCode}')),
//         );
//         return 'Unknown location';
//       }
//     } catch (e) {
//       print('Error fetching address: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch address: $e')),
//       );
//       return 'Unknown location';
//     }
//   }
//
//   void _onMapTapped(LatLng position) async {
//     final address = await _getAddressFromLatLng(position);
//     setState(() {
//       if (_isEditingPickup) {
//         _pickupLocation = position;
//         _pickupAddress = address ?? 'Unknown location';
//         _pickupController.text = _pickupAddress ?? '';
//         print("Selected Pickup: $_pickupAddress, $_pickupLocation");
//       } else {
//         _dropLocation = position;
//         _dropAddress = address ?? 'Unknown location';
//         _dropController.text = _dropAddress ?? '';
//         print("Selected Drop: $_dropAddress, $_dropLocation");
//       }
//       _updateMarkers();
//       _updateCameraPosition(position);
//     });
//   }
//
//   void _updateMarkers() async {
//     final pickupMarker = _pickupLocation != null
//         ? Marker(
//             markerId: const MarkerId('pickup'),
//             position: _pickupLocation!,
//             infoWindow: InfoWindow(title: 'Pickup: $_pickupAddress'),
//             icon: await BitmapDescriptor.defaultMarkerWithHue(
//                 BitmapDescriptor.hueGreen),
//           )
//         : null;
//
//     final dropMarker = _dropLocation != null
//         ? Marker(
//             markerId: const MarkerId('drop'),
//             position: _dropLocation!,
//             infoWindow: InfoWindow(title: 'Drop: $_dropAddress'),
//             icon: await BitmapDescriptor.defaultMarkerWithHue(
//                 BitmapDescriptor.hueRed),
//           )
//         : null;
//
//     setState(() {
//       _markers = {};
//       if (pickupMarker != null) _markers.add(pickupMarker);
//       if (dropMarker != null) _markers.add(dropMarker);
//     });
//     _updatePolylines();
//   }
//
//   void _updatePolylines() async {
//     if (_pickupLocation == null || _dropLocation == null) {
//       setState(() {
//         _polylines = {};
//       });
//       return;
//     }
//
//     try {
//       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         request: PolylineRequest(
//           origin: PointLatLng(
//               _pickupLocation!.latitude, _pickupLocation!.longitude),
//           destination:
//               PointLatLng(_dropLocation!.latitude, _dropLocation!.longitude),
//           mode: TravelMode.driving,
//         ),
//       );
//
//       print("Polyline result status: ${result.status}");
//       print("Polyline points: ${result.points}");
//
//       if (result.status == 'OK' && result.points.isNotEmpty) {
//         List<LatLng> polylineCoordinates = result.points
//             .map((point) => LatLng(point.latitude, point.longitude))
//             .toList();
//
//         setState(() {
//           _polylines = {
//             Polyline(
//               polylineId: const PolylineId('route'),
//               points: polylineCoordinates,
//               color: Colors.blue,
//               width: 5,
//             ),
//           };
//         });
//       } else {
//         print(
//             'No polyline points available or status not OK: ${result.status}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load route: ${result.status}')),
//         );
//       }
//     } catch (e) {
//       print('Error fetching polyline: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load route: $e')),
//       );
//     }
//   }
//
//   void _clearLocations() {
//     setState(() {
//       final double? latitude = SharedPreferenceHelper.getLatitude()?.toDouble();
//       final double? longitude =
//           SharedPreferenceHelper.getLongitude()?.toDouble();
//       if (latitude != null &&
//           longitude != null &&
//           latitude.isFinite &&
//           longitude.isFinite) {
//         _pickupLocation = LatLng(latitude, longitude);
//       } else {
//         _pickupLocation = _defaultLocation;
//       }
//       _pickupAddress = SharedPreferenceHelper.getDeliveryAddress();
//       _pickupController.text = _pickupAddress ?? '';
//       _dropLocation = null;
//       _dropAddress = null;
//       _dropController.clear();
//       _markers = {};
//       _polylines = {};
//       _isEditingPickup = true;
//       selectedVehicleIndex = -1;
//       _updateCameraPosition(_pickupLocation ?? _defaultLocation);
//     });
//     _updateMarkers();
//   }
//
//   void _showLogoutDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Logout',
//             style: Theme.of(context)
//                 .textTheme
//                 .titleLarge
//                 ?.copyWith(fontSize: 20.sp),
//           ),
//           content: Text(
//             'Are you sure you want to logout?',
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyMedium
//                 ?.copyWith(fontSize: 16.sp),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(fontSize: 16.sp, color: Colors.grey),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'Logout',
//                 style: TextStyle(fontSize: 16.sp, color: AppColors.background),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<BookRideCubit, BookRideState>(
//       listener: (context, state) {
//         if (state is BookRideSuccess) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => SearchingDriverScreen(
//                   pickupLocation:
//                       LatLng(9.9171716, 78.1319455), // Static pickup location
//                   pickupAddress: "periyar bus stop",
//                   bookingId: state.ride.ride.bookingId,
//                   rideId: state.ride.ride.id),
//             ),
//           );
//         } else if (state is BookRideError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }
//       },
//       child: Scaffold(
//         drawer: Drawer(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               DrawerHeader(
//                 decoration: const BoxDecoration(color: AppColors.background),
//                 child: Center(
//                   child: Text(
//                     'USERNAME',
//                     style: TextStyle(color: Colors.white, fontSize: 24.sp),
//                   ),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.history, size: 20.sp),
//                 title: Text(
//                   'Invoices history',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(fontSize: 15.sp),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const InvoicesHistoryScreen()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.person, size: 20.sp),
//                 title: Text(
//                   'Profile',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(fontSize: 15.sp),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ProfileManagementScreen()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.info, size: 20.sp),
//                 title: Text(
//                   'About',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(fontSize: 15.sp),
//                 ),
//                 onTap: () {},
//               ),
//               ListTile(
//                 leading: Icon(Icons.description, size: 20.sp),
//                 title: Text(
//                   'Terms and conditions',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(fontSize: 15.sp),
//                 ),
//                 onTap: () {},
//               ),
//               ListTile(
//                 leading: Icon(Icons.logout, size: 20.sp),
//                 title: Text(
//                   'Logout',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(fontSize: 15.sp),
//                 ),
//                 onTap: () {
//                   _showLogoutDialog();
//                 },
//               ),
//             ],
//           ),
//         ),
//         body: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Builder(
//                       builder: (BuildContext context) {
//                         return GestureDetector(
//                           onTap: () {
//                             Scaffold.of(context).openDrawer();
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                               color: AppColors.background,
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Icon(
//                               Icons.menu,
//                               size: 20.sp,
//                               color: Colors.white,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const RecentPlacesScreen()),
//                             );
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                               color: AppColors.background,
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Icon(
//                               Icons.search,
//                               size: 20.sp,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10.w),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const NotificationScreen()),
//                             );
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                               color: AppColors.background,
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Icon(
//                               Icons.notifications,
//                               size: 20.sp,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10.w),
//                         GestureDetector(
//                           onTap: _clearLocations,
//                           child: Container(
//                             padding: const EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                               color: AppColors.background,
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Icon(
//                               Icons.refresh,
//                               size: 20.sp,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10.h),
//                 Container(
//                   child: GooglePlaceAutoCompleteTextField(
//                     textEditingController: _pickupController,
//                     googleAPIKey: apiKey,
//                     inputDecoration: InputDecoration(
//                       hintText: "Pickup Location",
//                       border: InputBorder.none,
//                       hintStyle: Theme.of(context).textTheme.bodyMedium,
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 8.h, horizontal: 10),
//                       prefixIcon: Icon(Icons.my_location_outlined,
//                           color: Colors.grey, size: 20.sp),
//                     ),
//                     focusNode: _pickupFocusNode,
//                     debounceTime: 800,
//                     isLatLngRequired: true,
//                     getPlaceDetailWithLatLng: (Prediction prediction) {
//                       setState(() {
//                         _pickupAddress = prediction.description;
//                         _pickupController.text = _pickupAddress ?? '';
//                         _pickupLocation = LatLng(
//                           double.parse(prediction.lat ?? '0'),
//                           double.parse(prediction.lng ?? '0'),
//                         );
//                         print(
//                             "Selected Pickup: $_pickupAddress, $_pickupLocation");
//                         _updateCameraPosition(_pickupLocation!);
//                         _updateMarkers();
//                       });
//                     },
//                     itemClick: (Prediction prediction) {
//                       _pickupController.text = prediction.description ?? '';
//                       _pickupController.selection = TextSelection.fromPosition(
//                         TextPosition(offset: _pickupController.text.length),
//                       );
//                       setState(() {
//                         _isEditingPickup = true;
//                       });
//                     },
//                     itemBuilder: (context, index, Prediction prediction) {
//                       return Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                         ),
//                         child: Text(prediction.description ?? ''),
//                       );
//                     },
//                     isCrossBtnShown: true,
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 Container(
//                   child: GooglePlaceAutoCompleteTextField(
//                     textEditingController: _dropController,
//                     googleAPIKey: apiKey,
//                     inputDecoration: InputDecoration(
//                       hintText: "Drop Location",
//                       border: InputBorder.none,
//                       hintStyle: Theme.of(context).textTheme.bodyMedium,
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 8.h, horizontal: 10),
//                       prefixIcon: Icon(Icons.location_on_outlined,
//                           color: Colors.grey, size: 20.sp),
//                     ),
//                     focusNode: _dropFocusNode,
//                     debounceTime: 800,
//                     isLatLngRequired: true,
//                     getPlaceDetailWithLatLng: (Prediction prediction) {
//                       setState(() {
//                         _dropAddress = prediction.description;
//                         _dropController.text = _dropAddress ?? '';
//                         _dropLocation = LatLng(
//                           double.parse(prediction.lat ?? '0'),
//                           double.parse(prediction.lng ?? '0'),
//                         );
//                         print("Selected Drop: $_dropAddress, $_dropLocation");
//                         _updateCameraPosition(_dropLocation!);
//                         _updateMarkers();
//                       });
//                     },
//                     itemClick: (Prediction prediction) {
//                       _dropController.text = prediction.description ?? '';
//                       _dropController.selection = TextSelection.fromPosition(
//                         TextPosition(offset: _dropController.text.length),
//                       );
//                       setState(() {
//                         _isEditingPickup = false;
//                       });
//                     },
//                     itemBuilder: (context, index, Prediction prediction) {
//                       return Container(
//                         padding: const EdgeInsets.all(10),
//                         child: Text(prediction.description ?? ''),
//                       );
//                     },
//                     seperatedBuilder: const Divider(),
//                     isCrossBtnShown: true,
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 Expanded(
//                   child:
//                       BlocBuilder<DisplayVehiclesCubit, DisplayVehiclesState>(
//                     builder: (context, state) {
//                       if (state is DisplayVehiclesLoading) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (state is DisplayVehiclesSuccess) {
//                         final vehicles = state.vehicleData.vehicleTypes;
//                         return ListView(
//                           shrinkWrap: true,
//                           physics: const AlwaysScrollableScrollPhysics(),
//                           children: [
//                             SizedBox(height: 10.h),
//                             Container(
//                               height: 200.h,
//                               child: GoogleMap(
//                                 onMapCreated: _onMapCreated,
//                                 initialCameraPosition: CameraPosition(
//                                   target: _pickupLocation ?? _defaultLocation,
//                                   zoom: 14.0,
//                                 ),
//                                 markers: _markers,
//                                 polylines: _polylines,
//                                 myLocationEnabled: true,
//                                 myLocationButtonEnabled: true,
//                                 zoomGesturesEnabled: true,
//                                 scrollGesturesEnabled: true,
//                                 tiltGesturesEnabled: true,
//                                 rotateGesturesEnabled: true,
//                                 onTap: _onMapTapped,
//                                 gestureRecognizers: {
//                                   Factory<OneSequenceGestureRecognizer>(
//                                     () => EagerGestureRecognizer(),
//                                   ),
//                                 },
//                               ),
//                             ),
//                             SizedBox(height: 20.h),
//                             ...List.generate(
//                               vehicles.length,
//                               (index) {
//                                 final vehicle = vehicles[index];
//                                 if (index == selectedVehicleIndex) {
//                                   return Card(
//                                     color: Colors.white,
//                                     elevation: 3,
//                                     margin: EdgeInsets.symmetric(vertical: 5.h),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: ListTile(
//                                       leading: Container(
//                                         width: 40.w,
//                                         height: 40.h,
//                                         child:
//                                             Image.network(vehicle.vehicleImage),
//                                       ),
//                                       title: Text(
//                                         vehicle.name,
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       subtitle: Text(
//                                           "${vehicle.description} (${vehicle.seatingCapacity} seats)"),
//                                       trailing: Text(
//                                         "₹${vehicle.baseFare}",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.green),
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   return ListTile(
//                                     leading: Container(
//                                       width: 40.w,
//                                       height: 40.h,
//                                       child:
//                                           Image.network(vehicle.vehicleImage),
//                                     ),
//                                     title: Text(vehicle.name),
//                                     subtitle: Text(
//                                         "${vehicle.description} (${vehicle.seatingCapacity} seats)"),
//                                     trailing: Text("₹${vehicle.baseFare}"),
//                                     onTap: () {
//                                       setState(() {
//                                         selectedVehicleIndex = index;
//                                       });
//                                     },
//                                   );
//                                 }
//                               },
//                             ),
//                             // Card(
//                             //   color: Colors.white,
//                             //   margin: EdgeInsets.symmetric(vertical: 5.h),
//                             //   shape: RoundedRectangleBorder(
//                             //       borderRadius: BorderRadius.circular(10),
//                             //       side: const BorderSide(color: Colors.grey)),
//                             //   child: ListTile(
//                             //     leading: Container(
//                             //       padding: EdgeInsets.symmetric(
//                             //           horizontal: 10.w, vertical: 10.h),
//                             //       decoration: const BoxDecoration(
//                             //           color: AppColors.background,
//                             //           shape: BoxShape.circle),
//                             //       child: Image.asset("assets/cashback.png"),
//                             //     ),
//                             //     title: const Text("City Rides Cashback"),
//                             //     subtitle: const Text("₹4 cashback per ride"),
//                             //     trailing:
//                             //         Icon(Icons.arrow_forward_ios, size: 16.sp),
//                             //   ),
//                             // ),
//                             ListTile(
//                               leading: Image.asset("assets/bottle.png"),
//                               title: const Text("Free water bottle Services"),
//                               subtitle: const Text("Applicable for all rides"),
//                             ),
//                             SizedBox(height: 5.h),
//                             Padding(
//                               padding: EdgeInsets.symmetric(vertical: 10.h),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: Card(
//                                       color: AppColors.background,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: ListTile(
//                                         title: const Text(
//                                           "Book Now",
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                         onTap: bookingRide,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10.w),
//                                   Expanded(
//                                     child: Card(
//                                       color: Colors.white,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: ListTile(
//                                         title: const Text(
//                                           "Schedule Ride",
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         onTap: () {},
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         );
//                       } else if (state is DisplayVehiclesError) {
//                         return Center(child: Text(state.message));
//                       }
//                       return const Center(child: Text("No vehicles available"));
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:apniride_flutter/Bloc/BookRide/book_ride_cubit.dart';
// import 'package:apniride_flutter/Bloc/DisplayVehicles/display_vehicles_cubit.dart';
// import 'package:apniride_flutter/model/displayVehicles.dart';
// import 'package:apniride_flutter/screen/invoices_screen.dart';
// import 'package:apniride_flutter/screen/notification.dart';
// import 'package:apniride_flutter/screen/payment_optinal.dart';
// import 'package:apniride_flutter/screen/profile_screen.dart';
// import 'package:apniride_flutter/screen/rating.dart';
// import 'package:apniride_flutter/screen/ratings_screen.dart';
// import 'package:apniride_flutter/screen/search_bar.dart';
// import 'package:apniride_flutter/screen/searching_driver.dart';
// import 'package:apniride_flutter/utils/app_theme.dart';
// import 'package:apniride_flutter/utils/shared_preference.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import '../Bloc/BookRide/book_ride_state.dart';
// import '../Bloc/DisplayVehicles/display_vehicles_state.dart';
// import '../utils/api_service.dart';
// import 'package:http/http.dart' as http;
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int selectedVehicleIndex = -1;
//   GoogleMapController? _mapController;
//   LatLng? _pickupLocation;
//   LatLng? _dropLocation;
//   String? _pickupAddress;
//   String? _dropAddress;
//   String? _selectedPaymentMethod = 'COD';
//   Set<Marker> _markers = {};
//   Set<Polyline> _polylines = {};
//   static const LatLng _defaultLocation = LatLng(17.732000, 83.306839);
//   final String apiKey = 'AIzaSyDuMya4zkiRrzmh66-P-9_--Mfek8SXIHI';
//   final FocusNode _pickupFocusNode = FocusNode();
//   final FocusNode _dropFocusNode = FocusNode();
//   final TextEditingController _pickupController = TextEditingController();
//   final TextEditingController _dropController = TextEditingController();
//   bool _isEditingPickup = true;
//   final ApiService apiService = ApiService();
//
//   Future<void> _fetchAndDrawPolyline() async {
//     if (_pickupLocation == null || _dropLocation == null) {
//       setState(() {
//         _polylines = {};
//       });
//       return;
//     }
//
//     final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
//         'origin=${_pickupLocation!.latitude},${_pickupLocation!.longitude}&'
//         'destination=${_dropLocation!.latitude},${_dropLocation!.longitude}&'
//         'key=$apiKey';
//
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'OK') {
//           final String encodedPolyline =
//               data['routes'][0]['overview_polyline']['points'];
//           final List<LatLng> polylinePoints = _decodePolyline(encodedPolyline);
//
//           setState(() {
//             _polylines = {
//               Polyline(
//                 polylineId: const PolylineId('route'),
//                 points: polylinePoints,
//                 color: Colors.black,
//                 width: 5,
//               ),
//             };
//           });
//         } else {
//           print('Directions API error: ${data['status']}');
//           setState(() {
//             _polylines = {};
//           });
//         }
//       } else {
//         print('Directions API HTTP error: ${response.statusCode}');
//         setState(() {
//           _polylines = {};
//         });
//       }
//     } catch (e) {
//       print('Error fetching polyline: $e');
//       setState(() {
//         _polylines = {};
//       });
//     }
//   }
//
//   // Helper method to decode polyline points
//   List<LatLng> _decodePolyline(String encoded) {
//     List<LatLng> points = [];
//     int index = 0, len = encoded.length;
//     int lat = 0, lng = 0;
//
//     while (index < len) {
//       int b, shift = 0, result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lat += dlat;
//
//       shift = 0;
//       result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lng += dlng;
//
//       points.add(LatLng(lat / 1e5, lng / 1e5));
//     }
//     return points;
//   }
//
//   Future<void> bookingRide({
//     bool isScheduleRide = false,
//     String? pickupTime,
//     required String paymentMethod,
//   }) async {
//     if (_pickupLocation == null ||
//         _dropLocation == null ||
//         selectedVehicleIndex == -1) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please select pickup, drop, and vehicle type')),
//       );
//       return;
//     }
//
//     final vehicle = context.read<DisplayVehiclesCubit>().state
//             is DisplayVehiclesSuccess
//         ? (context.read<DisplayVehiclesCubit>().state as DisplayVehiclesSuccess)
//             .vehicleData
//             .vehicleTypes[selectedVehicleIndex]
//         : null;
//
//     if (vehicle == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a valid vehicle')),
//       );
//       return;
//     }
//
//     final data = {
//       "pickup": _pickupAddress ?? "alagar kovil temple",
//       "drop": _dropAddress ?? "Meenakshi amman temple",
//       "distance_km": 8,
//       "vehicle_type": vehicle.name,
//       "pickup_lat": _pickupLocation!.latitude.toString(),
//       "pickup_lng": _pickupLocation!.longitude.toString(),
//       "drop_lat": _dropLocation!.latitude.toString(),
//       "drop_lng": _dropLocation!.longitude.toString(),
//       "pickup_mode": isScheduleRide ? "LATER" : "NOW",
//       "payment_method": paymentMethod,
//       if (isScheduleRide && pickupTime != null) "pickup_time": pickupTime,
//     };
//     print("Book data here : ${data}");
//     if (mounted) {
//       context.read<BookRideCubit>().bookRides(data, context);
//     }
//   }
//
//   Future<void> showDateTimePicker() async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 30)),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: AppColors.background,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//             dialogBackgroundColor: Colors.white,
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (pickedDate != null) {
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//         builder: (context, child) {
//           return Theme(
//             data: ThemeData.light().copyWith(
//               colorScheme: const ColorScheme.light(
//                 primary: AppColors.background,
//                 onPrimary: Colors.white,
//                 surface: Colors.white,
//                 onSurface: Colors.black,
//               ),
//               dialogBackgroundColor: Colors.white,
//             ),
//             child: child!,
//           );
//         },
//       );
//
//       if (pickedTime != null) {
//         final DateTime scheduledDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//
//         final String formattedDateTime =
//             scheduledDateTime.toUtc().toIso8601String();
//         await bookingRide(
//           isScheduleRide: true,
//           pickupTime: formattedDateTime,
//           paymentMethod: _selectedPaymentMethod!,
//         );
//       }
//     }
//   }
//
//   void _showBookingOptionsDraggableSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       builder: (BuildContext context) {
//         return FutureBuilder<String?>(
//           future: SharedPreferenceHelper.getPaymentMethod(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             String initialPaymentMethod = snapshot.data ?? 'COD';
//             return DraggableScrollableSheet(
//               initialChildSize: 0.6,
//               minChildSize: 0.3,
//               maxChildSize: 0.8,
//               builder:
//                   (BuildContext context, ScrollController scrollController) {
//                 return StatefulBuilder(
//                   builder: (BuildContext context, StateSetter setState) {
//                     if (_selectedPaymentMethod == null) {
//                       _selectedPaymentMethod = initialPaymentMethod;
//                     }
//                     return Scaffold(
//                       bottomNavigationBar: Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 20.w, vertical: 20.h),
//                         color: Colors.white,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.background,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 18.h, horizontal: 30.w),
//                             minimumSize: Size(150.w, 50.h),
//                           ),
//                           onPressed: selectedVehicleIndex != -1
//                               ? () {
//                                   Navigator.pop(context);
//                                   bookingRide(
//                                       paymentMethod: _selectedPaymentMethod!);
//                                 }
//                               : null,
//                           child: Text(
//                             'Confirm Request',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       body: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius:
//                               BorderRadius.vertical(top: Radius.circular(20.r)),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 10.0,
//                               offset: Offset(0, -1),
//                             ),
//                           ],
//                         ),
//                         child: SingleChildScrollView(
//                           controller: scrollController,
//                           child: Padding(
//                             padding: EdgeInsets.all(16.w),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Center(
//                                   child: Container(
//                                     width: 40.w,
//                                     height: 5.h,
//                                     margin: EdgeInsets.only(bottom: 10.h),
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[300],
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   'Booking Options',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleLarge
//                                       ?.copyWith(
//                                         fontSize: 20.sp,
//                                         fontWeight: FontWeight.bold,
//                                         color: AppColors.background,
//                                       ),
//                                 ),
//                                 SizedBox(height: 16.h),
//                                 Text(
//                                   'Select Vehicle',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium
//                                       ?.copyWith(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                 ),
//                                 SizedBox(height: 8.h),
//                                 BlocBuilder<DisplayVehiclesCubit,
//                                     DisplayVehiclesState>(
//                                   builder: (context, state) {
//                                     if (state is DisplayVehiclesSuccess) {
//                                       final vehicles =
//                                           state.vehicleData.vehicleTypes;
//                                       return SizedBox(
//                                         height: 150.h,
//                                         child: ListView.builder(
//                                           controller: scrollController,
//                                           itemCount: vehicles.length,
//                                           itemBuilder: (context, index) {
//                                             final vehicle = vehicles[index];
//                                             Widget item = ListTile(
//                                               contentPadding:
//                                                   EdgeInsets.symmetric(
//                                                       vertical: 4.h),
//                                               leading: Container(
//                                                 width: 40.w,
//                                                 height: 40.h,
//                                                 child: Image.network(
//                                                     vehicle.vehicleImage),
//                                               ),
//                                               title: Text(vehicle.name),
//                                               subtitle: Text(
//                                                   "${vehicle.description} (${vehicle.seatingCapacity} seats)"),
//                                               trailing: Text(
//                                                   "₹${vehicle.baseFare}",
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold)),
//                                               onTap: () {
//                                                 setState(() {
//                                                   selectedVehicleIndex = index;
//                                                 });
//                                               },
//                                             );
//                                             if (index == selectedVehicleIndex) {
//                                               return Card(
//                                                 elevation: 4.0,
//                                                 color: Colors.white,
//                                                 margin: EdgeInsets.symmetric(
//                                                     vertical: 4.h),
//                                                 child: item,
//                                               );
//                                             }
//                                             return item;
//                                           },
//                                         ),
//                                       );
//                                     }
//                                     return const Center(
//                                         child: CircularProgressIndicator());
//                                   },
//                                 ),
//                                 SizedBox(height: 16.h),
//                                 Text(
//                                   'Payment Method',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium
//                                       ?.copyWith(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                 ),
//                                 SizedBox(height: 8.h),
//                                 GestureDetector(
//                                   // onTap: () {
//                                   //   Navigator.push(
//                                   //     context,
//                                   //     MaterialPageRoute(
//                                   //       builder: (context) =>
//                                   //           const PaymentOptinal(),
//                                   //     ),
//                                   //   ).then((_) async {
//                                   //     String? updatedMethod =
//                                   //         await SharedPreferenceHelper
//                                   //             .getPaymentMethod();
//                                   //     if (updatedMethod != null &&
//                                   //         updatedMethod !=
//                                   //             _selectedPaymentMethod) {
//                                   //       setState(() {
//                                   //         _selectedPaymentMethod =
//                                   //             updatedMethod;
//                                   //       });
//                                   //     }
//                                   //   });
//                                   // },
//                                   child: ListTile(
//                                     contentPadding: EdgeInsets.zero,
//                                     leading: Icon(Icons.payment,
//                                         color: AppColors.background),
//                                     title: Text(
//                                       'Choose Payment Method',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyMedium,
//                                     ),
//                                     subtitle: _selectedPaymentMethod != null
//                                         ? Text(
//                                             _selectedPaymentMethod!,
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodySmall
//                                                 ?.copyWith(
//                                                   color: AppColors.background,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                           )
//                                         : null,
//                                     trailing: const Icon(
//                                       Icons.arrow_forward_ios,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 16.h),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<DisplayVehiclesCubit>().displayVehicles(context);
//     final double? latitude = SharedPreferenceHelper.getLatitude()?.toDouble();
//     final double? longitude = SharedPreferenceHelper.getLongitude()?.toDouble();
//     if (latitude != null &&
//         longitude != null &&
//         latitude.isFinite &&
//         longitude.isFinite) {
//       _pickupLocation = LatLng(latitude, longitude);
//     } else {
//       _pickupLocation = _defaultLocation;
//     }
//
//     _pickupAddress = SharedPreferenceHelper.getDeliveryAddress();
//     _pickupController.text = _pickupAddress ?? '';
//     _updateMarkers();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _updateCameraPosition(_pickupLocation!);
//     });
//     _pickupFocusNode.addListener(() {
//       if (_pickupFocusNode.hasFocus) {
//         setState(() {
//           _isEditingPickup = true;
//         });
//       }
//     });
//     _dropFocusNode.addListener(() {
//       if (_dropFocusNode.hasFocus) {
//         setState(() {
//           _isEditingPickup = false;
//         });
//       }
//     });
//     updateFcm();
//   }
//
//   updateFcm() async {
//     print("Update fcm");
//     String? token = await FirebaseMessaging.instance.getToken();
//     if (token != null) {
//       print("FCM Token: $token");
//       SharedPreferenceHelper.setFcmToken(token);
//       final data = {"fcm_token": token};
//       apiService.updateFcm(data);
//     }
//   }
//
//   @override
//   void dispose() {
//     _pickupFocusNode.dispose();
//     _dropFocusNode.dispose();
//     _pickupController.dispose();
//     _dropController.dispose();
//     _mapController?.dispose();
//     super.dispose();
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//     _updateCameraPosition(_pickupLocation ?? _defaultLocation);
//   }
//
//   void _updateCameraPosition(LatLng target) {
//     if (_pickupLocation != null && _dropLocation != null) {
//       LatLngBounds bounds = LatLngBounds(
//         southwest: LatLng(
//           _pickupLocation!.latitude < _dropLocation!.latitude
//               ? _pickupLocation!.latitude
//               : _dropLocation!.latitude,
//           _pickupLocation!.longitude < _dropLocation!.longitude
//               ? _pickupLocation!.longitude
//               : _dropLocation!.longitude,
//         ),
//         northeast: LatLng(
//           _pickupLocation!.latitude > _dropLocation!.latitude
//               ? _pickupLocation!.latitude
//               : _dropLocation!.latitude,
//           _pickupLocation!.longitude > _dropLocation!.longitude
//               ? _pickupLocation!.longitude
//               : _dropLocation!.longitude,
//         ),
//       );
//       _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
//     } else {
//       _mapController?.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: target, zoom: 17.0),
//         ),
//       );
//     }
//   }
//
//   Future<String?> _getAddressFromLatLng(LatLng position) async {
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey');
//     try {
//       final response = await http.get(url);
//       print("Geocoding response: ${response.body}");
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['results'].isNotEmpty) {
//           return data['results'][0]['formatted_address'];
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('No address found for this location')),
//           );
//           return 'Unknown location';
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Geocoding error: ${response.statusCode}')),
//         );
//         return 'Unknown location';
//       }
//     } catch (e) {
//       print('Error fetching address: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch address: $e')),
//       );
//       return 'Unknown location';
//     }
//   }
//
//   void _onMapTapped(LatLng position) async {
//     final address = await _getAddressFromLatLng(position);
//     setState(() {
//       if (_isEditingPickup) {
//         _pickupLocation = position;
//         _pickupAddress = address ?? 'Unknown location';
//         _pickupController.text = _pickupAddress ?? '';
//         print("Selected Pickup: $_pickupAddress, $_pickupLocation");
//       } else {
//         _dropLocation = position;
//         _dropAddress = address ?? 'Unknown location';
//         _dropController.text = _dropAddress ?? '';
//         print("Selected Drop: $_dropAddress, $_dropLocation");
//       }
//       _updateMarkers();
//       _updateCameraPosition(position);
//       _fetchAndDrawPolyline(); // Fetch and draw polyline after location update
//     });
//   }
//
//   void _updateMarkers() async {
//     final pickupMarker = _pickupLocation != null
//         ? Marker(
//             markerId: const MarkerId('pickup'),
//             position: _pickupLocation!,
//             infoWindow: InfoWindow(title: 'Pickup: $_pickupAddress'),
//             icon: await BitmapDescriptor.defaultMarkerWithHue(
//                 BitmapDescriptor.hueGreen),
//           )
//         : null;
//
//     final dropMarker = _dropLocation != null
//         ? Marker(
//             markerId: const MarkerId('drop'),
//             position: _dropLocation!,
//             infoWindow: InfoWindow(title: 'Drop: $_dropAddress'),
//             icon: await BitmapDescriptor.defaultMarkerWithHue(
//                 BitmapDescriptor.hueRed),
//           )
//         : null;
//
//     setState(() {
//       _markers = {};
//       if (pickupMarker != null) _markers.add(pickupMarker);
//       if (dropMarker != null) _markers.add(dropMarker);
//     });
//     _fetchAndDrawPolyline(); // Fetch and draw polyline after updating markers
//   }
//
//   void _clearLocations() {
//     setState(() {
//       final double? latitude = SharedPreferenceHelper.getLatitude()?.toDouble();
//       final double? longitude =
//           SharedPreferenceHelper.getLongitude()?.toDouble();
//       if (latitude != null &&
//           longitude != null &&
//           latitude.isFinite &&
//           longitude.isFinite) {
//         _pickupLocation = LatLng(latitude, longitude);
//       } else {
//         _pickupLocation = _defaultLocation;
//       }
//       _pickupAddress = SharedPreferenceHelper.getDeliveryAddress();
//       _pickupController.text = _pickupAddress ?? '';
//       _dropLocation = null;
//       _dropAddress = null;
//       _dropController.clear();
//       _markers = {};
//       _polylines = {};
//       _isEditingPickup = true;
//       selectedVehicleIndex = -1;
//       _selectedPaymentMethod = 'COD';
//       _updateCameraPosition(_pickupLocation ?? _defaultLocation);
//     });
//     _updateMarkers();
//   }
//
//   void _showLogoutDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Logout',
//             style: Theme.of(context)
//                 .textTheme
//                 .titleLarge
//                 ?.copyWith(fontSize: 20.sp),
//           ),
//           content: Text(
//             'Are you sure you want to logout?',
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyMedium
//                 ?.copyWith(fontSize: 16.sp),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(fontSize: 16.sp, color: Colors.grey),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'Logout',
//                 style: TextStyle(fontSize: 16.sp, color: AppColors.background),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   bool get _isProceedEnabled =>
//       _pickupLocation != null && _dropLocation != null;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<BookRideCubit, BookRideState>(
//       listener: (context, state) {
//         if (state is BookRideSuccess) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => SearchingDriverScreen(
//                 pickupLocation: LatLng(9.9171716, 78.1319455),
//                 pickupAddress: "periyar bus stop",
//                 bookingId: state.ride.ride.bookingId,
//                 rideId: state.ride.ride.id,
//               ),
//             ),
//           );
//         } else if (state is BookRideError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }
//       },
//       child: Scaffold(
//         drawer: Drawer(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               DrawerHeader(
//                 decoration: const BoxDecoration(color: AppColors.background),
//                 child: Center(
//                   child: Text(
//                     'USERNAME',
//                     style: TextStyle(color: Colors.white, fontSize: 24.sp),
//                   ),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.history, size: 20.sp),
//                 title: Text(
//                   'Invoices history',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(fontSize: 15.sp),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const InvoicesHistoryScreen()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.person, size: 20.sp),
//                 title: Text(
//                   'Profile',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(fontSize: 15.sp),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ProfileManagementScreen()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.info, size: 20.sp),
//                 title: Text(
//                   'About',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(fontSize: 15.sp),
//                 ),
//                 onTap: () {},
//               ),
//               // ListTile(
//               //   leading: Icon(Icons.info, size: 20.sp),
//               //   title: Text(
//               //     'Ratings',
//               //     style: Theme.of(context)
//               //         .textTheme
//               //         .bodyMedium
//               //         ?.copyWith(fontSize: 15.sp),
//               //   ),
//               //   onTap: () {
//               //     Navigator.push(
//               //         context,
//               //         MaterialPageRoute(
//               //             builder: (context) => RateExperienceScreen(rideId: 20)));
//               //   },
//               // ),
//               ListTile(
//                 leading: Icon(Icons.description, size: 20.sp),
//                 title: Text(
//                   'Terms and conditions',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(fontSize: 15.sp),
//                 ),
//                 onTap: () {},
//               ),
//               ListTile(
//                 leading: Icon(Icons.logout, size: 20.sp),
//                 title: Text(
//                   'Logout',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(fontSize: 15.sp),
//                 ),
//                 onTap: () {
//                   _showLogoutDialog();
//                 },
//               ),
//             ],
//           ),
//         ),
//         body: Stack(
//           children: [
//             SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Builder(
//                           builder: (BuildContext context) {
//                             return GestureDetector(
//                               onTap: () {
//                                 Scaffold.of(context).openDrawer();
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.background,
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Icon(
//                                   Icons.menu,
//                                   size: 20.sp,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const RecentPlacesScreen()),
//                                 );
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.background,
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Icon(
//                                   Icons.search,
//                                   size: 20.sp,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10.w),
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const NotificationScreen()),
//                                 );
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.background,
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Icon(
//                                   Icons.notifications,
//                                   size: 20.sp,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10.w),
//                             // GestureDetector(
//                             //   onTap: _clearLocations,
//                             //   child: Container(
//                             //     padding: const EdgeInsets.all(5),
//                             //     decoration: BoxDecoration(
//                             //       color: AppColors.background,
//                             //       borderRadius: BorderRadius.circular(5),
//                             //     ),
//                             //     child: Icon(
//                             //       Icons.refresh,
//                             //       size: 20.sp,
//                             //       color: Colors.white,
//                             //     ),
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10.h),
//                     Container(
//                       child: GooglePlaceAutoCompleteTextField(
//                         textEditingController: _pickupController,
//                         googleAPIKey: apiKey,
//                         inputDecoration: InputDecoration(
//                           hintText: "Pickup Location",
//                           border: InputBorder.none,
//                           hintStyle: Theme.of(context).textTheme.bodyMedium,
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 8.h, horizontal: 10),
//                           prefixIcon: Icon(Icons.my_location_outlined,
//                               color: Colors.grey, size: 20.sp),
//                         ),
//                         focusNode: _pickupFocusNode,
//                         debounceTime: 800,
//                         isLatLngRequired: true,
//                         getPlaceDetailWithLatLng: (Prediction prediction) {
//                           setState(() {
//                             _pickupAddress = prediction.description;
//                             _pickupController.text = _pickupAddress ?? '';
//                             _pickupLocation = LatLng(
//                               double.parse(prediction.lat ?? '0'),
//                               double.parse(prediction.lng ?? '0'),
//                             );
//                             print(
//                                 "Selected Pickup: $_pickupAddress, $_pickupLocation");
//                             _updateCameraPosition(_pickupLocation!);
//                             _updateMarkers();
//                             _fetchAndDrawPolyline();
//                           });
//                         },
//                         itemClick: (Prediction prediction) {
//                           _pickupController.text = prediction.description ?? '';
//                           _pickupController.selection =
//                               TextSelection.fromPosition(
//                             TextPosition(offset: _pickupController.text.length),
//                           );
//                           setState(() {
//                             _isEditingPickup = true;
//                           });
//                         },
//                         itemBuilder: (context, index, Prediction prediction) {
//                           return Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                             ),
//                             child: Text(prediction.description ?? ''),
//                           );
//                         },
//                         isCrossBtnShown: true,
//                       ),
//                     ),
//                     SizedBox(height: 10.h),
//                     Container(
//                       child: GooglePlaceAutoCompleteTextField(
//                         textEditingController: _dropController,
//                         googleAPIKey: apiKey,
//                         inputDecoration: InputDecoration(
//                           hintText: "Drop Location",
//                           border: InputBorder.none,
//                           hintStyle: Theme.of(context).textTheme.bodyMedium,
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 8.h, horizontal: 10),
//                           prefixIcon: Icon(Icons.location_on_outlined,
//                               color: Colors.grey, size: 20.sp),
//                         ),
//                         focusNode: _dropFocusNode,
//                         debounceTime: 800,
//                         isLatLngRequired: true,
//                         getPlaceDetailWithLatLng: (Prediction prediction) {
//                           setState(() {
//                             _dropAddress = prediction.description;
//                             _dropController.text = _dropAddress ?? '';
//                             _dropLocation = LatLng(
//                               double.parse(prediction.lat ?? '0'),
//                               double.parse(prediction.lng ?? '0'),
//                             );
//                             print(
//                                 "Selected Drop: $_dropAddress, $_dropLocation");
//                             _updateCameraPosition(_dropLocation!);
//                             _updateMarkers();
//                             _fetchAndDrawPolyline(); // Fetch polyline after drop update
//                           });
//                         },
//                         itemClick: (Prediction prediction) {
//                           _dropController.text = prediction.description ?? '';
//                           _dropController.selection =
//                               TextSelection.fromPosition(
//                             TextPosition(offset: _dropController.text.length),
//                           );
//                           setState(() {
//                             _isEditingPickup = false;
//                           });
//                         },
//                         itemBuilder: (context, index, Prediction prediction) {
//                           return Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                             ),
//                             child: Text(prediction.description ?? ''),
//                           );
//                         },
//                         isCrossBtnShown: true,
//                       ),
//                     ),
//                     SizedBox(height: 10.h),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           Expanded(
//                             child: BlocBuilder<DisplayVehiclesCubit,
//                                 DisplayVehiclesState>(
//                               builder: (context, state) {
//                                 if (state is DisplayVehiclesLoading) {
//                                   return const Center(
//                                       child: CircularProgressIndicator());
//                                 } else if (state is DisplayVehiclesSuccess) {
//                                   final vehicles =
//                                       state.vehicleData.vehicleTypes;
//                                   return GoogleMap(
//                                     onMapCreated: _onMapCreated,
//                                     initialCameraPosition: CameraPosition(
//                                       target:
//                                           _pickupLocation ?? _defaultLocation,
//                                       zoom: 17.0,
//                                     ),
//                                     markers: _markers,
//                                     polylines:
//                                         _polylines, // Add polylines to GoogleMap
//                                     myLocationEnabled: true,
//                                     myLocationButtonEnabled: true,
//                                     zoomGesturesEnabled: true,
//                                     scrollGesturesEnabled: true,
//                                     tiltGesturesEnabled: true,
//                                     rotateGesturesEnabled: true,
//                                     onTap: _onMapTapped,
//                                     gestureRecognizers: {
//                                       Factory<OneSequenceGestureRecognizer>(
//                                         () => EagerGestureRecognizer(),
//                                       ),
//                                     },
//                                   );
//                                 } else if (state is DisplayVehiclesError) {
//                                   return Center(child: Text(state.message));
//                                 }
//                                 return const Center(
//                                     child: Text("No vehicles available"));
//                               },
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(vertical: 10.h),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Expanded(
//                                   child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: AppColors.background,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10.r),
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 18.h, horizontal: 20.w),
//                                       minimumSize: Size(120.w, 50.h),
//                                     ),
//                                     onPressed: () {
//                                       _showBookingOptionsDraggableSheet();
//                                     },
//                                     child: Text(
//                                       'Book now',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 10.w),
//                                 Expanded(
//                                   child: OutlinedButton(
//                                     style: OutlinedButton.styleFrom(
//                                       side: BorderSide(
//                                           color: AppColors.background),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10.r),
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 18.h, horizontal: 20.w),
//                                       minimumSize: Size(120.w, 50.h),
//                                     ),
//                                     onPressed: () {
//                                       showDateTimePicker();
//                                     },
//                                     child: Text(
//                                       'Schedule Ride',
//                                       style: TextStyle(
//                                         color: AppColors.background,
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:apniride_flutter/Bloc/BookRide/book_ride_cubit.dart';
import 'package:apniride_flutter/Bloc/DisplayVehicles/display_vehicles_cubit.dart';
import 'package:apniride_flutter/model/displayVehicles.dart';
import 'package:apniride_flutter/screen/about_us.dart';
import 'package:apniride_flutter/screen/invoices_screen.dart';
import 'package:apniride_flutter/screen/notification.dart';
import 'package:apniride_flutter/screen/payment_optinal.dart';
import 'package:apniride_flutter/screen/payment_screen.dart';
import 'package:apniride_flutter/screen/profile_screen.dart';
import 'package:apniride_flutter/screen/ride_screen.dart';
import 'package:apniride_flutter/screen/search_bar.dart';
import 'package:apniride_flutter/screen/searching_driver.dart';
import 'package:apniride_flutter/screen/terms_and_conditions.dart';
import 'package:apniride_flutter/screen/wallet_history_screen.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:apniride_flutter/utils/shared_preference.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../Bloc/BookRide/book_ride_state.dart';
import '../Bloc/DisplayVehicles/display_vehicles_state.dart';
import '../Bloc/RidesHistory/rides_history_cubit.dart';
import '../Bloc/RidesHistory/rides_history_state.dart';
import '../Bloc/Wallets/wallets_cubit.dart';
import '../Bloc/Wallets/wallets_state.dart';
import '../model/booking_status.dart';
import '../utils/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'SplashScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedVehicleIndex = -1;
  GoogleMapController? _mapController;
  LatLng? _pickupLocation;
  LatLng? _dropLocation;
  String? _pickupAddress;
  String? _dropAddress;
  String? _selectedPaymentMethod;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  static const LatLng _defaultLocation = LatLng(17.732000, 83.306839);
  final String apiKey = 'AIzaSyDuMya4zkiRrzmh66-P-9_--Mfek8SXIHI';
  final FocusNode _pickupFocusNode = FocusNode();
  final FocusNode _dropFocusNode = FocusNode();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  bool _isEditingPickup = true;
  final ApiService apiService = ApiService();
  double? _calculatedDistance;
  bool bookLoading = true;

  Future<void> _fetchAndDrawPolyline() async {
    if (_pickupLocation == null || _dropLocation == null) {
      setState(() {
        _polylines = {};
        _calculatedDistance = null;
      });
      return;
    }

    final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${_pickupLocation!.latitude},${_pickupLocation!.longitude}&'
        'destination=${_dropLocation!.latitude},${_dropLocation!.longitude}&'
        'key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final String encodedPolyline =
              data['routes'][0]['overview_polyline']['points'];
          final List<LatLng> polylinePoints = _decodePolyline(encodedPolyline);
          final distanceMeters =
              data['routes'][0]['legs'][0]['distance']['value'];
          setState(() {
            _polylines = {
              Polyline(
                polylineId: const PolylineId('route'),
                points: polylinePoints,
                color: Colors.black,
                width: 5,
              ),
            };
            _calculatedDistance = (distanceMeters / 1000).toDouble();
          });
        } else {
          setState(() {
            _polylines = {};
            _calculatedDistance = null;
          });
        }
      } else {
        setState(() {
          _polylines = {};
          _calculatedDistance = null;
        });
      }
    } catch (e) {
      setState(() {
        _polylines = {};
        _calculatedDistance = null;
      });
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

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  // double _calculateSegmentedFare(double distanceKm, List<PricingRules> pricingRules) {
  //   if (pricingRules.isEmpty) return 0.0;
  //   pricingRules.sort((a, b) => a.minDistance.compareTo(b.minDistance));
  //
  //   double totalFare = 0.0;
  //   double remainingDistance = distanceKm;
  //
  //   for (var rule in pricingRules) {
  //     if (remainingDistance <= 0) break;
  //
  //     double segmentDistance = 0.0;
  //     if (distanceKm >= rule.minDistance) {
  //       if (rule.maxDistance >= distanceKm) {
  //         segmentDistance = remainingDistance;
  //       } else {
  //         segmentDistance = rule.maxDistance - rule.minDistance;
  //       }
  //       totalFare += segmentDistance * rule.perKmRate;
  //       remainingDistance -= segmentDistance;
  //     }
  //   }
  //   if (remainingDistance > 0) return 0.0;
  //
  //   return totalFare;
  // }
  double _calculateSegmentedFare(
      double distanceKm, List<PricingRules> pricingRules) {
    if (pricingRules.isEmpty) return 0.0;

    // Sort pricing rules by minDistance to ensure correct order
    pricingRules.sort((a, b) => a.minDistance.compareTo(b.minDistance));

    double totalFare = 0.0;
    double remainingDistance = distanceKm;

    for (var rule in pricingRules) {
      if (remainingDistance <= 0) break;

      // Calculate the distance covered by this rule
      double segmentDistance = 0.0;
      if (distanceKm >= rule.minDistance) {
        if (rule.maxDistance >= distanceKm) {
          segmentDistance = remainingDistance;
        } else {
          segmentDistance = rule.maxDistance - rule.minDistance;
        }
        // Calculate base fare for this segment
        double baseFare = segmentDistance * rule.perKmRate;
        // Calculate GST for this segment
        double gstAmount = baseFare * (rule.gstPercentage / 100.0);
        // Add base fare and GST to total fare
        totalFare += baseFare + gstAmount;
        remainingDistance -= segmentDistance;
      }
    }

    if (remainingDistance > 0) return 0.0;

    return totalFare;
  }

  Future<void> bookingRide({
    bool isScheduleRide = false,
    String? pickupTime,
    required String paymentMethod,
  }) async {
    String? savedMethod = await SharedPreferenceHelper.getPaymentMethod();
    if (savedMethod == null || savedMethod.isEmpty) {
      SharedPreferenceHelper.setPaymentMethod('Cash');
      savedMethod = await SharedPreferenceHelper.getPaymentMethod();
    }

    if (_pickupLocation == null ||
        _dropLocation == null ||
        selectedVehicleIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select pickup, drop, and vehicle type')),
      );
      return;
    }

    final vehicle = context.read<DisplayVehiclesCubit>().state
            is DisplayVehiclesSuccess
        ? (context.read<DisplayVehiclesCubit>().state as DisplayVehiclesSuccess)
            .vehicleData
            .vehicleTypes[selectedVehicleIndex]
        : null;

    if (vehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid vehicle')),
      );
      return;
    }

    double distanceKm = _calculatedDistance ??
        calculateDistance(_pickupLocation!, _dropLocation!);

    if (vehicle.pricingRules.isEmpty) {
      _showErrorDialog(
          'This vehicle is not available for booking due to missing pricing rules.');
      return;
    }

    // Calculate fare using segmented pricing rules
    double fare = _calculateSegmentedFare(distanceKm, vehicle.pricingRules);

    if (fare == 0.0) {
      _showErrorDialog(
          'The selected vehicle cannot be booked for a distance of ${distanceKm.toStringAsFixed(2)} km. '
          'Please choose another vehicle or adjust the locations.');
      return;
    }

    if (paymentMethod == 'My Wallet') {
      double walletBalance = context.read<RazorpayPaymentCubit>().state
              is RazorpayPaymentWalletFetched
          ? double.tryParse((context.read<RazorpayPaymentCubit>().state
                      as RazorpayPaymentWalletFetched)
                  .wallet
                  .data
                  .balance) ??
              0.0
          : 0.0;
      if (walletBalance < fare) {
        _showWalletInsufficientDialog(fare);
        return;
      }
    }

    String backendPaymentType;
    switch (paymentMethod) {
      case 'Razorpay':
        backendPaymentType = 'razorpay';
        break;
      case 'My Wallet':
        backendPaymentType = 'wallet';
        break;
      case 'Cash':
      default:
        backendPaymentType = 'cod';
    }

    final data = {
      "pickup": _pickupAddress ?? "alagar kovil temple",
      "drop": _dropAddress ?? "Meenakshi amman temple",
      "distance_km": distanceKm,
      "vehicle_type": vehicle.name,
      "pickup_lat": _pickupLocation!.latitude.toString(),
      "pickup_lng": _pickupLocation!.longitude.toString(),
      "drop_lat": _dropLocation!.latitude.toString(),
      "drop_lng": _dropLocation!.longitude.toString(),
      "pickup_mode": isScheduleRide ? "LATER" : "NOW",
      "type": backendPaymentType,
      if (isScheduleRide && pickupTime != null) "pickup_time": pickupTime,
    };

    if (mounted) {
      context
          .read<BookRideCubit>()
          .bookRides(data, context, isScheduleRide: isScheduleRide);
    }
  }

  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371;
    double lat1 = start.latitude * pi / 180;
    double lon1 = start.longitude * pi / 180;
    double lat2 = end.latitude * pi / 180;
    double lon2 = end.longitude * pi / 180;
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return double.parse(distance.toStringAsFixed(2));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Note',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20.sp),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20.sp),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 16.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: TextStyle(fontSize: 16.sp, color: AppColors.background),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showWalletInsufficientDialog(double requiredAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Insufficient Wallet Balance',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 20.sp),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20.sp),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Text(
              'Your wallet balance is not sufficient for this ride (₹${requiredAmount.toStringAsFixed(2)} required). '
              'Please add money to your wallet or choose another payment method.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 16.sp),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddWalletScreen()),
                ).then((_) {
                  context.read<RazorpayPaymentCubit>().getWalletBalance();
                });
              },
              child: Text(
                'Add Money',
                style: TextStyle(fontSize: 16.sp, color: AppColors.background),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
            ),
          ],
          contentPadding:
              EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        );
      },
    );
  }

  void _showAddMoneySheet() {
    final TextEditingController amountController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.w,
            right: 16.w,
            top: 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Money to Wallet',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 18.h, horizontal: 30.w),
                  minimumSize: Size(double.infinity, 50.h),
                ),
                onPressed: () {
                  final amount = double.tryParse(amountController.text) ?? 0.0;
                  if (amount > 0) {
                    context
                        .read<RazorpayPaymentCubit>()
                        .addWalletAmount(amount);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a valid amount')),
                    );
                  }
                },
                child: Text(
                  'Add Money',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  // }
  Future<void> showDateTimePicker() async {
    final DateTime initialDate =
        DateTime.now().add(const Duration(minutes: 15));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      // Allow today as earliest date
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.background,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Set initialTime to 15 minutes from now if it's today, otherwise use midnight
      final TimeOfDay initialTime = DateTime.now().day == pickedDate.day
          ? TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15)))
          : const TimeOfDay(hour: 0, minute: 0);

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.background,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final DateTime scheduledDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Validate that the selected time is at least 15 minutes from now
        final DateTime now = DateTime.now();
        final DateTime earliestAllowedTime =
            now.add(const Duration(minutes: 15));

        if (scheduledDateTime.isBefore(earliestAllowedTime)) {
          // Show an error message if the selected time is too soon
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Please select a time at least 15 minutes from now.'),
            ),
          );
          return;
        }

        final String formattedDateTime =
            scheduledDateTime.toUtc().toIso8601String();
        _showBookingOptionsDraggableSheet(
          isScheduleRide: true,
          pickupTime: formattedDateTime,
        );
      }
    }
  }

  void _showSuccessDialog() {
    setState(() {
      bookLoading = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Success',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 20.sp),
          ),
          content: Text(
            'Your scheduled ride was booked successfully!',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 16.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearLocations();
              },
              child: Text(
                'OK',
                style: TextStyle(fontSize: 16.sp, color: AppColors.background),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showBookingOptionsDraggableSheet({
    bool isScheduleRide = false,
    String? pickupTime,
  }) {
    if (_pickupLocation == null || _dropLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select pickup and drop locations first.')),
      );
      return;
    }
    if (_calculatedDistance == null) {
      _calculatedDistance = calculateDistance(_pickupLocation!, _dropLocation!);
    }
    context.read<DisplayVehiclesCubit>().displayVehicles(context);
    context.read<RazorpayPaymentCubit>().getWalletBalance();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: StatefulBuilder(
            builder: (BuildContext statefulContext, StateSetter setState) {
              return BlocListener<RazorpayPaymentCubit, RazorpayPaymentState>(
                listener: (context, state) {
                  if (state is RazorpayPaymentWalletFetched &&
                      statefulContext.mounted) {
                    double walletBalance =
                        double.tryParse(state.wallet.data.balance) ?? 0.0;
                    if (_selectedPaymentMethod == 'My Wallet' &&
                        walletBalance <= 0) {
                      setState(() {
                        _selectedPaymentMethod = 'Cash';
                        SharedPreferenceHelper.setPaymentMethod('Cash');
                      });
                      if (statefulContext.mounted) {
                        ScaffoldMessenger.of(statefulContext).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Your wallet is empty. Payment method set to Cash.'),
                          ),
                        );
                      }
                    }
                  } else if (state is RazorpayPaymentFailure &&
                      statefulContext.mounted) {
                    ScaffoldMessenger.of(statefulContext).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Error fetching wallet balance: ${state.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Scaffold(
                  bottomNavigationBar: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    color: Colors.white,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 15.h, horizontal: 20.w),
                        minimumSize: Size(150.w, 50.h),
                      ),
                      onPressed: selectedVehicleIndex != -1
                          ? () {
                              FocusScope.of(context).unfocus();
                              Navigator.pop(sheetContext);
                              setState(() {
                                bookLoading = false;
                              });
                              bookingRide(
                                isScheduleRide: isScheduleRide,
                                pickupTime: pickupTime,
                                paymentMethod: _selectedPaymentMethod ?? 'Cash',
                              );
                            }
                          : null,
                      child: Text(
                        isScheduleRide ? 'Booking Request' : 'Confirm Request',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  body: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // borderRadius:
                      //     BorderRadius.vertical(top: Radius.circular(20.r)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Column(
                      // Changed from SingleChildScrollView to Column
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: 40.w,
                            height: 5.h,
                            margin: EdgeInsets.only(bottom: 10.h),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Expanded(
                          // NEW: Wrap content in Expanded to fill available space
                          child: SingleChildScrollView(
                            // NEW: Moved SingleChildScrollView here to allow scrolling only for content
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Booking Options',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.background,
                                        ),
                                  ),
                                  if (_calculatedDistance != null) ...[
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Distance: ${_calculatedDistance!.toStringAsFixed(2)} km',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green,
                                          ),
                                    ),
                                  ],
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Select Vehicle',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  SizedBox(height: 8.h),
                                  BlocBuilder<DisplayVehiclesCubit,
                                      DisplayVehiclesState>(
                                    builder: (context, state) {
                                      if (state is DisplayVehiclesSuccess) {
                                        final vehicles =
                                            state.vehicleData.vehicleTypes;
                                        // final double itemHeight = 60.h + 8.h; // Base height + padding
                                        // final double selectedItemHeight = itemHeight + 8.h; // Add margin for selected item
                                        // double totalHeight = (vehicles.length - (selectedVehicleIndex >= 0 ? 1 : 0)) * itemHeight +
                                        //     (selectedVehicleIndex >= 0 ? selectedItemHeight : 0);
                                        // totalHeight = totalHeight.clamp(80.h, 200.h); // Minimum 80.h, maximum 200.h
                                        return SizedBox(
                                          height: 160.h,
                                          child: ListView.builder(
                                            controller: ScrollController(),
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            itemCount: vehicles.length,
                                            itemBuilder: (context, index) {
                                              final vehicle = vehicles[index];
                                              double? fare;
                                              bool isAvailable = false;

                                              if (_calculatedDistance != null) {
                                                fare = _calculateSegmentedFare(
                                                    _calculatedDistance!,
                                                    vehicle.pricingRules);
                                                isAvailable = fare > 0;
                                              }

                                              Widget item = Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: index ==
                                                                selectedVehicleIndex
                                                            ? AppColors
                                                                .background
                                                            : Colors
                                                                .transparent)),
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 0.h),
                                                  leading: SizedBox(
                                                    width: 40.w,
                                                    height: 40.h,
                                                    child: Image.network(
                                                        vehicle.vehicleImage),
                                                  ),
                                                  title: Text(vehicle.name),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "${vehicle.description} (${vehicle.seatingCapacity} seats)"),
                                                      if (isAvailable &&
                                                          fare != null)
                                                        Container()
                                                      else
                                                        Text(
                                                          "Unavailable for this distance",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                    ],
                                                  ),
                                                  trailing: isAvailable &&
                                                          fare != null
                                                      ? Text(
                                                          "₹${fare.toStringAsFixed(2)}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      : Text(
                                                          'N/A',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                  onTap: () {
                                                    if (isAvailable) {
                                                      setState(() {
                                                        selectedVehicleIndex =
                                                            index;
                                                      });
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'This vehicle is not available for the selected distance.'),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              );

                                              /*  if (index ==
                                                  selectedVehicleIndex) {
                                                return Card(
                                                  elevation: 4.0,
                                                  color: Colors.white,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 4.h),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    // 👈 Rounded corners
                                                    side: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                      // 👈 Border color
                                                      width:
                                                          1.0, // 👈 Border width
                                                    ),
                                                  ),
                                                  child: item,
                                                );
                                              }*/
                                              return item;
                                            },
                                          ),
                                        );
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Payment Method',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  SizedBox(height: 8.h),
                                  BlocBuilder<RazorpayPaymentCubit,
                                      RazorpayPaymentState>(
                                    builder: (context, state) {
                                      double walletBalance = 0.0;
                                      if (state
                                          is RazorpayPaymentWalletFetched) {
                                        walletBalance = double.tryParse(
                                                state.wallet.data.balance) ??
                                            0.0;
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const PaymentOptinal(),
                                            ),
                                          ).then((_) async {
                                            if (statefulContext.mounted) {
                                              String? updatedMethod =
                                                  await SharedPreferenceHelper
                                                      .getPaymentMethod();
                                              setState(() {
                                                _selectedPaymentMethod =
                                                    updatedMethod ?? 'Cash';
                                              });
                                            }
                                          });
                                        },
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: Icon(Icons.payment,
                                              color: AppColors.background),
                                          title: Text(
                                            'Choose Payment Method',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          subtitle: Text(
                                            _selectedPaymentMethod ?? 'Cash',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: AppColors.background,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      print("ModalBottomSheet dismissed");
    });
  }

  @override
  @override
  void initState() {
    super.initState();
    context.read<RidesHistoryCubit>().fetchRidesHistory(context);
    _pickupController.addListener(() {
      /*if (_pickupController.text.isEmpty) {
        setState(() {
          _pickupLocation = null;
          _pickupAddress = null;
          _updateMarkers();
          _fetchAndDrawPolyline();
        });
      }*/
    });

    _dropController.addListener(() {
      if (_dropController.text.isEmpty) {
        setState(() {
          _dropLocation = null;
          _dropAddress = null;
          _updateMarkers();
          _fetchAndDrawPolyline();
        });
      }
    });
    _loadSavedPaymentMethod();

    context.read<DisplayVehiclesCubit>().displayVehicles(context);

    // Fetch current location asynchronously
    _getCurrentLocation(); // New method call

    _updateMarkers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pickupLocation != null) {
        _updateCameraPosition(_pickupLocation!);
      }
    });
    _pickupFocusNode.addListener(() {
      if (_pickupFocusNode.hasFocus) {
        setState(() {
          _isEditingPickup = true;
        });
      }
    });
    _dropFocusNode.addListener(() {
      if (_dropFocusNode.hasFocus) {
        setState(() {
          _isEditingPickup = false;
        });
      }
    });
    updateFcm();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Handle: Show a dialog or snackbar to enable location services
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location services')),
        );
        _pickupLocation = _defaultLocation; // Fallback to default
        return;
      }

      // Check/request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Handle: Permissions denied
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions denied')),
          );
          _pickupLocation = _defaultLocation;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Handle: Permissions permanently denied (open app settings)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Location permissions permanently denied. Please enable in settings.')),
        );
        _pickupLocation = _defaultLocation;
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Set location
      _pickupLocation = LatLng(position.latitude, position.longitude);

      // Reverse geocode to get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _pickupAddress =
            '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}'; // Customize as needed
        _pickupController.text = _pickupAddress ?? '';
      }

      // Update UI
      setState(() {
        _updateMarkers();
        _fetchAndDrawPolyline();
      });
      if (_mapController != null) {
        // Assuming you have a GoogleMapController
        _updateCameraPosition(_pickupLocation!);
      }
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
      _pickupLocation = _defaultLocation; // Fallback
      setState(() {});
    }
  }

  Future<void> _loadSavedPaymentMethod() async {
    String? savedMethod = await SharedPreferenceHelper.getPaymentMethod();
    setState(() {
      _selectedPaymentMethod = savedMethod ?? 'Cash';
    });
  }

  updateFcm() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      SharedPreferenceHelper.setFcmToken(token);
      final data = {"fcm_token": token};
      apiService.updateFcm(data);
    }
  }

  @override
  void dispose() {
    _pickupFocusNode.dispose();
    _dropFocusNode.dispose();
    _pickupController.dispose();
    _dropController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateCameraPosition(_pickupLocation ?? _defaultLocation);
  }

  void _updateCameraPosition(LatLng target) {
    if (_pickupLocation != null && _dropLocation != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          _pickupLocation!.latitude < _dropLocation!.latitude
              ? _pickupLocation!.latitude
              : _dropLocation!.latitude,
          _pickupLocation!.longitude < _dropLocation!.longitude
              ? _pickupLocation!.longitude
              : _dropLocation!.longitude,
        ),
        northeast: LatLng(
          _pickupLocation!.latitude > _dropLocation!.latitude
              ? _pickupLocation!.latitude
              : _dropLocation!.latitude,
          _pickupLocation!.longitude > _dropLocation!.longitude
              ? _pickupLocation!.longitude
              : _dropLocation!.longitude,
        ),
      );
      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: 17.0),
        ),
      );
    }
  }

  Widget _buildOngoingRides() {
    return BlocBuilder<RidesHistoryCubit, RidesHistoryState>(
      builder: (context, state) {
        if (state is RidesHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RidesHistorySuccess) {
          final rides = state.ridesHistory.rides
              .where((ride) =>
                  ride.status != 'completed' && ride.status != 'cancelled')
              .toList();

          if (rides.isEmpty) {
            return const SizedBox.shrink(); // No ongoing rides
          }
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[50], // Light background for the section
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_car,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Current Rides",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 140.h, // Increased height to accommodate pick/drop
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: rides.length,
                    separatorBuilder: (context, index) => SizedBox(width: 10.w),
                    itemBuilder: (context, index) {
                      final ride = rides[index];
                      return GestureDetector(
                        onTap: () {
                          if (ride.status == 'pending') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchingDriverScreen(
                                  pickupLocation: LatLng(9.9171716, 78.1319455),
                                  pickupAddress: ride.pickup,
                                  bookingId: ride.bookingId,
                                  rideId: ride.id,
                                  distance: ride.distanceKm,
                                ),
                              ),
                            );
                          } else if (ride.status == 'accepted' ||
                              ride.status == 'ongoing' ||
                              ride.status == 'arrived') {
                            final bookingStatus = BookingStatus(
                              data: Data(
                                bookingId: ride.bookingId,
                                pickup: ride.pickup,
                                drop: ride.drop,
                                fare: ride.fare,
                                status: ride.status,
                                otp: ride.otp,
                                driverName: ride.driverName ?? 'Unknown Driver',
                                driverNumber: ride.driverNumber,
                                vehicleNumber: ride.driverVehicleNumber ?? '',
                                vechicleName: ride.vehicleName ?? '',
                                driverPhoto: ride.driverImage,
                                pickupTime: ride.pickupTime,
                                completed: ride.completed,
                                paid: ride.paid,
                                vehicleType: ride.vehicleType,
                              ),
                              statusCode: "",
                              StatusMessage: '',
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RideTrackingScreen(
                                  bookingStatus: bookingStatus,
                                  rideId: ride.id,
                                  distance: ride.distanceKm,
                                ),
                              ),
                            );
                          }
                        },
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          color: Colors.white, // White background for cards
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Container(
                            width: 180.w,
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "ID: ${ride.bookingId}",
                                        style: TextStyle(
                                          fontSize: 11
                                              .sp, // Slightly smaller for space
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 3.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(ride.status),
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                      ),
                                      child: Text(
                                        ride.status.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                // Pickup
                                Row(
                                  children: [
                                    Icon(Icons.my_location,
                                        size: 12.sp, color: Colors.green),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        ride.pickup ?? 'Pickup',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                // Drop
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 12.sp, color: Colors.red),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        ride.drop ?? 'Drop',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                // Vehicle and Fare
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ride.vehicleType,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "₹${ride.fare.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is RidesHistoryError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

// Helper method for status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
      case 'arrived':
        return Colors.blue;
      case 'ongoing':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<String?> _getAddressFromLatLng(LatLng position) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No address found for this location')),
          );
          return 'Unknown location';
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geocoding error: ${response.statusCode}')),
        );
        return 'Unknown location';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch address: $e')),
      );
      return 'Unknown location';
    }
  }

  void _onMapTapped(LatLng position) async {
    final address = await _getAddressFromLatLng(position);
    setState(() {
      if (_isEditingPickup) {
        _pickupLocation = position;
        _pickupAddress = address ?? 'Unknown location';
        _pickupController.text = _pickupAddress ?? '';
      } else {
        _dropLocation = position;
        _dropAddress = address ?? 'Unknown location';
        _dropController.text = _dropAddress ?? '';
      }
      _updateMarkers();
      _updateCameraPosition(position);
      _fetchAndDrawPolyline();
    });
  }

  void _updateMarkers() async {
    final pickupMarker = _pickupLocation != null
        ? Marker(
            markerId: const MarkerId('pickup'),
            position: _pickupLocation!,
            infoWindow: InfoWindow(title: 'Pickup: $_pickupAddress'),
            icon: await BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          )
        : null;

    final dropMarker = _dropLocation != null
        ? Marker(
            markerId: const MarkerId('drop'),
            position: _dropLocation!,
            infoWindow: InfoWindow(title: 'Drop: $_dropAddress'),
            icon: await BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
          )
        : null;

    setState(() {
      _markers = {};
      if (pickupMarker != null) _markers.add(pickupMarker);
      if (dropMarker != null) _markers.add(dropMarker);
    });
    _fetchAndDrawPolyline();
  }

  void _clearLocations() {
    setState(() {
      final double? latitude = SharedPreferenceHelper.getLatitude()?.toDouble();
      final double? longitude =
          SharedPreferenceHelper.getLongitude()?.toDouble();
      if (latitude != null &&
          longitude != null &&
          latitude.isFinite &&
          longitude.isFinite) {
        _pickupLocation = LatLng(latitude, longitude);
      } else {
        _pickupLocation = _defaultLocation;
      }
      _pickupAddress = SharedPreferenceHelper.getDeliveryAddress();
      _pickupController.text = _pickupAddress ?? '';
      _dropLocation = null;
      _dropAddress = null;
      _dropController.clear();
      _markers = {};
      _polylines = {};
      _isEditingPickup = true;
      selectedVehicleIndex = -1;
      _selectedPaymentMethod = 'Cash';
      _calculatedDistance = null;
      _updateCameraPosition(_pickupLocation ?? _defaultLocation);
    });
    _updateMarkers();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Logout',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 20.sp),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 16.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                SharedPreferenceHelper.clear();
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Splashscreen()),
                  (Route<dynamic> route) => false, // Remove all previous routes
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 16.sp, color: AppColors.background),
              ),
            ),
          ],
        );
      },
    );
  }

  bool get _isProceedEnabled =>
      _pickupLocation != null && _dropLocation != null;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: BlocListener<BookRideCubit, BookRideState>(
        listener: (context, state) {
          if (state is BookRideSuccess) {
            if (state.isScheduleRide) {
              _showSuccessDialog();
            } else {
              print("Redirect to search diver page");
              FocusScope.of(context).unfocus();
              setState(() {
                bookLoading = true;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchingDriverScreen(
                      pickupLocation: _pickupLocation,
                      pickupAddress: "periyar bus stop",
                      bookingId: state.ride.ride.bookingId,
                      rideId: state.ride.ride.id,
                      distance: state.ride.ride.distanceKm),
                ),
              );
            }
          } else if (state is BookRideError) {
            print("Book ride error");
            setState(() {
              bookLoading = true;
            });

            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(state.message)),
            // );
          }
        },
        child: Scaffold(
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration:
                        const BoxDecoration(color: AppColors.background),
                    child: Center(
                      child: Text(
                        SharedPreferenceHelper.getUserName() ?? "UserName",
                        style: TextStyle(color: Colors.white, fontSize: 24.sp),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, size: 20.sp),
                    title: Text(
                      'Profile',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 15.sp),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileManagementScreen()),
                      );
                      setState(() {
                        SharedPreferenceHelper.getUserName();
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.history, size: 20.sp),
                    title: Text(
                      'Invoices History',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 15.sp),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const InvoicesHistoryScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.history, size: 20.sp),
                    title: Text(
                      'Wallet History',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 15.sp),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WalletHistoryScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info, size: 20.sp),
                    title: Text(
                      'About Us',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 15.sp),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUs()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.description, size: 20.sp),
                    title: Text(
                      'Terms and Conditions',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 15.sp),
                    ),
                    onTap: () {
                      print("Terms and conditions");
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TermsAndConditions()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, size: 20.sp),
                    title: Text(
                      'Logout',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 15.sp),
                    ),
                    onTap: () {
                      _showLogoutDialog();
                    },
                  ),
                ],
              ),
            ),
            body: bookLoading
                ? Stack(
                    children: [
                      SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*  Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Builder(
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                        onTap: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: AppColors.background,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Icon(
                                            Icons.menu,
                                            size: 20.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Row(
                                    children: [
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               const RecentPlacesScreen()),
                                      //     );
                                      //   },
                                      //   child: Container(
                                      //     padding: const EdgeInsets.all(5),
                                      //     decoration: BoxDecoration(
                                      //       color: AppColors.background,
                                      //       borderRadius: BorderRadius.circular(5),
                                      //     ),
                                      //     child: Icon(
                                      //       Icons.search,
                                      //       size: 20.sp,
                                      //       color: Colors.white,
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(width: 10.w),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     // Navigator.push(
                                      //     //   context,
                                      //     //   MaterialPageRoute(
                                      //     //       builder: (context) =>
                                      //     //           const NotificationScreen()),
                                      //     // );
                                      //   },
                                      //   child: Container(
                                      //     padding: const EdgeInsets.all(5),
                                      //     decoration: BoxDecoration(
                                      //       color: AppColors.background,
                                      //       borderRadius:
                                      //           BorderRadius.circular(5),
                                      //     ),
                                      //     child: Icon(
                                      //       Icons.notifications,
                                      //       size: 20.sp,
                                      //       color: Colors.white,
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(width: 10.w),
                                    ],
                                  ),
                                ],
                              ),*/
                              SizedBox(height: 10.h),
                              GooglePlaceAutoCompleteTextField(
                                textEditingController: _pickupController,
                                googleAPIKey: apiKey,
                                inputDecoration: InputDecoration(
                                  hintText: "Pickup Location",
                                  border: InputBorder.none,
                                  suffixIcon: _pickupController.text.isEmpty
                                      ? InkWell(
                                          onTap: () {
                                            _getCurrentLocation();
                                          },
                                          child: Icon(
                                            Icons.gps_fixed_sharp,
                                          ))
                                      : InkWell(
                                          onTap: () {
                                            _pickupController.text = "";
                                            _pickupLocation = null;
                                            _pickupAddress = null;
                                            _updateMarkers();
                                          },
                                          child: Icon(Icons.close),
                                        ),
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.h, horizontal: 10),
                                  prefixIcon: Builder(
                                    builder: (context) => InkWell(
                                      onTap: () {
                                        _pickupFocusNode.unfocus();
                                        Scaffold.of(context)
                                            .openDrawer(); // Works now ✅
                                      },
                                      child: Icon(
                                        Icons.menu,
                                        color: AppColors.background,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                focusNode: _pickupFocusNode,
                                debounceTime: 800,
                                isLatLngRequired: true,
                                countries: ["in"],
                                getPlaceDetailWithLatLng:
                                    (Prediction prediction) {
                                  setState(() {
                                    _pickupAddress = prediction.description;
                                    _pickupController.text =
                                        _pickupAddress ?? '';
                                    _pickupLocation = LatLng(
                                      double.parse(prediction.lat ?? '0'),
                                      double.parse(prediction.lng ?? '0'),
                                    );
                                    _updateCameraPosition(_pickupLocation!);
                                    _updateMarkers();
                                    _fetchAndDrawPolyline();
                                  });
                                },
                                itemClick: (Prediction prediction) {
                                  _pickupController.text =
                                      prediction.description ?? '';
                                  _pickupController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: _pickupController.text.length),
                                  );
                                  setState(() {
                                    _isEditingPickup = true;
                                  });
                                },
                                itemBuilder:
                                    (context, index, Prediction prediction) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Text(prediction.description ?? ''),
                                  );
                                },
                                isCrossBtnShown: false,
                              ),
                              SizedBox(height: 10.h),
                              GooglePlaceAutoCompleteTextField(
                                textEditingController: _dropController,
                                googleAPIKey: apiKey,
                                inputDecoration: InputDecoration(
                                  hintText: "Drop Location",
                                  border: InputBorder.none,
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.h, horizontal: 10),
                                  prefixIcon: Icon(Icons.location_on_outlined,
                                      color: Colors.grey, size: 20.sp),
                                ),
                                focusNode: _dropFocusNode,
                                debounceTime: 800,
                                isLatLngRequired: true,
                                countries: ["in"],
                                getPlaceDetailWithLatLng:
                                    (Prediction prediction) {
                                  setState(() {
                                    _dropAddress = prediction.description;
                                    _dropController.text = _dropAddress ?? '';
                                    _dropLocation = LatLng(
                                      double.parse(prediction.lat ?? '0'),
                                      double.parse(prediction.lng ?? '0'),
                                    );
                                    _updateCameraPosition(_dropLocation!);
                                    _updateMarkers();
                                    _fetchAndDrawPolyline();
                                  });
                                },
                                itemClick: (Prediction prediction) {
                                  _dropController.text =
                                      prediction.description ?? '';
                                  _dropController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: _dropController.text.length),
                                  );
                                  setState(() {
                                    _isEditingPickup = false;
                                  });
                                },
                                itemBuilder:
                                    (context, index, Prediction prediction) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Text(prediction.description ?? ''),
                                  );
                                },
                                isCrossBtnShown: true,
                              ),
                              SizedBox(height: 10.h),
                              _buildOngoingRides(),
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: BlocBuilder<DisplayVehiclesCubit,
                                          DisplayVehiclesState>(
                                        builder: (context, state) {
                                          if (state is DisplayVehiclesLoading) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (state
                                              is DisplayVehiclesSuccess) {
                                            final vehicles =
                                                state.vehicleData.vehicleTypes;
                                            return GoogleMap(
                                              onMapCreated: _onMapCreated,
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target: _pickupLocation ??
                                                    _defaultLocation,
                                                zoom: 17.0,
                                              ),
                                              markers: _markers,
                                              polylines: _polylines,
                                              myLocationEnabled: true,
                                              myLocationButtonEnabled: true,
                                              zoomGesturesEnabled: true,
                                              scrollGesturesEnabled: true,
                                              tiltGesturesEnabled: true,
                                              rotateGesturesEnabled: true,
                                              onTap: _onMapTapped,
                                              gestureRecognizers: {
                                                Factory<
                                                    OneSequenceGestureRecognizer>(
                                                  () =>
                                                      EagerGestureRecognizer(),
                                                ),
                                              },
                                            );
                                          } else if (state
                                              is DisplayVehiclesError) {
                                            return Center(
                                                child: Text(state.message));
                                          }
                                          return const Center(
                                              child: Text(
                                                  "No vehicles available"));
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.background,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 18.h,
                                                    horizontal: 20.w),
                                                minimumSize: Size(120.w, 50.h),
                                              ),
                                              onPressed: () {
                                                _showBookingOptionsDraggableSheet();
                                              },
                                              child: Text(
                                                'Book now',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                    color:
                                                        AppColors.background),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 18.h,
                                                    horizontal: 20.w),
                                                minimumSize: Size(120.w, 50.h),
                                              ),
                                              onPressed: () {
                                                showDateTimePicker();
                                              },
                                              child: Text(
                                                'Schedule Ride',
                                                style: TextStyle(
                                                  color: AppColors.background,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )),
      ),
    );
  }
}
