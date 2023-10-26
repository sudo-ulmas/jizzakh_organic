import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/repository/repository.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthRepository authRepository})
      : _repository = authRepository,
        super(const LoginState.initial()) {
    on<_LoginButtonPressed>(_login);
  }

  final AuthRepository _repository;

  Future<void> _login(
    _LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(const LoginState.inProgress());
      await _repository.login(
        username: event.username,
        password: event.password,
      );
      emit(const LoginState.success());
    } catch (e) {
      emit(const LoginState.error());
    }
  }
}
