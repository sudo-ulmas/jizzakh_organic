import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:uboyniy_cex/repository/repository.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends HydratedBloc<LoginEvent, LoginState> {
  LoginBloc({required AuthRepository authRepository})
      : _repository = authRepository,
        super(const LoginState.initial(username: '')) {
    on<_LoginButtonPressed>(_login);
  }

  final AuthRepository _repository;

  Future<void> _login(
    _LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginState.inProgress(username: event.username));
      await _repository.login(
        username: event.username,
        password: event.password,
      );
      emit(LoginState.success(username: event.username));
    } catch (e) {
      emit(LoginState.error(username: event.username));
    }
  }

  @override
  LoginState? fromJson(Map<String, dynamic> json) {
    return LoginState.initial(username: json['username'] as String);
  }

  @override
  Map<String, dynamic>? toJson(LoginState state) {
    if (state is LoginSuccess) {
      return {'username': state.username};
    } else {
      return null;
    }
  }
}
