import 'dart:io';
import 'package:apniride_flutter/Bloc/UpdateProfile/update_profile_cubit.dart';
import 'package:apniride_flutter/Bloc/UpdateProfile/update_profile_state.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:share_plus/share_plus.dart';

import '../utils/shared_preference.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  _ProfileManagementScreenState createState() =>
      _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  File? _profileImage;
  String? _paymentMethod;
  String profileImage = "";
  final List<String> _paymentMethods = [
    "UPI",
    "Credit Card",
    "Debit Card",
    "Cash"
  ];

  @override
  void initState() {
    super.initState();
    getUserData();
    print("dsdsds");
  }

  getUserData() async {
    await context.read<UpdateProfileCubit>().getProfile(context);
    final state = context.read<UpdateProfileCubit>().state;
    if (state is UpdateProfileSuccess) {
      print("state.updateprofile.data.profilePhoto");
      print(state.updateprofile.data.profilePhoto);
      profileImage = state.updateprofile.data.profilePhoto;
      SharedPreferenceHelper.setUserName(state.updateprofile.data.username);
      setState(() {});
      print("profileImageprofileImage");
      print(profileImage);
    }
    if (state is UpdateProfileFetched) {
      profileImage = state.profile.data.profilePhoto;
      SharedPreferenceHelper.setUserName(state.profile.data.username);
      setState(() {});
      print("profileImageprofileImage");
      print(profileImage);
    }
    print("profileImageprofileImage");
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _profileImage = File(pickedFile.path);
                  });
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _profileImage = File(pickedFile.path);
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final data = dio.FormData.fromMap({
      'username': _nameController.text,
      'emergency_contact_number': _emergencyController.text,
      'preferred_payment_method': _paymentMethod ?? '',
      if (_profileImage != null)
        'profile_photo_upload': await dio.MultipartFile.fromFile(
          _profileImage!.path,
          filename: 'profile_photo.jpg',
        ),
    });

    if (mounted) {
      await context.read<UpdateProfileCubit>().updateProfile(data, context);
      getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileCubit, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileFetched) {
          setState(() {
            _nameController.text = state.profile.data.username;
            _emergencyController.text =
                state.profile.data.emergencyContactNumber;
            _mobileController.text = state.profile.data.mobile;
            _paymentMethod = state.profile.data.preferredPaymentMethod.isEmpty
                ? "UPI"
                : state.profile.data.preferredPaymentMethod;
          });
        } else if (state is UpdateProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully")),
          );
        } else if (state is UpdateProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          //   onPressed: () => Navigator.pop(context),
          // ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Profile Management",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: AppColors.background.withOpacity(0.4),
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : (profileImage.isNotEmpty)
                              ? NetworkImage(profileImage)
                              : null,
                      child: (_profileImage == null && (profileImage.isEmpty))
                          ? const Icon(Icons.person,
                              size: 50, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Full Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 1),
                        ),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      height: 55.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Upload Profile Photo",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Icon(Icons.image, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Registered Mobile Number",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextField(
                      controller: _mobileController,
                      readOnly: true,
                      showCursor: false,
                      // 👈 Hide blinking cursor
                      enableInteractiveSelection: false,
                      //keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 1),
                        ),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Emergency Contact",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextField(
                      controller: _emergencyController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Emergency Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 1),
                        ),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Preferred Payment Method",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                  SizedBox(height: 10.h),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    hint: Text(
                      "Payment Method",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                    value: _paymentMethod,
                    items: _paymentMethods
                        .map((method) => DropdownMenuItem(
                            value: method, child: Text(method)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value;
                      });
                    },
                  ),
                  SizedBox(height: 70.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.background,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed:
                        state is UpdateProfileLoading ? null : _saveProfile,
                    child: state is UpdateProfileLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save Profile"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
