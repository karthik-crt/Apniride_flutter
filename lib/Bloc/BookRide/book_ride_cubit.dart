// lib/Bloc/BookRide/book_ride_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/api_service.dart';
import 'book_ride_state.dart';

class BookRideCubit extends Cubit<BookRideState> {
  final ApiService apiService;

  BookRideCubit(this.apiService) : super(BookRideInitial());

  Future<void> bookRides(data, BuildContext context,
      {bool isScheduleRide = false}) async {
    emit(BookRideLoading());
    try {
      final bookRide = await apiService.bookRide(data);
      print("Booking cab $bookRide");
      if (bookRide.statusCode != 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(bookRide.statusMessage)),
        );
        emit(BookRideError(bookRide.statusMessage));
      } else {
        print("Book ride Book ride success");
        emit(BookRideSuccess(bookRide, isScheduleRide: isScheduleRide));
      }
    } catch (e) {
      print("Fetch ride error: $e");
      emit(BookRideError(e.toString()));
    }
  }
}
