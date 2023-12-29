import 'package:equatable/equatable.dart';

import '../../../../entity/user_entity.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHome extends HomeEvent {
  @override
  String toString() {
    return 'LoadHome';
  }
}

class LogoutHome extends HomeEvent {
  @override
  String toString() {
    return 'LogoutHome';
  }
}

class LoadUserInfo extends HomeEvent {
  String? accessToken;

  LoadUserInfo(this.accessToken);

  @override
  List<Object?> get props => [accessToken];

  @override
  String toString() {
    return 'LoadUserInfo{accessToken: $accessToken}';
  }
}

class UpdateUserInfo extends HomeEvent{
  UserEntity userEntity;

  UpdateUserInfo(this.userEntity);

  @override
  List<Object?> get props => [userEntity];

  @override
  String toString() {
    return 'UpdateUserInfo{userEntity: $userEntity}';
  }
}