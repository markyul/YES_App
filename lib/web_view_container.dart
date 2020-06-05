import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class WebViewContainer extends StatefulWidget {
  final url = 'http://project-yes-qnxfa.run.goorm.io/';

  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  var _title;
  final _key = UniqueKey();
  WebViewController _webViewController;

  _WebViewContainerState(this._url);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(_title ?? "Browser")
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: _url,
                  userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.106 Safari/537.36",
                  onWebViewCreated: (WebViewController webViewController){
                    _webViewController = webViewController;
                  },
                  onPageFinished: (url) {
                    _url = url;
                    setState(() {
                      _title = url;
                    });
                  },
                )
            )
          ],
        ),
      ),
      onWillPop: () {
        var future = _webViewController.canGoBack();
        future.then((canGoBack) {
          if(canGoBack) {
            _webViewController.goBack();
          } else {
            Navigator.pop(context);
          }
        });
        return Future.value(false);
      },
    );
  }
}