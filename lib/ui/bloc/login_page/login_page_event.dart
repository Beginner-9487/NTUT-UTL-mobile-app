import 'package:equatable/equatable.dart';

abstract class LoginPageEvent extends Equatable {
  const LoginPageEvent();

  @override
  List<Object?> get props => [];
}

class LoginPageEventRefresh extends LoginPageEvent {
  @override
  String toString() {
    return 'LoginPageEventRefresh';
  }
}

class LoginPageEventLogin extends LoginPageEvent {
  String account;
  String password;

  LoginPageEventLogin(this.account, this.password);

  @override
  List<Object?> get props => [account, password];

  @override
  String toString() {
    return 'LoginPageEventLogin';
  }
}

class LoginPageEventLoginAsGuest extends LoginPageEvent {
  @override
  String toString() {
    return 'LoginPageEventLoginAsGuest';
  }
}

class LoginPageEventSetWantedRememberAccount extends LoginPageEvent {
  bool state;

  LoginPageEventSetWantedRememberAccount(this.state);

  @override
  List<Object?> get props => [state];

  @override
  String toString() {
    return 'LoginPageEventSetWantedRememberAccount: $state';
  }
}

class LoginPageEventSetWantedLoginAutomatically extends LoginPageEvent {
  bool state;

  LoginPageEventSetWantedLoginAutomatically(this.state);

  @override
  List<Object?> get props => [state];

  @override
  String toString() {
    return 'LoginPageEventSetWantedLoginAutomatically: $state';
  }
}