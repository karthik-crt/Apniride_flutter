import 'package:apniride_flutter/screen/permission_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import 'CreateAccount.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: GestureDetector(
      //   onTap: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => Createaccount()));
      //   },
      //   child: Container(
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(7),
      //         color: Color(0xFF0E7C7B),
      //       ),
      //       width: 328,
      //       height: 50,
      //       alignment: Alignment.center,
      //       child: Text(
      //         "Verify",
      //         style: TextStyle(
      //           color: Colors.white,
      //         ),
      //       )),
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios_new_rounded),
              SizedBox(
                width: 10.w,
              ),
              Text(
                "Back",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Please wait.',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 20)),
            Text('we will auto verify the OTP sent to +91 9876543210',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 20)),
            SizedBox(
              height: 10,
            ),
            Pinput(
              length: 6,
              separatorBuilder: (index) => const SizedBox(width: 8),
              validator: (value) {
                return value == '222222' ? null : 'Pin is incorrect';
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                debugPrint('onCompleted: $pin');
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Didn't receive OTP?",
                  style: TextStyle(color: Colors.grey),
                ),
                Text("Resend OTP", style: TextStyle(color: Colors.grey))
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E7C7B),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Createaccount()));
                },
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:apniride_flutter/screen/permission_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pinput/pinput.dart';
//
// import 'CreateAccount.dart';
// import 'bottom_bar.dart';
//
// class OtpVerification extends StatefulWidget {
//   final String verificationId;
//   final int? resendToken;
//   final bool isOldUser;
//   final String phoneNumber;
//
//   const OtpVerification({
//     super.key,
//     required this.verificationId,
//     required this.resendToken,
//     required this.isOldUser,
//     required this.phoneNumber,
//   });
//
//   @override
//   State<OtpVerification> createState() => _OtpVerificationState();
// }
//
// class _OtpVerificationState extends State<OtpVerification> {
//   late String verificationId;
//   late int? resendToken;
//   final TextEditingController _pinController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     verificationId = widget.verificationId;
//     resendToken = widget.resendToken;
//   }
//
//   @override
//   void dispose() {
//     _pinController.dispose();
//     super.dispose();
//   }
//
//   Future<void> resendOtp() async {
//     await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: widget.phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await FirebaseAuth.instance.signInWithCredential(credential);
//         if (widget.isOldUser) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => BottomNavBar(currentindex: 0),
//             ),
//           );
//         } else {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => Createaccount()),
//           );
//         }
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Resend failed: ${e.message}')),
//         );
//       },
//       codeSent: (String newVerificationId, int? newResendToken) {
//         setState(() {
//           verificationId = newVerificationId;
//           resendToken = newResendToken;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('OTP resent successfully')),
//         );
//       },
//       codeAutoRetrievalTimeout: (String newVerificationId) {},
//       forceResendingToken: resendToken,
//     );
//   }
//
//   Future<void> verifyOtp(String pin) async {
//     if (pin.length != 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a 6-digit OTP')),
//       );
//       return;
//     }
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: pin,
//       );
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       if (widget.isOldUser) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BottomNavBar(currentindex: 0),
//           ),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => Createaccount()),
//         );
//       }
//     } catch (e) {
//       print("OTP Error : ${e.toString()}");
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   const SnackBar(content: Text('Invalid OTP')),
//       // );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         title: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Row(
//             children: [
//               Icon(Icons.arrow_back_ios_new_rounded),
//               SizedBox(
//                 width: 10.w,
//               ),
//               Text(
//                 "Back",
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Please wait, we will auto verify the OTP',
//                 style: Theme.of(context)
//                     .textTheme
//                     .headlineSmall
//                     ?.copyWith(fontSize: 20)),
//             Text('sent to ${widget.phoneNumber}',
//                 style: Theme.of(context)
//                     .textTheme
//                     .headlineSmall
//                     ?.copyWith(fontSize: 20)),
//             SizedBox(
//               height: 10,
//             ),
//             Pinput(
//               controller: _pinController,
//               length: 6,
//               separatorBuilder: (index) => const SizedBox(width: 8),
//               hapticFeedbackType: HapticFeedbackType.lightImpact,
//               onCompleted: (pin) async {
//                 await verifyOtp(pin);
//               },
//               onChanged: (value) {
//                 debugPrint('onChanged: $value');
//               },
//               cursor: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 9),
//                     width: 22,
//                     height: 1,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Didn't receive OTP?",
//                   style: TextStyle(color: Colors.grey),
//                 ),
//                 GestureDetector(
//                   onTap: resendOtp,
//                   child:
//                       Text("Resend OTP", style: TextStyle(color: Colors.grey)),
//                 )
//               ],
//             ),
//             Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF0E7C7B),
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed: () async {
//                   await verifyOtp(_pinController.text);
//                 },
//                 child: const Text(
//                   "Verify",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
