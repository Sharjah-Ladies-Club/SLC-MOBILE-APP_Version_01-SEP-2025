import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slc/view/obb_spa/bloc/bloc.dart';

import '../../common/colors.dart';
import '../../model/obb_recommendation_response.dart';
import '../../theme/styles.dart';
import '../../utils/utils.dart';
import 'bloc/obb_consult_bloc.dart';
import 'bloc/obb_consult_state.dart';

class MyRecommendation extends StatelessWidget {
  final int facilityId, recommendationId, userInfoId;
  final String colorCode;

  MyRecommendation(
      {this.facilityId,
      this.recommendationId,
      this.colorCode,
      this.userInfoId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        // create: (context) =>
        //     BeachBloc(beachBloc: BlocProvider.of<BeachBloc>(context))..add(new GetOrderStatusEvent(
        //         merchantReferenceNo: merchantReferenceNo))
        create: (context) {
          return ObbConsultBloc(obbConsultBloc: null)
            ..add(new GetFurtherRecommendation(
                facilityId: facilityId, recommendationId: recommendationId));
        },
        child: _MyRecommendation(
            facilityId: facilityId,
            colorCode: colorCode,
            userInfoId: userInfoId),
      ),
    );
  }
}

class _MyRecommendation extends StatefulWidget {
  final int facilityId, userInfoId;
  final String colorCode;
  _MyRecommendation({this.facilityId, this.colorCode, this.userInfoId});
  @override
  State<_MyRecommendation> createState() => _MyRecommendationState();
}

class _MyRecommendationState extends State<_MyRecommendation> {
  List<FurtherRecommendation> furtherRecommendation = [];

  double sWidth = 0.0, sHeight = 0.0;
  String logo = '';
  bool load = false;

  Utils util = Utils();

