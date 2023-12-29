import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/repository/my_user_repository.dart';
import 'package:ntut_utl_mobile_app/res/colors.dart';

class SplashPageLoading extends StatefulWidget {
  @override
  _SplashPageLoadingState createState() => _SplashPageLoadingState();
}

class _SplashPageLoadingState extends State<SplashPageLoading> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Your code to run after the build is complete
      MyUserRepository.force_to_logged_in(context);
    });
    return const Scaffold(
      body: Center(
        child: Text(
          true ? "Login.." : "No data for login",
          style: TextStyle(color: WColors.warning_red),
        ),
      ),
    );
  }
}