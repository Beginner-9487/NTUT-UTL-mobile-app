import 'package:bloc/bloc.dart';

import 'line_chart_state.dart';
import 'line_chart_event.dart';

class LineChartBloc extends Bloc<LineChartEvent, LineChartState> {
  bool alreadyHomeLoaded = false;

  LineChartBloc() : super(initialState) {
    // on<LoadHome>((event, emit) {
    //   mapEventToState(event).first;
    // });
    // on<LogoutHome>((event, emit) {
    //   mapEventToState(event).first;
    // });
    // on<UpdateUserInfo>((event, emit) {
    //   mapEventToState(event).first;
    // });
  }

  @override
  static InitLineChartState get initialState => InitLineChartState();

  @override
  Stream<LineChartState> mapEventToState(LineChartEvent event) async* {
    print("LineChartBloc: mapEventToState: $event");
    // if (event is LoadHome) {
    //   yield* _mapLoadHomeToState();
    // } else if (event is LogoutHome) {
    //   yield* _mapLogoutHomeToState();
    // } else if (event is LoadUserInfo) {
    //   yield* _mapLoadUserInfoToState();
    // } else if (event is UpdateUserInfo) {
    //   yield* _mapUpdateUserInfoToState(event.userEntity);
    // }
  }
}
