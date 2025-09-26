import 'package:apniride_flutter/model/cancel_ride.dart';

import '../../model/rides_history_data.dart';

abstract class CancelRideState {}

class CancelRideInitial extends CancelRideState {}

class CancelRideLoading extends CancelRideState {}

class CancelRideSuccess extends CancelRideState {
  final CancelRide cancelRide;

  CancelRideSuccess(this.cancelRide);
}

class CancelRideError extends CancelRideState {
  final String message;

  CancelRideError(this.message);
}
