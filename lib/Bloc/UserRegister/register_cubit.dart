import 'package:apniride_flutter/Bloc/UserRegister/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/api_service.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final ApiService apiService;
  RegisterCubit(this.apiService) : super(RegisterInitial());
  Future<void> login(Map<String, dynamic> data, context) async {
    emit(RegisterLoading());
    print("Submitting login data...");
    try {
      final registerData = await apiService.register(data);
      print("loginlogin");
      print(registerData.statusCode);
      if (registerData.statusCode != '1') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(registerData.statusMessage)));
        emit(
          RegisterError(
            registerData.statusMessage,
          ),
        );
      } else {
        emit(RegisterSuccess(registerData));
      }
    } catch (e) {
      print("Login error: $e");
      emit(RegisterError(e.toString()));
    }
  }
}
