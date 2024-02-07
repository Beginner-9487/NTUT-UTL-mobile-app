import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntut_utl_mobile_app/res/app_theme.dart';
import 'package:ntut_utl_mobile_app/res/app_colors.dart';
import 'package:ntut_utl_mobile_app/res/experiment_parameters.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/bluetooth/bluetooth_switch/bluetooth_switch_bloc.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/bluetooth/bluetooth_switch/bluetooth_switch_event.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/bluetooth/bluetooth_switch/bluetooth_switch_state.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/bluetooth/manager/bluetooth_manager_bloc.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/bluetooth/manager/bluetooth_manager_state.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/experiment/experiment_bloc.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/experiment/experiment_event.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/experiment/experiment_state.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/line_chart/mackay_irb/line_chart_bloc_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/line_chart/mackay_irb/line_chart_state_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/user_info/user_info_bloc.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/user_info/user_info_event.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/user_info/user_info_state.dart';
import 'package:ntut_utl_mobile_app/ui/view/bluetooth_off_screen.dart';
import 'package:ntut_utl_mobile_app/ui/view/line_chart_dashboard_view_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/ui/view/line_chart_view_foot_imu_test.dart';
import 'package:ntut_utl_mobile_app/ui/view/line_chart_view_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/ui/view/scan_bluetooth_devices_view_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/ui/view/scan_bluetooth_devices_view_test_fbp.dart';
import 'package:ntut_utl_mobile_app/utils/screen_utils.dart';

class HomeScreen extends StatefulWidget {
  static get ROUTER_NAME => '/HomePage';

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, StatefulWithResStrings {
  late BuildContext innerContext;
  UserInfoBloc userInfoBloc = UserInfoBloc();
  ExperimentBloc experimentBloc = ExperimentBloc();
  BluetoothSwitchBloc bluetoothSwitchBloc = BluetoothSwitchBloc();
  BluetoothManagerBloc bluetoothManagerBloc = BluetoothManagerBloc();
  LineChartBlocMackayIrb lineChartBlocMackayIrb = LineChartBlocMackayIrb();

  static double heightScreen(BuildContext context) {
    return MediaQuery.of(context).size.height - heightHeaderTab;
  }
  static double get heightHeaderTab => 65;
  static double get horizontalMarginHeaderTab => 12;
  static double get heightUserAvatar => 40;
  static double heightView1(BuildContext context) => (heightScreen(context) / 2) - 2 * heightUserAvatar;

  int get mode => experimentBloc.mode;
  String get username => userInfoBloc.username;
  Widget get userAvatar => userInfoBloc.userAvatar(heightUserAvatar);
  bool get isBluetoothOn => bluetoothSwitchBloc.isBluetoothOn;

  Map<Icon, Widget> get tabsView2 => {
    const Icon(Icons.bluetooth_searching_rounded):
      BlocBuilder<BluetoothManagerBloc, BluetoothManagerState>(
        bloc: bluetoothManagerBloc,
        builder: (context, redState) {
          return ScanBluetoothDevicesViewMackayIrb(ProjectParameters.bluetoothScanMackay);
        }
      ),
    const Icon(Icons.add_chart):
      BlocBuilder<LineChartBlocMackayIrb, LineChartStateMackayIrb>(
        bloc: lineChartBlocMackayIrb,
          builder: (context, redState) {
            return LineChartDashboardViewMackayIrb(ProjectParameters.lineChartDashboardViewKeyMackayIrb);
          }
      ),
    const Icon(Icons.bluetooth_searching_rounded):
      ScanBluetoothDevicesViewTestFBP(ProjectParameters.bluetoothScanTestViewKey),
  };
  late TabController _tabView2Controller;

  @override
  void initState() {
    super.initState();
    experimentBloc.add(ExperimentEventInit());
    userInfoBloc.add(UserInfoEventInit());
    bluetoothSwitchBloc.add(BluetoothSwitchEventInit());
  }

  @override
  Widget build(BuildContext context) {
    _tabView2Controller = TabController(length: tabsView2.length, vsync: this);
    return Expanded(
      child: BlocBuilder<UserInfoBloc, UserInfoState>(
        bloc: userInfoBloc,
        builder: (context, state) {
          return BlocBuilder<ExperimentBloc, ExperimentState>(
            bloc: experimentBloc,
            builder: (context, state) {
              return BlocBuilder<BluetoothSwitchBloc, BluetoothSwitchState>(
                bloc: bluetoothSwitchBloc,
                builder: (context, state) {
                  return fullScreen;
              });
          });
        }
      ),
    );
  }

  Widget get fullScreen => Scaffold(
    backgroundColor: AppTheme.colorHeader(context),
    body: SafeArea(
        child: Column(children: <Widget>[
          Container(
            color: AppTheme.colorHeader(context),
            height: heightHeaderTab,
            // Also Including Tab-bar height.
            child: appBarHeader(),
          ),
          AppTheme.divider(context),
          Expanded(
            child: screenView,
          ),
        ])
    ),
  );

  Widget get screenView {
    debugPrint("screenView: ${experimentBloc.mode}");
    switch (experimentBloc.mode) {
      case ExperimentMode.MackayIRB:
        return screenViewMackayIrb;
      case ExperimentMode.Foot:
        return screenViewFoot;
    }
    return const Scaffold();
  }

  Widget get screenViewMackayIrb =>
      (!isBluetoothOn) ? const BluetoothOffView() :
      Scaffold(
        body: SafeArea(
          child: Column(children: <Widget>[
            BlocBuilder<LineChartBlocMackayIrb, LineChartStateMackayIrb>(
              bloc: lineChartBlocMackayIrb,
              builder: (context, state) {
                return Container(
                  color: AppTheme.colorHeader(context),
                  height: heightView1(context),  // Also Including Tab-bar height.
                  child: LineChartViewMackayIrb(ProjectParameters.lineChartViewKeyMackayIrb),
                );
              }),
            AppTheme.divider(context),
            appBarTab(_tabView2Controller, tabsView2),
            BlocBuilder<LineChartBlocMackayIrb, LineChartStateMackayIrb>(
              bloc: lineChartBlocMackayIrb,
              builder: (context, state) {
                return Expanded(
                  child: TabBarView(
                    controller: _tabView2Controller,
                    children: tabsView2.values
                        .map((page) => page)
                        .toList(),
                  ),
                );
              }),
          ])
        )
      );

  Widget get screenViewFoot => LineChartViewFootImu(ProjectParameters.lineChartViewKeyFoot);

  Decoration _themeGradientDecoration() {
    return const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.theme_color,
            AppColors.theme_color_light,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ));
  }

  Widget appBarHeader() {
    return Container(
      height: pt(60),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            username,
            style: AppTheme.textStyleHeader(context),
          ),
          GestureDetector(
            // onTap: () {
            //   Scaffold.of(innerContext).openDrawer();
            // },
            child: Container(
              width: pt(heightUserAvatar),
              height: pt(heightUserAvatar),
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: pt(horizontalMarginHeaderTab)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(pt(heightUserAvatar / 2)),
                child: userAvatar,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appBarTab(TabController tabController, Map<Icon, Widget> tabs) {
    return TabBar(
      isScrollable: false,
      controller: tabController,
      tabs: tabs.keys.map((title) {
        return Tab(
          icon: title,
        );
      }).toList(),
    );
  }
}
