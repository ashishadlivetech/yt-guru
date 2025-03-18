import 'package:flutter/material.dart';
import 'package:project1/controllers/google_auth.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleLoginWebView extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const GoogleLoginWebView({super.key, required this.onLoginSuccess});

  @override
  _GoogleLoginWebViewState createState() => _GoogleLoginWebViewState();
}

class _GoogleLoginWebViewState extends State<GoogleLoginWebView> {
  late final WebViewController _controller;
  String? _authUrl;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (url.contains("success")) {
              widget.onLoginSuccess();
              Navigator.pop(context);
            }
          },
        ),
      );
    _loadAuthUrl();
  }

  /// Fetch authentication URL and load it in WebView
  Future<void> _loadAuthUrl() async {
    final authService = GoogleAuthService();
    final url = await authService.fetchAuthUrl();
    if (url != null) {
      setState(() {
        _authUrl = url;
      });
      _controller.loadRequest(Uri.parse(url));
    } else {
      print("Failed to fetch authentication URL.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Login")),
      body: _authUrl == null
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller),
    );
  }
}
