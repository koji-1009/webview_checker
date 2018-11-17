import 'package:flutter/material.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  var _url = "";
  var _withJavascript = true;
  var _clearCache = false;
  var _clearCookies = false;
  var _withZoom = false;
  var _scrollBar = false;

  void _showWebView() {
    if (_url.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute<Null>(
              settings: const RouteSettings(name: "/webview"),
              builder: (BuildContext context) => WebView(_url, _withJavascript,
                  _withZoom, _scrollBar, _clearCache, _clearCookies)));
    } else {
      _scaffoldState.currentState
          .showSnackBar(SnackBar(content: Text("URL is empty")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16.0),
              child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                      hintText: 'Enter the URL you want to check',
                      labelText: 'URL',
                      border: OutlineInputBorder()),
                  initialValue: _url,
                  onFieldSubmitted: (String value) {
                    setState(() {
                      _url = value;
                      _showWebView();
                    });
                  }),
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
    );
  }
}
