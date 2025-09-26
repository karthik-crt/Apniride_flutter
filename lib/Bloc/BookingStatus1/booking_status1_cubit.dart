import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/api_service.dart';
import 'booking_status1_state.dart';

class BookingStatusCubit1 extends Cubit<BookingStatusState1> {
  final ApiService apiService;

  BookingStatusCubit1(this.apiService) : super(BookingStatusInitial1());

  Future<void> fetchBookingStatus(
      BuildContext context, String bookingId) async {
    emit(BookingStatusLoading1());
    try {
      final bookingStatus = await apiService.bookingStatus(bookingId);
      print("bookingStatus ${bookingStatus.data.status}");
      if (bookingStatus.statusCode != '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(bookingStatus.StatusMessage)),
        );
        emit(BookingStatusError1(bookingStatus.StatusMessage));
      } else {
        emit(BookingStatusSuccess1(bookingStatus));
      }
    } catch (e) {
      emit(BookingStatusError1(e.toString()));
    }
  }
}
