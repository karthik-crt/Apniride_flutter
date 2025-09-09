import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/api_service.dart';
import 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final ApiService apiService;

  UpdateProfileCubit(this.apiService) : super(UpdateProfileInitial());

  Future<void> getProfile(context) async {
    emit(UpdateProfileLoading());
    try {
      final profileData = await apiService.getProfile();
      print("Fetched profile: $profileData");
      if (profileData.StatusCode != 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(profileData.statusMessage)),
        );
        emit(UpdateProfileError(profileData.statusMessage));
      } else {
        emit(UpdateProfileFetched(profileData));
      }
    } catch (e) {
      print("Fetch profile error: $e");
      emit(UpdateProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(FormData data, BuildContext context) async {
    emit(UpdateProfileLoading());
    print("Submitting profile data: $data");
    try {
      final profileData = await apiService.updateProfile(data);
      print("Update profile response: $profileData");
      if (profileData.StatusCode != 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(profileData.statusMessage)),
        );
        emit(UpdateProfileError(profileData.statusMessage));
      } else {
        emit(UpdateProfileSuccess(profileData));
      }
    } catch (e) {
      print("Update profile error: $e");
      emit(UpdateProfileError(e.toString()));
    }
  }
}
