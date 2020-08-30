import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatelessWidget {
  final _url;
  final _withJavascript;
  final _clearCache;
  final _clearCookies;
  final _withZoom;
  final _scrollBar;

  WebView(
    this._url,
    this._withJavascript,
    this._withZoom,
    this._scrollBar,
    this._clearCache,
    this._clearCookies,
  );

  @override
  Widget build(BuildContext context) => WebviewScaffold(
        url: _url,
        withJavascript: _withJavascript,
        clearCache: _clearCache,
        clearCookies: _clearCookies,
        withZoom: _withZoom,
        scrollBar: _scrollBar,
        appBar: AppBar(
          title: Text(_url),
        ),
      );
}
