// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:slc/common/first_letter_capitalized.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/model/event_price_category.dart';

import 'event_people_list.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class WebviewPage extends StatefulWidget {
  WebviewPage(
      {Key key,
      this.url,
      this.title,
      this.eventId,
      this.eventPriceCategoryList,
      this.showAddPeople})
      : super(key: key);

  final String url;
  final String title;
  int eventId;
  bool showAddPeople;
  List<EventPriceCategory> eventPriceCategoryList;

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  //ProgressBarHandler _handler1;

  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  //double _loadProgress = -1;
  // bool get finished => _loadProgress == 1.0;
  //final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.close();

    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      //debugPrint();
      if (mounted) {
        setState(() {
          //debugPrint("==> changed url"+url);
          // _history.add('onUrlChanged: $url');
        });
      }
    });

    // Add a listener to on url changed
    _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((
      WebViewStateChanged state,
    ) {
      print("watcher" + state.url);
      //debugPrint("===> current url : "+state.url);
      //String status = "http://103.88.77.8/slcweb/payment/status";
      if (state.url.contains("http://192.168.1.5/slcapi/api/events/participant-payment-result") ||
          state.url.contains(
              "https://webapp.slc.ae:8001/api/events/participant-payment-result") ||
          state.url.contains(
              "https://webapp.slc.ae/api/events/participant-payment-result")) {
        setState(() {
          Navigator.of(context).pop();
          flutterWebViewPlugin.close();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventPeopleList(
                        eventId: widget.eventId,
                        eventPriceCategoryList: widget.eventPriceCategoryList,
                        showAddPeople: widget.showAddPeople,
                      )));

          //_history.add('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.

    // Every listener should be canceled, the same should be done with this stream.
    if (_onDestroy != null) {
      _onDestroy.cancel();
    }
    if (_onUrlChanged != null) {
      _onUrlChanged.cancel();
    }
    if (_onStateChanged != null) {
      _onStateChanged.cancel();
    }
    if (flutterWebViewPlugin != null) {
      flutterWebViewPlugin.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: WebviewScaffold(
      url: widget.url,
      mediaPlaybackRequiresUserGesture: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: CustomAppBar(
          title: Capitalized.capitalizeFirstLetter(widget.title),
        ),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      // initialChild: MyHomePage()
    ));
  }
}
