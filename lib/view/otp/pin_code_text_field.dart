library pin_code_text_field;

import 'dart:async';
import 'dart:ui' as prefix;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';

typedef OnDone = void Function(String text);
typedef PinBoxDecoration = BoxDecoration Function(
  Color borderColor,
  Color pinBoxColor, {
  double borderWidth,
  double radius,
});

/// class to provide some standard PinBoxDecoration such as standard box or underlined
class ProvidedPinBoxDecoration {
  /// Default BoxDecoration
  static PinBoxDecoration defaultPinBoxDecoration = (
    Color borderColor,
    Color pinBoxColor, {
    double borderWidth = 2.0,
    // border radius
    double radius = 30.0,
  }) {
    return BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        color: pinBoxColor,
        borderRadius: BorderRadius.circular(radius));
  };

  /// Underlined BoxDecoration
  static PinBoxDecoration underlinedPinBoxDecoration = (
    Color borderColor,
    Color pinBoxColor, {
    double borderWidth = 2.0,
    double radius,
  }) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: borderColor,
          width: borderWidth,
        ),
      ),
    );
  };

  static PinBoxDecoration roundedPinBoxDecoration = (
    Color borderColor,
    Color pinBoxColor, {
    double borderWidth = 2.0,
    double radius,
  }) {
    return BoxDecoration(
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
      shape: BoxShape.circle,
      color: pinBoxColor,
    );
  };
}

class ProvidedPinBoxTextAnimation {
  /// A combination of RotationTransition, DefaultTextStyleTransition, ScaleTransition
  static AnimatedSwitcherTransitionBuilder awesomeTransition =
      (Widget child, Animation<double> animation) {
    return RotationTransition(
        child: DefaultTextStyleTransition(
          style: TextStyleTween(
                  begin: TextStyle(color: Colors.pink),
                  end: TextStyle(color: Colors.blue))
              .animate(animation),
          child: ScaleTransition(
            child: child,
            scale: animation,
          ),
        ),
        turns: animation);
  };

  /// Simple Scaling Transition
  static AnimatedSwitcherTransitionBuilder scalingTransition =
      (child, animation) {
    return ScaleTransition(
      child: child,
      scale: animation,
    );
  };

  /// No transition
  static AnimatedSwitcherTransitionBuilder defaultNoTransition =
      (Widget child, Animation<double> animation) {
    return child;
  };

  /// Rotate Transition
  static AnimatedSwitcherTransitionBuilder rotateTransition =
      (Widget child, Animation<double> animation) {
    return RotationTransition(child: child, turns: animation);
  };
}

class PinCodeTextField extends StatefulWidget {
  final bool isCupertino;
  final int maxLength;
  final TextEditingController controller;
  final bool hideCharacter;
  final bool highlight;
  final bool highlightAnimation;
  final Color highlightAnimationBeginColor;
  final Color highlightAnimationEndColor;
  final Duration highlightAnimationDuration;
  final Color highlightColor;
  final Color defaultBorderColor;
  final Color pinBoxColor;
  final double pinBoxBorderWidth;
  final double pinBoxRadius;
  final PinBoxDecoration pinBoxDecoration;
  final String maskCharacter;
  final TextStyle pinTextStyle;
  final double pinBoxHeight;
  final double pinBoxWidth;
  final OnDone onDone;
  final bool hasError;
  final Color errorBorderColor;
  final Color hasTextBorderColor;
  final Function(String) onTextChanged;
  final bool autofocus;
  final FocusNode focusNode;
  final AnimatedSwitcherTransitionBuilder pinTextAnimatedSwitcherTransition;
  final Duration pinTextAnimatedSwitcherDuration;
  final WrapAlignment wrapAlignment;
  final prefix.TextDirection textDirection;
  final TextInputType keyboardType;
  final EdgeInsets pinBoxOuterPadding;
  final String mobileNumber;
  final String countrycode;

