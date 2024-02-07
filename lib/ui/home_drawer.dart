import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/res/app_images.dart';
import 'package:ntut_utl_mobile_app/res/app_theme.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/user_info/user_info_bloc.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {super.key,
        this.screenIndex,
        this.iconAnimationController,
        this.callBackIndex,
        this.callBackLog
      });

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;
  final Function()? callBackLog;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> with StatefulWithResStrings {
  UserInfoBloc homeBloc = UserInfoBloc();

  String get username => homeBloc.username;
  bool get isLoggedIn => homeBloc.isLoggedIn;
  Widget get userAvatar => homeBloc.userAvatar(120);

  List<DrawerList>? drawerList;
  @override
  void initState() {
    super.initState();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: str.home,
        icon: const Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: str.help,
        isAssetsImage: true,
        imageName: AppImage.png_help,
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: str.feedBack,
        icon: const Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: str.inviteFriend,
        icon: const Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.Share,
        labelName: str.rateTheApp,
        icon: const Icon(Icons.share),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: str.aboutUs,
        icon: const Icon(Icons.info),
      ),
      DrawerList(
        index: DrawerIndex.Settings,
        labelName: str.settings,
        icon: const Icon(Icons.settings),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    setDrawerListArray();
    return Scaffold(
      backgroundColor: AppTheme.colorHomeDrawerBackground(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          userInfoView(),
          const SizedBox(
            height: 4,
          ),
          AppTheme.divider(context),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index]);
              },
            ),
          ),
          AppTheme.divider(context),
          Column(
            children: logButton(),
          ),
        ],
      ),
    );
  }

  Widget userInfoView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AnimatedBuilder(
              animation: widget.iconAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return ScaleTransition(
                  scale: AlwaysStoppedAnimation<double>(1.0 -
                      (widget.iconAnimationController!.value) * 0.2),
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation<double>(Tween<double>(
                        begin: 0.0, end: 24.0)
                        .animate(CurvedAnimation(
                        parent: widget.iconAnimationController!,
                        curve: Curves.fastOutSlowIn))
                        .value /
                        360),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey.withOpacity(0.6),
                              offset: const Offset(2.0, 4.0),
                              blurRadius: 8),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(60.0)),
                        child: userAvatar,
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                username,
                style: AppTheme.textStyleHomeDrawerUsername(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onLogButtonTapped() {
    widget.callBackLog!();
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationToScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                    width: 24,
                    height: 24,
                    child: Image.asset(listData.imageName,
                        color: widget.screenIndex == listData.index
                            ? Colors.blue
                            : AppTheme.nearlyBlack),
                  )
                      : Icon(listData.icon?.icon,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.black
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
              animation: widget.iconAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  transform: Matrix4.translationValues(
                      (MediaQuery.of(context).size.width * 0.75 - 64) *
                          (1.0 -
                              widget.iconAnimationController!.value -
                              1.0),
                      0.0,
                      0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      width:
                      MediaQuery.of(context).size.width * 0.75 - 64,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(28),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationToScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }

  List<Widget> logButton() {
    if(isLoggedIn) {
      return <Widget>[
        ListTile(
          title: Text(
            str.logout,
            style: const TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppTheme.darkText,
            ),
            textAlign: TextAlign.left,
          ),
          trailing: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          onTap: () {
            onLogButtonTapped();
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom,
        )
      ];
    } else {
      return <Widget>[
        ListTile(
          title: Text(
            str.login,
            style: const TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppTheme.darkText,
            ),
            textAlign: TextAlign.left,
          ),
          trailing: const Icon(
            Icons.login,
            color: Colors.blue,
          ),
          onTap: () {
            onLogButtonTapped();
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom,
        )
      ];
    }

  }
}

enum DrawerIndex {
  HOME,
  FeedBack,
  Help,
  Share,
  About,
  Invite,
  Testing,
  Settings,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
}