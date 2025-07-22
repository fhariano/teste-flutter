import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/views/shared/appbar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../shared/drawer_widget.dart';

class WebviewView extends StatefulWidget {
  const WebviewView({super.key});

  @override
  State<WebviewView> createState() => _WebviewViewState();
}

class _WebviewViewState extends State<WebviewView> {
  final user = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://flutter.dev'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(user: user),
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey, user: user),
      body: WebViewWidget(controller: _controller),
    );
  }
}
