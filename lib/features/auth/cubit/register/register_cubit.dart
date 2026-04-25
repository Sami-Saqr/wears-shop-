import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/network/dio_helper.dart';
import '../../data/models/user_model.dart';
import '../../data/repo/auth_repo.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepo _authRepo;
  UserModel? currentUser;

  RegisterCubit(this._authRepo) : super(RegisterInitial());

  Future<void> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());

    final result = await _authRepo.register(
      fullName: fullName,
      phone: phone,
      email: email,
      password: password,
    );

    if (result['success'] == true) {
      final token = result['token'] as String?;
      final user = result['user'] as UserModel?;
      
      // Save token if available
      if (token != null) {
        await CacheHelper.saveToken(token);
        DioHelper.setAuthToken(token);
      }

      currentUser = user;
      emit(RegisterSuccess(user: user, message: result['message']));
    } else {
      emit(RegisterFailure(result['message']));
    }
  }
}
