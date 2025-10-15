import 'package:equatable/equatable.dart';

import '../../../model/cashbacks_data.dart';

abstract class AvailableCashbacksState extends Equatable {
  const AvailableCashbacksState();

  @override
  List<Object?> get props => [];
}

class AvailableCashbacksInitial extends AvailableCashbacksState {}

class AvailableCashbacksLoading extends AvailableCashbacksState {}

class AvailableCashbacksSuccess extends AvailableCashbacksState {
  final Cashbacks cashbacks;

  const AvailableCashbacksSuccess(this.cashbacks);

  @override
  List<Object?> get props => [cashbacks];
}

class AvailableCashbacksError extends AvailableCashbacksState {
  final String message;

  const AvailableCashbacksError(this.message);

  @override
  List<Object?> get props => [message];
}
