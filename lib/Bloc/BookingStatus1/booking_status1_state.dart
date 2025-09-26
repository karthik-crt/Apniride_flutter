import 'package:apniride_flutter/model/booking_status.dart';
import 'package:equatable/equatable.dart';

abstract class BookingStatusState1 extends Equatable {
  const BookingStatusState1();

  @override
  List<Object> get props => [];
}

class BookingStatusInitial1 extends BookingStatusState1 {}

class BookingStatusLoading1 extends BookingStatusState1 {}

class BookingStatusSuccess1 extends BookingStatusState1 {
  final BookingStatus bookingStatus;

  const BookingStatusSuccess1(this.bookingStatus);

  @override
  List<Object> get props => [bookingStatus];
}

class BookingStatusError1 extends BookingStatusState1 {
  final String error;

  const BookingStatusError1(this.error);

  @override
  List<Object> get props => [error];
}
