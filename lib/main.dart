import 'package:flutter/material.dart';
import 'package:webview_checker/webview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView Checker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WebView Checker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  String _url = "";
  bool _withJavascript = true;
  bool _scrollBar = false;

  void _showWebView() {
    if (_url.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute<Null>(
              settings: const RouteSettings(name: "/webview"),
              builder: (BuildContext context) =>
                  WebView(_url, _withJavascript, _scrollBar)));
    } else {
      _scaffoldState.currentState
          .showSnackBar(SnackBar(content: Text("URL is empty")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
          ],
        ),
      ),
    );
  }
}
