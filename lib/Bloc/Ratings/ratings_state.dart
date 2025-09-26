import 'package:apniride_flutter/model/register_data.dart';

abstract class RatingsState {}

class RatingsInitial extends RatingsState {}

class RatingsLoading extends RatingsState {}

class RatingsSuccess extends RatingsState {
  final UserRegister register;
  RatingsSuccess(this.register);
  @override
  List<Object?> get props => [register];
}

class RatingsError extends RatingsState {
  final String message;

  RatingsError(this.message);
  List<Object?> get props => [message];
}
