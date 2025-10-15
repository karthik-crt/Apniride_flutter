import 'package:apniride_flutter/Bloc/Ratings/ratings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/api_service.dart';

class RatingsCubit extends Cubit<RatingsState> {
  final ApiService apiService;
  RatingsCubit(this.apiService) : super(RatingsInitial());
  Future<void> ratings(Map<String, dynamic> data, int rideId, context) async {
    emit(RatingsLoading());
    print("Ratings Data ${data}");
    try {
      final ratings = await apiService.addRatings(rideId, data);
      print("loginlogin");
      print(ratings.StatusCode);
      if (ratings.StatusCode != '1') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ratings.StatusMessage)));
        emit(
          RatingsError(
            ratings.StatusMessage,
          ),
        );
      } else {
        emit(RatingsSuccess(ratings));
      }
    } catch (e) {
      print("Login error: $e");
      emit(RatingsError(e.toString()));
    }
  }
}
