import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/api_service.dart';
import 'cashbacks_state.dart';

class CashbacksCubit extends Cubit<CashbacksState> {
  final ApiService apiService;

  CashbacksCubit(this.apiService) : super(CashbacksInitial());

  Future<void> getCashbacks(BuildContext context) async {
    emit(CashbacksLoading());
    print("get cashbacks...");
    try {
      final cashbacks = await apiService.getCashbacks();
      print("InvoiceHistory fetched: ${cashbacks.StatusMessage}");
      if (cashbacks.StatusCode != '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(cashbacks.StatusMessage)),
        );
        emit(CashbacksError(cashbacks.StatusMessage));
      } else {
        emit(CashbacksSuccess(cashbacks));
      }
    } catch (e) {
      print("Error fetching invoice history: $e");
      emit(CashbacksError(e.toString()));
    }
  }
}
