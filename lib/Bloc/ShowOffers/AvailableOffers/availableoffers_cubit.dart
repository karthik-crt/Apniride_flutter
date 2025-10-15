import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/api_service.dart';
import 'availableoffers_state.dart';

class AvailableCashbacksCubit extends Cubit<AvailableCashbacksState> {
  final ApiService apiService;

  AvailableCashbacksCubit(this.apiService) : super(AvailableCashbacksInitial());

  Future<void> getCashbacks(BuildContext context) async {
    emit(AvailableCashbacksLoading());
    print("get cashbacks...");
    try {
      final cashbacks = await apiService.getCashbacks();
      print("InvoiceHistory fetched: ${cashbacks.StatusMessage}");
      if (cashbacks.StatusCode != '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(cashbacks.StatusMessage)),
        );
        emit(AvailableCashbacksError(cashbacks.StatusMessage));
      } else {
        emit(AvailableCashbacksSuccess(cashbacks));
      }
    } catch (e) {
      print("GetAvailableCashbacks $e");
      emit(AvailableCashbacksError(e.toString()));
    }
  }
}
