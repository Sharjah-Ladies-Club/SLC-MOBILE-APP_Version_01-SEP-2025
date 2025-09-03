import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/strings.dart';

// ignore: must_be_immutable
class ProfileCustomNonEditableTextFieldComponent extends StatefulWidget {
  Function selectedFunction;
  TextEditingController mobileCtrl;
  String customLabelString;
  bool isPageFromProfileNonEditable;
  String colorCode = "";

  ProfileCustomNonEditableTextFieldComponent(
      {this.selectedFunction,
      this.mobileCtrl,
      this.customLabelString,
      this.isPageFromProfileNonEditable: false,
      this.colorCode = ""});

  @override
  _ProfileCustomNonEditableTextFieldComponentState createState() =>
      _ProfileCustomNonEditableTextFieldComponentState();
}

class _ProfileCustomNonEditableTextFieldComponentState
    extends State<ProfileCustomNonEditableTextFieldComponent> {
  double elevationPoint = 0.0;
  String todayDate =
      SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat();

  @override
  void initState() {
    widget.mobileCtrl.addListener(() {
      if (widget.mobileCtrl.text != Strings.txtMT) elevationPoint = 5.0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FormBuilder(
        // key: _dobFormKey,
        child: Container(
          //padding: EdgeInsets.fromLTRB(5.0, 0, 15.0, 0),
          child: genderForm(),
        ),
      ),
    );
  }

  Widget genderForm() {
    return Container(
      child: ListTile(
        title: FormBuilderTextField(
          readOnly: true,
          name: "profileMobileField",
          controller: widget.mobileCtrl,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          enableInteractiveSelection: false,
          maxLines: 1,
          style: PackageListHead.textFieldStyleWithoutArabWithColor(
              context,
              widget.colorCode != ""
                  ? ColorData.toColor(widget.colorCode)
                  : ColorData.primaryTextColor),
          decoration: InputDecoration(
            enabled: true,
            labelText: widget.customLabelString,
            border: underLineShow(),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            suffixIcon: null,
            contentPadding: EdgeInsets.all(5.0),
            labelStyle: PackageListHead.textFieldStyles(context, false),
          ),
        ),
      ),
    );
  }

  underLineShow() {
    if (widget.isPageFromProfileNonEditable) {
      return InputBorder.none;
    } else if (elevationPoint == 5.0) {
      return InputBorder.none;
    }
  }
}
