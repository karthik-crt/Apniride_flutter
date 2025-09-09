import 'package:apniride_flutter/model/register_data.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final UserRegister register;
  RegisterSuccess(this.register);
  @override
  List<Object?> get props => [register];
}

class RegisterError extends RegisterState {
  final String message;

  RegisterError(this.message);
  List<Object?> get props => [message];
}
