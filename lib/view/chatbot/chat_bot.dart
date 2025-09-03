import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatBot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('chat bot--> ' + URLUtils().chatBotUrl());
    var encoded = Uri.encodeFull(URLUtils().chatBotUrl());
    print("Encoded URL: " + encoded);
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: CustomAppBar(
                title: tr('chat'),
              ),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: WebView(
                initialUrl: encoded,
                javascriptMode: JavascriptMode.unrestricted,
              ),
            )));
  }
}
