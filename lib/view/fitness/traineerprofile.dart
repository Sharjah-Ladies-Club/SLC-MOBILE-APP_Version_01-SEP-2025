// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/view/fitness/bloc/bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../model/transaction_response.dart';

class FitnessTrainersProfile extends StatelessWidget {
  int trainerId;
  String classDate;
  List<TrainerProfile> trainerProfile = [];
  FitnessTrainersProfile({this.trainerId, this.classDate, this.trainerProfile});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FitnessBloc>(
      create: (context) => FitnessBloc(null)
        // ..add(GetTrainersProfileEvent(trainerId: 0, fromDate: classDate)),
        ..add(HideFitnessProgressBar()),
      child: _TrainersProfile(
        trainerId: this.trainerId,
        trainerProfile: this.trainerProfile,
        classDate: classDate,
      ),
    );
  }
}

class _TrainersProfile extends StatefulWidget {
  int trainerId;
  String classDate;
  String colorCode = "#EEEEEE";
  List<TrainerProfile> trainerProfile = [];
  _TrainersProfile({
    this.trainerId,
    this.trainerProfile,
    this.classDate,
  });

  @override
  State<_TrainersProfile> createState() => TrainerProfileState();
}

class TrainerProfileState extends State<_TrainersProfile> {
  int trainerId;
  String classDate;
  TrainerProfile tProfile = new TrainerProfile();
  List<TrainerProfile> trainerProfile = [];
  PageController pgcontroller = PageController(viewportFraction: 0.2);
  ProgressBarHandler _handler;
  WebViewController _controller;

  int selectedIndex = 0;
  int selectedTrainerIndex = 0;
  int tolLength = 1;
  List<TrainerProfile> newLst = [];

  //TrainerProfileState({this.trainerId, this.trainerProfile, this.classDate});

