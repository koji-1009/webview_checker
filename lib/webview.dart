import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatelessWidget {
  final String _url;

  WebView(this._url);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: _url,
      appBar: AppBar(
        title: Text(_url),
      ),
    );
  }
}
