// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:apniride_flutter/utils/app_theme.dart';
//
// class RatingsScreen extends StatefulWidget {
//   final int rideId;
//
//   const RatingsScreen({super.key, required this.rideId});
//
//   @override
//   _RatingsScreenState createState() => _RatingsScreenState();
// }
//
// class _RatingsScreenState extends State<RatingsScreen> {
//   int _selectedRating = 0;
//   final TextEditingController _feedbackController = TextEditingController();
//
//   void _submitRatingAndFeedback() {
//     if (_selectedRating == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select a rating'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//     print('Ride ID: ${widget.rideId}');
//     print('Rating: $_selectedRating');
//     print('Feedback: ${_feedbackController.text}');
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Thank you for your feedback!'),
//         backgroundColor: Colors.green,
//       ),
//     );
//
//     Navigator.pop(context);
//   }
//
//   @override
//   void dispose() {
//     _feedbackController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: SizedBox(
//         width: double.infinity,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.background,
//             foregroundColor: Colors.white,
//             padding: EdgeInsets.symmetric(vertical: 12.h),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           onPressed: _submitRatingAndFeedback,
//           child: Text(
//             'Submit Feedback',
//             style: TextStyle(fontSize: 16.sp),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   SizedBox(width: 50.w),
//                   Text(
//                     'Ratings',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20.h),
//               Text(
//                 'How was your ride?',
//                 style: TextStyle(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Text(
//                 'Rate your experience',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(5, (index) {
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedRating = index + 1;
//                       });
//                     },
//                     child: Icon(
//                       Icons.star,
//                       size: 50.w,
//                       color: _selectedRating > index
//                           ? Colors.yellow.shade700
//                           : Colors.grey.shade300,
//                     ),
//                   );
//                 }),
//               ),
//               SizedBox(height: 30.h),
//               Text(
//                 'Share your feedback',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               TextField(
//                 controller: _feedbackController,
//                 maxLines: 5,
//                 decoration: InputDecoration(
//                   hintText: 'Tell us about your experience ...',
//                   hintStyle: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(color: Colors.grey.shade500),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: AppColors.background),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
