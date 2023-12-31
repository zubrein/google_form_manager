part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccessState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LogoutState extends LoginState {
  @override
  List<Object?> get props => [];
}
