import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/custom_aboutus_picker/custom_aboutus_code.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/custom_aboutus_picker/custom_aboutus_codes.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/custom_aboutus_picker/custom_aboutus_selection_dialog.dart';

// export 'custom_country_code.dart';

class NationalityCodePicker extends StatefulWidget {
  final ValueChanged<HearAboutResponse> onChanged;

  //Exposed new method to get the initial information of the country
  final ValueChanged<HearAboutResponse> onInit;
  final String initialSelection;
  final List<String> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final WidgetBuilder emptySearchBuilder;
  final Function(HearAboutResponse) builder;
  final TextEditingController nationalityController;

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
  final List<String> nationalityFilter;
  final String isEditBtnEnabled;

  NationalityCodePicker(
      {this.isEditBtnEnabled,
      this.onChanged,
      this.onInit,
      this.initialSelection,
      this.favorite = const [],
      this.nationalityFilter = const [],
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
      this.nationalityController});

  @override
  State<StatefulWidget> createState() {
    return new _NationalityCodePickerState(getCountryCode());
  }

  getCountryCode() {
    List<Map> jsonList = codes;

    List<HearAboutResponse> elements = jsonList
        .map((s) => HearAboutResponse(
              marketingSourceName: s['marketingSourceName'],
//              code: s['code'],
              // dialCode: s['dialCode'],
//              flagUri: 'flags/${s['code'].toLowerCase()}.png',
            ))
        .toList();

    if (nationalityFilter.length > 0) {
      elements = elements
          .where((c) => nationalityFilter.contains(c.marketingSourceName))
          .toList();
    }

    return elements;
  }
}

class _NationalityCodePickerState extends State<NationalityCodePicker> {
  HearAboutResponse selectedItem;
  List<HearAboutResponse> elements = [];
  List<HearAboutResponse> favoriteElements = [];

  double elevationPoint = 0.0;

  _NationalityCodePickerState(this.elements);

  Key key;

  @override
  void initState() {
    super.initState();
    widget.nationalityController.addListener(() {
      if (widget.nationalityController.text != null &&
          widget.nationalityController.text != "") {
        elevationPoint = 5.0;
        selectedItem = elements[0];
        selectedItem.marketingSourceName = widget.nationalityController.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int number = Random().nextInt(1000000000);
    key = PageStorageKey(number.toString());
    Widget _widget;
    if (widget.builder != null)
      _widget = InkWell(
        onTap: () {
          if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
            _showSelectionDialog();
          }
        },
        child: widget.builder(selectedItem),
      );
    else {
      // setState(() {
      if (selectedItem == null) {
        widget.nationalityController.text = "";
        elevationPoint = 0.0;
      } else if (selectedItem != null) {
        widget.nationalityController.text =
            selectedItem.toNationalityStringOnly();
        elevationPoint = 5.0;
      }

      setState(() {});

      // });
      _widget = TextButton(
        // padding: widget.padding,
        style: TextButton.styleFrom(
          padding: widget.padding,
        ),
        onPressed: () {
          if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
            _showSelectionDialog();
          }
        },
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
              child: Container(
                // padding: EdgeInsets.fromLTRB(5.0, 0, 15.0, 0),
                child: nationalityForm(),
              ),
            ),
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

  Future getDB() async {
    var db = new DatabaseHelper();
    var hearAboutDetailsList =
        await db.getContentByCID(TableDetails.CID_HEAR_ABOUT_US_LIST);
    // _handler.dismiss();
    List<HearAboutResponse> hearAboutResponse = [];
    if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
            (Constants.LANGUAGE_ENGLISH) ||
        SPUtil.getInt(Constants.CURRENT_LANGUAGE) == 0) {
      // codes.clear();
      // NationalityApiResponse HearAboutResponseL = NationalityApiResponse.fromJson(jsonDecode(a.englishContent));
      hearAboutResponse.clear();

      jsonDecode(jsonDecode(hearAboutDetailsList.englishContent)["statusMsg"])[
              "response"]
          .forEach(
              (f) => hearAboutResponse.add(new HearAboutResponse.fromJson(f)));
      print(hearAboutResponse);
    } else if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
        Constants.LANGUAGE_ARABIC) {
      // codes.clear();

      hearAboutResponse.clear();

      jsonDecode(jsonDecode(hearAboutDetailsList.arabicContent)["statusMsg"])[
              "response"]
          .forEach(
              (f) => hearAboutResponse.add(new HearAboutResponse.fromJson(f)));
    }
    return hearAboutResponse;
  }

  Future<void> _showSelectionDialog() async {
    List<HearAboutResponse> elements = await getDB();

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

  void _publishSelection(HearAboutResponse e) {
    if (widget.onChanged != null) {
      widget.onChanged(e);
    }
  }

//  void _onInit(HearAboutResponse initialData) {
//    if (widget.onInit != null) {
//      widget.onInit(initialData);
//    }
//  }

  Widget nationalityForm() {
    return Container(
      //  padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      //margin: EdgeInsets.only(bottom: 15.0),

      // height:65.0,
//  containerHeight == true ? 90.0 :
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          dense: true,
          minLeadingWidth: 0.0,
          leading: Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(left: 0.0)
                  : EdgeInsets.only(right: 5.0),
              child: prefixIconfn()),
          title: IgnorePointer(
              child: FormBuilderTextField(
            readOnly: true,
            name: "hearabout",
            controller: widget.nationalityController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            // inputFormatters: inputFormatterfn(_dialCode == '+971' ? 9 : 10),
            // focusNode: _focusNode,
            // autofocus: elevationPoint == 5.0?true:false,
            // onFieldSubmitted: (term){
            //   _fieldFocusChange(context, _focusNode, widget._customLabelString,term);
            //                 },
            enableInteractiveSelection: false,
            // obscureText: widget._defaultCountryCode == true
            // ? false
            // : _passwordObscureChange,
            maxLines: 1,
            // maxLength: mobileMaxLengthFn(),
            style: PackageListHead.textFieldStyleWithoutArab(context, false),
            decoration: InputDecoration(
              // filled: true,
              labelText: tr("hear"),
              // fillColor: ColorData.loginBackgroundColor,
              border: underLineShow(),
              // counterStyle: TextStyle(fontSize: 0.0),
              // labelStyle: TextStyle(color: themeStyle.primaryColor,),
              // focusColor: themeStyle.primaryColor,
              // hintText: '',
              // border: OutlineInputBorder(),
              suffixIcon: siffixIconfn(),
              contentPadding: EdgeInsets.all(5.0),
              labelStyle: (elevationPoint == 5.0)
                  ? PackageListHead.textFieldStyles(context, true)
                  : PackageListHead.textFieldStyles(context, false),
            ),
          )),
          // trailing: siffixIconfn(),
        ),
      ),
    );
  }

  siffixIconfn() {
    return IconButton(
      onPressed: () {
        //showDatePicker();
      },
      icon: Icon(CommonIcons.dropdown,
          size: 12, color: ColorData.inActiveIconColor),
    );
  }

  underLineShow() {
    if (elevationPoint == 5.0) {
      return InputBorder.none;
    }
  }

  prefixIconfn() {
    return IconButton(
      onPressed: () {
        //showDatePicker();
      },
      icon: Icon(CommonIcons.nationality, color: ColorData.inActiveIconColor),
    );
  }
}
