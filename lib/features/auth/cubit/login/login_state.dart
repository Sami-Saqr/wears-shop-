import '../../data/models/user_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserModel? user;
  final String message;

  LoginSuccess({this.user, this.message = 'Login successful'});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}
