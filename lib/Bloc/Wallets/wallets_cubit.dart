import 'package:apniride_flutter/Bloc/Wallets/wallets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/api_service.dart';

class RazorpayPaymentCubit extends Cubit<RazorpayPaymentState> {
  final ApiService apiService;

  RazorpayPaymentCubit(this.apiService) : super(RazorpayPaymentInitial());

  Future<void> getWalletBalance() async {
    try {
      emit(RazorpayPaymentLoading());
      final response = await apiService.getWallet();
      emit(RazorpayPaymentWalletFetched(response));
    } catch (e) {
      emit(RazorpayPaymentFailure(e.toString()));
    }
  }

  Future<void> addWalletAmount(double amount) async {
    try {
      emit(RazorpayPaymentLoading());
      final response =
          await apiService.addWallet({"amount": amount.toString()});
      emit(RazorpayPaymentSuccess(response));
    } catch (e) {
      emit(RazorpayPaymentFailure(e.toString()));
    }
  }
}
