import 'package:flutter/material.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/first_letter_capitalized.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
// import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
// ignore: must_be_immutable
class NotificationWebView extends StatefulWidget {
  String title;
  String webNavigationUrl;

  NotificationWebView(this.title, this.webNavigationUrl);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<NotificationWebView> {
  ProgressBarHandler _handler1;

  @override
  Widget build(BuildContext context) {
    var progressBar1 = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler1 = handler;
        handler.show();
        return;
      },
    );
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200.0),
          child: CustomAppBar(
            title: Capitalized.capitalizeFirstLetter(widget.title),
          ),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: widget.webNavigationUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (val) => {
                _handler1.dismiss(),
              },
            ),
            progressBar1,
          ],
        ),
      ),
    );
  }
}
