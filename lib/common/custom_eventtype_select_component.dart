// // import 'dart:convert';
//
// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:slc/model/booking_timetable.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/strings.dart';

// ignore: must_be_immutable
class CustomEventTypeComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController eventTypeController;
  String isEditBtnEnabled;
  List<EventType> eventTypeResponse = []; //List<EventType>();
  String label = "";

  CustomEventTypeComponent(
      {this.selectedFunction,
      this.eventTypeController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.eventTypeResponse,
      this.label,
      Key key})
      : super(key: key);

  @override
  _CustomEventTypeComponentState createState() =>
      _CustomEventTypeComponentState();
}

class _CustomEventTypeComponentState extends State<CustomEventTypeComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.eventTypeController.addListener(() {
      if (widget.eventTypeController.text != "") elevationPoint = 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: eventTypeForm(),
    );
  }

  Future<Widget> getEventTypeDDList() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.eventTypeResponse.length * 25.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.eventTypeResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () {
                      Get.back();
                      onSelection(widget.eventTypeResponse[i]);
                    },
                    child: Container(
                        height: 35.0,
                        padding: EdgeInsets.only(top: 10.0),
                        child: PackageListHead.genderNationalityPicker(
                            context, widget.eventTypeResponse[i].eventType)),
                  );
                },
              ),
            ),
          );
        });
  }

  onSelection(EventType val) {
    widget.eventTypeController.text = val.eventType;
    elevationPoint = 5.0;
    widget.selectedFunction(val);
    setState(() {});
  }

  Widget eventTypeForm() {
    return Container(
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
              getEventTypeDDList();
            }
          },
          dense: true,
          minLeadingWidth: 0.0,
          leading: Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(left: 0.0)
                  : EdgeInsets.only(right: 5.0),
              child: prefixIconFn()),
          title: IgnorePointer(
              child: FormBuilderTextField(
            readOnly: true,
            name: "eventType",
            controller: widget.eventTypeController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enableInteractiveSelection: false,
            maxLines: 1,
            style: PackageListHead.textFieldStyles(context, false),
            decoration: InputDecoration(
              enabled: true,
              labelText: widget.label,
              border: underLineShow(),
              suffixIcon: suffixIconFn(),
              contentPadding: EdgeInsets.all(5.0),
              labelStyle: (elevationPoint == 5.0)
                  ? PackageListHead.textFieldStyles(context, true)
                  : PackageListHead.textFieldStyles(context, false),
            ),
          )),
        ),
      ),
    );
  }

  suffixIconFn() {
    return IconButton(
      onPressed: () {},
      icon: Icon(CommonIcons.dropdown,
          size: 12.0, color: ColorData.inActiveIconColor),
    );
  }

  underLineShow() {
    if (elevationPoint == 5.0) {
      return InputBorder.none;
    }
  }

  prefixIconFn() {
    return Padding(
      padding: EdgeInsets.zero,
      child: Icon(Icons.redeem, color: ColorData.inActiveIconColor),
    );
  }
}

class CustomEventTypeWithIconComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController eventTypeController;
  String isEditBtnEnabled;
  List<EventType> eventTypeResponse = []; //List<EventType>();
  String label = "";
  String imagePath;

  CustomEventTypeWithIconComponent(
      {this.selectedFunction,
      this.eventTypeController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.eventTypeResponse,
      this.label,
      this.imagePath,
      Key key})
      : super(key: key);

  @override
  _CustomEventTypeWithIconComponentState createState() =>
      _CustomEventTypeWithIconComponentState();
}

class _CustomEventTypeWithIconComponentState
    extends State<CustomEventTypeWithIconComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.eventTypeController.addListener(() {
      if (widget.eventTypeController.text != "") elevationPoint = 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: eventTypeForm(),
    );
  }

  Future<Widget> getEventTypeDDList() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.eventTypeResponse.length * 25.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.eventTypeResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () {
                      Get.back();
                      onSelection(widget.eventTypeResponse[i]);
                    },
                    child: Container(
                        height: 35.0,
                        padding: EdgeInsets.only(top: 10.0),
                        child: PackageListHead.genderNationalityPicker(
                            context, widget.eventTypeResponse[i].eventType)),
                  );
                },
              ),
            ),
          );
        });
  }

  onSelection(EventType val) {
    widget.eventTypeController.text = val.eventType;
    elevationPoint = 5.0;
    widget.selectedFunction(val);
    setState(() {});
  }

  Widget eventTypeForm() {
    return Container(
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
              getEventTypeDDList();
            }
          },
          dense: true,
          minLeadingWidth: 0.0,
          leading: Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(left: 0.0)
                  : EdgeInsets.only(right: 5.0),
              child: prefixIconFn()),
          title: IgnorePointer(
              child: FormBuilderTextField(
            readOnly: true,
            name: "eventType",
            controller: widget.eventTypeController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enableInteractiveSelection: false,
            maxLines: 1,
            style: PackageListHead.textFieldStyles(context, false),
            decoration: InputDecoration(
              enabled: true,
              labelText: widget.label,
              border: underLineShow(),
              suffixIcon: suffixIconFn(),
              contentPadding: EdgeInsets.all(5.0),
              labelStyle: (elevationPoint == 5.0)
                  ? PackageListHead.textFieldStyles(context, true)
                  : PackageListHead.textFieldStyles(context, false),
            ),
          )),
        ),
      ),
    );
  }

  suffixIconFn() {
    return IconButton(
      onPressed: () {},
      icon: Icon(CommonIcons.dropdown,
          size: 12.0, color: ColorData.inActiveIconColor),
    );
  }

  underLineShow() {
    if (elevationPoint == 5.0) {
      return InputBorder.none;
    }
  }

  prefixIconFn() {
    return Padding(
      padding: EdgeInsets.zero,
      child: widget.imagePath != null
          ? Image.asset(widget.imagePath, width: 30)
          : Icon(Icons.redeem, color: ColorData.inActiveIconColor),
    );
  }
}
