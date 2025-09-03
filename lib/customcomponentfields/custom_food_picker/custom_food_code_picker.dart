import 'package:flutter/material.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/custom_food_picker/custom_food_code.dart';
import 'package:slc/customcomponentfields/custom_food_picker/custom_food_selection_dialog.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';

// ignore: must_be_immutable
class FoodCodePicker extends StatefulWidget {
  final ValueChanged<FoodCode> onChanged;

  //Exposed new method to get the initial information of the food
  final ValueChanged<FoodCode> onInit;
  final String initialSelection;
  final List<String> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool showFoodOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final WidgetBuilder emptySearchBuilder;
  final List<FoodCode> codes;
  final Function(FoodCode) builder;

  /// shows the name of the food instead of the dialcode
  final bool showOnlyFoodWhenClosed;

  /// aligns the flag and the Text left
  ///
  /// additionally this option also fills the available space of the widget.
  /// this is especially usefull in combination with [showOnlyFoodWhenClosed],
  /// because longer foodnames are displayed in one line
  final bool alignLeft;

  /// shows the flag
  final bool showFlag;

  /// contains the food codes to load only the specified countries.
  final List<String> foodFilter;

  bool isFoodCodeReadOnly;

  FoodCodePicker(
      {this.onChanged,
      this.onInit,
      this.initialSelection,
      this.favorite = const [],
      this.foodFilter = const [],
      this.textStyle,
      this.padding = const EdgeInsets.all(0.0),
      this.showFoodOnly = false,
      this.searchDecoration = const InputDecoration(),
      this.searchStyle,
      this.emptySearchBuilder,
      this.showOnlyFoodWhenClosed = false,
      this.alignLeft = false,
      this.showFlag = true,
      this.builder,
      this.isFoodCodeReadOnly = false,
      this.codes = const []});

  @override
  State<StatefulWidget> createState() {
    return new _FoodCodePickerState(getFoodCode());
  }

  getFoodCode() {
    // List<Map> jsonList = [];

    List<FoodCode> elements = codes;
//     jsonList
//         .map((s) => FoodCode(
//               mealName: s['mealName'],
//               id: s['id'],
//               calorie: s['calorie'],
// //              flagUri: 'flags/${s['code'].toLowerCase()}.png',
//             ))
//         .toList();

    if (foodFilter.length > 0) {
      elements =
          elements.where((c) => foodFilter.contains(c.mealName)).toList();
    }

    return elements;
  }
}

class _FoodCodePickerState extends State<FoodCodePicker> {
  FoodCode selectedItem;
  List<FoodCode> elements = [];
  List<FoodCode> favoriteElements = [];

  //ProgressBarHandler _handler;

  _FoodCodePickerState(this.elements);

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
                  (widget.showOnlyFoodWhenClosed
                      ? selectedItem.toString()
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
      selectedItem.mealName = widget.initialSelection;
    }

    //Change added: get the initial entered food information
    _onInit(selectedItem);

    super.initState();
  }

  Future<void> _showSelectionDialog() async {
    if (!widget.isFoodCodeReadOnly) {
      // List<Map> jsonList = [];

      List<FoodCode> elements = widget.codes;
//       jsonList
//           .map((s) => FoodCode(
//                 id: s['id'],
//                 mealName: s['mealName'],
// //              code: s['code'],
//                 calorie: s['calorie'],
// //              flagUri: 'flags/${s['code'].toLowerCase()}.png',
//               ))
//           .toList();

      showDialog(
        context: context,
        builder: (_) => FoodSelectionDialog(elements, favoriteElements,
            showFoodOnly: widget.showFoodOnly,
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

  void _publishSelection(FoodCode e) {
    if (widget.onChanged != null) {
      widget.onChanged(e);
    }
  }

  void _onInit(FoodCode initialData) {
    if (widget.onInit != null) {
      widget.onInit(initialData);
    }
  }
}
