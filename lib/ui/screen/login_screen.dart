import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/res/app_images.dart';
import 'package:ntut_utl_mobile_app/res/app_theme.dart';
import 'package:ntut_utl_mobile_app/res/app_colors.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/login_page/login_page_bloc.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/login_page/login_page_event.dart';

import '../../res/project_parameters.dart';
import '../../utils/screen_utils.dart';

enum LoginMode {
  LOGIN,
  REGIST,
}

class LoginModeNotification extends Notification {
  final LoginMode mode;
  LoginModeNotification(this.mode);
}

class LoginScreen extends StatefulWidget {
  static const String ROUTER_NAME = "/LoginPage";

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin, StatefulWithResStrings {
  LoginPageBloc loginPageBloc = LoginPageBloc();

  late LoginMode mode;
  late AnimationController animationController;
  late CurvedAnimation curvedAnimation;

  @override
  void initState() {
    super.initState();
    mode = LoginMode.LOGIN;
    animationController = AnimationController(vsync: this,duration: const Duration(seconds: 1));
    curvedAnimation = CurvedAnimation(parent: animationController, curve: Curves.elasticOut);
    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.theme_color_dark,
        elevation: 0,
        centerTitle: true,
        title: Text(mode == LoginMode.LOGIN ? str.login : str.register),
      ),
      body: NotificationListener<LoginModeNotification>(
        onNotification: (notification) {
          setState(() {
            mode = notification.mode;
          });
          return true;
        },
        child: login_back_ground(),
      ),
    );
  }

  Container login_back_ground() {
    return Container(
      color: AppColors.gray_background,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              height: pt(200),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.theme_color_dark,
                    AppColors.theme_color,
                    AppColors.theme_color_light
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: pt(50),
              child: Image.asset(
                AppImage.gif_signboard,
                width: ScreenUtils().screenWidth,
              ),
            ),
            ScaleTransition(
              scale: curvedAnimation,
              child: Container(
                margin: EdgeInsets.only(top: pt(170)),
                child: LoginCard(
                  mode: mode,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginCard extends StatefulWidget {
  bool isLogging;
  LoginMode mode;

  LoginCard({
    super.key,
    this.isLogging = false,
    this.mode = LoginMode.LOGIN,
  });

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> with StatefulWithResStrings {
  late TextEditingController userController;
  late TextEditingController pwdController;
  late TextEditingController pwdAgainController;
  late FocusNode pwdFocus;
  late FocusNode pwdAgainFocus;

  LoginPageBloc loginPageBloc = LoginPageBloc();

  @override
  void initState() {
    super.initState();
    userController = TextEditingController();
    pwdController = TextEditingController();
    pwdAgainController = TextEditingController();
    pwdFocus = FocusNode();
    pwdAgainFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shadows: <BoxShadow>[
          AppTheme.lightElevation(),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(1),
            bottomRight: Radius.circular(1),
            topRight: Radius.elliptical(25, 25),
            bottomLeft: Radius.elliptical(25, 25),
          ),
        ),
      ),
      child: Container(
          width: pt(310),
          padding: EdgeInsets.all(
            pt(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              row_account(),
              SizedBox(
                height: pt(20),
              ),
              row_password(),
              animatedContainer_check_password_again(),
              SizedBox(
                height: pt(30),
              ),
              container_login_or_register_button(),
              SizedBox(
                height: pt(15),
              ),
              row_others(),
            ],
          )),
    );
  }

  Row row_account() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: pt(16)),
          child: const Icon(
            Icons.account_circle,
            color: AppColors.theme_color,
          ),
        ),
        Expanded(
          child: TextField(
            onSubmitted: (String str) {
              FocusScope.of(context).requestFocus(pwdFocus);
            },
            textInputAction: TextInputAction.next,
            controller: userController,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
            ),
            decoration: InputDecoration(
              hintText: str.account,
              hintStyle: const TextStyle(
                fontSize: 16,
                color: AppColors.hint_color,
              ),
              contentPadding: EdgeInsets.only(
                top: pt(10),
                bottom: pt(4),
              ),
            ),
          ),
        )
      ],
    );
  }

  Row row_password() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: pt(16)),
          child: const Icon(
            Icons.lock,
            color: AppColors.theme_color,
          ),
        ),
        Expanded(
          child: TextField(
            obscureText: true,
            onSubmitted: (String str) {
              if (widget.mode == LoginMode.REGIST) {
                FocusScope.of(context).requestFocus(pwdAgainFocus);
              }
            },
            textInputAction: widget.mode == LoginMode.LOGIN
                ? TextInputAction.done
                : TextInputAction.next,
            focusNode: pwdFocus,
            controller: pwdController,
            style: TextStyle(
                fontSize: pt(22), fontWeight: FontWeight.w300),
            decoration: InputDecoration(
              hintText: str.password,
              hintStyle: const TextStyle(
                fontSize: 16,
                color: AppColors.hint_color,
              ),
              contentPadding: EdgeInsets.only(
                top: pt(10),
                bottom: pt(4),
              ),
            ),
          ),
        )
      ],
    );
  }

  AnimatedContainer animatedContainer_check_password_again() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(
          top: widget.mode == LoginMode.LOGIN ? 0 : pt(20)),
      child: Offstage(
        offstage: widget.mode != LoginMode.REGIST,
        child: Padding(
          padding: EdgeInsets.only(
            top: pt(0),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: pt(16)),
                child: const Icon(
                  Icons.lock,
                  color: AppColors.theme_color,
                ),
              ),
              Expanded(
                child: TextField(
                  obscureText: true,
                  focusNode: pwdAgainFocus,
                  controller: pwdAgainController,
                  style: TextStyle(
                      fontSize: pt(22), fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                    hintText: str.retypePassword,
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      color: AppColors.hint_color,
                    ),
                    contentPadding: EdgeInsets.only(
                      top: pt(10),
                      bottom: pt(4),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container container_login_or_register_button() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
      child: ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.resolveWith<double>((Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return 10.0;
              }
              return 1.0;
            }),
            textStyle: MaterialStateProperty.resolveWith<TextStyle>((Set<MaterialState> states) {
              return const TextStyle(color: Colors.white);
            }),
            backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              return AppColors.theme_color;
            }),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((Set<MaterialState> states) {
              return const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(1),
                    topRight: Radius.elliptical(14, 14),
                    bottomLeft: Radius.elliptical(14, 14),
                    bottomRight: Radius.circular(1)),
              );
            }),
          ),
          onPressed: widget.isLogging
              ? null
              : () {
            if (widget.mode == LoginMode.LOGIN) {
              login(userController.text, pwdController.text);
            } else {
              register_and_login(userController.text, pwdController.text,
                  pwdAgainController.text);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: pt(8)),
            child: widget.isLogging
                ? const CupertinoActivityIndicator()
                : Text(
              widget.mode == LoginMode.LOGIN
                  ? str.login
                  : str.register,
              style: const TextStyle(fontSize: 18),
            ),
          )),
    );
  }

  Row row_others() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        container_login_as_guest(),
        container_login_or_register_switch_button()
      ]
    );
  }

  ButtonStyle? buttonStyle_others() {
    // return ButtonStyle(
    //     backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
    //       return WColors.gray_background;
    //     }),
    //     shape: MaterialStateProperty.resolveWith<OutlinedBorder>((Set<MaterialState> states) {
    //       return const RoundedRectangleBorder(
    //         borderRadius: BorderRadius.only(
    //             topLeft: Radius.elliptical(14, 14),
    //             topRight: Radius.elliptical(14, 14),
    //             bottomLeft: Radius.elliptical(14, 14),
    //             bottomRight: Radius.elliptical(14, 14)
    //         ),
    //       );
    //     }),
    // );
    return null;
  }

  Container container_login_as_guest() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pt(4)),
      child: ElevatedButton(
          style: buttonStyle_others(),
          child: Text(
            str.loginAsGuest,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          onPressed: () {
            login_as_guest();
          }),
    );
  }

  Container container_login_or_register_switch_button() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pt(4)),
      child: ElevatedButton(
          style: buttonStyle_others(),
          child: Text(
            widget.mode == LoginMode.LOGIN ? str.register : str.login,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          onPressed: () {
            if (widget.isLogging) {
              return;
            }
            LoginModeNotification(widget.mode == LoginMode.LOGIN
                ? LoginMode.REGIST
                : LoginMode.LOGIN)
                .dispatch(context);
          }),
    );
  }

  Future<bool> login(String account, String password) async {
    setState(() {
      widget.isLogging = true;
    });

    try {
      loginPageBloc.add(LoginPageEventLogin(account, password));
      print('_LoginCardState : login success');
      go_to_defalut_page();
      return true;
    } catch (e) {
      AppTheme.showMsg(context, exception: e as Exception);
    }

    setState(() {
      widget.isLogging = false;
    });

    return false;
  }

  Future register_and_login(String account, String password, String retypePassword) async {
    return false;
  }

  Future login_as_guest() async {
    loginPageBloc.add(LoginPageEventLoginAsGuest());
    print('_LoginCardState : login as guest success');
    go_to_defalut_page();
    return true;
  }

  void go_to_defalut_page() {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    if(parentRoute?.canPop ?? false) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.pushReplacementNamed(context, ProjectParameters.stringDefaultPageName)
          .then((_) {
      });
    }
  }
}
