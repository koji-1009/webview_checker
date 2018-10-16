import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatelessWidget {
  final _url;
  final _withJavascript;
  final _scrollBar;

  WebView(this._url, this._withJavascript, this._scrollBar);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: _url,
      withJavascript: _withJavascript,
      scrollBar: _scrollBar,
      appBar: AppBar(
        title: Text(_url),
      ),
    );
  }
}
