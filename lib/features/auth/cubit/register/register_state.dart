import '../../data/models/user_model.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final UserModel? user;
  final String message;

  RegisterSuccess({this.user, this.message = 'Registration successful'});
}

class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure(this.error);
}
