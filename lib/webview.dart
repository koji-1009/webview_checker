import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatelessWidget {
  const WebView({
    @required this.url,
    @required this.withJavascript,
    @required this.withZoom,
    @required this.scrollBar,
    @required this.clearCache,
    @required this.clearCookies,
  });

  final String url;
  final bool withJavascript;
  final bool clearCache;
  final bool clearCookies;
  final bool withZoom;
  final bool scrollBar;

  @override
  Widget build(BuildContext context) => WebviewScaffold(
        url: url,
        withJavascript: withJavascript,
        clearCache: clearCache,
        clearCookies: clearCookies,
        withZoom: withZoom,
        scrollBar: scrollBar,
        appBar: AppBar(
          title: Text(url),
        ),
      );
}
