import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../res/strings/strings.dart';
import '../../utils/string_decode.dart';

class WebViewPage extends StatefulWidget {
  static const ROUTER_NAME = '/WebViewPage';

  const WebViewPage({super.key});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late String title;
  late String url;
  late FlutterWebviewPlugin flutterWebviewPlugin;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin = FlutterWebviewPlugin();

    //initialChild只有第一网页加载时会显示，网页内部页面跳转不会再显示，所以要手动加上页面内跳转监听
    flutterWebviewPlugin.onStateChanged.listen((state) {
      print('_WebViewPageState.initState  state = ${state.type}');
      if (state.type == WebViewState.shouldStart) {
        setState(() {
          showLoading = true;
        });
      } else if (state.type == WebViewState.finishLoad ||
          state.type == WebViewState.abortLoad) {
        setState(() {
          showLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      title = decodeString(args['title']);
      url = args['url'];
    }
    return WebviewScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 8),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                flutterWebviewPlugin.goBack();
              },
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.open_in_browser,
              color: Colors.white,
            ),
            tooltip: ResourceString.openBrowser,
            onPressed: () {
              _launchURL();
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 1),
          child: showLoading
              ? const LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                )
              : Container(),
        ),
      ),
      url: url,
      hidden: true,
      // initialChild: getLoading(),
      withZoom: true,
      withLocalStorage: true,
    );
  }

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
