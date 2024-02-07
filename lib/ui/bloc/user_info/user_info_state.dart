import 'package:equatable/equatable.dart';

abstract class UserInfoState extends Equatable {
  const UserInfoState();

  @override
  List<Object?> get props => [];
}

class UserInfoStateError extends UserInfoState {
  String exception;

  UserInfoStateError(this.exception);

  @override
  List<String?> get props => [exception];

  @override
  String toString() {
    return 'UserInfoStateError: $exception';
  }
}

class UserInfoStateInit extends UserInfoState {
  @override
  String toString() {
    return 'UserInfoStateInit';
  }
}

class UserInfoStateRefreshing extends UserInfoState {
  @override
  String toString() {
    return 'UserInfoStateRefreshing';
  }
}