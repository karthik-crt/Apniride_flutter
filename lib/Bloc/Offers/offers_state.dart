import 'package:apniride_flutter/model/offers_data.dart';

import '../../model/rides_history_data.dart';

abstract class OffersState {}

class OffersInitial extends OffersState {}

class OffersLoading extends OffersState {}

class OffersSuccess extends OffersState {
  final Offers offersData;

  OffersSuccess(this.offersData);
}

class OffersError extends OffersState {
  final String message;

  OffersError(this.message);
}
