import 'package:apniride_flutter/Bloc/BookRide/book_ride_cubit.dart';
import 'package:apniride_flutter/Bloc/BookingStatus/booking_status_cubit.dart';
import 'package:apniride_flutter/Bloc/BookingStatus1/booking_status1_cubit.dart';
import 'package:apniride_flutter/Bloc/CancelRide/cancel_ride_cubit.dart';
import 'package:apniride_flutter/Bloc/DisplayVehicles/display_vehicles_cubit.dart';
import 'package:apniride_flutter/Bloc/InvoiceHistory/invoice_cubit.dart';
import 'package:apniride_flutter/Bloc/RidesHistory/rides_history_cubit.dart';
import 'package:apniride_flutter/Bloc/UpdateProfile/update_profile_cubit.dart';
import 'package:apniride_flutter/Bloc/UserRegister/register_cubit.dart';
import 'package:apniride_flutter/model/booking_status.dart';
import 'package:apniride_flutter/screen/SplashScreen.dart';
import 'package:apniride_flutter/utils/api_service.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:apniride_flutter/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Bloc/LoginCubit/login_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferenceHelper.init();
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    print("FCM Token: $token");
    SharedPreferenceHelper.setFcmToken(token);
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print(" Refreshed FCM Token: $newToken");
    SharedPreferenceHelper.setFcmToken(newToken);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ApiService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => LoginCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) => RegisterCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) =>
                  DisplayVehiclesCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) =>
                  UpdateProfileCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) => BookRideCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) =>
                  BookingStatusCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) =>
                  RidesHistoryCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) => CancelRideCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) =>
                  InvoiceHistoryCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) =>
                  BookingStatusCubit1(context.read<ApiService>())),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (__, context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: AppTheme.lightTheme,
              home: Splashscreen(),
            );
          },
        ),
      ),
    );
  }
}
