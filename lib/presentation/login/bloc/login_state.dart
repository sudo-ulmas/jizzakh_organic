part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = LoginInitial;

  const factory LoginState.inProgress() = LoginInProgress;

  const factory LoginState.error() = LoginError;

  const factory LoginState.success() = LoginSuccess;
}
