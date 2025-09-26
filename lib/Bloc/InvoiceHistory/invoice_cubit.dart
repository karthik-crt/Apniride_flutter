import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/api_service.dart';
import 'invoice_state.dart';

class InvoiceHistoryCubit extends Cubit<InvoiceHistoryState> {
  final ApiService apiService;

  InvoiceHistoryCubit(this.apiService) : super(InvoiceHistoryInitial());

  Future<void> fetchInvoiceHistory(BuildContext context) async {
    emit(InvoiceHistoryLoading());
    print("Fetching invoice history...");
    try {
      final invoices = await apiService.getInvoices();
      print("InvoiceHistory fetched: ${invoices.StatusMessage}");
      if (invoices.StatusCode != '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(invoices.StatusMessage)),
        );
        emit(InvoiceHistoryError(invoices.StatusMessage));
      } else {
        emit(InvoiceHistorySuccess(invoices));
      }
    } catch (e) {
      print("Error fetching invoice history: $e");
      emit(InvoiceHistoryError(e.toString()));
    }
  }
}
