import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_codes.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_selection_dialog.dart';
// import 'package:slc/customcomponentfields/custom_list_tile_dropdown.dart'
//     as prefix0;
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';

class NationalityCodePicker extends StatefulWidget {
  final ValueChanged<NationalityResponse> onChanged;

  //Exposed new method to get the initial information of the country
  final ValueChanged<NationalityResponse> onInit;
  final String initialSelection;
  final List<String> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final WidgetBuilder emptySearchBuilder;
  final Function(NationalityResponse) builder;
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
      this.nationalityController,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _NationalityCodePickerState(getCountryCode());
  }

  getCountryCode() {
    List<Map> jsonList = codes;

    List<NationalityResponse> elements = jsonList
        .map((s) => NationalityResponse(
              nationalityName: s['nationalityName'],
            ))
        .toList();

    if (nationalityFilter.length > 0) {
      elements = elements
          .where((c) => nationalityFilter.contains(c.nationalityName))
          .toList();
    }

    return elements;
  }
}

class _NationalityCodePickerState extends State<NationalityCodePicker> {
  NationalityResponse selectedItem;
  List<NationalityResponse> elements = [];
  List<NationalityResponse> favoriteElements = [];

  double elevationPoint = 0.0;

  _NationalityCodePickerState(this.elements);

  @override
  void initState() {
    super.initState();
    widget.nationalityController.addListener(() {
      if (widget.nationalityController.text != null &&
          widget.nationalityController.text != "") {
        elevationPoint = 5.0;
        selectedItem = elements[0];
        selectedItem.nationalityName = widget.nationalityController.text;
      } else {
        elevationPoint = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _widget;
    if (widget.builder != null)
      _widget = InkWell(
        onTap: () {
          if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
            _showSelectionDialog();
            FocusScope.of(context).requestFocus(new FocusNode());
          }
        },
        child: widget.builder(selectedItem),
      );
    else {
      _widget = TextButton(
        style: TextButton.styleFrom(
            foregroundColor: ColorData.colorBlue, padding: EdgeInsets.zero),
        //padding: widget.padding,
        onPressed: () {
          if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
            _showSelectionDialog();
            FocusScope.of(context).requestFocus(new FocusNode());
          }
        },
        child: Container(
          child: nationalityForm(),
        ),
      );
    }
    return _widget;
  }

  verticalLine() {
    return Container(
      margin: Localizations.localeOf(context).languageCode == "ar"
          ? EdgeInsets.only(top: 5.0, bottom: 5.0, left: 7.0, right: 5.0)
          : EdgeInsets.only(top: 5.0, bottom: 5.0, left: 7.0, right: 5.0),
      child: VerticalDivider(width: 2, color: Colors.black),
    );
  }

  Future getDB() async {
    var db = new DatabaseHelper();
    var nationalityDetailsList =
        await db.getContentByCID(TableDetails.CID_NATIONALITY);
    List<NationalityResponse> nationalityResponse =
        []; //List<NationalityResponse>();
    if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
            (Constants.LANGUAGE_ENGLISH) ||
        SPUtil.getInt(Constants.CURRENT_LANGUAGE) == 0) {
      nationalityResponse.clear();

      jsonDecode(jsonDecode(
              nationalityDetailsList.englishContent)["statusMsg"])["response"]
          .forEach((f) =>
              nationalityResponse.add(new NationalityResponse.fromJson(f)));
      print(nationalityResponse);
    } else if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
        Constants.LANGUAGE_ARABIC) {
      nationalityResponse.clear();

      jsonDecode(jsonDecode(nationalityDetailsList.arabicContent)["statusMsg"])[
              "response"]
          .forEach((f) =>
              nationalityResponse.add(new NationalityResponse.fromJson(f)));
    }
    return nationalityResponse;
  }

  Future<void> _showSelectionDialog() async {
    List<NationalityResponse> elements = await getDB();

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

  void _publishSelection(NationalityResponse e) {
    if (widget.onChanged != null) {
      widget.onChanged(e);
      if (selectedItem == null) {
        widget.nationalityController.text = "";
        elevationPoint = 0.0;
      } else if (selectedItem != null) {
        widget.nationalityController.text =
            selectedItem.toNationalityStringOnly();
        elevationPoint = 5.0;
      }
      setState(() {});
    }
  }

  // ignore: unused_element
  void _onInit(NationalityResponse initialData) {
    if (widget.onInit != null) {
      widget.onInit(initialData);
    }
  }

  Widget nationalityForm() {
    return Container(
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.zero,
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
              child: prefixIconFn()),
          title: IgnorePointer(
              child: FormBuilderTextField(
            readOnly: true,
            name: "nationality",
            controller: widget.nationalityController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enableInteractiveSelection: false,
            maxLines: 1,
            style: PackageListHead.textFieldStyles(context, false),
            decoration: InputDecoration(
              labelText: tr("nationalityLabel"),
              border: underLineShow(),
              suffixIcon: suffixIconFn(),
              contentPadding: EdgeInsets.only(
                  left: 5.0, right: 15.0, top: 10.0, bottom: 10.0),
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
      child: Icon(CommonIcons.nationality, color: ColorData.inActiveIconColor),
    );
  }
}
