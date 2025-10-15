import 'package:equatable/equatable.dart';

import '../../model/cashbacks_data.dart';

abstract class CashbacksState extends Equatable {
  const CashbacksState();

  @override
  List<Object?> get props => [];
}

class CashbacksInitial extends CashbacksState {}

class CashbacksLoading extends CashbacksState {}

class CashbacksSuccess extends CashbacksState {
  final Cashbacks cashbacks;

  const CashbacksSuccess(this.cashbacks);

  @override
  List<Object?> get props => [cashbacks];
}

class CashbacksError extends CashbacksState {
  final String message;

  const CashbacksError(this.message);

  @override
  List<Object?> get props => [message];
}
