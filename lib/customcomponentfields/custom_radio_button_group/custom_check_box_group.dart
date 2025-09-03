import 'package:circle_checkbox/redev_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:slc/model/survey_answer.dart';

class CheckboxGroup extends StatefulWidget {
  final List<SurveyAnswer> labels;
  final List<String> checked;
  final List<String> disabled;
  final void Function(bool isChecked, int eventAnswerId, int index) onChange;
  final void Function(List<String> selected) onSelected;
  final TextStyle labelStyle;
  final GroupedButtonsOrientation orientation;
  final Widget Function(CircleCheckbox checkBox, Text label, int index)
      itemBuilder;
  final Color activeColor;
  final Color checkColor;
  final bool tristate;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  CheckboxGroup({
    Key key,
    @required this.labels,
    this.checked,
    this.disabled,
    this.onChange,
    this.onSelected,
    this.labelStyle = const TextStyle(),
    this.activeColor,
    this.checkColor = const Color(0xFFFFFFFF),
    this.tristate = false,
    this.orientation = GroupedButtonsOrientation.VERTICAL,
    this.itemBuilder,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(0.0),
  }) : super(key: key);

  @override
  CheckboxGroupState createState() => CheckboxGroupState();
}

class CheckboxGroupState extends State<CheckboxGroup> {
  List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    _selected = widget.checked ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.checked != null) {
      _selected = [];
      _selected.addAll(widget.checked);
    }

    List<Widget> content = [];

    for (int i = 0; i < widget.labels.length; i++) {
      CircleCheckbox cb = CircleCheckbox(
        value: _selected.contains(widget.labels.elementAt(i).answer),
        onChanged: (widget.disabled != null &&
                widget.disabled.contains(widget.labels.elementAt(i).answer))
            ? null
            : (bool isChecked) => onChanged(isChecked, i),
        checkColor: widget.checkColor,
        activeColor:
            widget.activeColor ?? Theme.of(context).toggleableActiveColor,
        tristate: widget.tristate,
      );

      Text t = Text(widget.labels.elementAt(i).answer,
          style: (widget.disabled != null &&
                  widget.disabled.contains(widget.labels.elementAt(i)))
              ? widget.labelStyle.apply(color: Theme.of(context).disabledColor)
              : widget.labelStyle);

      if (widget.itemBuilder != null)
        content.add(widget.itemBuilder(cb, t, i));
      else {
        if (widget.orientation == GroupedButtonsOrientation.VERTICAL) {
          content.add(Row(children: <Widget>[
            SizedBox(width: 12.0),
            cb,
            SizedBox(width: 5.0),
            t,
          ]));
        } else {
          content.add(Column(children: <Widget>[
            cb,
            SizedBox(width: 12.0),
            t,
          ]));
        }
      }
    }

    return widget.orientation == GroupedButtonsOrientation.VERTICAL
        ? Column(
            children: content,
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        : Row(children: content);
  }

  void onChanged(bool isChecked, int i) {
    bool isAlreadyContained =
        _selected.contains(widget.labels.elementAt(i).answer);

    if (mounted) {
      setState(() {
        if (!isChecked && isAlreadyContained) {
          _selected.remove(widget.labels.elementAt(i).answer);
        } else if (isChecked && !isAlreadyContained) {
          _selected.clear();
          _selected.add(widget.labels.elementAt(i).answer);
        }

        if (widget.onChange != null)
          widget.onChange(isChecked, widget.labels.elementAt(i).answerId, i);
        if (widget.onSelected != null) widget.onSelected(_selected);
      });
    }
  }
}
