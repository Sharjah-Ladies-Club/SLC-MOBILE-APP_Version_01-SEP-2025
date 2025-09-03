import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/custom_aboutus_picker/custom_aboutus_code.dart';

class SelectionDialog extends StatefulWidget {
  final List<HearAboutResponse> elements;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final WidgetBuilder emptySearchBuilder;
  final bool showFlag;

  final List<HearAboutResponse> favoriteElements;

  SelectionDialog(this.elements, this.favoriteElements,
      {Key key,
      this.showCountryOnly,
      this.emptySearchBuilder,
      InputDecoration searchDecoration = const InputDecoration(),
      this.searchStyle,
      this.showFlag})
      : assert(searchDecoration != null, 'searchDecoration must not be null!'),
        this.searchDecoration =
            searchDecoration.copyWith(prefixIcon: Icon(Icons.search)),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  List<HearAboutResponse> filteredElements;
  MaskedTextController searchController =
      new MaskedTextController(mask: Strings.maskEngValidationStr);

  @override
  Widget build(BuildContext context) {
    if (Localizations.localeOf(context).languageCode == "ar") {
      searchController.updateMask(Strings.maskArbValidationStr);
    } else {
      searchController.updateMask(Strings.maskEngValidationStr);
    }

    return SimpleDialog(
      title: Column(
        children: <Widget>[
          TextField(
            controller: searchController,
            style: widget.searchStyle,
            decoration: widget.searchDecoration,
            onChanged: _filterElements,
          ),
        ],
      ),
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: filteredElements.length == 0
                ? 35.0
                : filteredElements.length * 35.0 >
                        MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.height / 3.3)
                    ? MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.height / 3.3)
                    : filteredElements.length * 35.0,
            child: ListView(
                children: [
              widget.favoriteElements.isEmpty
                  ? const DecoratedBox(decoration: BoxDecoration())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[]
                        ..addAll(widget.favoriteElements
                            .map(
                              (f) => SimpleDialogOption(
                                child: _buildOption(f),
                                onPressed: () {
                                  _selectItem(f);
                                },
                              ),
                            )
                            .toList())
                        ..add(const Divider())),
            ]..addAll(filteredElements.isEmpty
                    ? [_buildEmptySearchWidget(context)]
                    : filteredElements.map((e) => SimpleDialogOption(
                          key: Key(e.toLongString()),
                          child: _buildOption(e),
                          onPressed: () {
                            _selectItem(e);
                          },
                        ))))),
      ],
    );
  }

  Widget _buildOption(HearAboutResponse e) {
    return Container(
      width: 400,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: PackageListHead.genderNationalityPicker(
                context, e.toNationalityStringOnly()),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder(context);
    }

    return Center(
        child: PackageListHead.genderNationalityPicker(
            context, tr("noDataFound")));
  }

  @override
  void initState() {
    filteredElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    s = searchController.text.toUpperCase();
    setState(() {
      filteredElements = widget.elements
          .where((e) => e.marketingSourceName.toUpperCase().contains(s))
          .toList();
    });
  }

  void _selectItem(HearAboutResponse e) {
    Navigator.pop(context, e);
  }
}
