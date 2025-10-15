import 'package:apniride_flutter/Bloc/RidesHistory/rides_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/api_service.dart';
import 'offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  final ApiService apiService;

  OffersCubit(this.apiService) : super(OffersInitial());

  Future<void> getOffers(BuildContext context) async {
    emit(OffersLoading());
    try {
      final offerData = await apiService.getOffers();
      print("offerData fetched: ${offerData.StatusMessage}");
      if (offerData.StatusCode != '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(offerData.StatusMessage)),
        );
        emit(OffersError(offerData.StatusMessage));
      } else {
        emit(OffersSuccess(offerData));
      }
    } catch (e) {
      print("Error fetching rides history: $e");
      emit(OffersError(e.toString()));
    }
  }
}
