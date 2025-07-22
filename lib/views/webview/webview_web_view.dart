import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_flutter/views/shared/appbar_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import '../shared/drawer_widget.dart';

class WebviewWebView extends StatefulWidget {
  const WebviewWebView({super.key});

  @override
  State<WebviewWebView> createState() => _WebviewWebViewState();
}

class _WebviewWebViewState extends State<WebviewWebView> {
  final user = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PlatformWebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    )..loadRequest(LoadRequestParams(uri: Uri.parse('https://flutter.dev')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(user: user),
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey, user: user),
      body: PlatformWebViewWidget(
        PlatformWebViewWidgetCreationParams(controller: _controller),
      ).build(context),
    );
  }
}
