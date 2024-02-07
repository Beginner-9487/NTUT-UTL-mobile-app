import 'package:bloc/bloc.dart';
import 'package:ntut_utl_mobile_app/repository/login_page/login_page_data_interface.dart';
import 'package:ntut_utl_mobile_app/repository/user/data/user_data_service_interface.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/login_page/login_page_event.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/login_page/login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginPageData get localDataLoginPage => ProjectParameters.loginPageData;
  UserDataService get userDataService => ProjectParameters.userDataService;

  setWantedToRememberAccount(value) {
    localDataLoginPage.setWantedToRememberAccount(value);
  }
  Future<bool> get getInitWantedToRememberAccount async => localDataLoginPage.wantedToRememberAccount;
  Future<String> getInitAccountText() async {
    return localDataLoginPage.autoEnterAccount();
  }

  Future<bool> get getInitWantedToLoginAutomatically async => localDataLoginPage.wantedToLoginAutomatically;
  setWantedToLoginAutomatically(value) {
    localDataLoginPage.setWantedToLoginAutomatically(value);
  }

  LoginPageBloc() : super(initialState) {
    on<LoginPageEventRefresh>((event, emit) {
      mapEventToState(event).first;
    });
    on<LoginPageEventLogin>((event, emit) {
      mapEventToState(event).first;
    });
    on<LoginPageEventSetWantedRememberAccount>((event, emit) {
      mapEventToState(event).first;
    });
    on<LoginPageEventSetWantedLoginAutomatically>((event, emit) {
      mapEventToState(event).first;
    });
  }

  @override
  static LoginPageState get initialState => LoginPageStateInit();

  @override
  Stream<LoginPageState> mapEventToState(LoginPageEvent event) async* {
    print("LoginPageBloc: mapEventToState: $event");
    if (event is LoginPageEventRefresh) {
      yield* _mapRefreshToState();
    } else if (event is LoginPageEventLogin) {
      yield* _mapLoginToState(event);
    } else if (event is LoginPageEventLoginAsGuest) {
      yield* _mapLoginAsGuestToState();
    } else if (event is LoginPageEventSetWantedRememberAccount) {
      yield* _mapWantRememberAccountToState(event);
    } else if (event is LoginPageEventSetWantedLoginAutomatically) {
      yield* _mapWantLoginAutomaticallyToState(event);
    }
  }

  _refreshUI() {
    emit(LoginPageStateRefreshing());
    emit(LoginPageStateInit());
  }

  Stream<LoginPageState> _mapRefreshToState() async* {
    _refreshUI();
  }
  Stream<LoginPageState> _mapLoginToState(LoginPageEventLogin event) async* {
    userDataService.login(event.account, event.password);
    _refreshUI();
  }
  Stream<LoginPageState> _mapLoginAsGuestToState() async* {
    userDataService.loginAsGuest();
    _refreshUI();
  }
  Stream<LoginPageState> _mapWantRememberAccountToState(LoginPageEventSetWantedRememberAccount event) async* {
    localDataLoginPage.setWantedToRememberAccount(event.state);
  }
  Stream<LoginPageState> _mapWantLoginAutomaticallyToState(LoginPageEventSetWantedLoginAutomatically event) async* {
    localDataLoginPage.setWantedToRememberAccount(event.state);
  }
}
