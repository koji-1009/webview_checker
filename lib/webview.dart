import 'package:flutter/material.dart';

class WebView extends StatelessWidget {
  final String _url;

  WebView(this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web View"),
      ),
    );
  }
}
