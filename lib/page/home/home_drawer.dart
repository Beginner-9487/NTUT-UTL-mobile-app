import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntut_utl_mobile_app/entity/user_entity.dart';
import 'package:ntut_utl_mobile_app/repository/my_user_repository.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import '../../../http/index.dart';
import '../../../res/my_images.dart';
import '../../../res/strings/strings.dart';
import '../../../utils/screen_utils.dart';
import '../account/login_page.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

///主页侧滑菜单
class HomeDrawer extends StatefulWidget {
  bool get isLogin => MyUserRepository.isLoggedIn;
  UserEntity get userEntity => MyUserRepository.currentUserEntity;

  HomeDrawer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> with StateWithResStrings {
  late HomeBloc homeBloc;
  bool hasSignIn = false;

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {
        // 这里监听状态并赋值属性不合适。因为侧滑菜单在直到第一次展开时才被初始化。此时监听为时已晚
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        bloc: homeBloc,
        builder: (context, state) {
          return Column(
            children: <Widget>[
              Container(
                height: pt(200),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(MyImage.jpeg_drawer_background),
                        fit: BoxFit.cover,
                        alignment: Alignment.center)),
                alignment: Alignment.center,
                child: SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: pt(10),
                        top: pt(15),
                        child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  if (!hasSignIn) {
                                    hasSignIn = true;
                                    UserEntity copy = widget.userEntity
                                        .copyWith();
                                    homeBloc.add(UpdateUserInfo(copy));
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      !hasSignIn ? ResourceString.signin : ResourceString.signined,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: pt(5),
                                    ),
                                    Image.asset(
                                      MyImage.png_sign_in,
                                      color: Colors.white,
                                      width: 25,
                                      height: 25,
                                    )
                                  ],
                                ),
                              ),
                      ),
                      Positioned(
                        right: pt(10),
                        top: pt(15),
                        child: widget.userEntity == null
                            ? Container()
                            : GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  // Navigator.pushNamed(context, RankPage.ROUTER_NAME);
                                },
                                child: Image.asset(
                                  MyImage.png_rank,
                                  color: Colors.white,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                      ),
                      Positioned(
                        left: pt(10),
                        bottom: pt(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(pt(17)),
                                  child: widget.userEntity.get_avatar(34),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (!widget.isLogin) {
                                      Navigator.pushNamed(context,
                                              LoginPage.ROUTER_NAME)
                                          .then((_) {
                                        homeBloc.add(LoadHome());
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: pt(10)),
                                    child: Text(
                                      widget.userEntity.username ?? str.login,
                                      style: const TextStyle(
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: widget.userEntity == null
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        showIdDialog();
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            (widget.userEntity.id ==
                                                        null ||
                                                    widget.userEntity
                                                            .id.isEmpty)
                                                ? ResourceString.initSignature
                                                : widget
                                                    .userEntity.id,
                                            style:
                                                TextStyle(color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Offstage(
                offstage: !ProjectParameters.allowGiveAppFeedback,
                child: _menuItem(const Icon(Icons.feedback), ResourceString.feedback, () {
                  showFeedbackDialog();
                }),
              ),
              _menuItem(const Icon(Icons.attach_money), ResourceString.supportAuthor, () {
                // Navigator.pushNamed(context, SupportAuthorPage.ROUTER_NAME);
              }),
              _menuItem(const Icon(Icons.error_outline), ResourceString.about, () {
                // Navigator.pushNamed(context, AboutPage.ROUTER_NAME);
              }),
              _menuItem(const Icon(Icons.account_circle),
                  widget.isLogin ? str.logout : str.login, () {
                Navigator.pop(context);
                if (widget.isLogin) {
                  homeBloc.add(LogoutHome());
                }
                Navigator.pushNamed(context, LoginPage.ROUTER_NAME)
                    .then((_) {
                  homeBloc.add(LoadHome());
                });
              }),
//              FlatButton(
//                child: Text('去测试页'),
//                onPressed: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) {
//                        return Scaffold(
//                          body: TestPage(),
//                        );
//                      },
//                    ),
//                  );
//                },
//              ),
//            FlatButton(
//              child: Text('去nest'),
//              onPressed: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) {
//                      return Scaffold(
//                        body: NestedTestPage(),
//                      );
//                    },
//                  ),
//                );
//              },
//            ),
            ],
          );
        },
      ),
    );
  }

  Widget _menuItem(Widget icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: onTap,
    );
  }

  Future checkTodayHasSignin(DateTime updateTime) async {
    ///为防止打卡作弊，当前时间从网络上获取
    DateTime now;
    try {
      Response response = await dio.get(
          'http://api.m.taobao.com/rest/api3.do?api=mtop.common.getTimestamp');
      Map<String, dynamic> data =
          (response.data as Map<String, dynamic>)['data'];
      String todayMills = data['t'];
      now = DateTime.fromMillisecondsSinceEpoch(int.parse(todayMills),
          isUtc: true);
    } catch (e) {
      print(e);
      hasSignIn = true;
      setState(() {});
      return;
    }

    DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );
//    print('$updateTime,$today');
    hasSignIn = updateTime.isAfter(today.toUtc());
    setState(() {});
  }

  showIdDialog() {
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController controller =
              TextEditingController(text: widget.userEntity.id);
          if (widget.userEntity.id != null) {
            controller.selection = TextSelection(
                baseOffset: widget.userEntity.id.length,
                extentOffset: widget.userEntity.id.length);
          }
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
            content: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: pt(5),
                  vertical: pt(8),
                ),
              ),
              controller: controller,
              autofocus: true,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(ResourceString.cancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text(ResourceString.confirm),
                onPressed: () {
                  UserEntity copy = widget.userEntity
                      .copyWith(id: controller.text);
                  homeBloc.add(UpdateUserInfo(copy));
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  showFeedbackDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
            content: Container(
              height: pt(200),
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: TextField(
                maxLines: null,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  hintText: ResourceString.feedbackTips,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: pt(5),
                    vertical: pt(8),
                  ),
                ),
                controller: controller,
                autofocus: true,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(ResourceString.cancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text(ResourceString.confirm),
                onPressed: () {
                  // BmobFeedbackEntity feedback = BmobFeedbackEntity(
                  //     widget.userName ?? '未登录用户', controller.text ?? '空');
                  // feedback.save().then((_) {
                  //   print('feedback send success');
                  // });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
