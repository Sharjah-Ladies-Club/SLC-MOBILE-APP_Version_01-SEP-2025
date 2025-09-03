import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/GenderResponse.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';

// ignore: must_be_immutable
class CustomGenderComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController genderController;
  String isEditBtnEnabled;

  CustomGenderComponent(
      {this.selectedFunction,
      this.genderController,
      this.isEditBtnEnabled,
      this.textStyle,
      Key key})
      : super(key: key);

  @override
  _CustomGenderComponentState createState() => _CustomGenderComponentState();
}

class _CustomGenderComponentState extends State<CustomGenderComponent> {
  List<GenderResponse> genderResponse = []; //List<GenderResponse>();
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.genderController.addListener(() {
      if (widget.genderController.text != "") elevationPoint = 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: genderForm(),
    );
  }

  Future getDB(stage) async {
    var db = new DatabaseHelper();
    var genderDetailsList = await db.getContentByCID(TableDetails.CID_GENDER);
    if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
            (Constants.LANGUAGE_ENGLISH) ||
        SPUtil.getInt(Constants.CURRENT_LANGUAGE) == 0) {
      genderResponse.clear();

      jsonDecode(jsonDecode(genderDetailsList.englishContent)["statusMsg"])[
              "response"]
          .forEach((f) => genderResponse.add(new GenderResponse.fromJson(f)));
    } else if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
        Constants.LANGUAGE_ARABIC) {
      genderResponse.clear();

      jsonDecode(jsonDecode(genderDetailsList.arabicContent)["statusMsg"])[
              "response"]
          .forEach((f) => genderResponse.add(new GenderResponse.fromJson(f)));
    }

    return genderResponse;
  }

  Future<Widget> getGenderDDList() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: genderResponse.length * 35.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: genderResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () {
                      Get.back();
                      onSelection(genderResponse[i]);
                    },
                    child: Container(
                        height: 35.0,
                        padding: EdgeInsets.only(top: 10.0),
                        child: PackageListHead.genderNationalityPicker(
                            context, genderResponse[i].genderName)),
                  );
                },
              ),
            ),
          );
        });
  }

  onSelection(val) {
    widget.genderController.text = val.genderName;
    elevationPoint = 5.0;
    widget.selectedFunction(val);
    setState(() {});
  }

  Widget genderForm() {
    return Container(
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
              genderResponse = await getDB("afterInitSate");
              getGenderDDList();
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
            name: "gender",
            controller: widget.genderController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enableInteractiveSelection: false,
            maxLines: 1,
            style: PackageListHead.textFieldStyles(context, false),
            decoration: InputDecoration(
              enabled: true,
              labelText: tr("genderLabelString"),
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

  // prefixIconFn() {
  //   return IconButton(
  //     onPressed: () {},
  //     icon: Icon(CommonIcons.user_one, color: ColorData.inActiveIconColor),
  //   );
  // }
  prefixIconFn() {
    return Padding(
      padding: EdgeInsets.zero,
      child: Icon(CommonIcons.user_one, color: ColorData.inActiveIconColor),
    );
  }

  Future<void> getGenderListFromDB(stage) async {
    genderResponse = await getDB(stage);
  }
}