  @override
  void initState() {
    logo = 'assets/images/${widget.facilityId}_logo.png';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    return BlocListener<ObbConsultBloc, ObbConsultState>(
      listener: (context, state) async {
        if (state is GetFurtherRecommendationState) {
          if (state.furtherRecommendation != null) {
            setState(() {
              furtherRecommendation = state.furtherRecommendation;
            });
          }
          setState(() {
            load = true;
          });
        }
        if (state is GetDownloadUrlState) {
          downloadAndSavePdf(
              state.downloadUrl,
              state.dtoken,
              widget.facilityId == 2
                  ? "obb_recommendation"
                  : "spa_recommendation");
          setState(() {});
        }
        if (state is OnFailure) {
          setState(() {
            load = true;
          });
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorData.backgroundColor,
          appBar: AppBar(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            automaticallyImplyLeading: true,
            title: Text(tr('my_recommendations'),
                style: TextStyle(color: Colors.blue[200])),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.blue[200],
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
          ),
          body: load
              ? furtherRecommendation.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: furtherRecommendation.length,
                      itemBuilder: (BuildContext context, int index) {
                        DateTime dateTime = furtherRecommendation[index].date !=
                                    null &&
                                furtherRecommendation[index].date.isNotEmpty
                            ? DateTime.parse(furtherRecommendation[index].date)
                            : DateTime.now();
                        String date = DateFormat('MMM dd yyyy')
                            .format(dateTime)
                            .toString();
                        return ObbFurtherRecommendation(
                          date: date,
                          followUp: furtherRecommendation[index].recommendation,
                          nextVisit: furtherRecommendation[index].nextVisit,
                          dailyUse: furtherRecommendation[index].dailyUse,
                          weeklyUse: furtherRecommendation[index].weeklyUse,
                          specialAdvise:
                              furtherRecommendation[index].specialAdvice,
                          by: furtherRecommendation[index].therapistName,
                          logo: logo,
                        );
                      })
                  : Center(
                      child: Text(tr('noDataFound'),
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Styles.loginBtnFontSize,
                            fontFamily: tr('currFontFamily'),
                            color: ColorData.primaryTextColor,
                          )),
                    )
              : Center(child: CircularProgressIndicator()),
          bottomNavigationBar: UnconstrainedBox(
            child: Container(
              width: sWidth * 0.6,
              child: ElevatedButton(
                  onPressed: () async {
                    var status = await Permission.storage.status;
                    if (!status.isGranted) {
                      await Permission.storage.request();
                    }
                    bool dirDownloadExists = true;
                    util.customGetSnackBarWithOutActionButton(
                        tr("download"), tr("download_progress"), context);
                    BlocProvider.of<ObbConsultBloc>(context).add(
                        GetDownloadUrlEvent(
                            facilityId: widget.facilityId,
                            recommendationId: widget.userInfoId));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: widget.colorCode == null
                        ? Colors.blue[200]
                        : ColorData.toColor(widget.colorCode),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    )),
                  ),

                  // style: ButtonStyle(
                  //     foregroundColor:
                  //         MaterialStateProperty.all<Color>(Colors.white),
                  //     backgroundColor: MaterialStateProperty.all<Color>(
                  //         widget.colorCode == null
                  //             ? Colors.blue[200]
                  //             : ColorData.toColor(widget.colorCode)),
                  //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //         RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.all(
                  //       Radius.circular(8.0),
                  //     )))),
                  child: Text(tr("download"))),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> downloadAndSavePdf(
      String durl, String dtoken, String dfileName) async {
    if (durl.isEmpty) {
      debugPrint("ERROR");
      util.customGetSnackBarWithOutActionButton(
          tr("download"), tr('invalid_doc'), context);
    }
    var status = await Permission.manageExternalStorage.status;
    // var status = await Permission.storage.status;
    log(":::::::::::::::::: PERMISSION STORAGE AFTER STATUS");
    if (!status.isGranted) {
      log(":::::::::::::::::: PERMISSION STORAGE IN CONDITION $status");
      await Permission.manageExternalStorage.request();
      return;
    }

    if (status.isDenied || !status.isGranted) {
      // await Permission.manageExternalStorage.request();
      openAppSettings();
      return;
    }
    log(":::::::::::::::::: PERMISSION STORAGE $status");
    bool dirDownloadExists = true;

    var directory;
    // if (Platform.isIOS) {
    //   directory = await getDownloadsDirectory();
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
      // directory = await getApplicationSupportDirectory();
    } else {
      // directory = await getDownloadsDirectory();
      directory = "/storage/emulated/0/Download/";
      dirDownloadExists = await Directory(directory).exists();
      if (Platform.isAndroid) {
        if (dirDownloadExists) {
          directory = "/storage/emulated/0/Download/";
        } else {
          // final appDir = await getDownloadsDirectory();
          // directory = appDir.path;
          directory = "/storage/emulated/0/Downloads/";
        }
      }
    }
    log(":::::::::::::::::::: PATH \n${directory}");
    try {
      final response = await http.get(Uri.parse(durl), headers: {
        'Authorization': 'Bearer ${dtoken}',
        'Content-Type': 'application/pdf',
      });
      print('Url downloaded to: $durl');
      print('Toke downloaded to: $dtoken');
      if (response.statusCode == 200) {
        // 2. Get the directory to save the file
        //final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory}/$dfileName.pdf';

        // 3. Save the PDF
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        // Optional: Open the PDF using open_filex
        // await OpenFilex.open(filePath);
        util.customGetSnackBarWithOutActionButton(
            tr("download"), tr('document_downloaded'), context);
      } else {
        log(":::::::::::::::::: DOWNLOAD ERROR:\n${response.statusCode}");
        util.customGetSnackBarWithOutActionButton(
            tr("documents"), 'Problem in Download. Try again', context);
        // 'Failed to download PDF: ${response.statusCode}', context);
      }
    } catch (e) {
      util.customGetSnackBarWithOutActionButton(
          tr("download"), 'Problem in Download. Try again', context);
      // 'Error downloading PDF: $e', context);
      log(":::::::::::::::::: DOWNLOAD ERROR 01:\n$e");
    }
  }
}

class ObbFurtherRecommendation extends StatelessWidget {
  final String date,
      logo,
      followUp,
      nextVisit,
      dailyUse,
      weeklyUse,
      specialAdvise,
      by;
  const ObbFurtherRecommendation(
      {this.date,
      this.logo,
      this.followUp,
      this.nextVisit,
      this.dailyUse,
      this.weeklyUse,
      this.specialAdvise,
      this.by});

  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Localizations.localeOf(context).languageCode == "en"
              ? EdgeInsets.only(left: 10, top: 8, bottom: 4)
              : EdgeInsets.only(right: 10, top: 8, bottom: 4),
          child: Text(date,
              // overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Styles.loginBtnFontSize,
                fontFamily: tr('currFontFamily'),
                color: ColorData.primaryTextColor,
              )),
        ),
        Card(
          margin: EdgeInsets.only(left: 10, right: 10, top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  logo,
                  width: sWidth * 0.28,
                ),
              ),
              Container(
                width: sWidth * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(tr("service_recommend"),
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Styles.loginBtnFontSize,
                            fontFamily: tr('currFontFamily'),
                            color: ColorData.primaryTextColor,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(tr("follow_up") + ": " + (followUp ?? "-"),
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Styles.loginBtnFontSize,
                            fontFamily: tr('currFontFamily'),
                            color: ColorData.primaryTextColor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(tr("next_visit") + ": " + (nextVisit ?? "-"),
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Styles.loginBtnFontSize,
                            fontFamily: tr('currFontFamily'),
                            color: ColorData.primaryTextColor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(tr("home_care"),
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Styles.loginBtnFontSize,
                            fontFamily: tr('currFontFamily'),
                            color: ColorData.primaryTextColor,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(tr("daily_use") + ": " + (dailyUse ?? "-"),
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Styles.loginBtnFontSize,
                            fontFamily: tr('currFontFamily'),
                            color: ColorData.primaryTextColor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(tr("weekly_use") + ": " + (weeklyUse ?? "-"),
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Styles.loginBtnFontSize,
                            fontFamily: tr('currFontFamily'),
                            color: ColorData.primaryTextColor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                          tr("special_advise") + ": " + (specialAdvise ?? "-"),
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Styles.loginBtnFontSize,
                            fontFamily: tr('currFontFamily'),
                            color: ColorData.primaryTextColor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6, bottom: 4),
                      child: Text(tr("by") + ": " + (by ?? "-"),
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Styles.loginBtnFontSize,
                            fontFamily: tr('currFontFamily'),
                            color: ColorData.primaryTextColor,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
