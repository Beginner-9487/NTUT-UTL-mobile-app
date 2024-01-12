import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntut_utl_mobile_app/page/line_chart/line_chart_page.dart';
import 'package:ntut_utl_mobile_app/repository/my_user_repository.dart';

import '../../res/colors.dart';
import '../../res/project_parameters.dart';
import '../../res/strings/strings.dart';
import '../../utils/display_util.dart';
import '../../utils/screen_utils.dart';
import '../base/custom_sliver_app_bar_delegate.dart';
import '../bluetooth/page/other_bluetooth_page.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'home_drawer.dart';

class HomePage extends StatefulWidget {
  static get ROUTER_NAME => '/HomePage';

  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin, StateWithResStrings {
  late BuildContext innerContext;
  HomeBloc homeBloc = HomeBloc();
  bool get isLogin => MyUserRepository.isLoggedIn;
  String get username => MyUserRepository.currentUserEntity.username;
  Widget get header_avatar => MyUserRepository.currentUserEntity.get_avatar(34);

  late TabController _tabController;
  late ScrollController _scrollController;
  late TextEditingController _searchTextController;

  Map<String, Widget> get tabs => ProjectParameters.homePageTabs(str);

  @override
  void initState() {
    super.initState();
    homeBloc.add(LoadHome());
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: tabs.length, vsync: this);
    _scrollController = ScrollController();
    _searchTextController = TextEditingController();
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (BuildContext context) => homeBloc
        ),
      ],
      child: BlocListener(
        bloc: homeBloc,
        listener: (context, state) {
          print("BlocListener: $state");
          if (state is HomeLoadError) {
            if (innerContext != null) {
              DisplayUtil.showMsg(innerContext, exception: state.exception as Exception?);
              MyUserRepository.force_to_logged_in(context);
            }
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
            bloc: homeBloc,
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  Scaffold(
                    body: Builder(builder: (context) {
                      innerContext = context;
                      return Stack(
                        children: <Widget>[
                          DecoratedBox(
                            decoration: _themeGradientDecoration(),
                            child: SafeArea(
                              child: NestedScrollView(
                                controller: _scrollController,
                                headerSliverBuilder: (
                                    BuildContext context,
                                    bool innerBoxIsScrolled)
                                {
                                  //为了练习代码，并不是直接使用SliverAppBar来实现头部
                                  return <Widget>[
                                    SliverToBoxAdapter(
                                      child: Container(
                                        decoration: _themeGradientDecoration(),
                                        child: appBarHeader(),
                                      ),
                                    ),
                                    //因为子页TabBarView不一定都会用CustomScrollView,放弃使用SliverOverlapAbsorber + SliverOverlapInjector
                                    //影响是滑到顶部后子页还能继续上滑一小段距离（我的tabBarView是包了一层上面有圆角的DecoratedBox的，滑动列表时可发现圆角背景还会上滑而不是固定住，但影响不大，页面和它内部滚动widget的滚动衔接还是在的，所以看上去都是在滑动）
                                    SliverPersistentHeader(
                                      pinned: true,
                                      floating: true,
                                      delegate: CustomSliverAppBarDelegate(
                                        minHeight: pt(40),
                                        maxHeight: pt(40),
                                        child: Container(
                                          height: pt(40),
                                          decoration:
                                              _themeGradientDecoration(),
                                          child: appBarTab(_tabController),
                                        ),
                                      ),
                                    ),
                                  ];
                                },
                                body: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(pt(10)),
                                      topRight: Radius.circular(pt(10)),
                                    ),
                                  ),
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: tabs.values
                                        .map((page) => page)
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    drawer: Drawer(
                      child: HomeDrawer(),
                    ),
                  ),
                  // Offstage(
                  //   offstage: state is! HomeLoading,
                  //   child: getLoading(start: state is HomeLoading),
                  // )
                ],
              );
            }),
      ),
    );
  }

  Decoration _themeGradientDecoration() {
    return const BoxDecoration(
        gradient: LinearGradient(
      colors: [
//        WColors.theme_color_dark,
        WColors.theme_color,
        WColors.theme_color_light,
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
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Scaffold.of(innerContext).openDrawer();
            },
            child: Container(
              width: pt(34),
              height: pt(34),
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: pt(12)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(pt(17)),
                child: header_avatar,
              ),
            ),
          ),
          // const Expanded(
          //   child: Hero(
          //     tag: 'searchBar',
          //     child: Material(
          //       type: MaterialType.transparency,
          //       child: null
          //     ),
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () {},
          //   child: null
          // ),
          Text(username)
        ],
      ),
    );
  }

  Widget appBarTab(TabController tabController) {
    return TabBar(
      isScrollable: true,
      controller: tabController,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: Colors.white,
      tabs: tabs.keys.map((title) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: pt(6)),
          child: Text(
            title,
            style: const TextStyle(fontSize: 15),
          ),
        );
      }).toList(),
    );
  }
}
