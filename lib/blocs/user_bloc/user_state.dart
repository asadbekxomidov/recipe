import 'package:user_repository/user_repository.dart';

sealed class UserState {}

final class UserStateInitial extends UserState {}

final class UserStateLoading extends UserState {}

final class UserStateLoaded extends UserState {
  final UserModel userModel;
  UserStateLoaded({required this.userModel});
}

final class UserStateError extends UserState {
  final String message;
  UserStateError({required this.message});
}
