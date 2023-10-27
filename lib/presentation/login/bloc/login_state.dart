part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial({required String username}) = LoginInitial;

  const factory LoginState.inProgress({required String username}) =
      LoginInProgress;

  const factory LoginState.error({required String username}) = LoginError;

  const factory LoginState.success({required String username}) = LoginSuccess;
}
