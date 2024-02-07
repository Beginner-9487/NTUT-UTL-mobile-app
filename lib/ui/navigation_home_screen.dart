import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/res/app_theme.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:ntut_utl_mobile_app/ui/drawer_user_controller.dart';
import 'package:ntut_utl_mobile_app/ui/home_drawer.dart';
import 'package:ntut_utl_mobile_app/ui/screen/home_screen.dart';
import 'package:ntut_utl_mobile_app/ui/screen/login_screen.dart';
import 'package:ntut_utl_mobile_app/ui/screen/setting_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  const NavigationHomeScreen({super.key});

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = ProjectParameters.widgetDefaultPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colorNavigationHomeScreen(context),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.colorNavigationHomeScreenBackground(context),
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexData) {
              changeIndex(drawerIndexData);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
            onEndButtonTapped: () {
                onLogTapped();
            },
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexData) {
    if (drawerIndex != drawerIndexData) {
      drawerIndex = drawerIndexData;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const HomeScreen();
          });
          break;
        case DrawerIndex.Settings:
          setState(() {
            screenView = SettingsScreen();
          });
          break;
        // case DrawerIndex.Help:
        //   setState(() {
        //     screenView = HelpScreen();
        //   });
        //   break;
        // case DrawerIndex.FeedBack:
        //   setState(() {
        //     screenView = FeedbackScreen();
        //   });
        //   break;
        // case DrawerIndex.Invite:
        //   setState(() {
        //     screenView = InviteFriend();
        //   });
        //   break;
        default:
          break;
      }
    }
  }

  void onLogTapped() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
        settings: const RouteSettings(name: '/LoginScreen'),
      ),
    );
  }
}
