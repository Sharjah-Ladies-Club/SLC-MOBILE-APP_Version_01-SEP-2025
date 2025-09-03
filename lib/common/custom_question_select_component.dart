// import 'dart:convert';
//
// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/model/enquiry_questioners.dart';

// ignore: must_be_immutable
class CustomQuestionComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController questionController;
  String isEditBtnEnabled;
  List<MemberQuestionsResponse> questionResponse = [];
  // List<MemberQuestionsResponse>();
  String label = "";
  bool showPrefixIcon = true;

  CustomQuestionComponent(
      {this.selectedFunction,
      this.questionController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.questionResponse,
      this.label,
      this.showPrefixIcon,
      Key key})
      : super(key: key);

  @override
  _CustomQuestionComponentState createState() =>
      _CustomQuestionComponentState();
}

class _CustomQuestionComponentState extends State<CustomQuestionComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.questionController.addListener(() {
      if (widget.questionController.text != "") elevationPoint = 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: questionForm(),
    );
  }

  Future<Widget> getQuestionDDList() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.questionResponse.length * 35.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.questionResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () {
                      Get.back();
                      onQuestionSelection(widget.questionResponse[i]);
                    },
                    child: Container(
                        height: 35.0,
                        padding: EdgeInsets.only(top: 10.0),
                        child: PackageListHead.genderNationalityPicker(
                            context, widget.questionResponse[i].questionName)),
                  );
                },
              ),
            ),
          );
        });
  }

  onQuestionSelection(val) {
    debugPrint(val.questionName);
    widget.questionController.text = val.questionName;
    elevationPoint = 5.0;
    setState(() {});
    widget.selectedFunction(val, val.memberQuestionId);
  }

  // Widget questionForm() {
  //   return Container(
  //     child: Card(
  //         color: ColorData.loginBackgroundColor,
  //         elevation: elevationPoint,
  //         child: ListTile(
  //           leading: widget.showPrefixIcon ? prefixIconFn() : null,
  //           onTap: () async {
  //             FocusScope.of(context).requestFocus(new FocusNode());
  //             if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
  //               getQuestionDDList();
  //             }
  //           },
  //           dense: true,
  //           minLeadingWidth: 0.0,
  //           // leading: Container(
  //           //     margin: Localizations.localeOf(context).languageCode == "en"
  //           //         ? EdgeInsets.only(left: 0.0)
  //           //         : EdgeInsets.only(right: 5.0),
  //           //     child: widget.showPrefixIcon ? prefixIconFn() : null),
  //           // leading: widget.showPrefixIcon ? prefixIconFn() : null,
  //           title: FormBuilderTextField(
  //             readOnly: true,
  //             name: "question",
  //             controller: widget.questionController,
  //             keyboardType: TextInputType.text,
  //             textInputAction: TextInputAction.done,
  //             enableInteractiveSelection: false,
  //             maxLines: 1,
  //             style: PackageListHead.textFieldStyles(context, false),
  //             decoration: InputDecoration(
  //               enabled: true,
  //               labelText: widget.label,
  //               border: underLineShow(),
  //               suffixIcon: suffixIconFn(),
  //               contentPadding: EdgeInsets.all(5.0),
  //               labelStyle: (elevationPoint == 5.0)
  //                   ? PackageListHead.textFieldStyles(context, true)
  //                   : PackageListHead.textFieldStyles(context, false),
  //             ),
  //           ),
  //         )),
  //   );
  // }

  Widget questionForm() {
    return Container(
      child: Card(
          color: ColorData.loginBackgroundColor,
          elevation: elevationPoint,
          child: ListTile(
            onTap: () async {
              FocusScope.of(context).requestFocus(new FocusNode());
              if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
                getQuestionDDList();
              }
            },
            dense: true,
            minLeadingWidth: 0.0,
            // leading: Container(
            //     margin: Localizations.localeOf(context).languageCode == "en"
            //         ? EdgeInsets.only(left: 0.0)
            //         : EdgeInsets.only(right: 5.0),
            //     child: widget.showPrefixIcon ? prefixIconFn() : null),
            leading: widget.showPrefixIcon ? prefixIconFn() : null,
            title: IgnorePointer(
                child: FormBuilderTextField(
              readOnly: true,
              name: "question",
              controller: widget.questionController,
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
          )),
      // child: Text("123")),
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
      child: Icon(CommonIcons.user_one, color: ColorData.inActiveIconColor),
    );
  }
}
