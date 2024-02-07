import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ntut_utl_mobile_app/repository/login_page/login_page_data_interface.dart';
import 'package:ntut_utl_mobile_app/repository/user/data/user_data_service_interface.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import 'user_info_event.dart';
import 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  bool get isLoggedIn => userDataService.isLoggedIn;
  String get username => userDataService.username;
  Widget userAvatar(double size) {
    return userDataService.avatar(size);
  }

  UserDataService get userDataService => ProjectParameters.userDataService;
  LoginPageData get localDataLoginPage => ProjectParameters.loginPageData;

  UserInfoBloc() : super(initialState) {
    on<UserInfoEventInit>((event, emit) {
      mapEventToState(event).first;
    });
    on<UserInfoEventRefresh>((event, emit) {
      mapEventToState(event).first;
    });
  }

  @override
  static UserInfoState get initialState => UserInfoStateInit();

  @override
  Stream<UserInfoState> mapEventToState(UserInfoEvent event) async* {
    print("UserBloc: mapEventToState: $event");
    if (event is UserInfoEventInit) {
      yield* _mapUserEventInitToState();
    } else if (event is UserInfoEventRefresh) {
      yield* _mapUserEventRefreshToState();
    }
  }

  _refreshUI() {
    emit(UserInfoStateRefreshing());
    emit(UserInfoStateInit());
  }

  Stream<UserInfoState>  _mapUserEventInitToState() async* {
    if(await localDataLoginPage.wantedToLoginAutomatically) {
      if(!await userDataService.loginAutomatically()) {
        emit(UserInfoStateError("Login failed."));
      }
    }
    _refreshUI();
  }

  Stream<UserInfoState>  _mapUserEventRefreshToState() async* {
    _refreshUI();
  }
}
