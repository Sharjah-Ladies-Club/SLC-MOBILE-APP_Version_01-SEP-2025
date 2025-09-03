import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/custom_drop_down/custom_facility_list_show_dialog.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/facility_response.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/utils/constant.dart';

// ignore: must_be_immutable
class CustomDropdownStateful extends StatefulWidget {
  Function _onTap;
  List<FacilityResponse> facilityResponseList;
  final double facilityViewHeight;
  int selectedFacilityId = 0;

  CustomDropdownStateful(this._onTap, this.facilityResponseList,
      {this.facilityViewHeight, this.selectedFacilityId});

  @override
  DropdownState createState() =>
      DropdownState(selectedFacilityId: this.selectedFacilityId);
}

class DropdownState extends State<CustomDropdownStateful> {
  final formKey = new GlobalKey<FormState>();
  FacilityResponse selectedValue;
  DropdownState({this.selectedFacilityId});
  int selectedFacilityId = 0;
  String a;
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.facilityResponseList != null &&
        widget.facilityResponseList.length > 0) {
      if (selectedFacilityId == null || selectedFacilityId == 0) {
        selectedFacilityId =
            SPUtil.getInt(Constants.SELECTED_FACILITY_ID, defValue: 0);
      }
      if (selectedFacilityId > 0) {
        widget.facilityResponseList.forEach((facilityDetail) {
          if (facilityDetail.facilityId == selectedFacilityId) {
            selectedValue = facilityDetail;
          }
        });
      } else {
        selectedValue = widget.facilityResponseList[0];
      }
      textEditingController.text = selectedValue.facilityName;
      print("selected facility GGGG" + textEditingController.text);
    } else {
      textEditingController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (SPUtil.getBool(Constants.IS_FACILITY_LIST_RELOADED)) {
      if (widget.facilityResponseList != null &&
          widget.facilityResponseList.length > 0) {
        setState(() {
          selectedValue = widget.facilityResponseList[0];
          textEditingController.text = selectedValue.facilityName;
        });
      }
    }

//    double screenHeight = MediaQuery.of(context).size.height;
    double imageHeight = (widget.facilityViewHeight - 77) * (75 / 100.0);
    return Container(
      color: ColorData.whiteColor,
      key: Key(Random().nextInt(1000000).toString()),
      child: Column(
        children: <Widget>[
          CountryCodePicker(
            response: widget.facilityResponseList,
            onChanged: (country) => {
              SPUtil.putBool(Constants.IS_FACILITY_LIST_RELOADED, false),
              widget._onTap(country),
              setState(() {
                selectedValue = country;
                textEditingController.text = country.facilityName;
              }),
            },
            initialSelection:
                (selectedValue != null && selectedValue.facilityName != null)
                    ? selectedValue.facilityName
                    : "",
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
            textEditingController: textEditingController,
          ),
          Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Container(
                  height: imageHeight,
                  child: imageUI(
                    (selectedValue != null &&
                            selectedValue.facilityImageURL != null)
                        ? selectedValue.facilityImageURL
                        : '',
                  )))
        ],
      ),
    );
  }

  Widget imageUI(String url) {
    return CachedNetworkImage(
      imageUrl: url != null ? url : ImageData.slcLogImage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        child: Center(
          child: SizedBox(
              height: 30.0, width: 30.0, child: CircularProgressIndicator()),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
