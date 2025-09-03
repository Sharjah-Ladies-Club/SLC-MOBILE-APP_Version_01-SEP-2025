import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/strings.dart';

// ignore: must_be_immutable
class CustomActiveFacilityComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController facilityController;
  String isEditBtnEnabled;
  List<ActiveFacilityViewDto> facilityResponse =
      []; //List<ActiveFacilityViewDto>();
  String label = "";

  CustomActiveFacilityComponent(
      {this.selectedFunction,
      this.facilityController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.facilityResponse,
      this.label,
      Key key});

  @override
  _CustomActiveFacilityComponentState createState() =>
      _CustomActiveFacilityComponentState();
}

class _CustomActiveFacilityComponentState
    extends State<CustomActiveFacilityComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.facilityController.addListener(() {
      if (widget.facilityController.text != "") elevationPoint = 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: voucherForm(),
    );
  }

  Future<Widget> getDeliveryDDList() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // debugPrint(
          //     " elivery address" + widget.facilityResponse.length.toString());
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.facilityResponse.length * 25.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.facilityResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return Visibility(
                      visible: true,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          onSelection(widget.facilityResponse[i]);
                        },
                        child: Container(
                            height: 35.0,
                            padding: EdgeInsets.only(top: 10.0),
                            child: PackageListHead.genderNationalityPicker(
                                context,
                                widget.facilityResponse[i].facilityName)),
                      ));
                },
              ),
            ),
          );
        });
  }

  onSelection(ActiveFacilityViewDto val) {
    widget.facilityController.text = val.facilityName;
    elevationPoint = 5.0;
    widget.selectedFunction(val);
    setState(() {});
  }

  Widget voucherForm() {
    // debugPrint("Coming in");
    return Container(
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            // debugPrint(" on tap " +
            //     widget.isEditBtnEnabled.toString() +
            //     " " +
            //     Strings.ProfileCallState.toString());
            if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
              getDeliveryDDList();
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
            readOnly: false,
            name: "voucher",
            controller: widget.facilityController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enableInteractiveSelection: false,
            // key: UniqueKey(),
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
      child: Icon(CommonIcons.user_one, color: ColorData.inActiveIconColor),
    );
  }
}
