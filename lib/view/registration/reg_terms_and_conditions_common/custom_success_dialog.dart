import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/theme/styles.dart';

class ModalRoundedDialog extends StatefulWidget {
  final double _opacity;
  final String _textMessage; // optional message to show
  final Function
      _handlerCallback; // callback that will give a handler object to change widget state.
  final Function positiveCallBack;
  final String title;
  final String content;

  ModalRoundedDialog(
      {@required Function handleCallback(DialogHandler handler),
      String message = "", // some text to show if needed...
      double opacity = 0.7, // opacity default value
      this.title,
      this.content,
      this.positiveCallBack})
      : this._textMessage = message,
        this._opacity = opacity,
        this._handlerCallback = handleCallback;

  @override
  State createState() => _ModalRoundedProgressBarState();
}

//StateClass ...
class _ModalRoundedProgressBarState extends State<ModalRoundedDialog> {
  bool _isShowing =
      false; // member that control if a rounded progressBar will be showing or not

  @override
  void initState() {
    super.initState();
    /* Here we create a handle object that will be sent for a widget that creates a ModalRounded      ProgressBar.*/
    DialogHandler handler = DialogHandler();

    handler.show = this.show; // handler show member holds a show() method
    handler.dismiss =
        this.dismiss; // handler dismiss member holds a dismiss method
    widget._handlerCallback(handler); //callback to send handler object
  }

  @override
  Widget build(BuildContext context) {
    //return a simple stack if we don't wanna show a roundedProgressBar...
    if (!_isShowing) return Stack();

    // here we return a layout structre that show a roundedProgressBar with a simple text message
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: widget._opacity,
            //ModalBarried used to make a modal effect on screen
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black54,
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  content: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Center(
                            child: Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorData.primaryTextColor,
                                fontSize: Styles.textSizeSmall,
                                fontFamily: tr("currFontFamily"),
                                fontWeight: FontWeight.w500,
                                // fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Center(
                            child: Text(
                              widget.content,
                              style: TextStyle(
                                fontSize: Styles.textSiz,
                                color: ColorData.primaryTextColor,
                                fontFamily: tr("currFontFamily"),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            //   Text(
                            //
                            // .tr('mailCheck', args: [_fNameController.text]), style: TextStyle(fontSize: 12.0)
                            // ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            ColorData.colorBlue),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    )))),
                                // shape: RoundedRectangleBorder(
                                //     borderRadius:
                                //         BorderRadius.all(Radius.circular(5.0))),
                                // color: ColorData.colorBlue,
                                child: new Text(
                                  tr("ok"),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Styles.loginBtnFontSize,
                                      fontFamily: tr("currFontFamily")),
                                ),
                                onPressed: widget.positiveCallBack,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  widget._textMessage,
                  style: Styles.failureUIStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // method do change state and show our CircularProgressBar
  void show() {
    if (!mounted) return;
    setState(() => _isShowing = true);
  }

  // method to change state and hide our CIrcularProgressBar
  void dismiss() {
    if (!mounted) return;
    setState(() => _isShowing = false);
  }
}

// handler class
class DialogHandler {
  Function show; //show is the name of member..can be what you want...
  Function dismiss;
}
