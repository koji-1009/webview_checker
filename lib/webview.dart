import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatelessWidget {
  const WebPage({
    Key? key,
    required this.url,
    required this.withJavascript,
    required this.clearCache,
    required this.clearCookies,
  }) : super(key: key);

  final String url;
  final bool withJavascript;
  final bool clearCache;
  final bool clearCookies;

  @override
  Widget build(BuildContext context) {
    if (clearCookies) {
      CookieManager().clearCookies().then((_) {});
    }

    final webView = WebView(
      onWebViewCreated: (controller) async {
        if (clearCache) {
          await controller.clearCache();
        }
      },
      initialUrl: url,
      javascriptMode: withJavascript
          ? JavascriptMode.unrestricted
          : JavascriptMode.disabled,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter\'s appBar'),
      ),
      body: webView,
    );
  }
}
