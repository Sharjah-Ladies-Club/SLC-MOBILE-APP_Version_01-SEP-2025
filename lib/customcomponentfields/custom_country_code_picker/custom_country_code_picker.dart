import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/custom_country_code_picker/custom_country_code.dart';
import 'package:slc/customcomponentfields/custom_country_code_picker/custom_country_codes.dart';
import 'package:slc/customcomponentfields/custom_country_code_picker/custom_selection_dialog.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/country.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';

export 'custom_country_code.dart';

// ignore: must_be_immutable
class CountryCodePicker extends StatefulWidget {
  final ValueChanged<CountryCode> onChanged;

  //Exposed new method to get the initial information of the country
  final ValueChanged<CountryCode> onInit;
  final String initialSelection;
  final List<String> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final WidgetBuilder emptySearchBuilder;
  final Function(CountryCode) builder;

  /// shows the name of the country instead of the dialcode
  final bool showOnlyCountryWhenClosed;

  /// aligns the flag and the Text left
  ///
  /// additionally this option also fills the available space of the widget.
  /// this is especially usefull in combination with [showOnlyCountryWhenClosed],
  /// because longer countrynames are displayed in one line
  final bool alignLeft;

  /// shows the flag
  final bool showFlag;

  /// contains the country codes to load only the specified countries.
  final List<String> countryFilter;

  bool isCountryCodeReadOnly;

  CountryCodePicker({
    this.onChanged,
    this.onInit,
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
    this.isCountryCodeReadOnly = false,
  });

  @override
  State<StatefulWidget> createState() {
    return new _CountryCodePickerState(getCountryCode());
  }

  getCountryCode() {
    List<Map> jsonList = codes;

    List<CountryCode> elements = jsonList
        .map((s) => CountryCode(
              countryName: s['countryName'],
//              code: s['code'],
              dialCode: s['dialCode'],
//              flagUri: 'flags/${s['code'].toLowerCase()}.png',
            ))
        .toList();

    if (countryFilter.length > 0) {
      elements =
          elements.where((c) => countryFilter.contains(c.dialCode)).toList();
    }

    return elements;
  }
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  CountryCode selectedItem;
  List<CountryCode> elements = [];
  List<CountryCode> favoriteElements = [];

  //ProgressBarHandler _handler;

  _CountryCodePickerState(this.elements);

  @override
  Widget build(BuildContext context) {
    Widget _widget;
    if (widget.builder != null)
      _widget = InkWell(
        onTap: _showSelectionDialog,
        child: widget.builder(selectedItem),
      );
    else {
      _widget = TextButton(
        // padding: widget.padding,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: widget.padding,
        ),
        onPressed: _showSelectionDialog,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(right: 10.0)
                  : EdgeInsets.only(left: 10.0),
              child: Icon(CommonIcons.dropdown,
                  size: 12, color: ColorData.inActiveIconColor),
            ),
            Flexible(
              fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
              child: Container(
                padding: const EdgeInsets.only(top: 2.0, left: 5.0, right: 5.0),
                child: Text(
                  (widget.showOnlyCountryWhenClosed
                      ? selectedItem.toCountryStringOnly()
                      : selectedItem.toString()),
                  // widget.initialSelection,
                  //style: widget.textStyle ?? Theme.of(context).textTheme.button,
                  style: PackageListHead.textFieldCountryCodeStyles(context),
                ),
              ),
            ),
            verticalLine(),
          ],
        ),
      );
    }
    return _widget;
  }

  verticalLine() {
    return Container(
      margin: Localizations.localeOf(context).languageCode == "ar"
          ? EdgeInsets.only(top: 5.0, bottom: 5.0, left: 25.0, right: 5.0)
          : EdgeInsets.only(top: 5.0, bottom: 5.0, left: 7.0, right: 5.0),
      child: VerticalDivider(width: 2, color: Colors.black),
    );
  }

  @override
  initState() {
    selectedItem = elements[0];
    if (widget.initialSelection != null) {
      selectedItem.dialCode = widget.initialSelection;
    }

    //Change added: get the initial entered country information
    _onInit(selectedItem);

    super.initState();
  }

  Future getDB() async {
    // _handler.show();
    var db = new DatabaseHelper();
    var a = await db.getContentByCID(TableDetails.CID_COUNTRY);
    // _handler.dismiss();
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
    if (!widget.isCountryCodeReadOnly) {
      await getDB();
      List<Map> jsonList = codes;

      List<CountryCode> elements = jsonList
          .map((s) => CountryCode(
                countryId: s['countryId'],
                countryName: s['countryName'],
//              code: s['code'],
                dialCode: s['dialCode'],
//              flagUri: 'flags/${s['code'].toLowerCase()}.png',
              ))
          .toList();

      showDialog(
        context: context,
        builder: (_) => SelectionDialog(elements, favoriteElements,
            showCountryOnly: widget.showCountryOnly,
            emptySearchBuilder: widget.emptySearchBuilder,
            searchDecoration: widget.searchDecoration,
            searchStyle: widget.searchStyle,
            showFlag: widget.showFlag),
      ).then((e) {
        if (e != null) {
          setState(() {
            selectedItem = e;
          });

          _publishSelection(e);
        }
      });
    }
  }

  void _publishSelection(CountryCode e) {
    if (widget.onChanged != null) {
      widget.onChanged(e);
    }
  }

  void _onInit(CountryCode initialData) {
    if (widget.onInit != null) {
      widget.onInit(initialData);
    }
  }
}
