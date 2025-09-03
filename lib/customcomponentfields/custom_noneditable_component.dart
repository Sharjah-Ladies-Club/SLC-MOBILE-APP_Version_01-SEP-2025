import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/common/colors.dart';
// import 'package:slc/customcomponentfields/custom_list_tile_dropdown.dart'
//     as prefix0;
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/strings.dart';

// ignore: must_be_immutable
class CustomNonEditableTextFieldComponent extends StatefulWidget {
//  String initialValue;
  Function selectedFunction;
  TextEditingController mobileCtrl;
  IconData customLeadIcon;
  String customLabelString;

  CustomNonEditableTextFieldComponent(
      {
//        this.initialValue,
      this.selectedFunction,
      this.mobileCtrl,
      this.customLeadIcon,
      this.customLabelString});

  @override
  _CustomNonEditableTextFieldComponentState createState() =>
      _CustomNonEditableTextFieldComponentState();
}

class _CustomNonEditableTextFieldComponentState
    extends State<CustomNonEditableTextFieldComponent> {
  double elevationPoint = 0.0;
  String todayDate =
      SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat();

  @override
  void initState() {
    widget.mobileCtrl.addListener(() {
      if (widget.mobileCtrl.text != Strings.txtMT) elevationPoint = 5.0;
    });
//    if (widget.initialValue == "" || widget.initialValue == null) {
//      elevationPoint = 0.0;
//    } else {
//      widget.mobileCtrl.text = widget.initialValue;
//      elevationPoint = 5.0;
//    }
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
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          dense: true,
          leading: prefixIconfn(),
          title: FormBuilderTextField(
            readOnly: true,
            name: "profileMobileField",
            controller: widget.mobileCtrl,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enableInteractiveSelection: false,
            maxLines: 1,
            style: PackageListHead.textFieldStyleWithoutArab(context, false),
            decoration: InputDecoration(
              enabled: true,
              labelText: widget.customLabelString,
              border: underLineShow(),
              suffixIcon: null,
              contentPadding: EdgeInsets.all(5.0),
              labelStyle: (elevationPoint == 5.0)
                  ? PackageListHead.textFieldStyles(context, true)
                  : PackageListHead.textFieldStyles(context, false),
            ),
          ),
        ),
      ),
    );
  }

  underLineShow() {
    if (elevationPoint == 5.0) {
      return InputBorder.none;
    }
  }

  prefixIconfn() {
    return IconButton(
      onPressed: () {},
      icon: Icon(widget.customLeadIcon, color: ColorData.inActiveIconColor),
    );
  }
}
