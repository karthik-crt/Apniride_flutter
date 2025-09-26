import 'package:apniride_flutter/model/booking_status.dart';
import 'package:equatable/equatable.dart';

abstract class BookingStatusState extends Equatable {
  const BookingStatusState();

  @override
  List<Object> get props => [];
}

class BookingStatusInitial extends BookingStatusState {}

class BookingStatusLoading extends BookingStatusState {}

class BookingStatusSuccess extends BookingStatusState {
  final BookingStatus bookingStatus;

  const BookingStatusSuccess(this.bookingStatus);

  @override
  List<Object> get props => [bookingStatus];
}

class BookingStatusError extends BookingStatusState {
  final String error;

  const BookingStatusError(this.error);

  @override
  List<Object> get props => [error];
}
