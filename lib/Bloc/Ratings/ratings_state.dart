import 'package:apniride_flutter/model/add_ratings.dart';
import 'package:apniride_flutter/model/register_data.dart';

abstract class RatingsState {}

class RatingsInitial extends RatingsState {}

class RatingsLoading extends RatingsState {}

class RatingsSuccess extends RatingsState {
  final AddRatings ratings;
  RatingsSuccess(this.ratings);
  @override
  List<Object?> get props => [ratings];
}

class RatingsError extends RatingsState {
  final String message;

  RatingsError(this.message);
  List<Object?> get props => [message];
}
