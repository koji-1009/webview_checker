import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  const WebPage({
    super.key,
    required this.url,
    required this.withJavascript,
    required this.clearCache,
    required this.clearCookies,
  });

  final String url;
  final bool withJavascript;
  final bool clearCache;
  final bool clearCookies;

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late WebViewController _controller;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(
        widget.withJavascript
            ? JavaScriptMode.unrestricted
            : JavaScriptMode.disabled,
      )
      ..loadRequest(
        Uri.parse(widget.url),
      );

    Future(() async {
      if (widget.clearCookies) {
        await WebViewCookieManager().clearCookies();
      }

      if (widget.clearCache) {
        await _controller.clearCache();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter\'s appBar'),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
