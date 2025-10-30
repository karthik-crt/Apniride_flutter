// import 'package:apniride_flutter/screen/rating.dart';
// import 'package:apniride_flutter/utils/app_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class AddWalletScreen extends StatefulWidget {
//   const AddWalletScreen({Key? key}) : super(key: key);
//
//   @override
//   State<AddWalletScreen> createState() => _AddWalletScreenState();
// }
//
// class _AddWalletScreenState extends State<AddWalletScreen> {
//   bool autoDeduct = false;
//   final TextEditingController amountController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: Text(
//           "Payments",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 13.sp,
//           ),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Add money field
//           const Text(
//             "Add Money to wallet",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 15.h),
//           TextField(
//             controller: amountController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               hintText: "Enter Amount",
//               hintStyle: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.normal),
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.transparent)),
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
//             ),
//           ),
//
//           SizedBox(height: 25.h),
//
//           // Payment Options
//           const Text(
//             "Payment Options",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 15.h),
//           // paymentOptionTile(
//           //   imageUrl: "assets/upi.png",
//           //   title: "UPI",
//           //   onTap: () {},
//           // ),
//           SizedBox(height: 10.h),
//           // paymentOptionTile(
//           //   imageUrl: "assets/debit_card.png",
//           //   title: "Credit/Debit Card",
//           //   onTap: () {},
//           // ),
//
//           SizedBox(height: 20.h),
//
//           // Wallet Balance
//           const Text(
//             "Wallet Balance",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 15.h),
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.teal.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Image.asset(
//                   "assets/wallet_balance.png",
//                   height: 30.h,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               const Text(
//                 "₹ 1,200",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//
//           SizedBox(height: 20.h),
//
//           // Auto-Deduct
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Auto-Detect trip fare",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 2),
//                   Text(
//                     "Trip fares will be automatically deducted from\nyour wallet",
//                     style: TextStyle(fontSize: 11.sp, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               Switch(
//                 value: autoDeduct,
//                 activeColor: AppColors.background,
//                 onChanged: (val) {
//                   setState(() {
//                     autoDeduct = val;
//                   });
//                 },
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 10),
//
//           // Auto-deduct amount
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Auto-Deduct trip fare",
//                 style: TextStyle(fontSize: 16.sp),
//               ),
//               Text(
//                 "₹ 100",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//
//           SizedBox(height: 60.h),
//
//           // Buttons
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.background,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                   ),
//                   onPressed: () {},
//                   child:
//                       const Text("Add money", style: TextStyle(fontSize: 16)),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: OutlinedButton(
//                   style: OutlinedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     side: BorderSide(
//                       color: Colors.grey,
//                     ), // Border color here
//                   ),
//                   onPressed: () {
//                     _showSuccessModal(context);
//                   },
//                   child: const Text(
//                     "Pay now",
//                     style: TextStyle(fontSize: 16, color: Colors.black),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showSuccessModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         color: Colors.white,
//         padding: EdgeInsets.all(20.h),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.check_circle,
//               color: AppColors.background,
//               size: 60.sp,
//             ),
//             SizedBox(height: 10.h),
//             Text(
//               'Payment Successfully',
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20.h),
//             SizedBox(
//               width: double.infinity, // Makes button full-width
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Close the modal
//                   // Navigator.pushReplacement(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) => RateExperienceScreen(),
//                   //   ),
//                   // );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.background,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 60.w,
//                     vertical: 10.h,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   'OK',
//                   style: TextStyle(color: Colors.white, fontSize: 16.sp),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget paymentOptionTile({
//     required String imageUrl,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Image.asset(imageUrl, height: 28),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:apniride_flutter/utils/api_service.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:apniride_flutter/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../Bloc/Wallets/wallets_cubit.dart';
import '../Bloc/Wallets/wallets_state.dart';

class AddWalletScreen extends StatefulWidget {
  const AddWalletScreen({Key? key}) : super(key: key);

