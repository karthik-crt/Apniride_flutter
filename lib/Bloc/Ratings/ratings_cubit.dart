import 'package:apniride_flutter/Bloc/Ratings/ratings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/api_service.dart';

class RatingsCubit extends Cubit<RatingsState> {
  final ApiService apiService;
  RatingsCubit(this.apiService) : super(RatingsInitial());
  Future<void> ratings(Map<String, dynamic> data, context) async {
    emit(RatingsLoading());
    print("Ratings Data");
    try {
      final registerData = await apiService.register(data);
      print("loginlogin");
      print(registerData.statusCode);
      if (registerData.statusCode != '1') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(registerData.statusMessage)));
        emit(
          RatingsError(
            registerData.statusMessage,
          ),
        );
      } else {
        emit(RatingsSuccess(registerData));
      }
    } catch (e) {
      print("Login error: $e");
      emit(RatingsError(e.toString()));
    }
  }
}
