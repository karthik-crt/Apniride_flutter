import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/api_service.dart';
import 'display_vehicles_state.dart';

class DisplayVehiclesCubit extends Cubit<DisplayVehiclesState> {
  final ApiService apiService;
  DisplayVehiclesCubit(this.apiService) : super(DisplayVehiclesInitial());
  Future<void> displayVehicles(context) async {
    emit(DisplayVehiclesLoading());
    print("Submitting login data...");
    try {
      final vehicles = await apiService.displayVehicles();
      print("loginlogin");
      print(vehicles.statusCode);
      if (vehicles.statusCode != '1') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(vehicles.statusMessage)));
        emit(
          DisplayVehiclesError(
            vehicles.statusMessage,
          ),
        );
      } else {
        emit(DisplayVehiclesSuccess(vehicles));
      }
    } catch (e) {
      print("Display vehicles: $e");
      emit(DisplayVehiclesError(e.toString()));
    }
  }
}