  @override
  State<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  bool autoDeduct = false;
  final TextEditingController amountController = TextEditingController();
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("success success");
    final amount = double.tryParse(amountController.text) ?? 0.0;
    String paymentId = response.paymentId ?? "";
    String orderId = response.orderId ?? "";
    String signature = response.signature ?? "";
    print("Payment ID: $paymentId");
    print("Order ID: $orderId");
    print("Signature: $signature");
    print(response);
    if (amount > 0) {
      context.read<RazorpayPaymentCubit>().addWalletAmount(amount);
    }
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

  @override
  void dispose() {
    _razorpay.clear();
    amountController.dispose();
    super.dispose();
  }

  void _startRazorpayPayment(double amount) {
    _razorpay = Razorpay();

    final options = {
      'key': 'rzp_test_RWneIBNQYQoNVc',
      'amount': (amount * 100).toInt(), // Amount in paise
      'name': 'ApniRide',
      'description': 'Add money to wallet',
      //'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      context.read<RazorpayPaymentCubit>().getWalletBalance();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error initiating payment: $e")),
      );
    }
  }

  void _showSuccessModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.background,
              size: 60.sp,
            ),
            SizedBox(height: 10.h),
            Text(
              'Payment Successful',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the modal
                  Navigator.pop(context); // Return to previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  padding: EdgeInsets.symmetric(
                    horizontal: 60.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RazorpayPaymentCubit(context.read<ApiService>()),
      child: BlocConsumer<RazorpayPaymentCubit, RazorpayPaymentState>(
        listener: (context, state) {
          if (state is RazorpayPaymentSuccess) {
            SharedPreferenceHelper.setWalletBalance(
                state.addWallet.balance.toDouble());
            context
                .read<RazorpayPaymentCubit>()
                .getWalletBalance(); // Refresh balance
            _showSuccessModal(context);
          } else if (state is RazorpayPaymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          double walletBalance = 0.0;
          if (state is RazorpayPaymentWalletFetched) {
            walletBalance = double.tryParse(state.wallet.data.balance) ?? 0.0;
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: Text(
                "Payments",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.sp,
                ),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Add Money to wallet",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15.h),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Amount",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.transparent)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 16),
                  ),
                ),
                SizedBox(height: 25.h),
                const Text(
                  "Payment Options",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 15.h),
                // paymentOptionTile(
                //   imageUrl: "assets/razorpay.png",
                //   title: "Razorpay",
                //   onTap: () {
                //     final amount =
                //         double.tryParse(amountController.text) ?? 0.0;
                //     if (amount > 0) {
                //       _startRazorpayPayment(amount);
                //     } else {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text("Please enter a valid amount")),
                //       );
                //     }
                //   },
                // ),
                SizedBox(height: 20.h),
                const Text(
                  "Wallet Balance",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        "assets/wallet_balance.png",
                        height: 30.h,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "₹ $walletBalance",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Auto-Detect trip fare",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Trip fares will be automatically deducted from\nyour wallet",
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                    Switch(
                      value: autoDeduct,
                      activeColor: AppColors.background,
                      onChanged: (val) {
                        setState(() {
                          autoDeduct = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Auto-Deduct trip fare",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Text(
                      "₹ 100",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 60.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.background,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          final amount =
                              double.tryParse(amountController.text) ?? 0.0;
                          if (amount > 0) {
                            _startRazorpayPayment(amount);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Please enter a valid amount")),
                            );
                          }
                        },
                        child: const Text("Add money",
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        onPressed: () {
                          final amount =
                              double.tryParse(amountController.text) ?? 0.0;
                          if (amount > 0) {
                            _startRazorpayPayment(amount);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Please enter a valid amount")),
                            );
                          }
                        },
                        child: const Text(
                          "Pay now",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget paymentOptionTile({
    required String imageUrl,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(imageUrl, height: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
