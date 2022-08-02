// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatefulWidget {
 

  WebScreen(
      {required this.news,Key? key,});
Map news;
  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebView(
          initialUrl: widget.news["link"],
          debuggingEnabled: true,
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          onPageFinished: (d) {
            setState(() {
              loading = false;
            });
          },
        ),
      ),
    );
  }
}
