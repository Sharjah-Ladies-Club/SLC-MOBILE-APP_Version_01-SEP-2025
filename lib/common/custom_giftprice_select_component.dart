import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/strings.dart';

// ignore: must_be_immutable
class CustomGiftCardPriceComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController priceController;
  String isEditBtnEnabled;
  List<GiftCardItemsPrice> priceResponse = []; // List<GiftCardItemsPrice>();
  String label = "";

  CustomGiftCardPriceComponent(
      {this.selectedFunction,
      this.priceController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.priceResponse,
      this.label,
      Key key})
      : super(key: key);

  @override
  _CustomGiftCardPriceComponentState createState() =>
      _CustomGiftCardPriceComponentState();
}

class _CustomGiftCardPriceComponentState
    extends State<CustomGiftCardPriceComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.priceController.addListener(() {
      if (widget.priceController.text != "") elevationPoint = 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: priceForm(),
    );
  }

  Future<Widget> getGiftCardPriceDDList() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // debugPrint(
          //     " elivery address" + widget.priceResponse.length.toString());
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.priceResponse.length * 25.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.priceResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return Visibility(
                      visible: true,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          onSelection(widget.priceResponse[i]);
                        },
                        child: Container(
                            height: 35.0,
                            padding: EdgeInsets.only(top: 10.0),
                            child: PackageListHead.genderNationalityPicker(
                                context,
                                widget.priceResponse[i].price.toString())),
                      ));
                },
              ),
            ),
          );
        });
  }

  onSelection(GiftCardItemsPrice val) {
    widget.priceController.text = val.price.toString();
    elevationPoint = 5.0;
    widget.selectedFunction(val);
    setState(() {});
  }

  Widget priceForm() {
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
              getGiftCardPriceDDList();
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
            name: "price",
            controller: widget.priceController,
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
