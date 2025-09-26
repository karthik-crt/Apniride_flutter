// import 'package:apniride_flutter/utils/app_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class AddWalletScreen extends StatefulWidget {
//   const AddWalletScreen({super.key});
//
//   @override
//   State<AddWalletScreen> createState() => _AddWalletScreenState();
// }
//
// class _AddWalletScreenState extends State<AddWalletScreen> {
//   final TextEditingController _amountController = TextEditingController();
//   final List<int> _presetAmounts = [100, 200, 500];
//   int? _selectedAmount;
//
//   void _onPresetTap(int amount) {
//     setState(() {
//       _selectedAmount = amount;
//       _amountController.text = amount.toString();
//     });
//   }
//
//   void _onAddWallet() {
//     final enteredText = _amountController.text.trim();
//     if (enteredText.isEmpty) {
//       _showSnackBar("Please enter or select an amount");
//       return;
//     }
//     final amount = int.tryParse(enteredText);
//     if (amount == null || amount <= 0) {
//       _showSnackBar("Enter a valid amount");
//       return;
//     }
//
//     // ✅ Call your API here with "amount"
//     _showSnackBar("Added ₹$amount to wallet!");
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 0,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(Icons.arrow_back_ios),
//         ),
//         title: Text(
//           "Add your Wallet",
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15.sp,
//               ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Select Amount", style: Theme.of(context).textTheme.bodyLarge),
//             SizedBox(height: 12.h),
//
//             // Preset amount buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: _presetAmounts.map((amount) {
//                 return ChoiceChip(
//                   label: Text("₹$amount"),
//                   selected: _selectedAmount == amount,
//                   onSelected: (_) => _onPresetTap(amount),
//                   selectedColor: AppColors.background,
//                   labelStyle: TextStyle(
//                     color: _selectedAmount == amount
//                         ? Colors.white
//                         : Colors.green.shade700,
//                   ),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 20.h),
//
//             Text(
//               " Enter Custom Amount",
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             SizedBox(height: 8.h),
//
//             // Custom amount input
//             TextField(
//               controller: _amountController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 prefixText: "₹ ",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 hintText: "Enter amount",
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedAmount = null;
//                 });
//               },
//             ),
//             SizedBox(height: 20.h),
//             Container(
//               // margin: EdgeInsets.only(top: 15.h, right: 15.w, left: 15.w),
//               width: MediaQuery.sizeOf(context).width,
//               height: 45.h,
//               child: ElevatedButton(
//                 style: ButtonStyle(
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(
//                         12,
//                       ), // rounded corners
//                       // border color
//                     ),
//                   ),
//                 ),
//                 onPressed: () {
//                   //Navigator.pushNamed(context, AppRoutes.home);
//                 },
//                 child: Text(
//                   "Add Wallet",
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                         color: Colors.white,
//                         fontSize: 15.sp,
//                       ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:apniride_flutter/utils/shared_preference.dart'; // Assume this handles SharedPreferences
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddWalletScreen extends StatefulWidget {
  const AddWalletScreen({super.key});

  @override
  State<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<int> _presetAmounts = [100, 200, 500];
  int? _selectedAmount;
  void _onPresetTap(int amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toString();
    });
  }

  Future<void> _onAddWallet() async {
    final enteredText = _amountController.text.trim();
    if (enteredText.isEmpty) {
      _showSnackBar("Please enter or select an amount");
      return;
    }
    final amount = int.tryParse(enteredText);
    if (amount == null || amount <= 0) {
      _showSnackBar("Enter a valid amount");
      return;
    }

    double currentBalance =
        await SharedPreferenceHelper.getWalletBalance() ?? 0.0;
    await SharedPreferenceHelper.setWalletBalance(currentBalance + amount);
    _showSnackBar("Added ₹$amount to wallet!");
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Add your wallet",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Amount", style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _presetAmounts.map((amount) {
                return ChoiceChip(
                  backgroundColor: Colors.white,
                  label: Text("₹$amount"),
                  selected: _selectedAmount == amount,
                  onSelected: (_) => _onPresetTap(amount),
                  selectedColor: AppColors.background,
                  labelStyle: TextStyle(
                    color: _selectedAmount == amount
                        ? Colors.white
                        : Colors.green.shade700,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.h),

            Text(
              "Enter Custom Amount",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8.h),

            // Custom amount input
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "₹ ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Enter amount",
              ),
              onChanged: (value) {
                setState(() {
                  _selectedAmount = null;
                });
              },
            ),
            SizedBox(height: 20.h),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 45.h,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.background),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                onPressed: _onAddWallet,
                child: Text(
                  "Add Wallet",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 15.sp,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
