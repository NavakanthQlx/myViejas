import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String urlString;

  const WebViewScreen(
      {Key? key, this.urlString = "https://viejas.com/promotions/"})
      : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: WebView(
        initialUrl: widget.urlString,
      ),
    );
  }
}
