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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WebView Checker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _URL_PRIVACY_POLICY =
      'https://github.com/koji-1009/webview_checker/blob/master/privacy_policy.md';

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final _controller = TextEditingController();

  var _withJavascript = true;
  var _clearCache = false;
  var _clearCookies = false;
  var _withZoom = false;
  var _scrollBar = false;

  _getLastUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("saved_url");
  }

  _saveLastUrl() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("saved_url", _controller.text);
  }

  _showWebView() {
    final url = _controller.text;
    if (url.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute<Null>(
              settings: const RouteSettings(name: "/webview"),
              builder: (BuildContext context) => WebView(url, _withJavascript,
                  _withZoom, _scrollBar, _clearCache, _clearCookies)));
    } else {
      _scaffoldState.currentState
          .showSnackBar(SnackBar(content: Text("URL is empty")));
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
      appBar: AppBar(title: Text(widget.title), actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: _launchURL,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: _URL_PRIVACY_POLICY,
                child: Text("Privacy Policy"),
              )
            ];
          },
        ),
      ]),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                maxLines: 1,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                    hintText: 'Enter the URL you want to check',
                    labelText: 'URL',
                    border: OutlineInputBorder()),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  CheckboxListTile(
                      title: const Text('JavaScript enable'),
                      value: _withJavascript,
                      onChanged: (bool value) {
                        setState(() {
                          _withJavascript = value;
                        });
                      }),
                  CheckboxListTile(
                    title: const Text('Scrollbar enable'),
                    value: _scrollBar,
                    onChanged: (bool value) {
                      setState(() {
                        _scrollBar = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('With zoom button'),
                    value: _withZoom,
                    onChanged: (bool value) {
                      setState(() {
                        _withZoom = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Clear cache'),
                    value: _clearCache,
                    onChanged: (bool value) {
                      setState(() {
                        _clearCache = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Clear cookies'),
                    value: _clearCookies,
                    onChanged: (bool value) {
                      setState(() {
                        _clearCookies = value;
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showWebView,
        tooltip: 'Open WebView',
        child: Icon(Icons.open_in_browser),
      ),
    );
  }
}
