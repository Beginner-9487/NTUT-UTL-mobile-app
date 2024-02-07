import 'package:equatable/equatable.dart';

abstract class UserInfoEvent extends Equatable {
  const UserInfoEvent();

  @override
  List<Object?> get props => [];
}

class UserInfoEventInit extends UserInfoEvent {
  @override
  String toString() {
    return 'UserInfoEventInit';
  }
}

class UserInfoEventRefresh extends UserInfoEvent {
  @override
  String toString() {
    return 'UserInfoEventRefresh';
  }
}