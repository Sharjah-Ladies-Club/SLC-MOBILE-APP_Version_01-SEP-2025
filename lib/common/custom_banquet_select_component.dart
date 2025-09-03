// // import 'dart:convert';
//
// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/strings.dart';

// ignore: must_be_immutable
class CustomBanquetComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController hallController;
  String isEditBtnEnabled;
  List<ImageVRDto> hallResponse = []; // List<Venue>();
  String label = "";

  CustomBanquetComponent(
      {this.selectedFunction,
      this.hallController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.hallResponse,
      this.label,
      Key key})
      : super(key: key);

  @override
  _CustomBanquetComponentState createState() => _CustomBanquetComponentState();
}

class _CustomBanquetComponentState extends State<CustomBanquetComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.hallController.addListener(() {
      if (widget.hallController.text != "") elevationPoint = 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: hallForm(),
    );
  }

  Future<Widget> getBanquetDDList() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.hallResponse.length * 25.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.hallResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () {
                      Get.back();
                      onSelection(widget.hallResponse[i]);
                    },
                    child: Container(
                        height: 35.0,
                        padding: EdgeInsets.only(top: 10.0),
                        child: PackageListHead.genderNationalityPicker(
                            context, widget.hallResponse[i].imageName)),
                  );
                },
              ),
            ),
          );
        });
  }

  onSelection(ImageVRDto val) {
    widget.hallController.text = val.imageName;
    elevationPoint = 5.0;
    widget.selectedFunction(val);
    setState(() {});
  }

  Widget hallForm() {
    return Container(
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
              getBanquetDDList();
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
            name: "venue",
            controller: widget.hallController,
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
