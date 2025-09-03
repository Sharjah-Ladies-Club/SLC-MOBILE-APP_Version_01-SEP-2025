// ignore_for_file: must_be_immutable

import 'dart:collection';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:slc/view/fitness/bloc/bloc.dart';
import 'package:slc/view/fitness/fitness_enquiry.dart';
import 'package:slc/view/fitness/gymentry.dart';
import 'package:slc/view/fitness/personaltraining.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/theme/styles.dart';

class FitnessMembershipPage extends StatelessWidget {
  int facilityId;
  String colorCode;
  String memName;
  int memID;
  int abcID;
  String validity;
  int moduleId;
  FitnessMembershipPage(
      {this.facilityId,
      this.colorCode,
      this.memName,
      this.memID,
      this.abcID,
      this.validity,
      this.moduleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<FitnessBloc>(
              create: (context) => FitnessBloc(null)
                ..add(GetItemDetailsEvent(
                    facilityId: facilityId, retailItemSetId: ""))
                ..add(GetPaymentTerms(facilityId: facilityId))),
        ],
        child: FitnessMembership(
            memName: memName,
            memID: memID,
            abcID: abcID,
            validity: validity,
            facilityId: facilityId,
            colorCode: colorCode,
            moduleId: moduleId),
      ),
    );
  }
}

class FitnessMembership extends StatefulWidget {
  final String memName;
  final int memID;
  final int abcID;
  final String validity;
  int facilityId;
  String retailItemSetId;
  int enquiryDetailId;
  int tableNo;
  String colorCode;
  bool showItemCategory = false;
  int moduleId = 0;
  List<FacilityItems> facilityItems = [];
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  List<FacilityDetailItem> retailOrderCategoryItems = [];
  // new List<FacilityDetailItem>();
  FacilityDetailItem selectedRetailOrderItems = new FacilityDetailItem();

  FitnessMembership(
      {Key key,
      @required this.memName,
      @required this.memID,
      @required this.abcID,
      @required this.validity,
      this.facilityId,
      this.colorCode,
      this.moduleId})
      : super(key: key);
  @override
  State<FitnessMembership> createState() => _FitnessMembershipState();
}

