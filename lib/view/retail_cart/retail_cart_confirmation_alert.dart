// import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/view/mypage/my_page.dart';
import 'package:slc/model/order_status_response.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/Beach/bloc/beach_bloc.dart';
import 'package:slc/view/Beach/bloc/beach_event.dart';
import 'package:slc/view/Beach/bloc/beach_state.dart';

// ignore: must_be_immutable
class RetailCartConfirmationAlert extends StatelessWidget {
  String merchantReferenceNo = "";
  RetailCartConfirmationAlert({this.merchantReferenceNo});
  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      Constants.isNotFromNotificationFamily = false;
      Constants.isFromNotificationFamily = 0;
      //Navigator.pop(context, true);
      return false;
    }

    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: BlocProvider(
            create: (context) {
              return BeachBloc(beachBloc: null)
                ..add(new GetOrderStatusEvent(
                    merchantReferenceNo: merchantReferenceNo));
            },
            child: _RetailCartConfirmationAlert(
              merchantReferenceNo: merchantReferenceNo,
            ),
          ),
        ));
  }
}

// ignore: must_be_immutable
class _RetailCartConfirmationAlert extends StatefulWidget {
  String merchantReferenceNo = "";
  OrderStatus orderStatus = new OrderStatus();
  _RetailCartConfirmationAlert({this.merchantReferenceNo});
  @override
  _RetailCartConfirmationAlertState createState() =>
      _RetailCartConfirmationAlertState(
          merchantReferenceNo: merchantReferenceNo);
}

class _RetailCartConfirmationAlertState
    extends State<_RetailCartConfirmationAlert> {
  String merchantReferenceNo = "";
  OrderStatus orderStatus = new OrderStatus();
  _RetailCartConfirmationAlertState({this.merchantReferenceNo});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Alert();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BeachBloc, BeachState>(
        listener: (context, state) async {
          if (state is GetOrderStatusState) {
            if (state.orderStatus != null) {
              setState(() {
                widget.orderStatus = state.orderStatus;
              });
            }
          }
        },
        child: SafeArea(
          child: Scaffold(
            // appBar: PreferredSize(
            //   preferredSize: Size.fromHeight(100.0),
            //   child: CustomAppBar(
            //     title: tr('thanks_page'),
            //   ),
            // ),
            appBar: AppBar(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              automaticallyImplyLeading: true,
              title: Text(tr('thanks_page'),
                  style: TextStyle(color: Colors.blue[200])),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.blue[200],
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPage()),
                  );
                },
              ),
              backgroundColor: Colors.white,
            ),
            body:
                // SingleChildScrollView(
                //   child:
                widget.orderStatus.orderStatusId == null
                    ? Text("")
                    : Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/beachorder.png"),
                                fit: BoxFit.cover)),
                        height: MediaQuery.of(context).size.height * 0.99,
                        width: MediaQuery.of(context).size.width * 0.99,
                        child: Container(
                          margin: EdgeInsets.only(right: 10, left: 10),
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.15),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.orderStatus.orderStatusId == 2
                                      ? tr('paymentSuccessfullyDone')
                                      : tr('transactionFailed'),
                                  style: TextStyle(
                                      color:
                                          widget.orderStatus.colorCode != null
                                              ? ColorData.toColor(
                                                  widget.orderStatus.colorCode)
                                              : ColorData.colorBlue,
                                      fontSize: 16,
                                      fontFamily: tr('currFontFamily')),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                height: 100,
                                child: MaterialButton(
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          width: 2,
                                          color: Colors.green,
                                          style: BorderStyle.solid)),
                                  child: Icon(
                                    widget.orderStatus.orderStatusId == 2
                                        ? Icons.check
                                        : Icons.error,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  color: Colors.lightGreen[100],
                                  textColor: Colors.amber,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyPage()),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.orderStatus.orderStatusId == 2
                                      ? tr('yourItemsOrdered')
                                      : tr('somethingwentwrong'),
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor
                                          .withOpacity(1.0),
                                      fontSize: Styles.textSizRegular,
                                      fontFamily: tr('currFontFamily')),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.center,
                                child: Text(
                                  tr('yourTransactionNo'),
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor
                                          .withOpacity(1.0),
                                      fontSize: Styles.textSizeSmall,
                                      fontFamily: tr('currFontFamily')),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.orderStatus.orderNo != null
                                      ? widget.orderStatus.orderNo
                                      : "",
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor
                                          .withOpacity(1.0),
                                      fontSize: Styles.textSizeSmall,
                                      fontFamily: tr('currFontFamily')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ));
    // );
  }
}
