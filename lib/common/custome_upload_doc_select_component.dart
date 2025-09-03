import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../model/facility_item.dart';
import '../theme/colors.dart';
import '../theme/customIcons.dart';
import '../theme/styles.dart';
import '../utils/strings.dart';

class CustomUploadTypeComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController docTypeController;
  String isEditBtnEnabled;
  List<DocumentType> docTypeResponse = []; //List<EventType>();
  String label = "";
  String imagePath;

  CustomUploadTypeComponent(
      {this.selectedFunction,
      this.docTypeController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.docTypeResponse,
      this.label,
      this.imagePath,
      Key key})
      : super(key: key);

  @override
  _CustomUploadTypeComponentState createState() =>
      _CustomUploadTypeComponentState();
}

class _CustomUploadTypeComponentState extends State<CustomUploadTypeComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.docTypeController.addListener(() {
      if (widget.docTypeController.text != "") elevationPoint = 5.0;
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
              height: widget.docTypeResponse.length * 25.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.docTypeResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () {
                      Get.back();
                      onSelection(widget.docTypeResponse[i]);
                    },
                    child: Container(
                        height: 35.0,
                        padding: EdgeInsets.only(top: 10.0),
                        child: PackageListHead.genderNationalityPicker(context,
                            widget.docTypeResponse[i].otherMemberName)),
                  );
                },
              ),
            ),
          );
        });
  }

  onSelection(DocumentType val) {
    widget.docTypeController.text = val.otherMemberName;
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
            name: "docType",
            controller: widget.docTypeController,
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
          : Icon(Icons.upload, color: ColorData.inActiveIconColor),
    );
  }
}
