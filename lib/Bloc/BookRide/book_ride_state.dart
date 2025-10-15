// lib/Bloc/BookRide/book_ride_state.dart
import '../../model/book_ride.dart';

abstract class BookRideState {}

class BookRideInitial extends BookRideState {}

class BookRideLoading extends BookRideState {}

class BookRideSuccess extends BookRideState {
  final BookRide ride;
  final bool isScheduleRide; // Added field

  BookRideSuccess(this.ride, {this.isScheduleRide = false});

  @override
  List<Object?> get props => [ride, isScheduleRide];
}

class BookRideError extends BookRideState {
  final String message;

  BookRideError(this.message);
}
