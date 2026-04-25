import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/network/dio_helper.dart';
import '../../data/models/user_model.dart';
import '../../data/repo/auth_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo _authRepo;
  UserModel? currentUser;

  LoginCubit(this._authRepo) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    final result = await _authRepo.login(
      email: email,
      password: password,
    );

    if (result['success'] == true) {
      final token = result['token'] as String;
      
      // Save token
      await CacheHelper.saveToken(token);
      DioHelper.setAuthToken(token);

      // Get user data
      final user = await _authRepo.getUserData();
      currentUser = user;

      emit(LoginSuccess(user: user, message: result['message']));
    } else {
      emit(LoginFailure(result['message']));
    }
  }

  void logout() {
    CacheHelper.removeToken();
    DioHelper.clearAuthToken();
    currentUser = null;
    emit(LoginInitial());
  }

  bool get isLoggedIn => CacheHelper.isLoggedIn();
}
