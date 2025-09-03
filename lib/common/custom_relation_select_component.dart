// // import 'dart:convert';
//
// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
// import 'package:slc/customcomponentfields/custom_list_tile_dropdown.dart'
//     as prefix0;
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/model/booking_timetable.dart';

// ignore: must_be_immutable
class CustomRelationComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController relationController;
  String isEditBtnEnabled;
  List<EnquiryRelation> relationResponse = []; //List<EnquiryRelation>();
  String label = "";

  CustomRelationComponent(
      {this.selectedFunction,
      this.relationController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.relationResponse,
      this.label,
      Key key})
      : super(key: key);

  @override
  _CustomRelationComponentState createState() =>
      _CustomRelationComponentState();
}

class _CustomRelationComponentState extends State<CustomRelationComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.relationController.addListener(() {
      if (widget.relationController.text != "") elevationPoint = 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: relationForm(),
    );
  }

  Future<Widget> getRelationDDList() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.relationResponse.length * 25.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.relationResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () {
                      Get.back();
                      onSelection(widget.relationResponse[i]);
                    },
                    child: Container(
                        height: 35.0,
                        padding: EdgeInsets.only(top: 10.0),
                        child: PackageListHead.genderNationalityPicker(
                            context, widget.relationResponse[i].relationName)),
                  );
                },
              ),
            ),
          );
        });
  }

  onSelection(EnquiryRelation val) {
    widget.relationController.text = val.relationName;
    elevationPoint = 5.0;
    widget.selectedFunction(val);
    setState(() {});
  }

  Widget relationForm() {
    return Container(
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
              getRelationDDList();
            }
          },
          dense: true,
          minLeadingWidth: 0.0,
          leading: Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(left: 0.0)
                  : EdgeInsets.only(right: 5.0),
              child: prefixIconFn()),
          // leading: prefixIconFn(),
          title: IgnorePointer(
              child: FormBuilderTextField(
            readOnly: true,
            name: "relation",
            controller: widget.relationController,
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