  const PinCodeTextField(
      {Key key,
      this.isCupertino: false,
      this.maxLength: 4,
      this.controller,
      this.hideCharacter: false,
      this.highlight: false,
      this.highlightAnimation: false,
      this.highlightAnimationBeginColor: Colors.white,
      this.highlightAnimationEndColor: Colors.black,
      this.highlightAnimationDuration,
      this.highlightColor: Colors.transparent,
      this.pinBoxDecoration,
      this.maskCharacter: " ",
      this.pinBoxWidth: 45.0,
      this.pinBoxHeight: 35.0,
      this.pinTextStyle,
      this.onDone,
      this.defaultBorderColor,
      this.hasTextBorderColor: Colors.transparent,
      this.pinTextAnimatedSwitcherTransition,
      this.pinTextAnimatedSwitcherDuration: const Duration(),
      this.hasError: false,
      this.errorBorderColor: Colors.red,
      this.onTextChanged,
      this.autofocus: false,
      this.focusNode,
      this.wrapAlignment: WrapAlignment.start,
      this.textDirection: prefix.TextDirection.ltr,
      this.keyboardType: TextInputType.number,
      this.pinBoxOuterPadding = const EdgeInsets.symmetric(horizontal: 4.0),
      this.pinBoxColor,
      this.pinBoxBorderWidth = 1.5,
      this.pinBoxRadius = 7,
      this.mobileNumber,
      this.countrycode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PinCodeTextFieldState();
  }
}
//244

class PinCodeTextFieldState extends State<PinCodeTextField>
    with SingleTickerProviderStateMixin {
  AnimationController _highlightAnimationController;
  Animation _highlightAnimationColorTween;
  FocusNode focusNode;
  String text = "";
  int currentIndex = 0;
  List<String> strList = [];
  bool hasFocus = false;
  double screenWidth;

  @override
  void didUpdateWidget(PinCodeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    focusNode = widget.focusNode ?? focusNode;

    if (oldWidget.maxLength < widget.maxLength) {
      setState(() {
        currentIndex = text.length;
      });
      widget.controller?.text = text;
      widget.controller?.selection =
          TextSelection.collapsed(offset: text.length);
    } else if (oldWidget.maxLength > widget.maxLength &&
        widget.maxLength > 0 &&
        text.length > 0 &&
        text.length > widget.maxLength) {
      setState(() {
        text = text.substring(0, widget.maxLength);
        currentIndex = text.length;
      });
      widget.controller?.text = text;
      widget.controller?.selection =
          TextSelection.collapsed(offset: text.length);
    }
  }

  _calculateStrList() async {
    if (strList.length > widget.maxLength) {
      strList.length = widget.maxLength;
    }
    while (strList.length < widget.maxLength) {
      strList.add("");
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.highlightAnimation) {
      _highlightAnimationController = AnimationController(
          vsync: this,
          duration:
              widget.highlightAnimationDuration ?? Duration(milliseconds: 500));
      _highlightAnimationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _highlightAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _highlightAnimationController.forward();
        }
      });
      _highlightAnimationColorTween = ColorTween(
              begin: widget.highlightAnimationBeginColor,
              end: widget.highlightAnimationEndColor)
          .animate(_highlightAnimationController);
      _highlightAnimationController.forward();
    }
    focusNode = widget.focusNode ?? FocusNode();

    _initTextController();
    _calculateStrList();
    widget.controller?.addListener(_controllerListener);
    focusNode?.addListener(_focusListener);
  }

  void _controllerListener() {
    // if (mounted == true) {
    setState(() {
      _initTextController();
    });

    if (widget.onTextChanged != null) {
      widget.onTextChanged(widget.controller.text);
    }
    // }
  }

  void _focusListener() {
    // if (mounted == true) {
    setState(() {
      hasFocus = focusNode.hasFocus;
    });
    // }
  }

  void _initTextController() {
    if (widget.controller == null) {
      return;
    }
    strList.clear();
    if (widget.controller.text.isNotEmpty) {
      if (widget.controller.text.length > widget.maxLength) {
        throw Exception("TextEditingController length exceeded maxLength!");
      }
    }

    text = widget.controller.text;
    for (var i = 0; i < text.length; i++) {
      strList.add(widget.hideCharacter ? widget.maskCharacter : text[i]);
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      // Only dispose the focus node if it's internal.  Don't dispose the passed
      // in focus node as it's owned by the parent not this child widget.
      focusNode?.dispose();
    } else {
      focusNode.removeListener(_focusListener);
    }
    _highlightAnimationController?.dispose();
    widget.controller?.removeListener(_controllerListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: <Widget>[
          labelShowHide(),
          _touchPinBoxRow(),
          _fakeTextInputCupertino()
          // _fakeTextInput()
          // widget.isCupertino ? _fakeTextInputCupertino() : _fakeTextInput(),
        ],
      ),
    );
  }

  Widget labelShowHide() {
    if (widget.maxLength == 4) {
      return
//  Container(margin:EdgeInsets.only(bottom: 15.0, left: 10.0, right: 10.0),child:

          PackageListHead.textFieldIsBlue(context, 'password',
              hasFocus || widget.controller.text.length > 0);

// Text(tr('password'),style: TextStyle(color:hasFocus || ?Theme.of(context).primaryColor:Colors.black, fontFamily:  tr('currFontFamily'),

// PackageListHead.customTextView(context, 1.0,tr('password'),hasFocus,FontWeight.w500);
// ),
// ),
// );
    } else {
      return
//  Container(width: 300.0, child: // );
          otpDecsriptionTextAndNumber();
    }
  }

  Widget otpDecsriptionTextAndNumber() {
    return Container(
//      width: 300.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Text(tr('otpSendToTxt'),style: TextStyle(color:Colors.black, fontFamily:  tr('currFontFamily'),

// ),
// ),

          Padding(
            padding: EdgeInsets.only(bottom: 15.0, left: 10.0, right: 10.0),
            child: Text(
                tr('otpSendToTxt') +
                    (Localizations.localeOf(context).languageCode == "en"
                        ? "${widget.countrycode != "" ? "\n" + widget.countrycode : " " + widget.countrycode}" +
                            "${" " + widget.mobileNumber}"
                        : "${widget.countrycode != "" ? "\n " + widget.mobileNumber : " " + widget.mobileNumber}" +
                            " " +
                            "${(widget.countrycode == Constants.UAE_COUNTRY_CODE) ? Constants.UAE_COUNTRY_CODE_REVERSE_PLUS : widget.countrycode}"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorData.primaryTextColor,
                  fontSize: Styles.packageExpandTextSiz,
//                  fontWeight:  FontWeight.w500,
                  fontFamily: tr("currFontFamilyEnglishOnly"),
                )),
          ),

//          PackageListHead.customTextView(
//              context,
//              0.4,
//              tr('otpSendToTxt'),
//              false,
//              FontWeight.w500),
          // Text(
          //   ,
          //   style: TextStyle(fontSize: FontSizeData.fontRegularSize),
          // ),

//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              PackageListHead.customTextView(
//                  context, 1.0, widget.countrycode, false, FontWeight.bold),
//              PackageListHead.customTextView(context, 1.0,
//                  "${" " + widget.mobileNumber}", false, FontWeight.bold)
//            ],
//          )
        ],
      ),
    );
  }

  Widget _touchPinBoxRow() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (hasFocus) {
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(Duration(milliseconds: 100), () {
            FocusScope.of(context).requestFocus(focusNode);
          });
        } else {
          FocusScope.of(context).requestFocus(focusNode);
        }
      },
      child: _pinBoxRow(context),
    );
  }

