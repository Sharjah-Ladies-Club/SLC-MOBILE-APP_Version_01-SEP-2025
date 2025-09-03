import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/customcomponentfields/customappbar.dart';

// ignore: must_be_immutable
class DefaultScaffold extends StatefulWidget {
  String title;
  Widget body;
  int index;
  Key key;

  DefaultScaffold(this.key, this.title, this.body, this.index)
      : super(key: key);

  @override
  _DefaultScaffoldState createState() => _DefaultScaffoldState();
}

class _DefaultScaffoldState extends State<DefaultScaffold>
    with AutomaticKeepAliveClientMixin {
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: CustomAppBar(
            title: tr(
              widget.title,
            ),
          ),
        ),
        body: Container(
          child: widget.body,
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
