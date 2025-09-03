import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/strings.dart';
// import 'package:slc/model/facility_item.dart';

// ignore: must_be_immutable
class CustomGiftCardCategoryComponent extends StatefulWidget {
  Function selectedFunction;
  final TextStyle textStyle;
  TextEditingController categoryController;
  String isEditBtnEnabled;
  List<GiftCardCategory> categoryResponse = []; //List<GiftCardCategory>();
  String label = "";

  CustomGiftCardCategoryComponent(
      {this.selectedFunction,
      this.categoryController,
      this.isEditBtnEnabled,
      this.textStyle,
      this.categoryResponse,
      this.label,
      Key key})
      : super(key: key);

  @override
  _CustomGiftCardCategoryComponentState createState() =>
      _CustomGiftCardCategoryComponentState();
}

class _CustomGiftCardCategoryComponentState
    extends State<CustomGiftCardCategoryComponent> {
  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();
    widget.categoryController.addListener(() {
      if (widget.categoryController.text != "") elevationPoint = 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: categoryForm(),
    );
  }

  Future<Widget> getGiftCardCategoryDDList() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // debugPrint(
          //     " elivery address" + widget.categoryResponse.length.toString());
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.categoryResponse.length * 25.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.categoryResponse.length,
                itemBuilder: (BuildContext context, int i) {
                  return Visibility(
                      visible: true,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          onSelection(widget.categoryResponse[i]);
                        },
                        child: Container(
                            height: 35.0,
                            padding: EdgeInsets.only(top: 10.0),
                            child: PackageListHead.genderNationalityPicker(
                                context,
                                widget.categoryResponse[i].categoryName)),
                      ));
                },
              ),
            ),
          );
        });
  }

  onSelection(GiftCardCategory val) {
    widget.categoryController.text = val.categoryName;
    elevationPoint = 5.0;
    widget.selectedFunction(val);
    setState(() {});
  }

  Widget categoryForm() {
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
              getGiftCardCategoryDDList();
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
            name: "category",
            controller: widget.categoryController,
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
      child: Icon(Icons.card_giftcard, color: ColorData.inActiveIconColor),
    );
  }
}
