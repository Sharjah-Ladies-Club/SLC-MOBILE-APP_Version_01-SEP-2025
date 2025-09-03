import 'package:flutter/material.dart';
// import 'package:groovin_widgets/groovin_widgets.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// This class represents a slightly more customizable ExpansionTile.
/// It allows for a subtitle, customizing the BoxDecoration,
/// and the border radius of the InkWell of the ListTile that
/// the ExpansionTile creates.
// ignore: must_be_immutable
class GroovenNonCollapse extends StatefulWidget {
  // Creates a [ListTile] with a trailing button that expands or collapses
  // the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  // be non-null.
  GroovenNonCollapse(
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
      // this.controller,
      // this.isExpanded,

      this.initiallyExpanded = false,
      this.btnIndex,
      this.selectedIndex,
      this.onTap})
      : assert(initiallyExpanded != null),
        super(key: key);

  /// A widget to display before the title.
  final Widget leading;

  /// The primary content of the list item.
  final Widget title;

  /// Optional content to display below the title
  final Widget subtitle;

  /// BoxDecoration for this widget
  final BoxDecoration boxDecoration;

  /// Represents the radius of the corners of the InkWell used by GroovinListTile
  final BorderRadius inkwellRadius;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// The color to display behind the sublist when expanded.
  final Color backgroundColor;

  /// The color to assign to the default trailing icon
  final Color defaultTrailingIconColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  bool initiallyExpanded;

  //  AnimationController controller;

  //  bool isExpanded;

  int btnIndex;
  int selectedIndex;
  Function onTap;

  @override
  _GroovinExpansionTileState createState() => _GroovinExpansionTileState();
}

class _GroovinExpansionTileState extends State<GroovenNonCollapse>
    with SingleTickerProviderStateMixin {
  //static final Animatable<double> _easeOutTween =
  // CurveTween(curve: Curves.easeOut);
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

  //Animation<Color> _borderColor;
  Animation<Color> _headerColor;
  Animation<Color> _iconColor;

  //Animation<Color> _backgroundColor;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    // isExpanded =  widget.isExpanded;
    // controller = widget.controller;
    // closeOthers();
    controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = controller.drive(_easeInTween);

    _iconTurns = controller.drive(_halfTween.chain(_easeInTween));
    //_borderColor = controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = controller.drive(_iconColorTween.chain(_easeInTween));
    //_backgroundColor =
    //  controller.drive(_backgroundColorTween.chain(_easeOutTween));

    isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (isExpanded) controller.value = 1.0;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void closeOthers() {
    if (widget.selectedIndex != widget.btnIndex) {
      // widget.initiallyExpanded = true;

      isExpanded = false;

      controller.reverse();

// .then<void>((void value) {
//           if (!mounted) return;
//           setState(() {
//             // Rebuild without widget.children.
//           });
//         });
      // isExpanded = PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
      // if (isExpanded) controller.value = 1.0;
    } else if (widget.selectedIndex == widget.btnIndex && isExpanded) {
      // widget.initiallyExpanded = false;
      // if(!isExpanded){
      //    controller.reverse();
      // }
      // else

// if(isExpanded)
// {
//   controller.reverse();
//     isExpanded = false;
// }
// else if(!isExpanded) {

      controller.forward();
//         //  if (isExpanded)
      //  controller.value = 1.0;

      isExpanded = true;
// }

    } else if (!isExpanded) {
      controller.reverse();
      isExpanded = false;
    }
    PageStorage.of(context)?.writeState(context, isExpanded);
    // setState(() {

    // });
  }

  void _handleTap() {
    // setState(() {

    isExpanded = !isExpanded;

    // isExpanded = false;

// if(isExpanded)
// controller.forward();
// else
// controller.reverse();

    // if (isExpanded) {
    //   controller.forward();
    // } else {
    //   controller.reverse()
    //   ;
    //   // .then<void>((void value) {
    //   //   if (!mounted) return;
    //   //   setState(() {
    //   //     // Rebuild without widget.children.
    //   //   });
    //   // });
    // }
    PageStorage.of(context)?.writeState(context, isExpanded);
    // });
    widget.onTap(isExpanded, widget.btnIndex);
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged(isExpanded);
      // widget.onTap(isExpanded,widget.btnIndex);
    }
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    //final Color borderSideColor = _borderColor.value ?? Colors.transparent;
    final Color titleColor = _headerColor.value;
    // var sa = widget.btnIndex;
    if (widget.selectedIndex != -1) {
      closeOthers();
    }

    return Container(
      decoration: widget.boxDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: IconThemeData(color: _iconColor.value),
            child: ListTile(
              dense: true,
              minLeadingWidth: 0,
              minVerticalPadding: 0,
              onTap: () {
                // closeOthers,
                _handleTap();
                // widget.onTap(isExpanded,widget.btnIndex);
              },
              // inkwellRadius: widget.inkwellRadius,
              leading: widget.leading,
              title: DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: titleColor),
                child: widget.title,
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
