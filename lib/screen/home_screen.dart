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
// import '../Bloc/DisplayVehicles/display_vehicles_state.dart';
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
//   final String apiKey = 'AIzaSyDbOdkQtzqELG0WWQIsULDOJM6f_jNv1y0';
//   final FocusNode _pickupFocusNode = FocusNode();
//   final FocusNode _dropFocusNode = FocusNode();
//   final TextEditingController _pickupController = TextEditingController();
//   final TextEditingController _dropController = TextEditingController();
//   bool _isEditingPickup = true;
//   Future<void> bookingRide() async {
//     final data = ({
//       "pickup": "periyar bus stop",
//       "drop": "mattuthavani",
//       "distance_km": 8,
//       "vehicle_type": "Car",
//       "pickup_lat": "9.9171716",
//       "pickup_lng": "78.1319455",
//       "drop_lat": "9.9442",
//       "drop_lng": "78.1562",
//       "pickup_mode": "NOW"
//     });
//
//     if (mounted) {
//       context.read<BookRideCubit>().bookRides(data, context);
//     }
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SearchingDriverScreen(
//           pickupLocation: _pickupLocation,
//           pickupAddress: _pickupAddress,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     print("Apikeyy ${apiKey}");
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
//   @override
//   void dispose() {
//     _pickupFocusNode.dispose();
//     _dropFocusNode.dispose();
//     _pickupController.dispose();
//     _dropController.dispose();
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
//       // SharedPreferenceHelper.saveLatitude(_pickupLocation!.latitude);
//       // SharedPreferenceHelper.saveLongitude(_pickupLocation!.longitude);
//       // SharedPreferenceHelper.saveDeliveryAddress(_pickupAddress!);
//     });
//   }
//
//   void _updateMarkers() {
//     setState(() {
//       _markers = {};
//       if (_pickupLocation != null) {
//         _markers.add(
//           Marker(
//             markerId: const MarkerId('pickup'),
//             position: _pickupLocation!,
//             infoWindow: InfoWindow(title: 'Pickup: $_pickupAddress'),
//             icon: BitmapDescriptor.defaultMarkerWithHue(
//                 BitmapDescriptor.hueGreen),
//           ),
//         );
//       }
//       if (_dropLocation != null) {
//         _markers.add(
//           Marker(
//             markerId: const MarkerId('drop'),
//             position: _dropLocation!,
//             infoWindow: InfoWindow(title: 'Drop: $_dropAddress'),
//             icon:
//                 BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//           ),
//         );
//       }
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
//       // _pickupController.clear();
//       _dropLocation = null;
//       _dropAddress = null;
//       _dropController.clear();
//       _markers = {};
//       _polylines = {};
//       _isEditingPickup = true;
//       _updateCameraPosition(_pickupLocation != null
//           ? _pickupLocation ?? LatLng(0, 0)
//           : _defaultLocation);
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
//     return Scaffold(
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: const BoxDecoration(color: AppColors.background),
//               child: Center(
//                 child: Text(
//                   'USERNAME',
//                   style: TextStyle(color: Colors.white, fontSize: 24.sp),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.history, size: 20.sp),
//               title: Text(
//                 'Invoices history',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyMedium
//                     ?.copyWith(fontSize: 15.sp),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const RideHistoryScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person, size: 20.sp),
//               title: Text(
//                 'Profile',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyMedium
//                     ?.copyWith(fontSize: 15.sp),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProfileManagementScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.info, size: 20.sp),
//               title: Text(
//                 'About',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyMedium
//                     ?.copyWith(fontSize: 15.sp),
//               ),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.description, size: 20.sp),
//               title: Text(
//                 'Terms and conditions',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyMedium
//                     ?.copyWith(fontSize: 15.sp),
//               ),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.logout, size: 20.sp),
//               title: Text(
//                 'Logout',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyMedium
//                     ?.copyWith(fontSize: 15.sp),
//               ),
//               onTap: () {
//                 _showLogoutDialog();
//               },
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Builder(
//                     builder: (BuildContext context) {
//                       return GestureDetector(
//                         onTap: () {
//                           Scaffold.of(context).openDrawer();
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                             color: AppColors.background,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Icon(
//                             Icons.menu,
//                             size: 20.sp,
//                             color: Colors.white,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const RecentPlacesScreen()));
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                             color: AppColors.background,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Icon(
//                             Icons.search,
//                             size: 20.sp,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10.w),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const NotificationScreen()));
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                             color: AppColors.background,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Icon(
//                             Icons.notifications,
//                             size: 20.sp,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10.w),
//                       GestureDetector(
//                         onTap: _clearLocations,
//                         child: Container(
//                           padding: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                             color: AppColors.background,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Icon(
//                             Icons.refresh,
//                             size: 20.sp,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10.h),
//               Container(
//                 child: GooglePlaceAutoCompleteTextField(
//                   textEditingController: _pickupController,
//                   googleAPIKey: apiKey,
//                   inputDecoration: InputDecoration(
//                     hintText: "Pickup Location",
//                     border: InputBorder.none,
//                     hintStyle: Theme.of(context).textTheme.bodyMedium,
//                     contentPadding:
//                         EdgeInsets.symmetric(vertical: 8.h, horizontal: 10),
//                     prefixIcon: Icon(Icons.my_location_outlined,
//                         color: Colors.grey, size: 20.sp),
//                   ),
//                   focusNode: _pickupFocusNode,
//                   debounceTime: 800,
//                   isLatLngRequired: true,
//                   getPlaceDetailWithLatLng: (Prediction prediction) {
//                     setState(() {
//                       _pickupAddress = prediction.description;
//                       _pickupController.text = _pickupAddress ?? '';
//                       _pickupLocation = LatLng(
//                         double.parse(prediction.lat ?? '0'),
//                         double.parse(prediction.lng ?? '0'),
//                       );
//                       print(
//                           "Selected Pickup: $_pickupAddress, $_pickupLocation");
//                       _updateCameraPosition(_pickupLocation!);
//                       _updateMarkers();
//                       // SharedPreferenceHelper.saveLatitude(_pickupLocation!.latitude);
//                       // SharedPreferenceHelper.saveLongitude(_pickupLocation!.longitude);
//                       // SharedPreferenceHelper.saveDeliveryAddress(_pickupAddress!);
//                     });
//                   },
//                   itemClick: (Prediction prediction) {
//                     _pickupController.text = prediction.description ?? '';
//                     _pickupController.selection = TextSelection.fromPosition(
//                       TextPosition(offset: _pickupController.text.length),
//                     );
//                     setState(() {
//                       _isEditingPickup = true;
//                     });
//                   },
//                   itemBuilder: (context, index, Prediction prediction) {
//                     return Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         // border: Border.all(color: AppColors.background)
//                       ),
//                       child: Text(prediction.description ?? ''),
//                     );
//                   },
//                   //seperatedBuilder: const Divider(),
//                   isCrossBtnShown: true,
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Container(
//                 child: GooglePlaceAutoCompleteTextField(
//                   textEditingController: _dropController,
//                   googleAPIKey: apiKey,
//                   inputDecoration: InputDecoration(
//                     hintText: "Drop Location",
//                     border: InputBorder.none,
//                     hintStyle: Theme.of(context).textTheme.bodyMedium,
//                     contentPadding:
//                         EdgeInsets.symmetric(vertical: 8.h, horizontal: 10),
//                     prefixIcon: Icon(Icons.location_on_outlined,
//                         color: Colors.grey, size: 20.sp),
//                   ),
//                   focusNode: _dropFocusNode,
//                   debounceTime: 800,
//                   isLatLngRequired: true,
//                   getPlaceDetailWithLatLng: (Prediction prediction) {
//                     setState(() {
//                       _dropAddress = prediction.description;
//                       _dropController.text = _dropAddress ?? '';
//                       _dropLocation = LatLng(
//                         double.parse(prediction.lat ?? '0'),
//                         double.parse(prediction.lng ?? '0'),
//                       );
//                       print("Selected Drop: $_dropAddress, $_dropLocation");
//                       _updateCameraPosition(_dropLocation!);
//                       _updateMarkers();
//                     });
//                   },
//                   itemClick: (Prediction prediction) {
//                     _dropController.text = prediction.description ?? '';
//                     _dropController.selection = TextSelection.fromPosition(
//                       TextPosition(offset: _dropController.text.length),
//                     );
//                     setState(() {
//                       _isEditingPickup = false;
//                     });
//                   },
//                   itemBuilder: (context, index, Prediction prediction) {
//                     return Container(
//                       padding: const EdgeInsets.all(10),
//                       child: Text(prediction.description ?? ''),
//                     );
//                   },
//                   seperatedBuilder: const Divider(),
//                   isCrossBtnShown: true,
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //   children: [
//               //     Text(
//               //       _isEditingPickup ? 'Editing Pickup' : 'Editing Drop',
//               //       style:
//               //           TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
//               //     ),
//               //     IconButton(
//               //       icon: Icon(Icons.swap_vert, size: 20.sp),
//               //       onPressed: () {
//               //         setState(() {
//               //           _isEditingPickup = !_isEditingPickup;
//               //         });
//               //       },
//               //       tooltip: 'Toggle Pickup/Drop',
//               //     ),
//               //   ],
//               // ),
//               Expanded(
//                 child: BlocBuilder<DisplayVehiclesCubit, DisplayVehiclesState>(
//                   builder: (context, state) {
//                     if (state is DisplayVehiclesLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (state is DisplayVehiclesSuccess) {
//                       final vehicles = state.vehicleData.vehicleTypes;
//                       return ListView(
//                         shrinkWrap: true,
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         children: [
//                           SizedBox(height: 10.h),
//                           Container(
//                             height: 200.h,
//                             child: GoogleMap(
//                               onMapCreated: _onMapCreated,
//                               initialCameraPosition: CameraPosition(
//                                 target: _pickupLocation ?? _defaultLocation,
//                                 zoom: 14.0,
//                               ),
//                               markers: _markers,
//                               polylines: _polylines,
//                               myLocationEnabled: true,
//                               myLocationButtonEnabled: true,
//                               zoomGesturesEnabled: true,
//                               scrollGesturesEnabled: true,
//                               tiltGesturesEnabled: true,
//                               rotateGesturesEnabled: true,
//                               onTap: _onMapTapped,
//                               gestureRecognizers: {
//                                 Factory<OneSequenceGestureRecognizer>(
//                                   () => EagerGestureRecognizer(),
//                                 ),
//                               },
//                             ),
//                           ),
//                           SizedBox(height: 20.h),
//                           ...List.generate(
//                             vehicles.length,
//                             (index) {
//                               final vehicle = vehicles[index];
//
//                               if (index == selectedVehicleIndex) {
//                                 return Card(
//                                   color: Colors.white,
//                                   elevation: 3,
//                                   margin: EdgeInsets.symmetric(vertical: 5.h),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: ListTile(
//                                     leading: Container(
//                                       width: 40.w,
//                                       height: 40.h,
//                                       child:
//                                           Image.network(vehicle.vehicleImage),
//                                     ),
//                                     title: Text(
//                                       vehicle.name,
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     subtitle: Text(
//                                         "${vehicle.description} (${vehicle.seatingCapacity} seats)"),
//                                     trailing: Text(
//                                       "₹${vehicle.baseFare}",
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.green),
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 return ListTile(
//                                   leading: Container(
//                                     width: 40.w,
//                                     height: 40.h,
//                                     child: Image.network(vehicle.vehicleImage),
//                                   ),
//                                   title: Text(vehicle.name),
//                                   subtitle: Text(
//                                       "${vehicle.description} (${vehicle.seatingCapacity} seats)"),
//                                   trailing: Text("₹${vehicle.baseFare}"),
//                                   onTap: () {
//                                     setState(() {
//                                       selectedVehicleIndex = index;
//                                     });
//                                   },
//                                 );
//                               }
//                             },
//                           ),
//                           Card(
//                             color: Colors.white,
//                             margin: EdgeInsets.symmetric(vertical: 5.h),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 side: const BorderSide(color: Colors.grey)),
//                             child: ListTile(
//                               leading: Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 10.w, vertical: 10.h),
//                                 decoration: const BoxDecoration(
//                                     color: AppColors.background,
//                                     shape: BoxShape.circle),
//                                 child: Image.asset("assets/cashback.png"),
//                               ),
//                               title: const Text("City Rides Cashback"),
//                               subtitle: const Text("₹4 cashback per ride"),
//                               trailing:
//                                   Icon(Icons.arrow_forward_ios, size: 16.sp),
//                             ),
//                           ),
//                           ListTile(
//                             leading: Image.asset("assets/bottle.png"),
//                             title: const Text("Free water bottle Services"),
//                             subtitle: const Text("Applicable for all rides"),
//                           ),
//                           SizedBox(height: 5.h),
//                           Padding(
//                             padding: EdgeInsets.symmetric(vertical: 10.h),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Card(
//                                     color: AppColors.background,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: ListTile(
//                                       title: const Text(
//                                         "Book Now",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                       onTap: () {
//                                         bookingRide();
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 10.w),
//                                 Expanded(
//                                   child: Card(
//                                     color: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: ListTile(
//                                       title: const Text(
//                                         "Schedule Ride",
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       onTap: () {},
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     } else if (state is DisplayVehiclesError) {
//                       return Center(child: Text(state.message));
//                     }
//                     return const Center(child: Text("No vehicles available"));
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:apniride_flutter/Bloc/BookRide/book_ride_cubit.dart';
import 'package:apniride_flutter/Bloc/DisplayVehicles/display_vehicles_cubit.dart';
import 'package:apniride_flutter/model/displayVehicles.dart';
import 'package:apniride_flutter/screen/invoices_screen.dart';
import 'package:apniride_flutter/screen/notification.dart';
import 'package:apniride_flutter/screen/profile_screen.dart';
import 'package:apniride_flutter/screen/search_bar.dart';
import 'package:apniride_flutter/screen/searching_driver.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:apniride_flutter/utils/shared_preference.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

import '../Bloc/BookRide/book_ride_state.dart';
import '../Bloc/DisplayVehicles/display_vehicles_state.dart';
import '../utils/api_service.dart';

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
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  static const LatLng _defaultLocation = LatLng(17.732000, 83.306839);
  late PolylinePoints polylinePoints;
  final String apiKey = 'AIzaSyDuMya4zkiRrzmh66-P-9_--Mfek8SXIHI';
  final FocusNode _pickupFocusNode = FocusNode();
  final FocusNode _dropFocusNode = FocusNode();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  bool _isEditingPickup = true;
  final ApiService apiService = ApiService();

  Future<void> bookingRide() async {
    // if (_pickupLocation == null ||
    //     _dropLocation == null ||
    //     selectedVehicleIndex == -1) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //         content: Text('Please select pickup, drop, and vehicle type')),
    //   );
    //   return;
    // }

    final data = {
      "pickup": "maatuthavani",
      "drop": "Thirumanagalam",
      "distance_km": 8,
      "vehicle_type": "Car",
      "pickup_lat": "9.9171716",
      "pickup_lng": "78.1319455",
      "drop_lat": "9.9442",
      "drop_lng": "78.1562",
      "pickup_mode": "NOW",
    };

    if (mounted) {
      context.read<BookRideCubit>().bookRides(data, context);
    }
  }

  @override
  void initState() {
    super.initState();
    print("Apikeyy $apiKey");
    polylinePoints = PolylinePoints(apiKey: apiKey);
    context.read<DisplayVehiclesCubit>().displayVehicles(context);
    final double? latitude = SharedPreferenceHelper.getLatitude()?.toDouble();
    final double? longitude = SharedPreferenceHelper.getLongitude()?.toDouble();
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
    _updateMarkers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCameraPosition(_pickupLocation!);
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
  }

  updateFcm() async {
    print("Update fcm");
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print("FCM Token: $token");
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
          CameraPosition(target: target, zoom: 14.0),
        ),
      );
    }
  }

  Future<String?> _getAddressFromLatLng(LatLng position) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey');
    try {
      final response = await http.get(url);
      print("Geocoding response: ${response.body}");
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
      print('Error fetching address: $e');
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
        print("Selected Pickup: $_pickupAddress, $_pickupLocation");
      } else {
        _dropLocation = position;
        _dropAddress = address ?? 'Unknown location';
        _dropController.text = _dropAddress ?? '';
        print("Selected Drop: $_dropAddress, $_dropLocation");
      }
      _updateMarkers();
      _updateCameraPosition(position);
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
    _updatePolylines();
  }

  void _updatePolylines() async {
    if (_pickupLocation == null || _dropLocation == null) {
      setState(() {
        _polylines = {};
      });
      return;
    }

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(
              _pickupLocation!.latitude, _pickupLocation!.longitude),
          destination:
              PointLatLng(_dropLocation!.latitude, _dropLocation!.longitude),
          mode: TravelMode.driving,
        ),
      );

      print("Polyline result status: ${result.status}");
      print("Polyline points: ${result.points}");

      if (result.status == 'OK' && result.points.isNotEmpty) {
        List<LatLng> polylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          };
        });
      } else {
        print(
            'No polyline points available or status not OK: ${result.status}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load route: ${result.status}')),
        );
      }
    } catch (e) {
      print('Error fetching polyline: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load route: $e')),
      );
    }
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
      _updateCameraPosition(_pickupLocation ?? _defaultLocation);
    });
    _updateMarkers();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                Navigator.pop(context);
                Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookRideCubit, BookRideState>(
      listener: (context, state) {
        if (state is BookRideSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchingDriverScreen(
                  pickupLocation:
                      LatLng(9.9171716, 78.1319455), // Static pickup location
                  pickupAddress: "periyar bus stop",
                  bookingId: state.ride.ride.bookingId,
                  rideId: state.ride.ride.id),
            ),
          );
        } else if (state is BookRideError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: AppColors.background),
                child: Center(
                  child: Text(
                    'USERNAME',
                    style: TextStyle(color: Colors.white, fontSize: 24.sp),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.history, size: 20.sp),
                title: Text(
                  'Invoices history',
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
                        builder: (context) => const InvoicesHistoryScreen()),
                  );
                },
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
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileManagementScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info, size: 20.sp),
                title: Text(
                  'About',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 15.sp),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.description, size: 20.sp),
                title: Text(
                  'Terms and conditions',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 15.sp),
                ),
                onTap: () {},
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              borderRadius: BorderRadius.circular(5),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RecentPlacesScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(
                              Icons.search,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(
                              Icons.notifications,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: _clearLocations,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(
                              Icons.refresh,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  child: GooglePlaceAutoCompleteTextField(
                    textEditingController: _pickupController,
                    googleAPIKey: apiKey,
                    inputDecoration: InputDecoration(
                      hintText: "Pickup Location",
                      border: InputBorder.none,
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 10),
                      prefixIcon: Icon(Icons.my_location_outlined,
                          color: Colors.grey, size: 20.sp),
                    ),
                    focusNode: _pickupFocusNode,
                    debounceTime: 800,
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction) {
                      setState(() {
                        _pickupAddress = prediction.description;
                        _pickupController.text = _pickupAddress ?? '';
                        _pickupLocation = LatLng(
                          double.parse(prediction.lat ?? '0'),
                          double.parse(prediction.lng ?? '0'),
                        );
                        print(
                            "Selected Pickup: $_pickupAddress, $_pickupLocation");
                        _updateCameraPosition(_pickupLocation!);
                        _updateMarkers();
                      });
                    },
                    itemClick: (Prediction prediction) {
                      _pickupController.text = prediction.description ?? '';
                      _pickupController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _pickupController.text.length),
                      );
                      setState(() {
                        _isEditingPickup = true;
                      });
                    },
                    itemBuilder: (context, index, Prediction prediction) {
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
                ),
                SizedBox(height: 10.h),
                Container(
                  child: GooglePlaceAutoCompleteTextField(
                    textEditingController: _dropController,
                    googleAPIKey: apiKey,
                    inputDecoration: InputDecoration(
                      hintText: "Drop Location",
                      border: InputBorder.none,
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 10),
                      prefixIcon: Icon(Icons.location_on_outlined,
                          color: Colors.grey, size: 20.sp),
                    ),
                    focusNode: _dropFocusNode,
                    debounceTime: 800,
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction) {
                      setState(() {
                        _dropAddress = prediction.description;
                        _dropController.text = _dropAddress ?? '';
                        _dropLocation = LatLng(
                          double.parse(prediction.lat ?? '0'),
                          double.parse(prediction.lng ?? '0'),
                        );
                        print("Selected Drop: $_dropAddress, $_dropLocation");
                        _updateCameraPosition(_dropLocation!);
                        _updateMarkers();
                      });
                    },
                    itemClick: (Prediction prediction) {
                      _dropController.text = prediction.description ?? '';
                      _dropController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _dropController.text.length),
                      );
                      setState(() {
                        _isEditingPickup = false;
                      });
                    },
                    itemBuilder: (context, index, Prediction prediction) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(prediction.description ?? ''),
                      );
                    },
                    seperatedBuilder: const Divider(),
                    isCrossBtnShown: true,
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child:
                      BlocBuilder<DisplayVehiclesCubit, DisplayVehiclesState>(
                    builder: (context, state) {
                      if (state is DisplayVehiclesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DisplayVehiclesSuccess) {
                        final vehicles = state.vehicleData.vehicleTypes;
                        return ListView(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 10.h),
                            Container(
                              height: 200.h,
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: _pickupLocation ?? _defaultLocation,
                                  zoom: 14.0,
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
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                            ...List.generate(
                              vehicles.length,
                              (index) {
                                final vehicle = vehicles[index];
                                if (index == selectedVehicleIndex) {
                                  return Card(
                                    color: Colors.white,
                                    elevation: 3,
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: Container(
                                        width: 40.w,
                                        height: 40.h,
                                        child:
                                            Image.network(vehicle.vehicleImage),
                                      ),
                                      title: Text(
                                        vehicle.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                          "${vehicle.description} (${vehicle.seatingCapacity} seats)"),
                                      trailing: Text(
                                        "₹${vehicle.baseFare}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    ),
                                  );
                                } else {
                                  return ListTile(
                                    leading: Container(
                                      width: 40.w,
                                      height: 40.h,
                                      child:
                                          Image.network(vehicle.vehicleImage),
                                    ),
                                    title: Text(vehicle.name),
                                    subtitle: Text(
                                        "${vehicle.description} (${vehicle.seatingCapacity} seats)"),
                                    trailing: Text("₹${vehicle.baseFare}"),
                                    onTap: () {
                                      setState(() {
                                        selectedVehicleIndex = index;
                                      });
                                    },
                                  );
                                }
                              },
                            ),
                            // Card(
                            //   color: Colors.white,
                            //   margin: EdgeInsets.symmetric(vertical: 5.h),
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //       side: const BorderSide(color: Colors.grey)),
                            //   child: ListTile(
                            //     leading: Container(
                            //       padding: EdgeInsets.symmetric(
                            //           horizontal: 10.w, vertical: 10.h),
                            //       decoration: const BoxDecoration(
                            //           color: AppColors.background,
                            //           shape: BoxShape.circle),
                            //       child: Image.asset("assets/cashback.png"),
                            //     ),
                            //     title: const Text("City Rides Cashback"),
                            //     subtitle: const Text("₹4 cashback per ride"),
                            //     trailing:
                            //         Icon(Icons.arrow_forward_ios, size: 16.sp),
                            //   ),
                            // ),
                            ListTile(
                              leading: Image.asset("assets/bottle.png"),
                              title: const Text("Free water bottle Services"),
                              subtitle: const Text("Applicable for all rides"),
                            ),
                            SizedBox(height: 5.h),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Card(
                                      color: AppColors.background,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        title: const Text(
                                          "Book Now",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onTap: bookingRide,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        title: const Text(
                                          "Schedule Ride",
                                          textAlign: TextAlign.center,
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if (state is DisplayVehiclesError) {
                        return Center(child: Text(state.message));
                      }
                      return const Center(child: Text("No vehicles available"));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