  void initState() {
    // TODO: implement initState
    newLst = widget.trainerProfile
        .where((o) => o.trainerID == widget.trainerId)
        .toList();
    tProfile =
        newLst != null && newLst.length > 0 ? newLst[0] : new TrainerProfile();
    tolLength = widget.trainerProfile.length;
    //debugPrint("First" + tProfile.trainerImageFile);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );
    return BlocListener<FitnessBloc, FitnessState>(
        listener: (context, state) async {
          if (state is ShowFitnessProgressBar) {
            _handler.show();
          } else if (state is HideFitnessProgressBar) {
            _handler.dismiss();
            print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
          }
          // } else if (state is GetTrainersProfileState) {
          //   if (state.trainerProfile != null) {
          //     widget.trainerProfile = state.trainerProfile;
          //     if (widget.trainerProfile != null &&
          //         widget.trainerProfile.length > 0) {
          //       tProfile = widget.trainerProfile[0];
          //       tolLength = widget.trainerProfile.length;
          //     }
          //     setState(() {});
          //   }
          // }
        },
        child: SafeArea(
          child: Scaffold(
              backgroundColor: ColorData.whiteColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100.0),
                child: CustomAppBar(
                  title: tr("fitness_title"),
                ),
              ),
              body: Stack(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: screenHeight * 0.13,
                            color: ColorData.fitnessTextBgColor,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 14, left: 8, right: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tr('trainers'),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorData
                                                        .fitnessFacilityColor),
                                              ),
                                              Text(
                                                ' ' + tr('profiles'),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    // fontWeight: FontWeight.bold,
                                                    color: ColorData
                                                        .primaryTextColor),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: screenWidth * 0.64,
                                            margin: EdgeInsets.only(top: 4),
                                            padding: EdgeInsets.all(8),
                                            color: ColorData.fitnessBgColor,
                                            child: Text(
                                              tProfile != null &&
                                                      tProfile.trainerName !=
                                                          null
                                                  ? Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? tProfile.trainerName
                                                      : tProfile.trainerName
                                                  : "",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: ColorData
                                                      .fitnessFacilityColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                      tProfile != null &&
                                              tProfile.trainerImageFile != null
                                          ? CircleAvatar(
                                              radius: 40.0,
                                              backgroundImage: NetworkImage(
                                                  tProfile.trainerImageFile),
                                            )
                                          : CircleAvatar(
                                              radius: 40.0,
                                              backgroundColor:
                                                  ColorData.whiteColor,
                                              child: Icon(Icons.person,
                                                  size: 28,
                                                  color: ColorData
                                                      .fitnessFacilityColor),
                                            ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //     padding: EdgeInsets.only(
                                //         top: 4, left: 8, right: 8),
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.start,
                                //       children: [
                                //         Text(
                                //           tr("emailLabel"),
                                //           style: TextStyle(
                                //               fontSize: 10,
                                //               fontWeight: FontWeight.bold,
                                //               color: ColorData
                                //                   .fitnessFacilityColor),
                                //         ),
                                //         Text(
                                //             tProfile != null &&
                                //                     tProfile.trainerEmail !=
                                //                         null
                                //                 ? tProfile.trainerEmail
                                //                 : "-",
                                //             style: TextStyle(
                                //                 fontSize: 10,
                                //                 fontWeight: FontWeight.bold,
                                //                 color: ColorData
                                //                     .primaryTextColor)),
                                //         SizedBox(
                                //           width: 4,
                                //         ),
                                //         Text(tr("mobileNumber"),
                                //             style: TextStyle(
                                //                 fontSize: 10,
                                //                 fontWeight: FontWeight.bold,
                                //                 color: ColorData
                                //                     .fitnessFacilityColor)),
                                //         Text(
                                //             tProfile != null &&
                                //                     tProfile.trainerPhone !=
                                //                         null
                                //                 ? tProfile.trainerPhone
                                //                 : "-",
                                //             style: TextStyle(
                                //                 fontSize: 10,
                                //                 fontWeight: FontWeight.bold,
                                //                 color: ColorData
                                //                     .primaryTextColor)),
                                //       ],
                                //     ))
                              ],
                            )),
                        Container(
                          height: 2,
                          width: screenWidth,
                          color: ColorData.fitnessFacilityColor,
                        ),
                        Container(
                            // height: screenHeight * 0.15,
                            width: screenWidth,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.zero,
                            color: ColorData.whiteColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Visibility(
                                    visible: tolLength >= 5 ? true : false,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex == 0
                                              ? selectedIndex = 0
                                              : selectedIndex =
                                                  selectedIndex - 1;
                                          pgcontroller.animateToPage(
                                              selectedIndex,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              curve: Curves.easeIn);
                                        });
                                      },
                                      child: SizedBox(
                                        child: Icon(Icons.arrow_back_ios),
                                      ),
                                    )),
                                SizedBox(
                                  height: screenHeight * 0.08,
                                  width: screenWidth * 0.76,
                                  child: PageView.builder(
                                      controller: pgcontroller,
                                      itemCount: tolLength,
                                      scrollDirection: Axis.horizontal,
                                      padEnds: false,
                                      pageSnapping: true,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return UnconstrainedBox(
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            onTap: () {
                                              newLst = widget.trainerProfile
                                                  .where((o) =>
                                                      o.trainerID ==
                                                      widget
                                                          .trainerProfile[index]
                                                          .trainerID)
                                                  .toList();

                                              setState(() {
                                                selectedIndex = index;
                                                tProfile = newLst != null &&
                                                        newLst.length > 0
                                                    ? newLst[0]
                                                    : new TrainerProfile();
                                                _controller.loadUrl(Localizations
                                                                .localeOf(
                                                                    context)
                                                            .languageCode ==
                                                        "en"
                                                    ? tProfile
                                                        .trainerEnglishProfile
                                                    : tProfile
                                                        .trainerArabicProfile);
                                              });
                                            },
                                            child: CircleAvatar(
                                              radius: 23.0,
                                              child: CircleAvatar(
                                                radius: 23.0,
                                                backgroundColor:
                                                    ColorData.whiteColor,
                                                backgroundImage: NetworkImage(widget
                                                                .trainerProfile !=
                                                            null &&
                                                        widget.trainerProfile
                                                                .length >
                                                            0 &&
                                                        widget
                                                                .trainerProfile[
                                                                    index]
                                                                .trainerImageFile !=
                                                            null
                                                    ? widget
                                                        .trainerProfile[index]
                                                        .trainerImageFile
                                                    : "https://webapp.slc.ae///UploadDocument//NoImage.png"),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                Visibility(
                                    visible: tolLength >= 5 ? true : false,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex + 1 == tolLength
                                              ? selectedIndex = tolLength - 1
                                              : selectedIndex =
                                                  selectedIndex + 1;
                                          pgcontroller.animateToPage(
                                              selectedIndex,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              curve: Curves.easeIn);
                                        });
                                      },
                                      child: Icon(Icons.arrow_forward_ios),
                                    )),
                              ],
                            )),
                        Container(
                          height: 2,
                          width: screenWidth,
                          color: ColorData.fitnessFacilityColor,
                        ),
                        Container(
                          height: screenHeight * 0.62,
                          width: screenWidth,
                          color: ColorData.whiteColor,
                          padding:
                              EdgeInsets.only(left: 8, right: 8, bottom: 8),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: screenHeight * 0.575,
                                    width: screenWidth,
                                    margin: EdgeInsets.only(top: 20),
                                    // padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    decoration: BoxDecoration(
                                        color: ColorData.backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    child: WebView(
                                        initialUrl:
                                            'https://webapp.slc.ae///UploadDocument//blank.html',
                                        javascriptMode:
                                            JavascriptMode.unrestricted,
                                        onWebViewCreated: (WebViewController
                                            webViewController) {
                                          _controller = webViewController;
                                          if (tProfile.trainerEnglishProfile !=
                                              null) {
                                            _controller.loadUrl(
                                                Localizations.localeOf(context)
                                                            .languageCode ==
                                                        "en"
                                                    ? tProfile
                                                        .trainerEnglishProfile
                                                    : tProfile
                                                        .trainerArabicProfile);
                                          }
                                        })),
                              ],
                            ),
                          ),
                        )
                      ]),
                  progressBar
                ],
              )),
        ));
  }
}
