// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/facility_detail/facility_content/facility_fitness/bloc/bloc.dart';
import 'package:slc/customcomponentfields/custom_food_picker/custom_food_code.dart';
import 'package:slc/customcomponentfields/custom_food_picker/custom_food_selection_dialog.dart';
import 'package:slc/customcomponentfields/customCalendar.dart';

class FacilityDiet extends StatelessWidget {
  List<FitnessUserDiet> dietList = [];
  String colorCode;
  int facilityId;
  FacilityDiet({this.facilityId, this.colorCode});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FacilityFitnessBloc>(
      create: (context) => FacilityFitnessBloc(fitnessBloc: null)
        ..add(new FetchFitnessDietContent(facilityId: this.facilityId)),
      child: FitnessDietPage(
          dietList: this.dietList,
          facilityId: this.facilityId,
          colorCode: this.colorCode),
    );
  }
}

class FitnessDietPage extends StatefulWidget {
  List<FitnessUserDiet> dietList = [];
  List<FoodCode> foodList = [];
  String colorCode;
  int facilityId;
  FitnessDietPage({this.dietList, this.facilityId, this.colorCode});
  @override
  _FitnessDietPageState createState() =>
      _FitnessDietPageState(dietList: this.dietList);
}

class _FitnessDietPageState extends State<FitnessDietPage> {
  List<FitnessUserDiet> dietList = [];
  List<FitnessUserDiet> dietCategory = [];
  List<FoodCode> foodList = [];
  Map<String, List<FitnessUserDiet>> categoryDiets =
      new Map<String, List<FitnessUserDiet>>();
  Map<String, MaskedTextController> _commentControllers =
      new Map<String, MaskedTextController>();
  _FitnessDietPageState({this.dietList});
  ProgressBarHandler _handler;
  String selectedDate = "";
  // CalendarController _controller = new CalendarController();
  Utils util = new Utils();
  int overallCalorie = 0;
  int actualCalorie = 0;
  DateTime date = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );
    return BlocListener<FacilityFitnessBloc, FacilityFitnessState>(
        listener: (context, state) async {
          if (state is ShowProgressBar) {
            _handler.show();
          } else if (state is HideProgressBar) {
            _handler.dismiss();
          } else if (state is PopulateFacilityFitnessDietData) {
            if (state.response != null) {
              setState(() {
                widget.foodList = state.response;
              });
            }
          } else if (state is SaveFacilityFitnessDietData) {
            if (state.response != null) {
              if (state.response == "Success") {
                util.customGetSnackBarWithOutActionButton(
                    "Diet", "Diet Followup Updated Successfully ", context);
                // BlocProvider.of<FacilityFitnessBloc>(context).add(
                //     FetchFitnessDietContent(
                //         facilityId: widget.facilityId,
                //         selectedDate: selectedDate));
              } else {
                util.customGetSnackBarWithActionButton(
                    "Diet", state.response, context);
              }
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(tr('dietplan'), style: TextStyle(color: Colors.blue)),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_outlined),
              color: Colors.blue,
            ),
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.97,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.97,
                          width: MediaQuery.of(context).size.width,
                          child: Row(children: [getCalendar()])),
                      progressBar
                    ],
                  ))),
        ));
  }

  Widget getCalendar() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenWidth,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: ColorData.fitnessBgColor,
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * 0.050,
              width: screenWidth,
              color: ColorData.fitnessFacilityColor,
              alignment: Alignment.center,
              child: Text(
                  DateFormat("MMMM", 'en_US')
                          .format(_selectedDate)
                          .toUpperCase() +
                      ' ' +
                      DateFormat("yyyy", 'en_US')
                          .format(_selectedDate)
                          .toUpperCase(),
                  style: Styles.textDefaultWithColor),
            ),
            Container(
              height: screenHeight * 0.075,
              padding: EdgeInsets.only(left: 50, right: 50),
              color: ColorData.fitnessBgColor,
              child: CustomDatePicker(
                DateTime.now(),
                width: screenWidth * 0.100,
                initialSelectedDate: DateTime.now(),
                monthTextStyle: TextStyle(
                    fontSize: Styles.textSizeSmall,
                    color: ColorData.fitnessFacilityColor,
                    fontWeight: FontWeight.bold),
                selectionColor: ColorData.fitnessFacilityColor,
                selectedTextColor: ColorData.fitnessBgColor,
                selectedDayTextStyle: TextStyle(
                    fontSize: Styles.loginBtnFontSize,
                    color: ColorData.fitnessBgColor,
                    fontWeight: FontWeight.bold),
                dayTextStyle: TextStyle(
                    fontSize: Styles.loginBtnFontSize,
                    color: ColorData.fitnessFacilityColor,
                    fontWeight: FontWeight.bold),
                dateTextStyle: TextStyle(
                    fontSize: Styles.textSizeSmall,
                    color: ColorData.fitnessFacilityColor,
                    fontWeight: FontWeight.bold),
                onDateChange: (date) async {
                  debugPrint('================== $date');
                  _selectedDate = date;
                  Meta m = await FacilityDetailRepository()
                      .getFitnessDietList(widget.facilityId, selectedDate);
                  List<FitnessUserDiet> diets = [];

                  if (m.statusCode == 200) {
                    jsonDecode(m.statusMsg)['response'].forEach(
                        (f) => diets.add(new FitnessUserDiet.fromJson(f)));
                  }
                  getCategoryDiets(diets);
                  setState(() {});
                },
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 12, right: 12, top: 14),
                height:
                    MediaQuery.of(context).size.height - (screenHeight * 0.30),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey[400]),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              overallCalorie.toString() +
                                  ' of ' +
                                  actualCalorie.toString() +
                                  ' Cal',
                              style: TextStyle(
                                  color: ColorData.toColor(widget.colorCode),
                                  fontSize: Styles.textSizeSmall,
                                  fontFamily: tr('currFontFamily')),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              tr('showcomments'),
                              style: TextStyle(
                                  color: ColorData.toColor(widget.colorCode),
                                  fontSize: Styles.textSizeSmall,
                                  fontFamily: tr('currFontFamily')),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height -
                            (screenHeight * 0.45),
                        child: Row(children: [getDiets()]),
                      ),
                      Visibility(
                          visible:
                              dietCategory != null && dietCategory.length > 0
                                  ? true
                                  : false,
                          child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorData.toColor(widget.colorCode)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  )))),
                              // textColor: Colors.white,
                              // color: ColorData.toColor(widget.colorCode),
                              child: Text(tr("submit"),
                                  style: TextStyle(
                                      fontSize: Styles.textSizeSmall,
                                      fontFamily: tr('currFontFamily'))),
                              onPressed: () {
                                FitnessUserDietEntry request =
                                    getDietSaveDetails();
                                BlocProvider.of<FacilityFitnessBloc>(context)
                                    .add(FetchFitnessDietSave(
                                        dietEntry: request));
                              },
                              // shape: new RoundedRectangleBorder(
                              //   borderRadius: new BorderRadius.circular(8.0),
                              // ),
                            ),
                          ))
                    ])),
          ],
        ));
  }

  Widget getDiets() {
    debugPrint(" diet cate" + dietCategory.length.toString());
    return Expanded(
        child: ListView.builder(
            key: PageStorageKey("Category_PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: dietCategory.length,
            itemBuilder: (context, j) {
              //return //Container(child: Text(enquiryDetailResponse[j].firstName));
              return Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: [
                          Container(
                            color: ColorData.fitnessBgColor,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dietCategory[j].mealTime,
                                  style: TextStyle(
                                      color: ColorData.fitnessFacilityColor,
                                      fontSize: Styles.textSizeSeventeen,
                                      fontFamily: tr('currFontFamily')),
                                ),
                                Text(
                                  dietCategory[j].calorie + ' Cal',
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor,
                                      fontSize: Styles.textSizeSeventeen,
                                      fontFamily: tr('currFontFamily')),
                                ),
                              ],
                            ),
                          ),
                          getDietItemList(
                              categoryDiets[dietCategory[j].mealTime]),
                          // Padding(
                          //   padding: EdgeInsets.all(5),
                          //   child: Column(
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Container(
                          //             margin: EdgeInsets.all(5),
                          //             height:
                          //                 MediaQuery.of(context).size.height *
                          //                     0.07,
                          //             width:
                          //                 MediaQuery.of(context).size.width *
                          //                     0.15,
                          //             decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(8),
                          //               color: Colors.red,
                          //             ),
                          //           ),
                          //           Padding(
                          //               padding: EdgeInsets.all(5),
                          //               child: Column(
                          //                 children: [
                          //                   Text('Boiled Egg \nDefault text'),
                          //                 ],
                          //               )),
                          //           Expanded(
                          //               child: Align(
                          //             alignment: Alignment(0.8, -0.5),
                          //             child: Container(
                          //                 margin: EdgeInsets.all(5),
                          //                 height: MediaQuery.of(context)
                          //                         .size
                          //                         .height *
                          //                     0.05,
                          //                 width: MediaQuery.of(context)
                          //                         .size
                          //                         .width *
                          //                     0.07,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius:
                          //                       BorderRadius.circular(8),
                          //                   color: Colors.grey[200],
                          //                 ),
                          //                 child: Center(
                          //                   child: Text(
                          //                     '2',
                          //                     style: TextStyle(
                          //                         color: Colors.purple),
                          //                   ),
                          //                 )),
                          //           )),
                          //         ],
                          //       ),
                          //       Row(
                          //         children: [
                          //           Container(
                          //             margin: EdgeInsets.all(5),
                          //             height:
                          //                 MediaQuery.of(context).size.height *
                          //                     0.07,
                          //             width:
                          //                 MediaQuery.of(context).size.width *
                          //                     0.15,
                          //             decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(8),
                          //               color: Colors.red,
                          //             ),
                          //           ),
                          //           Padding(
                          //               padding: EdgeInsets.all(5),
                          //               child: Column(
                          //                 children: [
                          //                   Text('Almond \nDefault Text'),
                          //                 ],
                          //               )),
                          //           Expanded(
                          //               child: Align(
                          //             alignment: Alignment(0.8, -0.5),
                          //             child: Container(
                          //                 margin: EdgeInsets.all(5),
                          //                 height: MediaQuery.of(context)
                          //                         .size
                          //                         .height *
                          //                     0.05,
                          //                 width: MediaQuery.of(context)
                          //                         .size
                          //                         .width *
                          //                     0.07,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius:
                          //                       BorderRadius.circular(8),
                          //                   color: Colors.grey[200],
                          //                 ),
                          //                 child: Center(
                          //                   child: Text(
                          //                     '5',
                          //                     style: TextStyle(
                          //                         color: Colors.purple),
                          //                   ),
                          //                 )),
                          //           )),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorData.toColor(widget.colorCode)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                    Radius.circular(30.0),
                                  )))),
                              // textColor: Colors.white,
                              // color: ColorData.toColor(widget.colorCode),
                              child: Text(tr("add")),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => FoodSelectionDialog(
                                      widget.foodList, widget.foodList,
                                      showFoodOnly: false,
                                      searchStyle: TextStyle(
                                          color: ColorData.primaryTextColor,
                                          fontWeight: null,
                                          fontFamily:
                                              tr('currFontFamilyEnglishOnly')),
                                      showFlag: false),
                                ).then((e) {
                                  if (e != null) {
                                    setState(() {
                                      FitnessUserDiet d = new FitnessUserDiet();
                                      d.mealTime = dietCategory[j].mealTime;
                                      d.fitnessScheduleId =
                                          dietCategory[j].fitnessScheduleId;
                                      d.fitnessFoodId = e.id;
                                      d.fitnessFoodName = e.mealName;
                                      d.calorie = e.calorie;
                                      d.qty = 0;
                                      d.takenQty = 0;
                                      d.takenCalorie = "0";
                                      d.id = 0;
                                      categoryDiets[dietCategory[j].mealTime]
                                          .add(d);
                                    });
                                  }
                                });
                              },
                              // shape: new RoundedRectangleBorder(
                              //   borderRadius: new BorderRadius.circular(30.0),
                              // ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Card(
                                  color: Colors.grey[100],
                                  child: TextFormField(
                                    controller: _commentControllers[
                                        dietCategory[j].mealTime],
                                    cursorColor: Colors.black,
                                    decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 11,
                                            top: 11,
                                            right: 15),
                                        hintText: "Comments"),
                                  )))
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(5),
                    //   child: Container(
                    //     color: Colors.white,
                    //     child: Column(
                    //       children: [
                    //         Padding(
                    //           padding: EdgeInsets.all(5),
                    //           child: Row(
                    //             children: [
                    //               Padding(
                    //                 padding: EdgeInsets.all(2),
                    //                 child: Text(
                    //                   'Morning Snack',
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.bold),
                    //                 ),
                    //               ),
                    //               Expanded(
                    //                   child: Align(
                    //                 alignment: Alignment(0.8, -0.5),
                    //                 child: Text(
                    //                   '462 Cal',
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.bold),
                    //                 ),
                    //               )),
                    //             ],
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: EdgeInsets.all(5),
                    //           child: Column(
                    //             children: [
                    //               Row(
                    //                 children: [
                    //                   Container(
                    //                     margin: EdgeInsets.all(5),
                    //                     height:
                    //                         MediaQuery.of(context).size.height *
                    //                             0.07,
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.15,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(8),
                    //                       color: Colors.red,
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                       padding: EdgeInsets.all(5),
                    //                       child: Column(
                    //                         children: [
                    //                           Text('Boiled Egg \nDefault text'),
                    //                         ],
                    //                       )),
                    //                   Expanded(
                    //                       child: Align(
                    //                     alignment: Alignment(0.8, -0.5),
                    //                     child: Container(
                    //                         margin: EdgeInsets.all(5),
                    //                         height: MediaQuery.of(context)
                    //                                 .size
                    //                                 .height *
                    //                             0.05,
                    //                         width: MediaQuery.of(context)
                    //                                 .size
                    //                                 .width *
                    //                             0.07,
                    //                         decoration: BoxDecoration(
                    //                           borderRadius:
                    //                               BorderRadius.circular(8),
                    //                           color: Colors.grey[200],
                    //                         ),
                    //                         child: Center(
                    //                           child: Text(
                    //                             '2',
                    //                             style: TextStyle(
                    //                                 color: Colors.purple),
                    //                           ),
                    //                         )),
                    //                   )),
                    //                 ],
                    //               ),
                    //               Row(
                    //                 children: [
                    //                   Container(
                    //                     margin: EdgeInsets.all(5),
                    //                     height:
                    //                         MediaQuery.of(context).size.height *
                    //                             0.07,
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.15,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(8),
                    //                       color: Colors.red,
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                       padding: EdgeInsets.all(5),
                    //                       child: Column(
                    //                         children: [
                    //                           Text('Almond \nDefault Text'),
                    //                         ],
                    //                       )),
                    //                   Expanded(
                    //                       child: Align(
                    //                     alignment: Alignment(0.8, -0.5),
                    //                     child: Container(
                    //                         margin: EdgeInsets.all(5),
                    //                         height: MediaQuery.of(context)
                    //                                 .size
                    //                                 .height *
                    //                             0.05,
                    //                         width: MediaQuery.of(context)
                    //                                 .size
                    //                                 .width *
                    //                             0.07,
                    //                         decoration: BoxDecoration(
                    //                           borderRadius:
                    //                               BorderRadius.circular(8),
                    //                           color: Colors.grey[200],
                    //                         ),
                    //                         child: Center(
                    //                           child: Text(
                    //                             '5',
                    //                             style: TextStyle(
                    //                                 color: Colors.purple),
                    //                           ),
                    //                         )),
                    //                   )),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         Align(
                    //           alignment: Alignment.centerRight,
                    //           child: RaisedButton(
                    //             textColor: Colors.white,
                    //             color: Colors.purple,
                    //             child: Text("Add"),
                    //             onPressed: () {},
                    //             shape: new RoundedRectangleBorder(
                    //               borderRadius: new BorderRadius.circular(30.0),
                    //             ),
                    //           ),
                    //         ),
                    //         Padding(
                    //             padding: EdgeInsets.all(5),
                    //             child: Card(
                    //                 color: Colors.grey[100],
                    //                 child: TextFormField(
                    //                   cursorColor: Colors.black,
                    //                   decoration: new InputDecoration(
                    //                       border: InputBorder.none,
                    //                       focusedBorder: InputBorder.none,
                    //                       enabledBorder: InputBorder.none,
                    //                       errorBorder: InputBorder.none,
                    //                       disabledBorder: InputBorder.none,
                    //                       contentPadding: EdgeInsets.only(
                    //                           left: 15,
                    //                           bottom: 11,
                    //                           top: 11,
                    //                           right: 15),
                    //                       hintText: "Comments"),
                    //                 )))
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            }));
  }

  Widget getDietItemList(List<FitnessUserDiet> diets) {
    return ListView.builder(
        key: PageStorageKey("Item_PageStorageKey"),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: diets.length,
        itemBuilder: (context, j) {
          //return //Container(child: Text(enquiryDetailResponse[j].firstName));
          return Container(
            height: MediaQuery.of(context).size.height * 0.12,
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Flexible(
                                  child: new Container(
                                      padding: new EdgeInsets.only(right: 2.0),
                                      child: new Text(
                                        diets[j].fitnessFoodName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily: tr('currFontFamily'),
                                            fontWeight: FontWeight.w500),
                                      ))),
                            ],
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Container(
                            margin:
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        left: 5,
                                        // left: MediaQuery.of(context).size.width *
                                        //     0.02,
                                      )
                                    : EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        right: 5,
                                        // right: MediaQuery.of(context).size.width *
                                        //     0.02,
                                      ),
                            child: Text(
                                tr("recommended") +
                                    ":" +
                                    diets[j].calorie +
                                    " Cal",
                                style: TextStyle(
                                    color: ColorData.toColor(widget.colorCode),
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                          subtitle: Container(
                            margin: Localizations.localeOf(context)
                                        .languageCode ==
                                    "en"
                                ? EdgeInsets.only(top: 5, bottom: 5, left: 5
                                    // left: MediaQuery.of(context).size.width *
                                    //     0.02,
                                    )
                                : EdgeInsets.only(top: 5, bottom: 5, right: 5
                                    // right: MediaQuery.of(context).size.width *
                                    //     0.02,
                                    ),
                            // height: MediaQuery.of(context).size.height * .05,
                            // width: MediaQuery.of(context).size.width * 0.18,
                            child: Text(
                                tr("taken") + " : " + diets[j].takenCalorie,
                                style: TextStyle(
                                    color: ColorData.toColor(widget.colorCode),
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                          trailing: Container(
                            margin: Localizations.localeOf(context)
                                        .languageCode ==
                                    "en"
                                ? EdgeInsets.only(top: 0, bottom: 0, left: 10
                                    // left: MediaQuery.of(context).size.width *
                                    //     0.30,
                                    )
                                : EdgeInsets.only(top: 0, bottom: 0, right: 10
                                    // right: MediaQuery.of(context).size.width *
                                    //     0.40,
                                    ),
                            height: MediaQuery.of(context).size.height * .05,
                            width: MediaQuery.of(context).size.width * 0.30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[200]),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(right: 80)
                                      : EdgeInsets.only(left: 80),
                                  child: new IconButton(
                                      icon: new Icon(Icons.delete,
                                          size: 18, color: Colors.grey),
                                      onPressed: () {
                                        if (diets[j].takenQty == null) {
                                          diets[j].takenQty = 0;
                                          diets[j].takenCalorie = "0";
                                        }
                                        if (diets[j].takenQty != null &&
                                            diets[j].takenQty > 0) {
                                          setState(() {
                                            diets[j].takenQty =
                                                diets[j].takenQty - 1;
                                            diets[j].takenCalorie = (diets[j]
                                                        .takenQty *
                                                    int.parse(diets[j].calorie))
                                                .toString();
                                          });
                                        }
                                        getTotal();
                                      }),
                                ),
                                Padding(
                                  padding: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          left: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30) /
                                              4)
                                      : EdgeInsets.only(
                                          right: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30) /
                                              4),
                                  child: VerticalDivider(
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          left: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30) /
                                              2.3,
                                          top: 9)
                                      : EdgeInsets.only(
                                          right: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30) /
                                              2.3,
                                          top: 9),
                                  child: new Text(
                                      diets[j].takenQty == null
                                          ? "0"
                                          : diets[j].takenQty.toString(),
                                      style: TextStyle(color: Colors.grey)),
                                ),
                                Padding(
                                  padding: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          left: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30) /
                                              1.75)
                                      : EdgeInsets.only(
                                          right: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30) /
                                              1.75),
                                  child: VerticalDivider(
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          left: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30) /
                                              1.60)
                                      : EdgeInsets.only(
                                          right: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30) /
                                              1.60),
                                  child: new IconButton(
                                      icon: new Icon(Icons.add,
                                          color: Colors.grey, size: 18),
                                      onPressed: () => setState(() {
                                            if (diets[j].takenQty == null) {
                                              diets[j].takenQty = 0;
                                              diets[j].takenCalorie = "0";
                                            }
                                            diets[j].takenQty =
                                                diets[j].takenQty + 1;
                                            diets[j].takenCalorie = (diets[j]
                                                        .takenQty *
                                                    int.parse(diets[j].calorie))
                                                .toString();
                                            getTotal();
                                          })),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // void _onCalendarCreated(
  //     DateTime day, DateTime day1, CalendarFormat format) async {
  //   selectedDate = _controller.selectedDay.toString().substring(0, 10);
  //   Meta m = await FacilityDetailRepository()
  //       .getFitnessDietList(widget.facilityId, selectedDate);
  //   List<FitnessUserDiet> diets = [];
  //
  //   if (m.statusCode == 200) {
  //     jsonDecode(m.statusMsg)['response']
  //         .forEach((f) => diets.add(new FitnessUserDiet.fromJson(f)));
  //   }
  //   setState(() {
  //     getCategoryDiets(diets);
  //   });
  // }
  //
  // void _onDaySelected(DateTime day) async {
  //   print('CALLBACK: _onDaySelected');
  //   selectedDate = day.toString().substring(0, 10);
  //   Meta m = await FacilityDetailRepository()
  //       .getFitnessDietList(widget.facilityId, selectedDate);
  //   List<FitnessUserDiet> diets = [];
  //
  //   if (m.statusCode == 200) {
  //     jsonDecode(m.statusMsg)['response']
  //         .forEach((f) => diets.add(new FitnessUserDiet.fromJson(f)));
  //   }
  //   setState(() {
  //     getCategoryDiets(diets);
  //   });
  // }

  void getCategoryDiets(List<FitnessUserDiet> diets) {
    List<FitnessUserDiet> categoryDiet = [];
    FitnessUserDiet dietCat = new FitnessUserDiet();
    int totalCalorie = 0;
    dietCategory.clear();
    categoryDiets.clear();
    _commentControllers.clear();
    for (var diet in diets) {
      if (dietCategory.where((d) => d.mealTime == diet.mealTime).isEmpty) {
        if (dietCat != null) {
          dietCat.calorie = totalCalorie.toString();
        }
        dietCat = new FitnessUserDiet();
        dietCat.mealTime = diet.mealTime;
        dietCat.fitnessScheduleId = diet.fitnessScheduleId;
        dietCat.calorie = "0";
        categoryDiet = [];
        categoryDiets[diet.mealTime] = categoryDiet;
        dietCategory.add(dietCat);
        totalCalorie = 0;
        _commentControllers[dietCat.mealTime] =
            new MaskedTextController(mask: Strings.maskEngValidationStr);
      }
      categoryDiet.add(diet);
      totalCalorie = totalCalorie + int.parse(diet.calorie);
    }
    if (dietCat != null) {
      dietCat.calorie = totalCalorie.toString();
    }
    getTotal();
  }

  FitnessUserDietEntry getDietSaveDetails() {
    List<DietFollowUp> diets = [];
    FitnessUserDietEntry dietEntry = new FitnessUserDietEntry();
    for (int i = 0; i < dietCategory.length; i++) {
      FitnessUserDiet grp = dietCategory[i];
      List<FitnessUserDiet> grpDiets = categoryDiets[grp.mealTime];
      for (int j = 0; j < grpDiets.length; j++) {
        DietFollowUp followUp = new DietFollowUp();
        followUp.mealTime = grp.mealTime;
        followUp.comments = _commentControllers[grp.mealTime].text.toString();
        followUp.fitnessFoodId = grpDiets[j].fitnessFoodId;
        followUp.fitnessScheduleId = grpDiets[j].fitnessScheduleId;
        followUp.qty = grpDiets[j].takenQty;
        followUp.calorie = grpDiets[j].takenCalorie;
        followUp.transDate = selectedDate;
        followUp.id = 0;
        followUp.fitnessUserDietId = grpDiets[j].id;
        diets.add(followUp);
      }
    }
    dietEntry.dietFollowUp = diets;
    return dietEntry;
  }

  void getTotal() {
    int totCal = 0;
    int actCal = 0;
    for (int i = 0; i < dietCategory.length; i++) {
      FitnessUserDiet grp = dietCategory[i];
      List<FitnessUserDiet> grpDiets = categoryDiets[grp.mealTime];
      for (int j = 0; j < grpDiets.length; j++) {
        if (grpDiets[j].id != 0) {
          actCal = actCal + (grpDiets[j].qty * int.parse(grpDiets[j].calorie));
        }
        totCal =
            totCal + (grpDiets[j].takenQty * int.parse(grpDiets[j].calorie));
      }
    }
    setState(() {
      overallCalorie = totCal;
      actualCalorie = actCal;
    });
  }
}
