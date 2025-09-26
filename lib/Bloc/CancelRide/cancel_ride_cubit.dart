import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/api_service.dart';
import 'cancel_ride_state.dart';

class CancelRideCubit extends Cubit<CancelRideState> {
  final ApiService apiService;

  CancelRideCubit(this.apiService) : super(CancelRideInitial());

  Future<void> cancelRides(BuildContext context, int rideId) async {
    emit(CancelRideLoading());
    try {
      final cancel = await apiService.cancelRide(rideId);
      print("cancel trip fetched: ${cancel.statusMessage}");
      if (cancel.statusCode != '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(cancel.statusMessage)),
        );
        emit(CancelRideError(cancel.statusMessage));
      } else {
        emit(CancelRideSuccess(cancel));
      }
    } catch (e) {
      print("Cancel trip: $e");
      emit(CancelRideError(e.toString()));
    }
  }
}
