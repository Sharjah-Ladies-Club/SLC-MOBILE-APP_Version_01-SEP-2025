import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/model/facility_item.dart';

// ignore: must_be_immutable
class CustomDeliveryChargesComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController deliveryController;
  String isEditBtnEnabled;
  List<DeliveryCharges> deliveryResponse = []; //List<DeliveryCharges>();
  String label = "";

  CustomDeliveryChargesComponent(
      {this.selectedFunction,
      this.deliveryController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.deliveryResponse,
      this.label,
      Key key})
      : super(key: key);

  @override
  _CustomDeliveryChargesComponentState createState() =>
      _CustomDeliveryChargesComponentState();
}

class _CustomDeliveryChargesComponentState
    extends State<CustomDeliveryChargesComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.deliveryController.addListener(() {
      if (widget.deliveryController.text != "") elevationPoint = 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AddressForm(),
    );
  }

  Future<Widget> getDeliveryDDList() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.deliveryResponse.length * 25.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.deliveryResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return Visibility(
                      visible: widget.deliveryResponse[i].cityName != 'Pickup',
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          onSelection(widget.deliveryResponse[i]);
                        },
                        child: Container(
                            height: 35.0,
                            padding: EdgeInsets.only(top: 10.0),
                            child: PackageListHead.genderNationalityPicker(
                                context, widget.deliveryResponse[i].cityName)),
                      ));
                },
              ),
            ),
          );
        });
  }

  onSelection(DeliveryCharges val) {
    widget.deliveryController.text = val.cityName;
    elevationPoint = 5.0;
    widget.selectedFunction(val);
    setState(() {});
  }

  Widget AddressForm() {
    return Container(
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          onTap: () async {
            // FocusScope.of(context).requestFocus(new FocusNode());
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
            readOnly: true,
            name: "citydetails",
            controller: widget.deliveryController,
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
      child: Icon(Icons.location_city, color: ColorData.inActiveIconColor),
    );
  }
}
