import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_checker/webview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView Checker',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'WebView Checker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _urlPrivacyPolicy =
      'https://github.com/koji-1009/webview_checker/blob/main/privacy_policy.md';

  final _scaffoldState = GlobalKey<ScaffoldState>();
  final _controller = TextEditingController();

  var _withJavascript = true;
  var _clearCache = false;
  var _clearCookies = false;
  var _withZoom = false;
  var _scrollBar = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_saveLastUrl);
    _getLastUrl().then((value) => _controller.text = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _launchURL,
            itemBuilder: (context) {
              return [
                const PopupMenuItem<String>(
                  value: _urlPrivacyPolicy,
                  child: Text('Privacy Policy'),
                )
              ];
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              maxLines: 1,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.go,
              decoration: const InputDecoration(
                hintText: 'Enter the URL you want to check',
                labelText: 'URL',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return CheckboxListTile(
                        title: const Text('JavaScript enable'),
                        value: _withJavascript,
                        onChanged: (value) {
                          setState(
                            () {
                              _withJavascript = value;
                            },
                          );
                        });
                  case 1:
                    return CheckboxListTile(
                      title: const Text('Scrollbar enable'),
                      value: _scrollBar,
                      onChanged: (value) {
                        setState(() {
                          _scrollBar = value;
                        });
                      },
                    );
                  case 2:
                    return CheckboxListTile(
                      title: const Text('With zoom button'),
                      value: _withZoom,
                      onChanged: (value) {
                        setState(() {
                          _withZoom = value;
                        });
                      },
                    );
                  case 4:
                    return CheckboxListTile(
                      title: const Text('Clear cache'),
                      value: _clearCache,
                      onChanged: (value) {
                        setState(() {
                          _clearCache = value;
                        });
                      },
                    );
                  case 5:
                    return CheckboxListTile(
                      title: const Text('Clear cookies'),
                      value: _clearCookies,
                      onChanged: (value) {
                        setState(() {
                          _clearCookies = value;
                        });
                      },
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showWebView,
        tooltip: 'Open WebView',
        child: const Icon(Icons.open_in_browser),
      ),
    );
  }

  Future<String> _getLastUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_url');
  }

  Future<void> _saveLastUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_url', _controller.text);
  }

  void _showWebView() {
    final url = _controller.text;
    if (url.isNotEmpty) {
      Navigator.push<WebView>(context, _createRoute(url));
    } else {
      _scaffoldState.currentState.showSnackBar(
        const SnackBar(
          content: Text(
            'URL is empty',
          ),
        ),
      );
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _scaffoldState.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Could not launch $url',
          ),
        ),
      );
    }
  }

  Route<WebView> _createRoute(String url) => MaterialPageRoute<WebView>(
        builder: (context) => WebView(
          url: url,
          withJavascript: _withJavascript,
          withZoom: _withZoom,
          scrollBar: _scrollBar,
          clearCache: _clearCache,
          clearCookies: _clearCookies,
        ),
      );
}
