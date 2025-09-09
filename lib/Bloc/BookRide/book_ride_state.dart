import '../../model/book_ride.dart';
import '../../model/login_data.dart';

abstract class BookRideState {}

class BookRideInitial extends BookRideState {}

class BookRideLoading extends BookRideState {}

class BookRideSuccess extends BookRideState {
  final BookRide ride;
  BookRideSuccess(this.ride);
  @override
  List<Object?> get props => [ride];
}

class BookRideError extends BookRideState {
  final String message;

  BookRideError(this.message);
}
