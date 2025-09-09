
import 'package:apniride_flutter/model/displayVehicles.dart';

import '../../model/login_data.dart';

abstract class DisplayVehiclesState {}

class DisplayVehiclesInitial extends DisplayVehiclesState {}

class DisplayVehiclesLoading extends DisplayVehiclesState {}

class DisplayVehiclesSuccess extends DisplayVehiclesState {
  final DisplayVehicles vehicleData;
  DisplayVehiclesSuccess(this.vehicleData);
  @override
  List<Object?> get props => [vehicleData];
}

class DisplayVehiclesError extends DisplayVehiclesState {
  final String message;

  DisplayVehiclesError(this.message);
}
