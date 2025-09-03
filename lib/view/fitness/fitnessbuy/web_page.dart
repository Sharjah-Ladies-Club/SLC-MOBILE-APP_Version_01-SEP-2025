// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:slc/common/first_letter_capitalized.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'fitnessbuy_confirmation_alert.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class FitnessBuyWebviewPage extends StatefulWidget {
  FitnessBuyWebviewPage(
      {Key key, this.url, this.title, this.facilityId, this.facilityItems})
      : super(key: key);

  final String url;
  final String title;
  int facilityId;
  List<FacilityItems> facilityItems;

  @override
  _FitnessBuyWebviewPageState createState() => _FitnessBuyWebviewPageState();
}

class _FitnessBuyWebviewPageState extends State<FitnessBuyWebviewPage> {
  //ProgressBarHandler _handler1;
  String referenceNo = "";
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
      var uri = Uri.parse(state.url);
      uri.queryParameters.forEach((k, v) {
        // debugPrint("Query Parameter: " + k + " " + v);
        if (k == "ref") {
          referenceNo = v;
        }
      });
      if (state.url.contains("http://103.88.77.8/slcapi/api/facilities/enquiry-payment-result") ||
          state.url.contains(
              "https://webapp.slc.ae:8001/api/facilities/enquiry-payment-result") ||
          state.url.contains(
              "https://webapp.slc.ae/api/facilities/enquiry-payment-result")) {
        setState(() {
          //  debugPrint("===> current url : "+state.url);
          //debugPrint("==>  Given url :"+status);
          flutterWebViewPlugin.close();
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FitnessBuyConfirmationAlert(
                merchantReferenceNo: referenceNo,
              ),
            ),
          );

          //_history.add('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });
  }

  @override
  void dispose() {
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
