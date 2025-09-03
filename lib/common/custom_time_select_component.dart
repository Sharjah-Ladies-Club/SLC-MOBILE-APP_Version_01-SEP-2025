import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
// import 'package:slc/customcomponentfields/custom_list_tile_dropdown.dart'
//     as prefix0;
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/strings.dart';
// import 'package:slc/model/booking_timetable.dart';

// ignore: must_be_immutable
class CustomTimeComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController timerController;
  String isEditBtnEnabled;
  List<String> timeselResponse = []; //List<String>();
  String label = "";

  CustomTimeComponent(
      {this.selectedFunction,
      this.timerController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.timeselResponse,
      this.label,
      Key key})
      : super(key: key);

  @override
  _CustomTimeComponentState createState() => _CustomTimeComponentState();
}

class _CustomTimeComponentState extends State<CustomTimeComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.timerController.addListener(() {
      if (widget.timerController.text != "") elevationPoint = 5.0;
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
              height: widget.timeselResponse.length * 25.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.timeselResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () {
                      Get.back();
                      onSelection(widget.timeselResponse[i]);
                    },
                    child: Container(
                        height: 35.0,
                        padding: EdgeInsets.only(top: 10.0),
                        child: PackageListHead.genderNationalityPicker(
                            context, widget.timeselResponse[i])),
                  );
                },
              ),
            ),
          );
        });
  }

  onSelection(String val) {
    widget.timerController.text = val;
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
            name: "timesel",
            controller: widget.timerController,
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
      child: Icon(Icons.timer, color: ColorData.inActiveIconColor),
    );
  }
}

class CustomTimeWithIconComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController timerController;
  String isEditBtnEnabled;
  List<String> timeselResponse = []; //List<String>();
  String label = "";
  String imagePath;

  CustomTimeWithIconComponent(
      {this.selectedFunction,
      this.timerController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.timeselResponse,
      this.label,
      this.imagePath,
      Key key})
      : super(key: key);

  @override
  _CustomTimeWithIconComponentState createState() =>
      _CustomTimeWithIconComponentState();
}

class _CustomTimeWithIconComponentState
    extends State<CustomTimeWithIconComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.timerController.addListener(() {
      if (widget.timerController.text != "") elevationPoint = 5.0;
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
              height: widget.timeselResponse.length * 25.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.timeselResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () {
                      Get.back();
                      onSelection(widget.timeselResponse[i]);
                    },
                    child: Container(
                        height: 35.0,
                        padding: EdgeInsets.only(top: 10.0),
                        child: PackageListHead.genderNationalityPicker(
                            context, widget.timeselResponse[i])),
                  );
                },
              ),
            ),
          );
        });
  }

  onSelection(String val) {
    widget.timerController.text = val;
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
            name: "timesel",
            controller: widget.timerController,
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

  // prefixIconFn() {
  //   return Padding(
  //     padding: EdgeInsets.zero,
  //     child: Icon(Icons.timer, color: ColorData.inActiveIconColor),
  //   );
  // }

  prefixIconFn() {
    return Padding(
      padding: EdgeInsets.zero,
      child: widget.imagePath != null
          ? Image.asset(widget.imagePath, width: 30)
          : Icon(Icons.timer, color: ColorData.inActiveIconColor),
    );
  }
}
