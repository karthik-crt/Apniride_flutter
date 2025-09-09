import '../../model/Updateprofile.dart';

abstract class UpdateProfileState {}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileFetched extends UpdateProfileState {
  final UpdateProfile profile;
  UpdateProfileFetched(this.profile);
  @override
  List<Object?> get props => [profile];
}

class UpdateProfileSuccess extends UpdateProfileState {
  final UpdateProfile updateprofile;
  UpdateProfileSuccess(this.updateprofile);
  @override
  List<Object?> get props => [updateprofile];
}

class UpdateProfileError extends UpdateProfileState {
  final String message;
  UpdateProfileError(this.message);
  @override
  List<Object?> get props => [message];
}