class _FitnessMembershipState extends State<FitnessMembership> {
  static final borderColor = Colors.grey[200];
  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    debugPrint("DDDDDDHHHHHHHHHHHHHHHHH" + widget.facilityId.toString());
    return BlocListener<FitnessBloc, FitnessState>(
        listener: (context, state) async {
          if (state is LoadFitnessItemList) {
            if (widget.facilityItems.length == 0) {
              setState(() {
                widget.retailOrderCategoryItems = state.fitnessItems;
                widget.selectedRetailOrderItems =
                    widget.retailOrderCategoryItems[0];
                // widget.facilityItems =
                //     widget.selectedRetailOrderItems.facilityItems;
                for (int j = 0;
                    j < widget.retailOrderCategoryItems.length;
                    j++) {
                  List<FacilityItems> facilityItemList =
                      widget.retailOrderCategoryItems[j].facilityItems;
                  widget.facilityItems.addAll(facilityItemList);
                }
                if (widget.retailOrderCategoryItems != null) {
                  widget.facilityId = widget.facilityId;
                  // widget.colorCode = "A81B8D";
                }
              });
            }
          } else if (state is FitnessEnquirySaveState) {
            if (state.error == "Success") {
              int enquiryDetailId = jsonDecode(state.message)['response'];
              widget.enquiryDetailId = enquiryDetailId;
              FacilityDetailResponse facilityDetailResponse =
                  new FacilityDetailResponse();
              Meta m2 = await (new FacilityDetailRepository())
                  .getFacilityDetails(widget.facilityId);
              if (m2.statusCode == 200) {
                facilityDetailResponse = FacilityDetailResponse.fromJson(
                    jsonDecode(m2.statusMsg)['response']);

                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FitnessEnquiry(
                      facilityItem: state.facilityItem,
                      facilityDetail: facilityDetailResponse,
                      enquiryDetailId: enquiryDetailId,
                      screenType: Constants.Work_Flow_UploadDocuments,
                      moduleId: widget.moduleId, //2
                    ),
                  ),
                );
              }
            }
          }
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: ColorData.backgroundColor,
            appBar: AppBar(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              automaticallyImplyLeading: true,
              title: Text("Fitness 180",
                  style: TextStyle(color: Colors.blue[200])),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.blue[200],
                onPressed: () {
                  Navigator.pop(context);
                  if (widget.moduleId == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FacilityDetailsPage(
                              facilityId: widget.facilityId)),
                    );
                  } else if (widget.moduleId == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GymEntryPage(
                                screenType: 1, colorCode: "A81B8D")));
                  } else if (widget.moduleId == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GymEntryPage(
                                screenType: 2, colorCode: "A81B8D")));
                  } else if (widget.moduleId == 4) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PersonalTrainingPage(
                                screenType: 1, colorCode: "A81B8D")));
                  }
                },
              ),
              backgroundColor: Colors.white,
            ),
            body: Column(
              children: [getItemList(widget.facilityId, "")],
            ),
          ),
        ));
  }

  Widget getItemList(int facilityId, String retailItemSetId) {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.facilityItems.length,
            itemBuilder: (context, j) {
              return Container(
                  margin: EdgeInsets.only(top: 5, left: 4, right: 3),
                  child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/fmcardbg.jpeg',
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * .175,
                            width: MediaQuery.of(context).size.width * .98,
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: MediaQuery.of(context).size.height * .175,
                            width: MediaQuery.of(context).size.width * .98,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              border: Border.all(color: borderColor),
                              color: Colors.transparent,
                            ),
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          top: 20.0, left: 10.0, bottom: 15.0)
                                      : EdgeInsets.only(
                                          top: 20.0, right: 10.0, bottom: 15.0),
                                  child: Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        widget.facilityItems[j]
                                                    .facilityItemName !=
                                                null
                                            ? widget.facilityItems[j]
                                                .facilityItemName
                                            : "Not Found",
                                        style: TextStyle(
                                            color: ColorData.toColor(
                                                widget.colorCode),
                                            fontSize: Styles.textSizeSeventeen,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: tr('currFontFamily')),
                                      )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  padding: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          top: 30.0, left: 10.0, bottom: 10.0)
                                      : EdgeInsets.only(
                                          top: 30.0, right: 10.0, bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: SingleChildScrollView(
                                              child: getHtml(widget
                                                  .facilityItems[j]
                                                  .description))),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(top: 100, left: 10.0)
                                      : EdgeInsets.only(top: 100, right: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'AED ' +
                                            widget.facilityItems[j].price
                                                .toStringAsFixed(2) +
                                            '  ',
                                        style: TextStyle(
                                            color: ColorData.toColor(
                                                widget.colorCode),
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily: tr('currFontFamily')),
                                      ),
                                      Visibility(
                                          visible: widget.facilityItems[j]
                                                  .isDiscountable
                                              ? true
                                              : false,
                                          child: Text(tr("discountable"),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      Styles.reviewTextSize,
                                                  //fontStyle: FontStyle.italic,
                                                  backgroundColor:
                                                      ColorData.toColor(
                                                          widget.colorCode))))

                                      //Image.asset(
                                      //    'assets/images/discount.png'))
                                    ],
                                  ),
                                ),
                                Container(
                                    margin: Localizations.localeOf(context)
                                                .languageCode ==
                                            "en"
                                        ? EdgeInsets.only(
                                            top: 70,
                                            bottom: 5,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.58,
                                          )
                                        : EdgeInsets.only(
                                            top: 70,
                                            bottom: 5,
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.58,
                                          ),
                                    height: MediaQuery.of(context).size.height *
                                        .05,
                                    // width:
                                    //     MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorData.whiteColor),
                                      color: ColorData.colorRed,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: new ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorData.toColor(
                                              widget.colorCode),
                                          side: BorderSide(
                                              width: 1.0,
                                              color: Colors.transparent)),
                                      onPressed: () async {
                                        EnquiryDetailResponse request =
                                            getEnquiry(widget.facilityItems[j]);
                                        BlocProvider.of<FitnessBloc>(context)
                                            .add(FitnessEnquirySaveEvent(
                                                enquiryDetailResponse: request,
                                                facilityItem:
                                                    widget.facilityItems[j]));
                                      },
                                      icon: Icon(Icons.add_shopping_cart),
                                      label: new Text(tr('buy_membership'),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: ColorData.whiteColor),
                                          textAlign: TextAlign.center),
                                    ))
                              ],
                            ),
                          )
                        ],
                      )));
            }));
  }

  EnquiryDetailResponse getEnquiry(FacilityItems item) {
    debugPrint("SSSSSSSSSSSSSSSSSSSSSSSSS:::" + item.facilityId.toString());
    EnquiryDetailResponse request = new EnquiryDetailResponse();
    request.facilityId = item.facilityId;
    request.facilityItemId = item.facilityItemId;
    request.erpCustomerId = SPUtil.getInt(Constants.USER_CUSTOMERID);
    request.firstName = SPUtil.getString(Constants.USER_FIRSTNAME);
    request.lastName = SPUtil.getString(Constants.USER_LASTNAME);
    request.enquiryStatusId = 1;
    request.supportDocuments = [];
    request.totalClass = 0;
    request.balanceClass = 0;
    request.consumedClass = 0;
    request.contacts = [];
    final String formatted =
        DateFormat('dd-MM-yyyy', 'en_US').format(DateTime.now());
    request.DOB = DateTimeUtils().dateToStringFormat(
        DateTimeUtils().stringToDate(SPUtil.getString(Constants.USER_DOB),
            DateTimeUtils.DD_MM_YYYY_Format),
        DateTimeUtils.dobFormat);
    request.enquiryDate = DateTimeUtils().dateToStringFormat(
        DateTimeUtils().stringToDate(
            formatted.toString(), DateTimeUtils.DD_MM_YYYY_Format),
        DateTimeUtils.dobFormat);

    request.nationalityId = 69;
    request.preferedTime = "";
    request.languages = "";
    request.emiratesID = "";
    request.address = "";
    request.genderId = 1;
    request.comments = "";
    request.isActive = true;
    request.enquiryTypeId = 1;
    request.countryId = 115;
    request.facilityItemName = item.facilityItemName;
    request.faclitiyItemDescription = item.description;
    request.price = item.price;
    request.vatPercentage = 0;
    request.facilityImageName = "";
    request.facilityImageUrl = "";
    request.enquiryDetailId = 0;
    request.rate = item.rate;
    return request;
  }

  Widget getHtml(String description) {
    return Html(
        style: {
          "body": Style(
            padding: EdgeInsets.all(0),
            margin: Margins.all(0),
          ),
          "p": Style(
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
            fontSize: FontSize(Styles.newTextSize),
            fontWeight: FontWeight.normal,
            color: ColorData.cardTimeAndDateColor,
            padding: EdgeInsets.all(0),
            margin: Margins.all(0),
          ),
        },
        // customFont: tr('currFontFamilyEnglishOnly'),
        // anchorColor: ColorData.primaryTextColor,
        data: (description != null
            ? '<html><body>' + description + '</body></html>'
            : tr('noDataFound')));
  }
}
