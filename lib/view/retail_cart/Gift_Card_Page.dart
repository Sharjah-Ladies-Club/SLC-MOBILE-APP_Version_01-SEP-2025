// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginpagefiledwhite.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/facility_request.dart';
import 'package:slc/model/facility_response.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/repo/home_repository.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/textinputtypefile.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/healthnbeauty/healthnbeauty.dart';
import 'package:slc/view/retail_cart/bloc/bloc.dart';

import '../../model/payment_terms_response.dart';
import 'Gift_Card_Payment.dart';

class GiftCardPage extends StatelessWidget {
  int facilityId;
  String colorCode;
  GiftCardPage({this.facilityId, this.colorCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<RetailCartBloc>(
              create: (context) => RetailCartBloc(retailBloc: null)
                ..add(GetGiftCardCategoryDetailsEvent(facilityId: facilityId))
                ..add(GetPaymentTerms(facilityId: facilityId))
              // ..add(GetGiftCardDetailsEvent(facilityId: facilityId))
              ),
        ],
        child: GiftCardHomePage(facilityId: facilityId, colorCode: colorCode),
      ),
    );
  }
}

class GiftCardHomePage extends StatefulWidget {
  int facilityId;
  String colorCode = "";
  List<GiftCardImage> giftCardImages = [];
  List<GiftCardImage> giftCardImagesForCategory = [];
  GiftCardUI giftCardCategoryAndPrice = new GiftCardUI();
  int _current = 0;
  int selectedItemIndex = -1;
  GiftCardHomePage({this.facilityId, this.colorCode});
  @override
  _GiftCardPage createState() {
    return _GiftCardPage();
  }
}

// final List<String> imgList = ["assets/images/1_logo.png"];
GiftCardCategory selectCardCategory =
    new GiftCardCategory(categoryId: 1, categoryName: "Birthday");
GiftCardItemsPrice selectCardPrice;

class _GiftCardPage extends State<GiftCardHomePage> {
  // static final borderColor = Colors.grey[200];
  var serverTestPath = URLUtils().getImageResultUrl();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Utils util = new Utils();
  double total = 0;
  int totalItems = 1;
  PaymentTerms paymentTerms = new PaymentTerms();
  DateTime get date => DateTime.now();
  // MaskedTextController _giftCategory =
  //     new MaskedTextController(mask: Strings.maskEngCommentValidationStr);
  // MaskedTextController _giftTo =
  //     new MaskedTextController(mask: Strings.maskEngCommentValidationStr);
  // MaskedTextController _giftPrice =
  //     new MaskedTextController(mask: Strings.maskEngCommentValidationStr);
  MaskedTextController _giftText =
      new MaskedTextController(mask: Strings.maskEngGiftValidationStr);
  MaskedTextController _giftMobileNo =
      new MaskedTextController(mask: Strings.maskMobileValidationStr);

  List<GiftCardCategory> giftTo = [];
  GiftCardCategory selectGiftTo = new GiftCardCategory();
  _GiftCardPage();