//   Widget _fakeTextInput() {
//     var transparentBorder = OutlineInputBorder(
//       borderSide: BorderSide(
//         color: Colors.transparent,
//         width: 0.0,
//       ),
//     );
//     return Stack(
//       children: <Widget>[
//         Container(
//           width: 0.1,
//           height: 16.0, // RenderBoxDecorator subtextGap constant is 8.0
//           child: TextField(
//             autofocus: !kIsWeb ? widget.autofocus : false,
//             focusNode: focusNode,
//             controller: widget.controller,
//             keyboardType: widget.keyboardType,
//             inputFormatters: widget.keyboardType == TextInputType.number
//                 ? <TextInputFormatter>[
//                     // WhitelistingTextInputFormatter.digitsOnly
//                     FilteringTextInputFormatter.digitsOnly,
//                   ]
//                 : null,
//             style: TextStyle(
//               height: 0.1, color: Colors.transparent,
// //          color: Colors.transparent,
//             ),
//             decoration: InputDecoration(
//               focusedErrorBorder: transparentBorder,
//               errorBorder: transparentBorder,
//               disabledBorder: transparentBorder,
//               enabledBorder: transparentBorder,
//               focusedBorder: transparentBorder,
//               counterText: null,
//               counterStyle: null,
//               helperStyle: TextStyle(
//                 height: 0.0,
//                 color: Colors.transparent,
//               ),
//               labelStyle: TextStyle(height: 0.1),
//               fillColor: Colors.transparent,
//               border: InputBorder.none,
//             ),
//             cursorColor: Colors.transparent,
//             maxLength: widget.maxLength,
//             onChanged: _onTextChanged,
//           ),
//         ),
//       ],
//     );
//   }

  Widget _fakeTextInputCupertino() {
    return Container(
      width: 0.1,
      height: 0.1,
      child: CupertinoTextField(
        autofocus: !kIsWeb ? widget.autofocus : false,
        focusNode: focusNode,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.keyboardType == TextInputType.number
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                // WhitelistingTextInputFormatter.digitsOnly
              ]
            : null,
        style: TextStyle(
          color: Colors.transparent,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: null,
        ),
        cursorColor: Colors.transparent,
        maxLength: widget.maxLength,
        onChanged: _onTextChanged,
      ),
    );
  }

  void _onTextChanged(text) {
    if (widget.onTextChanged != null) {
      widget.onTextChanged(text);
    }
    setState(() {
      this.text = text;
      currentIndex = text.length;
      if (text.length < currentIndex) {
        strList[text.length] = "";
      } else {
        for (int i = currentIndex; i < text.length; i++) {
          strList[i] = widget.hideCharacter ? widget.maskCharacter : text[i];
        }
      }
      // currentIndex = text.length;
    });
    if (text.length == widget.maxLength) {
      FocusScope.of(context).requestFocus(FocusNode());
      widget.onDone(text);
    }
  }

  Widget _pinBoxRow(BuildContext context) {
    _calculateStrList();
    List<Widget> pinCodes = List.generate(widget.maxLength, (int i) {
      return _buildPinCode(i, context);
    });
    return Wrap(
      direction: Axis.horizontal,
      alignment: widget.wrapAlignment,
      verticalDirection: VerticalDirection.down,
      textDirection: widget.textDirection,
      children: pinCodes,
    );
  }

  Widget _buildPinCode(int i, BuildContext context) {
    Color borderColor;
    BoxDecoration boxDecoration;
    if (widget.hasError) {
      borderColor = widget.errorBorderColor;
    } else if (widget.highlightAnimation && _shouldHighlight(i)) {
      return Container(
          // padding: const EdgeInsets.symmetric(horizontal: 4.0),
          // padding: EdgeInsets.only(top:20.0),
          child: AnimatedBuilder(
              animation: _highlightAnimationController,
              builder: (BuildContext context, Widget child) {
                if (widget.pinBoxDecoration != null) {
                  boxDecoration = widget.pinBoxDecoration(
                    _highlightAnimationColorTween.value,
                    widget.pinBoxColor,
                    borderWidth: widget.pinBoxBorderWidth,
                    radius: widget.pinBoxRadius,
                  );
                } else {
                  boxDecoration =
                      ProvidedPinBoxDecoration.defaultPinBoxDecoration(
                    _highlightAnimationColorTween.value,
                    widget.pinBoxColor,
                    borderWidth: widget.pinBoxBorderWidth,
                    radius: widget.pinBoxRadius,
                  );
                }

                return Container(
                  key: ValueKey<String>("container$i"),
                  child: Center(child: _animatedTextBox(strList[i], i)),
                  decoration: boxDecoration,
                  width: widget.pinBoxWidth,
                  height: widget.pinBoxHeight,
                );
              }));
    } else if (widget.highlight && _shouldHighlight(i)) {
      borderColor = widget.highlightColor;
    } else if (i < text.length) {
      borderColor = widget.hasTextBorderColor;
    } else {
      if (isFocusAvail()) {
        borderColor = Colors.transparent;
      } else {
        borderColor = widget.defaultBorderColor;
      }
    }

    if (widget.pinBoxDecoration != null) {
      boxDecoration = widget.pinBoxDecoration(
        borderColor,
        widget.pinBoxColor,
        borderWidth: widget.pinBoxBorderWidth,
        radius: widget.pinBoxRadius,
      );
    } else {
      boxDecoration = ProvidedPinBoxDecoration.defaultPinBoxDecoration(
        borderColor,
        widget.pinBoxColor,
        borderWidth: widget.pinBoxBorderWidth,
        radius: widget.pinBoxRadius,
      );
    }
//    EdgeInsets insets;
//    if (i == 0) {
//      insets = EdgeInsets.only(
//        left: 0.0,
//        top: 0.0,
//        right: 0.0,
//        bottom: 0.0,
//      );
//    } else if (i == strList.length - 1) {
//      insets = EdgeInsets.only(
//        left: 0.0,
//        top: 0.0,
//        right: 0.0,
//        bottom: 0.0,
//      );
//    } else {
//      // insets = widget.pinBoxOuterPadding;
//      insets = EdgeInsets.only(
//        left: 0.0,
//        top: 0.0,
//        right: 0.0,
//        bottom: 0.0,
//      );
//    }
    return Container(
        // height: 60.0,
        // width: 50.0,
        margin: EdgeInsets.only(left: 6.0, right: 6.0),
        child: Container(
//          padding: insets,
//        padding: EdgeInsets.all(0.0),
          child: Card(
            color: ColorData.loginBackgroundColor,
            elevation: customElevation(),
            child: Container(
              key: ValueKey<String>("container$i"),
              child: Center(child: _animatedTextBox(strList[i], i)),
              decoration: boxDecoration,
              width: widget.pinBoxWidth,
              height: widget.pinBoxHeight,
            ),
          ),
        ));
  }

  bool isFocusAvail() {
    if (hasFocus)
      return true;
    else
      return false;
  }

  customElevation() {
    if (hasFocus || widget.controller.text.length > 0) {
      return 5.0;
    } else if (widget.controller.text.length == 0) {
      return 0.0;
    }
  }

  bool _shouldHighlight(int i) {
    return hasFocus &&
        (i == text.length ||
            (i == text.length - 1 && text.length == widget.maxLength));
  }

  Widget _animatedTextBox(String text, int i) {
    return Container(
      margin: EdgeInsets.only(
//          top: Localizations.localeOf(context).languageCode == "en"
//
//              ? (widget.pinBoxHeight / 2) - 10.0
//
//              : 0.0),
          top:
//          Localizations.localeOf(context).languageCode == "en"
//              ? (widget.pinBoxHeight / 2) - 10.0
//              :
              (widget.pinBoxHeight / 2) - 10.0),
      child: (widget.pinTextAnimatedSwitcherTransition != null)
          ? AnimatedSwitcher(
              duration: widget.pinTextAnimatedSwitcherDuration,
              transitionBuilder: widget.pinTextAnimatedSwitcherTransition ??
                  (Widget child, Animation<double> animation) {
                    return child;
                  },
              child: Text(
                text,
                key: ValueKey<String>("$text$i"),
                style: widget.pinTextStyle,
              ),
            )
          : Text(
              text,
              key: ValueKey<String>("${strList[i]}$i"),
              style: widget.pinTextStyle,
            ),
    );
  }
}
