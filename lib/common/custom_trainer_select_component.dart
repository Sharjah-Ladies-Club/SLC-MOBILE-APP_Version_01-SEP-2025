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
class CustomTrainerComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController trainerController;
  String isEditBtnEnabled;
  List<Trainers> trainerResponse = []; //List<Trainers>();
  String label = "";

  CustomTrainerComponent(
      {this.selectedFunction,
      this.trainerController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.trainerResponse,
      this.label,
      Key key})
      : super(key: key);

  @override
  _CustomTrainerComponentState createState() => _CustomTrainerComponentState();
}

class _CustomTrainerComponentState extends State<CustomTrainerComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.trainerController.addListener(() {
      if (widget.trainerController.text != "") elevationPoint = 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: trainerForm(),
    );
  }

  Future<Widget> getTrainerDDList() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.trainerResponse.length * 25.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.trainerResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () {
                      Get.back();
                      onSelection(widget.trainerResponse[i]);
                    },
                    child: Container(
                        height: 35.0,
                        padding: EdgeInsets.only(top: 10.0),
                        child: PackageListHead.genderNationalityPicker(
                            context, widget.trainerResponse[i].trainer)),
                  );
                },
              ),
            ),
          );
        });
  }

  onSelection(Trainers val) {
    widget.trainerController.text = val.trainer;
    elevationPoint = 5.0;
    widget.selectedFunction(val);
    setState(() {});
  }

  Widget trainerForm() {
    return Container(
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
              getTrainerDDList();
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
            name: "trainer",
            controller: widget.trainerController,
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