  // final CarouselController _controller = CarouselController();
  int current = 0;
  bool valuefirst = false;
  double screenHeight = 0.0;
  double carouselHeight = 0.0;
  double menuHeight = 0.0;
  double contentHeight = 0.0;
  double buttonHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + 55);
    carouselHeight = Platform.isIOS
        ? screenHeight * (43.0 / 100.0)
        : screenHeight * (40.0 / 100.0);
    return BlocListener<RetailCartBloc, RetailCartState>(
      listener: (context, state) {
        if (state is LoadGiftCardCategoryList) {
          widget.giftCardCategoryAndPrice = state.giftCardUI;
          GiftCardCategory cardCategory = new GiftCardCategory();
          cardCategory.categoryId = 0;
          cardCategory.categoryName = "Self";
          giftTo.add(cardCategory);
          cardCategory = new GiftCardCategory();
          cardCategory.categoryId = 1;
          cardCategory.categoryName = "Others";
          giftTo.add(cardCategory);
          BlocProvider.of<RetailCartBloc>(context)
              .add(new GetGiftCardDetailsEvent(facilityId: widget.facilityId));
          setState(() {});
        } else if (state is LoadGiftCardImageList) {
          widget.giftCardImages = state.giftCardImageList;
          widget.giftCardImagesForCategory.clear();
          if (widget.giftCardCategoryAndPrice.categoryInfo != null &&
              widget.giftCardCategoryAndPrice.categoryInfo.length > 0) {
            widget.giftCardCategoryAndPrice.categoryInfo[0].selected = true;
            for (GiftCardImage image in widget.giftCardImages) {
              if (image.giftCardCategoryId ==
                  widget.giftCardCategoryAndPrice.categoryInfo[0].categoryId) {
                widget.giftCardImagesForCategory.add(image);
              }
            }
          }
          setState(() {});
        } else if (state is GetPaymentTermsResult) {
          paymentTerms = state.paymentTerms;
          setState(() {});
        } else if (state is NoRecordsFound) {}
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFF0F8FF),
        appBar: AppBar(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.blue[200]),
          title: Text(
            tr("gift_cards_title"),
            style: TextStyle(color: Colors.blue[200]),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.remove_shopping_cart),
            color: Colors.blue[200],
            onPressed: () async {
              FacilityRequest request = FacilityRequest(facilityGroupId: 1);
              Meta m1 =
                  await HomeRepository().getOnlineShopFacilityData(request);
              if (m1.statusCode == 200) {
                List<FacilityResponse> facilityResponseList = [];

                jsonDecode(m1.statusMsg)['response'].forEach((f) =>
                    facilityResponseList.add(new FacilityResponse.fromJson(f)));

                facilityResponseList.sort((a, b) =>
                    a.facilityDisplayOrder.compareTo(b.facilityDisplayOrder));

                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      //return Profile(Strings.ProfileInitialState);
                      return Healthnbeauty(
                          facilityResponseList[0].facilityGroupName,
                          facilityResponseList,
                          true);
                    },
                  ),
                );
              }
            },
          ),
          actions: <Widget>[],
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/beachorder.png"),
                      fit: BoxFit.cover)),
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.grey[200])),
                    height: (total == 0 || !this.valuefirst)
                        ? MediaQuery.of(context).size.height * 0.887
                        : MediaQuery.of(context).size.height * 0.80,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                height: carouselHeight,
                                child: SizedBox(
                                    height: carouselHeight,
                                    width: double.infinity,
                                    child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          carouselUi(
                                              context,
                                              widget.giftCardImagesForCategory !=
                                                      null
                                                  ? widget
                                                      .giftCardImagesForCategory
                                                  : [])
                                        ]))),
                            // Visibility(
                            //     visible: true,
                            //     child: Container(
                            //         height: carouselHeight,
                            //         // margin: EdgeInsets.only(left: 2, right: 2),
                            //         child: carouselUi(
                            //             context,
                            //             widget.giftCardImagesForCategory != null
                            //                 ? widget.giftCardImagesForCategory
                            //                 : []))),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 6, left: 16, right: 16),
                              child: Visibility(
                                  visible: true,
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(1.0, 6, 1.0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tr("occasion"),
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize: Styles.loginBtnFontSize,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: tr(
                                                  "currFontFamilyEnglishOnly")),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              1.0, 6, 1.0, 0),
                                          child: getCategoryWidget(),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 6, bottom: 6, left: 16, right: 16),
                                child: Visibility(
                                    visible: widget.giftCardCategoryAndPrice ==
                                                null ||
                                            widget.giftCardCategoryAndPrice
                                                    .priceinfo ==
                                                null
                                        ? false
                                        : true,
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(1.0, 6, 1.0, 1.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tr("gift_amount"),
                                            style: TextStyle(
                                                color: ColorData
                                                    .primaryTextColor
                                                    .withOpacity(1.0),
                                                fontSize:
                                                    Styles.loginBtnFontSize,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: tr(
                                                    "currFontFamilyEnglishOnly")),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                1.0, 6, 1.0, 1.0),
                                            child: getPriceWidget(),
                                          )
                                        ],
                                      ),
                                    ))),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 6, bottom: 6, left: 16, right: 16),
                                child: Visibility(
                                    visible: true,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          1.0, 10, 1.0, 1.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tr("prepaid_card_for"),
                                            style: TextStyle(
                                                color: ColorData
                                                    .primaryTextColor
                                                    .withOpacity(1.0),
                                                fontSize:
                                                    Styles.loginBtnFontSize,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: tr(
                                                    "currFontFamilyEnglishOnly")),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.056,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selectGiftTo
                                                            .categoryId = 0;
                                                      });
                                                    },
                                                    child: Text(
                                                      tr("gift_to_myself"),
                                                      style: TextStyle(
                                                          color: ColorData
                                                              .primaryTextColor
                                                              .withOpacity(
                                                                  0.80),
                                                          fontSize: Styles
                                                              .loginBtnFontSize,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: tr(
                                                              "currFontFamilyEnglishOnly")),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          (selectGiftTo !=
                                                                      null &&
                                                                  selectGiftTo
                                                                          .categoryId ==
                                                                      0)
                                                              ? Colors.black12
                                                              : Colors.white,
                                                      alignment:
                                                          Alignment.center,
                                                      padding: EdgeInsets.zero,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14)),
                                                      elevation: 0,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.056,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  margin: const EdgeInsets.only(
                                                      left: 18),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selectGiftTo
                                                            .categoryId = 1;
                                                      });
                                                    },
                                                    child: Text(
                                                      tr("gift_to_others"),
                                                      style: TextStyle(
                                                          color: ColorData
                                                              .primaryTextColor
                                                              .withOpacity(
                                                                  0.80),
                                                          fontSize: Styles
                                                              .loginBtnFontSize,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: tr(
                                                              "currFontFamilyEnglishOnly")),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          (selectGiftTo !=
                                                                      null &&
                                                                  selectGiftTo
                                                                          .categoryId ==
                                                                      1)
                                                              ? Colors.black12
                                                              : Colors.white,
                                                      alignment:
                                                          Alignment.center,
                                                      padding: EdgeInsets.zero,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14)),
                                                      elevation: 0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ))),
                            Padding(
                                padding: EdgeInsets.only(left: 6, right: 8),
                                child: Visibility(
                                    visible: selectGiftTo != null &&
                                        selectGiftTo.categoryId == 1,
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(1.0, 12, 1.0, 0),
                                      child: LoginPageFieldWhite(
                                        _giftMobileNo,
                                        tr("fr_mobileNumber"),
                                        Strings.countryCodeForNonMobileField,
                                        CommonIcons.phone,
                                        TextInputTypeFile.textInputTypeMobile,
                                        TextInputAction.done,
                                        () => {},
                                        () => {},
                                        isWhite: true,
                                      ),
                                    ))),
                            Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Visibility(
                                    visible: true,
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(1.0, 6, 1.0, 0),
                                      child: LoginPageFieldWhite(
                                        _giftText,
                                        tr("gift_card_text"),
                                        Strings.countryCodeForNonMobileField,
                                        Icons.add_comment,
                                        TextInputTypeFile.textInputTypeName,
                                        TextInputAction.done,
                                        () => {},
                                        () => {},
                                        readOnly: false,
                                        isWhite: true,
                                      ),
                                    ))),
                            // selectCardCategory == null
                            //     ? Text("")
                            //     : getItemList(),
                            Container(
                              margin: const EdgeInsets.only(left: 8, right: 8),
                              padding: EdgeInsets.fromLTRB(1.0, 6, 1.0, 0),
                              height: 180,
                              width: MediaQuery.of(context).size.width * .98,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.all(color: Colors.grey[200]),
                                color: Colors.white,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 24, left: 20, right: 20),
                                    child: Row(
                                      children: [
                                        Text(tr("gift_accept_proceed"),
                                            style: TextStyle(
                                                color: ColorData
                                                    .primaryTextColor
                                                    .withOpacity(1.0),
                                                fontSize: Styles.textSizRegular,
                                                fontFamily:
                                                    tr('currFontFamily'))),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 50, left: 20, right: 20),
                                    child: Row(
                                      children: [
                                        // SizedBox(
                                        //     width: MediaQuery.of(context)
                                        //             .size
                                        //             .width *
                                        //         0.80,
                                        //     child: Text(
                                        //         tr(
                                        //             "gift_payment_terms_conditions"),
                                        //         style: TextStyle(
                                        //             color: ColorData
                                        //                 .primaryTextColor
                                        //                 .withOpacity(1.0),
                                        //             fontSize: Styles
                                        //                 .packageExpandTextSiz,
                                        //             fontFamily: tr(
                                        //                 'currFontFamily')))),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.80,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.12,
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemCount: widget
                                                        .giftCardCategoryAndPrice
                                                        .termsInfo !=
                                                    null
                                                ? widget
                                                    .giftCardCategoryAndPrice
                                                    .termsInfo
                                                    .length
                                                : 0,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return Container(
                                                child: ListTile(
                                                    dense: false,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    minLeadingWidth: 0,
                                                    leading:
                                                        Text((i + 1).toString(),
                                                            style: TextStyle(
                                                              fontSize: Styles
                                                                  .textSiz,
                                                              color: ColorData
                                                                  .primaryTextColor,
                                                              // fontWeight: FontWeight.bold,
                                                              fontFamily: tr(
                                                                  'currFontFamily'),
                                                            )),
                                                    title: PackageListHead
                                                        .genderNationalityPicker(
                                                            context,
                                                            widget
                                                                .giftCardCategoryAndPrice
                                                                .termsInfo[i]
                                                                .terms)),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 140, left: 8),
                                    child: Row(
                                      children: [
                                        Theme(
                                            data: ThemeData(
                                                unselectedWidgetColor:
                                                    Colors.grey[400]),
                                            child: Checkbox(
                                              checkColor: Colors.greenAccent,
                                              activeColor: Colors.blue,
                                              value: this.valuefirst,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  this.valuefirst = value;
                                                });
                                              },
                                            )),
                                        Text(
                                          tr("i_accept"),
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize: Styles.loginBtnFontSize,
                                              fontFamily: tr('currFontFamily')),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),

                  // SizedBox(height: 20),
                  Visibility(
                      visible: (total != 0 && this.valuefirst) ? true : false,
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 10,
                              top: MediaQuery.of(context).size.height * 0.80),
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ButtonTheme(
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          widget.colorCode == null
                                              ? Colors.blue[200]
                                              : ColorData.toColor(
                                                  widget.colorCode)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  )))),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(8),
                              // ),
                              // color: widget.colorCode == null
                              //     ? Colors.blue[200]
                              //     : ColorData.toColor(widget.colorCode),
                              child: Align(
                                  alignment: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(left: 10, top: 15)
                                            : EdgeInsets.only(
                                                right: 10, top: 15),
                                        child: Text(
                                          totalItems.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.10,
                                                top: 10,
                                                bottom: 10)
                                            : EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.10,
                                                top: 10,
                                                bottom: 10),
                                        child: VerticalDivider(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                top: 15)
                                            : EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                top: 15),
                                        child: Text(
                                          "AED" + '',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.22,
                                                top: 15)
                                            : EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.22,
                                                top: 15),
                                        child: Text(
                                          total.toStringAsFixed(2),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.55,
                                                top: 16)
                                            : EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.50,
                                                top: 16),
                                        child: Text(
                                          tr("viewCart"),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Padding(
                                          padding: Localizations
                                                          .localeOf(context)
                                                      .languageCode ==
                                                  "en"
                                              ? EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.75,
                                                  top: 14)
                                              : EdgeInsets.only(
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.75,
                                                  top: 14),
                                          child: Icon(
                                            Icons.shopping_basket,
                                            color: Colors.white,
                                            size: 20,
                                          )),
                                    ],
                                  )),
                              onPressed: () async {
                                if (selectCardCategory == null) {
                                  util.customGetSnackBarWithOutActionButton(
                                      tr("gift_voucher"),
                                      tr("select_gift_voucher_category"),
                                      context);
                                  return;
                                }
                                if (selectCardPrice == null) {
                                  util.customGetSnackBarWithOutActionButton(
                                      tr("gift_voucher"),
                                      tr("select_gift_voucher_price"),
                                      context);
                                  return;
                                }
                                if (selectGiftTo == null) {
                                  util.customGetSnackBarWithOutActionButton(
                                      tr("gift_voucher"),
                                      tr("select_gift_to"),
                                      context);
                                  return;
                                }
                                if (selectGiftTo != null &&
                                    selectGiftTo.categoryId == 1 &&
                                    (_giftMobileNo.text == "" ||
                                        _giftMobileNo.text.length < 9)) {
                                  util.customGetSnackBarWithOutActionButton(
                                      tr("gift_voucher"),
                                      tr("enter_shared_mobileno"),
                                      context);
                                  return;
                                }

                                if (selectGiftTo != null &&
                                    selectGiftTo.categoryId == 1 &&
                                    (_giftMobileNo.text.substring(0, 1) ==
                                            "0" &&
                                        _giftMobileNo.text.length < 10)) {
                                  util.customGetSnackBarWithOutActionButton(
                                      tr("gift_voucher"),
                                      tr("enter_shared_mobileno"),
                                      context);
                                  return;
                                }
                                if (selectGiftTo != null &&
                                    selectGiftTo.categoryId == 1 &&
                                    (_giftMobileNo.text ==
                                            SPUtil.getString(
                                                Constants.USER_MOBILE) ||
                                        _giftMobileNo.text.substring(
                                                1, _giftMobileNo.text.length) ==
                                            SPUtil.getString(
                                                Constants.USER_MOBILE))) {
                                  util.customGetSnackBarWithOutActionButton(
                                      tr("gift_voucher"),
                                      tr("enter_correct_mobileno"),
                                      context);
                                  return;
                                }
                                if (widget.giftCardImagesForCategory
                                    .where(
                                        (element) => element.selected == true)
                                    .isEmpty) {
                                  util.customGetSnackBarWithOutActionButton(
                                      tr("gift_voucher"),
                                      tr("select_gift_card_image"),
                                      context);
                                  return;
                                }
                                if (_giftText.text == "") {
                                  util.customGetSnackBarWithOutActionButton(
                                      tr("gift_voucher"),
                                      tr("enter_gift_card_text"),
                                      context);
                                  return;
                                }
                                Meta m = await FacilityDetailRepository()
                                    .getDiscountList(widget.facilityId, total);
                                List<BillDiscounts> billDiscounts = [];
                                if (m.statusCode == 200) {
                                  billDiscounts =
                                      jsonDecode(m.statusMsg)['response']
                                          .forEach((f) => billDiscounts.add(
                                              new BillDiscounts.fromJson(f)));
                                }
                                // Disable collage
                                if (billDiscounts == null) {
                                  billDiscounts = [];
                                }
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          new GiftCardPaymentPage(
                                        giftCardText: _giftText.text,
                                        giftCardCategory: selectCardCategory,
                                        giftCardPrice: selectCardPrice,
                                        giftCardImage: widget
                                            .giftCardImagesForCategory
                                            .where((element) =>
                                                element.selected == true)
                                            .first,
                                        giftTo: selectGiftTo,
                                        sharedMobileNo: _giftMobileNo.text,
                                        total: total,
                                        retailItemSetId: 0,
                                        facilityId: widget.facilityId,
                                        tableNo: 0,
                                        colorCode: widget.colorCode,
                                        deliveryAddresses: [],
                                        deliveryCharges: [],
                                        billDiscounts: billDiscounts,
                                        giftVouchers: [],
                                        paymentTerms: paymentTerms,
                                      ),
                                    ));
                              },
                            ),
                          ))),
                ],
              )),
        ),
      ),
    );
  }

  void getTotal() {
    double totalAmt = 0;
    // totalItems = 0;
    // for (int j = 0;
    //     j < widget.retailOrderCategoryItems.retailCategoryItems.length;
    //     j++) {
    //   List<FacilityItem> facilityItems =
    //       widget.retailOrderCategoryItems.retailCategoryItems[j].facilityItems;
    //   for (int i = 0; i < facilityItems.length; i++) {
    //     int itemCount = itemCounts[facilityItems[i].facilityItemId] == null
    //         ? 0
    //         : itemCounts[facilityItems[i].facilityItemId].quantity;
    //     if (itemCount != null && itemCount > 0) {
    //       totalItems++;
    //     }
    //     totalAmt = totalAmt + (facilityItems[i].price * itemCount);
    //   }
    // }
    total = totalAmt;
  }

  // _onChangeOptionDropdown(GiftCardCategory cardCategory) {
  //   selectCardCategory = cardCategory;
  //   for (GiftCardImage c in widget.giftCardImages) {
  //     c.selected = false;
  //   }
  //   setState(() {});
  // }

  // _onChangeShareOptionDropdown(GiftCardCategory cardCategory) {
  //   selectGiftTo = cardCategory;
  //   setState(() {});
  // }

  _onSelectImage() {
    for (GiftCardImage c in widget.giftCardImagesForCategory) {
      c.selected = false;
    }
    setState(() {});
  }

  _onSelectPrice() {
    for (GiftCardItemsPrice c in widget.giftCardCategoryAndPrice.priceinfo) {
      c.selected = false;
    }
    setState(() {});
  }

  _onSelectCategory() {
    for (GiftCardCategory c in widget.giftCardCategoryAndPrice.categoryInfo) {
      c.selected = false;
    }
    setState(() {});
  }

  // _onChangePriceOptionDropdown(GiftCardItemsPrice price) {
  //   selectCardPrice = price;
  //   total = price.price;
  //   setState(() {});
  // }

  Widget getHtml(String description) {
    return Html(
        style: {
          "body": Style(
            padding: EdgeInsets.all(0),
            margin: Margins.all(0),
          ),
          "p": Style(
            color: ColorData.primaryTextColor.withOpacity(0.5),
            padding: EdgeInsets.all(0),
            margin: Margins.all(0),
          ),
          "span": Style(
            padding: EdgeInsets.all(0),
            margin: Margins.all(0),
            fontSize: FontSize(Styles.newTextSize),
            fontWeight: FontWeight.normal,
            color: ColorData.cardTimeAndDateColor,
            fontFamily: tr('currFontFamilyEnglishOnly'),
          ),
          "h6": Style(
            // fontSize: FontSize(Styles.textSizeSmall),
            // color: ColorData.primaryTextColor.withOpacity(0.5),
            // fontFamily: tr('currFontFamilyEnglishOnly'),
            padding: EdgeInsets.all(0),
            margin: Margins.all(0),
          ),
        },
        // customFont: tr('currFontFamilyEnglishOnly'),
        // anchorColor: ColorData.primaryTextColor,
        data: (description != null
            ? "<html><body>" + description + "</body></html>"
            : tr('noDataFound')));
  }

  Widget getItemList() {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.giftCardImages.length,
            itemBuilder: (context, j) {
              return Visibility(
                  visible: widget.giftCardImages[j].giftCardCategoryId ==
                      selectCardCategory.categoryId,
                  child: Card(
                      elevation: 5,
                      color: ColorData.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.26,
                        margin: EdgeInsets.all(5),
                        color: Colors.red,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 2),
                                // Localizations.localeOf(context).languageCode == "en"
                                //     ? EdgeInsets.only(top: 2, left: 5)
                                //     : EdgeInsets.only(top: 5, right: 5),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.24,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              // margin: Localizations.localeOf(context)
                                              //             .languageCode ==
                                              //         "en"
                                              //     ? EdgeInsets.only(left: 1, top: 1)
                                              //     : EdgeInsets.only(right: 1, top: 1),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.23,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.96,
                                              child: Image.network(
                                                  widget.giftCardImages[j]
                                                      .giftCardImageUrl,
                                                  fit: BoxFit.fill),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])),
                            // Padding(
                            //     padding: EdgeInsets.only(
                            //       left: 60,
                            //       top: 90,
                            //     ),
                            //     // Localizations.localeOf(context).languageCode == "en"
                            //     //     ? EdgeInsets.only(top: 2, left: 5)
                            //     //     : EdgeInsets.only(top: 5, right: 5),
                            //     child: Text(_giftText.text)),
                            // Padding(
                            //     padding: EdgeInsets.only(
                            //       left:
                            //           MediaQuery.of(context).size.width * 0.75,
                            //       top:
                            //           MediaQuery.of(context).size.height * 0.20,
                            //     ),
                            //     // Localizations.localeOf(context).languageCode == "en"
                            //     //     ? EdgeInsets.only(top: 2, left: 5)
                            //     //     : EdgeInsets.only(top: 5, right: 5),
                            //     child: Text(_giftPrice.text)),
                            StatefulBuilder(
                                builder: (BuildContext context,
                                        StateSetter setState) =>
                                    GestureDetector(
                                      child: Theme(
                                          data: ThemeData(
                                              unselectedWidgetColor:
                                                  Colors.grey[400]),
                                          child: CheckboxListTile(
                                            checkColor: Colors.greenAccent,
                                            activeColor: Colors.blue,
                                            value: widget.giftCardImages[j]
                                                        .selected ==
                                                    null
                                                ? false
                                                : widget
                                                    .giftCardImages[j].selected,
                                            onChanged: (bool value) {
                                              _onSelectImage();
                                              setState(() {
                                                widget.giftCardImages[j]
                                                    .selected = value;
                                              });
                                            },
                                            controlAffinity: ListTileControlAffinity
                                                .leading, //  <-- leading Checkbox
                                          )),
                                    ))
                          ],
                        ),
                      )));
            }));
  }

  Widget getCategoryWidget() {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return GridView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: widget.giftCardCategoryAndPrice.categoryInfo == null
            ? 0
            : widget.giftCardCategoryAndPrice.categoryInfo.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6.0,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 5.2),
        ),
        itemBuilder: (context, j) {
          return SizedBox(
            // width: MediaQuery.of(context).size.width * 0.3,
            child: ElevatedButton(
              onPressed: () {
                _onSelectCategory();
                widget.giftCardCategoryAndPrice.categoryInfo[j].selected = true;
                selectGiftTo = widget.giftCardCategoryAndPrice.categoryInfo[j];
                widget.giftCardImagesForCategory.clear();
                widget._current = 0;
                for (GiftCardImage image in widget.giftCardImages) {
                  image.selected = false;
                  if (image.giftCardCategoryId ==
                      widget.giftCardCategoryAndPrice.categoryInfo[j]
                          .categoryId) {
                    widget.giftCardImagesForCategory.add(image);
                  }
                }
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/birthday1.png',
                    height: 20,
                    width: 20,
                  ),
                  Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(left: 2),
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      widget.giftCardCategoryAndPrice.categoryInfo[j]
                          .categoryName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ColorData.primaryTextColor.withOpacity(0.80),
                          fontSize: Styles.packageExpandTextSiz,
                          fontWeight: FontWeight.w700,
                          fontFamily: tr("currFontFamilyEnglishOnly")),
                    ),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.giftCardCategoryAndPrice.categoryInfo[j]
                                .selected !=
                            null &&
                        widget.giftCardCategoryAndPrice.categoryInfo[j].selected
                    ? Colors.black12
                    : Colors.white,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 8, right: 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          );
        });
  }

  Widget getPriceWidget() {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    // int select = -1;

    return GridView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: widget.giftCardCategoryAndPrice.priceinfo == null
            ? 0
            : widget.giftCardCategoryAndPrice.priceinfo.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6.0,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 5.2),
        ),
        itemBuilder: (context, j) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _onSelectPrice();
                  widget.giftCardCategoryAndPrice.priceinfo[j].selected = true;
                  selectCardPrice =
                      widget.giftCardCategoryAndPrice.priceinfo[j];
                  total = selectCardPrice.price;
                  // print(selectCardPrice.toString());
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/currency1.png',
                    height: 24,
                    width: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      widget.giftCardCategoryAndPrice.priceinfo[j].price
                          .toStringAsFixed(2),
                      style: TextStyle(
                          color: ColorData.primaryTextColor.withOpacity(0.80),
                          fontSize: Styles.loginBtnFontSize,
                          fontWeight: FontWeight.w700,
                          fontFamily: tr("currFontFamilyEnglishOnly")),
                    ),
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                backgroundColor: (widget.giftCardCategoryAndPrice.priceinfo[j]
                                .selected !=
                            null &&
                        widget.giftCardCategoryAndPrice.priceinfo[j].selected)
                    ? Colors.black12
                    : Colors.white,
                padding: EdgeInsets.only(left: 16, right: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          );
        });
  }

  Widget carouselUi(BuildContext context, List<GiftCardImage> result) {
    if (result != null && result.length > 0) {
      return Column(children: [
        InkWell(
            onTap: () {
              _onSelectImage();
              setState(() {
                //widget.giftCardImages[widget._current].selected = true;
                widget.giftCardImagesForCategory[widget._current].selected =
                    true;
              });
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey[200]),
                  color: Colors.transparent,
                ),
                child: Container(
                  color: ColorData.whiteColor,
                  padding: EdgeInsets.only(bottom: 2.0),
                  child: CarouselSlider.builder(
                    itemCount: result.length,
                    itemBuilder:
                        (BuildContext context, int itemIndex, int realIndex) {
                      return imageUI(result[itemIndex].giftCardImageUrl,
                          result[itemIndex]);
                    },
                    options: CarouselOptions(
                        enlargeCenterPage: true,
                        height: carouselHeight - 70,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        pauseAutoPlayOnTouch: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            widget._current = index;
                          });
                        },
                        scrollDirection: Axis.horizontal),
                  ),
                ))),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Container(
            height: 30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: result.length,
                itemBuilder: (context, i) {
                  return Container(
                    width: 14.0,
                    height: 14.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget._current == i
                          ? Colors.blue[200]
                          : Colors.black12,
                    ),
                  );
                }),
          ),
        )
      ]);
    } else {
      return Container(
        child: Center(
          child: Text('No Data Found'),
        ),
      );
    }
  }

  Widget imageUI(String url, GiftCardImage image) {
    return Stack(children: [
      CachedNetworkImage(
        imageUrl: url != null ? url : Icons.warning,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
              //              colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          child: Center(
            child: SizedBox(
                height: 30.0, width: 30.0, child: CircularProgressIndicator()),
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) =>
              GestureDetector(
                child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.grey[400]),
                    child: CheckboxListTile(
                      checkColor: Colors.greenAccent,
                      activeColor: Colors.blue,
                      value: image.selected == null ? false : image.selected,
                      onChanged: (bool value) {
                        _onSelectImage();
                        setState(() {
                          image.selected = value;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    )),
              ))
    ]);
  }
}
