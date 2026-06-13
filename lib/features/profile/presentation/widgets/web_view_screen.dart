import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final String? successUrlPrefix;
  final String? cancelUrlPrefix;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.title,
    this.successUrlPrefix,
    this.cancelUrlPrefix,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  int progress = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (value) {
            setState(() {
              progress = value;
            });
          },
          onNavigationRequest: _onNavigationRequest,
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    final successUrlPrefix = widget.successUrlPrefix;
    if (successUrlPrefix != null && request.url.startsWith(successUrlPrefix)) {
      Navigator.pop(context, true);
      return NavigationDecision.prevent;
    }

    final cancelUrlPrefix = widget.cancelUrlPrefix;
    if (cancelUrlPrefix != null && request.url.startsWith(cancelUrlPrefix)) {
      Navigator.pop(context, false);
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          if (progress < 100) LinearProgressIndicator(value: progress / 100),
          Expanded(child: WebViewWidget(controller: controller)),
        ],
      ),
    );
  }
}
