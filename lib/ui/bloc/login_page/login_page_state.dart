import 'package:equatable/equatable.dart';

abstract class LoginPageState extends Equatable {
  const LoginPageState();

  @override
  List<Object?> get props => [];
}

class LoginPageStateInit extends LoginPageState {
  @override
  String toString() {
    return 'LoginPageStateInit';
  }
}

class LoginPageStateRefreshing extends LoginPageState {
  @override
  String toString() {
    return 'LoginPageStateRefreshing';
  }
}