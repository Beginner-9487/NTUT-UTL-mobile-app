import 'package:equatable/equatable.dart';

import '../../../../entity/user_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  @override
  String toString() {
    return 'HomeLoading';
  }
}

/// 主页基础数据已加载完成的state，主页内的所有子页需等待主页基础数据完成后再加载各自的数据，即有依赖关系。
/// 如果后面还想做如"检测升级"等逻辑，由于子页面没必要依赖"检测升级"，
/// 所以主页到时候的状态顺序应当类似这样：加载子页需要依赖的数据（如登录状态）-> 发送HomeLoaded -> 静默加载子页不依赖的数据（如检测升级）-> 发送类似如HomeBackgroundTaskLoaded的state。
/// 而不应该是这样：加载子页需要依赖的数据（如登录状态）同时加载子页不依赖的数据（如检测升级）-> 发送HomeLoaded
class HomePageLoaded extends HomeState {
  bool isLogin;
  String? userAccount;

  HomePageLoaded(this.isLogin, [this.userAccount]);

  @override
  List<Object?> get props => [isLogin, userAccount];

  @override
  String toString() {
    return 'HomeLoaded{isLogin: $isLogin, userAccount: $userAccount}';
  }
}

class HomeLoadError extends HomeState {
  Object exception;

  HomeLoadError(this.exception);

  @override
  List<Object?> get props => [exception];

  @override
  String toString() {
    return 'HomeLoadError';
  }
}

class HomeUserEntityLoaded extends HomeState {
  UserEntity? userEntity;

  HomeUserEntityLoaded(this.userEntity);

  @override
  List<Object?> get props => [userEntity];

  @override
  String toString() {
    return 'HomeUserLoaded{userEntity: $userEntity}';
  }
}
