import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/custom_country_code_picker/custom_country_codes.dart';
import 'package:slc/customcomponentfields/custom_drop_down/custom_survey_selection_dialog.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/country.dart';
import 'package:slc/model/facility_response.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';

// ignore: must_be_immutable
class CountryCodePicker extends StatefulWidget {
  final ValueChanged<FacilityResponse> onChanged;
  final ValueChanged<FacilityResponse> onInit;
  final List<FacilityResponse> response;
  final String initialSelection;
  final List<String> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final WidgetBuilder emptySearchBuilder;
  final Function(FacilityResponse) builder;
  final bool showOnlyCountryWhenClosed;
  final bool alignLeft;
  final bool showFlag;
  final List<String> countryFilter;
  TextEditingController textEditingController;

  CountryCodePicker({
    this.onChanged,
    this.onInit,
    this.response,
    this.initialSelection,
    this.favorite = const [],
    this.countryFilter = const [],
    this.textStyle,
    this.padding = const EdgeInsets.all(0.0),
    this.showCountryOnly = false,
    this.searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.emptySearchBuilder,
    this.showOnlyCountryWhenClosed = false,
    this.alignLeft = false,
    this.showFlag = true,
    this.builder,
    this.textEditingController,
  });

  @override
  State<StatefulWidget> createState() {
    return new _CountryCodePickerState(response,
        textEditingController: textEditingController);
  }
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  FacilityResponse selectedItem;
  List<FacilityResponse> elements = [];
  List<FacilityResponse> favoriteElements = [];

  //ProgressBarHandler _handler;
  TextEditingController textEditingController;

  _CountryCodePickerState(List<FacilityResponse> t,
      {this.textEditingController}) {
    elements.clear();
    elements = t;
  }

  @override
  Widget build(BuildContext context) {
    Widget _widget;
    if (widget.builder != null)
      _widget = InkWell(
        onTap: _showSelectionDialog,
        child: widget.builder(selectedItem),
      );
    else {
      _widget = GestureDetector(
          onTap: _showSelectionDialog,
          child: Card(
            margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              height: 50.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 2.0, left: 10.0, right: 5.0),
                      child: Stack(
                        children: <Widget>[
                          new TextField(
                            readOnly: true,
                            controller: textEditingController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            enableInteractiveSelection: false,
                            maxLines: 1,
                            style:
                                PackageListHead.textFieldStyles(context, false),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0.0),
                              labelStyle: PackageListHead.textFieldStyles(
                                  context, true),
                            ),
                          ),
                          /*Fake onClick listener on above readonly textField*/
                          GestureDetector(
                            child: Container(
                              color: Colors.transparent,
                            ),
                            onTap: _showSelectionDialog,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        Localizations.localeOf(context).languageCode == "en"
                            ? EdgeInsets.only(right: 20.0)
                            : EdgeInsets.only(left: 20.0),
                    child: Icon(CommonIcons.dropdown,
                        size: 12, color: ColorData.blackColor),
                  ),
                ],
              ),
            ),
          ));
    }
    return _widget;
  }

  @override
  initState() {
    textEditingController.addListener(() {});
    super.initState();
  }

  Future getDB() async {
    var db = new DatabaseHelper();
    var a = await db.getContentByCID(TableDetails.CID_COUNTRY);

    if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
            (Constants.LANGUAGE_ENGLISH) ||
        SPUtil.getInt(Constants.CURRENT_LANGUAGE) == 0) {
      codes.clear();
      Country countryResponseL = Country.fromJson(jsonDecode(a.englishContent));
      CountryRes countryResponse =
          CountryRes.fromJson(jsonDecode(countryResponseL.statusMsg));
      codes.addAll(countryResponse.response.map((map) => map));
      print(countryResponse);
    } else if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
        Constants.LANGUAGE_ARABIC) {
      codes.clear();

      Country countryResponseL = Country.fromJson(jsonDecode(a.arabicContent));

      CountryRes countryResponse =
          CountryRes.fromJson(jsonDecode(countryResponseL.statusMsg));
      codes.addAll(countryResponse.response.map((map) => map));
      print(countryResponse);
    }
  }

  Future<void> _showSelectionDialog() async {
    return showDialog(
      context: context,
      builder: (_) => SelectionDialog(elements, favoriteElements,
          showCountryOnly: widget.showCountryOnly,
          emptySearchBuilder: widget.emptySearchBuilder,
          searchDecoration: widget.searchDecoration,
          searchStyle: TextStyle(
            fontFamily: tr("currFontFamilyEnglishOnly"),
            color: ColorData.primaryTextColor,
          ),
          showFlag: widget.showFlag),
    ).then((e) {
      if (e != null) {
        if (mounted)
          setState(() {
            selectedItem = e;
          });

        _publishSelection(e);
      }
    });
  }

  void _publishSelection(FacilityResponse e) {
    if (widget.onChanged != null) {
      widget.onChanged(e);
    }
  }

//  void _onInit(FacilityResponse initialData) {
//    if (widget.onInit != null) {
//      widget.onInit(initialData);
//    }
//  }
}
