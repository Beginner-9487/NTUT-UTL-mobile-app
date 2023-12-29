import 'package:bloc/bloc.dart';
import 'package:ntut_utl_mobile_app/repository/my_user_repository.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import '../../../../entity/user_entity.dart';
import '../../../../res/api.dart';
import '../../../../utils/shared_preference_util.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  bool alreadyHomeLoaded = false;

  HomeBloc() : super(initialState) {
    on<LoadHome>((event, emit) {
      mapEventToState(event).first;
    });
    on<LogoutHome>((event, emit) {
      mapEventToState(event).first;
    });
    on<UpdateUserInfo>((event, emit) {
      mapEventToState(event).first;
    });
  }

  @override
  static HomeState get initialState => HomeLoading();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    print("HomeBloc: mapEventToState: $event");
    if (event is LoadHome) {
      yield* _mapLoadHomeToState();
    } else if (event is LogoutHome) {
      yield* _mapLogoutHomeToState();
    } else if (event is LoadUserInfo) {
      yield* _mapLoadUserInfoToState();
    } else if (event is UpdateUserInfo) {
      yield* _mapUpdateUserInfoToState(event.userEntity);
    }
  }

  void _homeLoadingInit() {
    alreadyHomeLoaded = false;
    emit(HomeLoading());
  }

  void _homeLoadingEnd() {
    alreadyHomeLoaded = true;
  }

  Stream<HomeState> _mapLoadHomeToState() async* {
    try {
      _homeLoadingInit();
      _homeLoadingEnd();
      add(LoadUserInfo(MyUserRepository.getToken()));
    } catch (e) {
      emit(HomeLoadError(e));
    }
  }

  Stream<HomeState> _mapLogoutHomeToState() async* {
    try {
      _homeLoadingInit();
      await AccountApi.logout();
      await SharedPreferencesUtil.setWantToStayLoggedIn(false);
      _homeLoadingEnd();
      emit(HomeUserEntityLoaded(UserEntity.getGuestUserEntity()));
      add(LoadHome());
    } catch (e) {
      emit(HomeLoadError(e));
    }
  }

  Stream<HomeState> _mapLoadUserInfoToState() async* {
    // emit(HomePageLoaded(isLogin, "123"));
    emit(HomeUserEntityLoaded(UserEntity("aa", "bb", "cc", "")));
    // MyGlobalRepository.currentUserEntity.username = "AA";
  }

  Stream<HomeState> _mapUpdateUserInfoToState(UserEntity entity) async* {
    try {
      _homeLoadingInit();
      // BmobUpdated updated = await entity.update();
      // entity.updatedAt = updated.updatedAt;
      emit(HomeUserEntityLoaded(entity));
      _homeLoadingEnd();
    } catch (e) {
      print('HomeBloc._mapUpdateBmobInfoToState  $e');
      emit(HomeLoadError(e));
    }
  }
}
