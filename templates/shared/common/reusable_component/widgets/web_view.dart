import 'package:expense_tracker/reusable_component/import.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewpage extends StatefulWidget {

  final String webUrl;
  final String appTitle;

  const WebViewpage({super.key,required this.webUrl,required this.appTitle});

  @override
  State<WebViewpage> createState() => _WebViewpageState();
}

class _WebViewpageState extends State<WebViewpage> {

  WebViewController controller=WebViewController();
  bool isLoading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.webUrl));
  }

  @override
  Widget build(BuildContext context) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            if(progress==100){
              if(isLoading){
                setState(() {
                  isLoading=false;
                });
              }
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.webUrl));
    return Scaffold(
      appBar: baseAppBar(context: context,title:widget.appTitle,backgroundColor: AppColors.scaffoldColor),
      body: isLoading?const Center(child: CircularProgressIndicator(),):WebViewWidget(controller: controller),
    );
  }
}
