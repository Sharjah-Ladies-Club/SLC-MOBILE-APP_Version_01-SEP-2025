import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

// ignore: must_be_immutable
class FacilityGroovinExpansionTile extends StatefulWidget {
  FacilityGroovinExpansionTile(
      {Key key,
      this.leading,
      this.title,
      this.subtitle,
      this.backgroundColor,
      this.defaultTrailingIconColor = Colors.grey,
      this.onExpansionChanged,
      this.boxDecoration,
      this.inkwellRadius,
      this.children = const <Widget>[],
      this.trailing,
      this.initiallyExpanded = false,
      this.btnIndex,
      this.selectedIndex,
      this.onTap,
      this.btn})
      : assert(initiallyExpanded != null),
        super(key: key);

  final Widget leading;

  final Widget title;

  final Widget subtitle;

  final BoxDecoration boxDecoration;

  final BorderRadius inkwellRadius;

  final ValueChanged<bool> onExpansionChanged;

  final List<Widget> children;

  final Widget btn;

  final Color backgroundColor;
  final Color defaultTrailingIconColor;
  final Widget trailing;
  bool initiallyExpanded;

  int btnIndex;
  int selectedIndex;
  Function onTap;

  @override
  _FacilityGroovinExpansionTileState createState() =>
      _FacilityGroovinExpansionTileState();
}

class _FacilityGroovinExpansionTileState
    extends State<FacilityGroovinExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  AnimationController controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;

  Animation<Color> _headerColor;
  Animation<Color> _iconColor;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = controller.drive(_easeInTween);

    _iconTurns = controller.drive(_halfTween.chain(_easeInTween));
    _headerColor = controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = controller.drive(_iconColorTween.chain(_easeInTween));

    isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (isExpanded) controller.value = 1.0;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void expand() {
    _handleTap();
  }

  void collapse() {
    _handleTap();
  }

  void toggle() {
    _handleTap();
  }

  void closeOthers() {
    if (widget.selectedIndex != widget.btnIndex) {
      isExpanded = false;

      controller.reverse();
    } else if (widget.selectedIndex == widget.btnIndex && isExpanded) {
      controller.forward();
      isExpanded = true;
    } else if (!isExpanded) {
      controller.reverse();
      isExpanded = false;
    }
    PageStorage.of(context)?.writeState(context, isExpanded);
    // setState(() {

    // });
  }

  void _handleTap() {
    isExpanded = !isExpanded;

    PageStorage.of(context)?.writeState(context, isExpanded);
    // });
    widget.onTap(isExpanded, widget.btnIndex);
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged(isExpanded);
    }
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color titleColor = _headerColor.value;
    if (widget.selectedIndex != -1) {
      closeOthers();
    }
    return Container(
      decoration: widget.boxDecoration,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: IconThemeData(color: _iconColor.value),
            child: new ListTile(
              minLeadingWidth: 0.0,
              dense: true,
              onTap: toggle,
              contentPadding: EdgeInsets.all(8),
              leading: widget.leading,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: titleColor),
                    child: widget.title,
                  ),
                  widget.btn,
                ],
              ),
              subtitle: widget.subtitle,
              trailing: widget.trailing ??
                  RotationTransition(
                    turns: _iconTurns,
                    child: Icon(
                      Icons.expand_more,
                      color: widget.defaultTrailingIconColor,
                    ),
                  ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween..end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.subtitle1.color
      ..end = theme.colorScheme.secondary;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.colorScheme.secondary;
    _backgroundColorTween..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !isExpanded && controller.isDismissed;
    return AnimatedBuilder(
      animation: controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}
