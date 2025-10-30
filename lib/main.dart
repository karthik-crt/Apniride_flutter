import 'package:apniride_flutter/Bloc/BookRide/book_ride_cubit.dart';
import 'package:apniride_flutter/Bloc/BookingStatus/booking_status_cubit.dart';
import 'package:apniride_flutter/Bloc/BookingStatus1/booking_status1_cubit.dart';
import 'package:apniride_flutter/Bloc/CancelRide/cancel_ride_cubit.dart';
import 'package:apniride_flutter/Bloc/Cashbacks/cashbacks_cubit.dart';
import 'package:apniride_flutter/Bloc/DisplayVehicles/display_vehicles_cubit.dart';
import 'package:apniride_flutter/Bloc/InvoiceHistory/invoice_cubit.dart';
import 'package:apniride_flutter/Bloc/Offers/offers_cubit.dart';
import 'package:apniride_flutter/Bloc/Ratings/ratings_cubit.dart';
import 'package:apniride_flutter/Bloc/RidesHistory/rides_history_cubit.dart';
import 'package:apniride_flutter/Bloc/ShowOffers/AvailableOffers/availableoffers_cubit.dart';
import 'package:apniride_flutter/Bloc/UpdateProfile/update_profile_cubit.dart';
import 'package:apniride_flutter/Bloc/UserRegister/register_cubit.dart';
import 'package:apniride_flutter/Bloc/WalletHistory/wallet_history_cubit.dart';
import 'package:apniride_flutter/Bloc/Wallets/wallets_cubit.dart';
import 'package:apniride_flutter/model/booking_status.dart';
import 'package:apniride_flutter/screen/SplashScreen.dart';
import 'package:apniride_flutter/screen/rides_history.dart';
import 'package:apniride_flutter/screen/wallet_history_screen.dart';
import 'package:apniride_flutter/utils/api_service.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:apniride_flutter/utils/notification_service.dart';
import 'package:apniride_flutter/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Bloc/LoginCubit/login_cubit.dart';
import 'firebase_options.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   print("BG message: ${message.data}");
// }
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await SharedPreferenceHelper.init();
//   String? token = await FirebaseMessaging.instance.getToken();
//   if (token != null) {
//     print("FCM Token: $token");
//     SharedPreferenceHelper.setFcmToken(token);
//   }
//   await NotificationService.init(navigatorKey);
//   FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//     print(" Refreshed FCM Token: $newToken");
//     SharedPreferenceHelper.setFcmToken(newToken);
//   });
//   await NotificationService.init(navigatorKey);
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print("Foreground message: ${message.data}");
//     NotificationService.showNotification(message);
//   });
//
//   FirebaseMessaging.instance.getInitialMessage().then((message) {
//     print("MessageMessage ${message}");
//     if (message != null) {
//       final data = message.data;
//       print("Initial message data: $data");
//       navigatorKey.currentState?.push(
//         MaterialPageRoute(builder: (context) => RidesHistories()),
//       );
//     }
//   });
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     if (message != null) {
//       final data = message.data;
//       print("Initial message data: $data");
//       navigatorKey.currentState?.push(
//         MaterialPageRoute(builder: (context) => RidesHistories()),
//       );
//     }
//   });
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//
//   runApp(const MyApp());
// }

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message received : ${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPreferenceHelper.init();
  await NotificationService.init(navigatorKey);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationSettings settings = await FirebaseMessaging.instance
      .requestPermission(alert: true, badge: true, sound: true);
  debugPrint('User granted permission: ${settings.authorizationStatus}');

  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    debugPrint('FCMToken: $token');
    SharedPreferenceHelper.setFcmToken(token);
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    debugPrint('Refreshed FCM Token: $newToken');
    SharedPreferenceHelper.setFcmToken(newToken);
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Foreground message: ${message.data}');
    NotificationService.showNotification(message);
  });

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      final data = message.data;
      debugPrint('getInitialMessage data: $data');
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => RidesHistories()),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final data = message.data;
    debugPrint('onMessageOpenedApp data: $data');
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => RidesHistories()),
    );
  });

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
          BlocProvider(
              create: (context) => RatingsCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) =>
                  RazorpayPaymentCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) => CashbacksCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) => OffersCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) =>
                  AvailableCashbacksCubit(context.read<ApiService>())),
          BlocProvider(
              create: (context) =>
                  WalletHistoryCubit(context.read<ApiService>())),
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
              navigatorKey: navigatorKey,
            );
          },
        ),
      ),
    );
  }
}
