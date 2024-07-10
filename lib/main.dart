import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_checker/webview.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView Checker',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _urlPrivacyPolicy =
      'https://github.com/koji-1009/webview_checker/blob/main/privacy_policy.md';

  final _controller = TextEditingController();

  var _withJavascript = true;
  var _clearCache = false;
  var _clearCookies = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_saveLastUrl);
    _getLastUrl().then((value) => _controller.text = value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView Checker'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _launchURL,
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: _urlPrivacyPolicy,
                child: Text('Privacy Policy'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
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
              itemBuilder: (context, index) => switch (index) {
                0 => CheckboxListTile(
                    title: const Text('JavaScript enable'),
                    value: _withJavascript,
                    onChanged: (value) {
                      setState(
                        () {
                          _withJavascript = value ?? false;
                        },
                      );
                    }),
                1 => CheckboxListTile(
                    title: const Text('Clear cache'),
                    value: _clearCache,
                    onChanged: (value) {
                      setState(() {
                        _clearCache = value ?? false;
                      });
                    },
                  ),
                2 => CheckboxListTile(
                    title: const Text('Clear cookies'),
                    value: _clearCookies,
                    onChanged: (value) {
                      setState(() {
                        _clearCookies = value ?? false;
                      });
                    },
                  ),
                _ => const SizedBox.shrink()
              },
            ),
          ),
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
    return prefs.getString('saved_url') ?? '';
  }

  Future<void> _saveLastUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_url', _controller.text);
  }

  void _showWebView() {
    final url = _controller.text;
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'URL is empty',
          ),
        ),
      );
      return;
    }

    Navigator.push<WebPage>(context, _createRoute(url));
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not launch $url',
          ),
        ),
      );
    }
  }

  Route<WebPage> _createRoute(String url) => MaterialPageRoute<WebPage>(
        builder: (context) => WebPage(
          url: url,
          withJavascript: _withJavascript,
          clearCache: _clearCache,
          clearCookies: _clearCookies,
        ),
      );
}
