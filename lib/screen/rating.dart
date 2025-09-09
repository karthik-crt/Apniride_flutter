import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateExperienceScreen extends StatefulWidget {
  const RateExperienceScreen({Key? key}) : super(key: key);

  @override
  State<RateExperienceScreen> createState() => _RateExperienceScreenState();
}

class _RateExperienceScreenState extends State<RateExperienceScreen> {
  int? selectedRating;
  final TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() {
    // if (selectedRating != null || _feedbackController.text.isNotEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       backgroundColor: Colors.green,
    //       content: Text(
    //         "Rating: ${selectedRating ?? 'No rating'}, Feedback: ${_feedbackController.text.isNotEmpty ? _feedbackController.text : 'Thanks for rating'}",
    //       ),
    //     ),
    //   );
    Navigator.pop(context);
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //         content: Text("Please select a rating or write feedback")),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),

                  SizedBox(height: 10.h),

                  // Title
                  Text("Rate your experience",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 14.sp)),
                ],
              ),

              SizedBox(height: 8.h),

              Text(
                "  How was your experience",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7.h),
              Text(
                "   Your feedback helps us to improve the app",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 13.sp, color: Colors.grey),
              ),
              SizedBox(height: 35.h),

              // Rating Buttons (1–5)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                    (index) {
                      final rating = index + 1;
                      final isSelected = selectedRating == rating;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRating = rating;
                          });
                        },
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.background
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              rating.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Feedback TextField
              TextField(
                controller: _feedbackController,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: "Write your feedback...",
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.grey, width: 0), // <-- normal color
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const Spacer(),

              // Submit Button
              SizedBox(
                height: 40.h,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  onPressed: _submitFeedback,
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
