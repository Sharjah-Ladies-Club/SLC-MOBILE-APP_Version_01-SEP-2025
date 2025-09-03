// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/view/facility_detail/facility_content/facility_fitness/facility_fitness_diet.dart';
import 'package:slc/view/facility_detail/facility_content/facility_fitness/facility_fitness_workout.dart';
import 'package:slc/utils/utils.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class FacilityDetailFitness extends StatelessWidget {
  List<FitnessUIDto> fitnessUI;
  String colorCode;
  int facilityId;

  FacilityDetailFitness({this.fitnessUI, this.colorCode, this.facilityId});

  @override
  Widget build(BuildContext context) {
    return Fitness(fitnessUI, colorCode, facilityId);
  }
}

class Fitness extends StatefulWidget {
  List<FitnessUIDto> fitnessUI;
  String colorCode;
  int facilityId;
  AutoScrollController scrlController;
  int selectedIndex = -1;
  int selectedHeadIndex = -1;
  int listIndex = -1;

  Key key = PageStorageKey("100000000000");
  Utils util = new Utils();

  Fitness(this.fitnessUI, this.colorCode, this.facilityId);

  @override
  State<StatefulWidget> createState() {
    return FitnessState();
  }
}

class FitnessState extends State<Fitness> {
  Utils util = Utils();

  @override
  Widget build(BuildContext context) {
    return getFitnessScreen(widget.fitnessUI);
  }

  Widget getFitnessScreen(List<FitnessUIDto> fitnesss) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        key: widget.key,
        scrollDirection: Axis.vertical,
        itemCount: fitnesss.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, i) {
          return Column(
            children: <Widget>[
              Card(
                  child: Container(
                // color: Colors.white,
                height: i == 0
                    ? MediaQuery.of(context).size.height * 0.35
                    : MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width * 0.96,
                decoration: BoxDecoration(
                    //border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Center(
                        child: Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.width * 0.96,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                        child: Image.asset(
                            "assets/images/" + fitnesss[i].imageUrl,
                            fit: BoxFit.fill),
                      ),
                    )),
                    Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 4),
                        child: Center(
                            child: Text(tr(fitnesss[i].imageName),
                                style: TextStyle(
                                    color: ColorData.inActiveIconColor,
                                    fontSize: Styles.textSizRegular)))),
                    Visibility(
                        visible: i == 0 ? true : false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(top: 4, bottom: 4),
                                child: Center(
                                    child: Text(
                                        (fitnesss[i].totalCal == null
                                                ? "0"
                                                : fitnesss[i]
                                                    .totalCal
                                                    .toString()) +
                                            " Cal  | " +
                                            fitnesss[i].mealPlan,
                                        style: TextStyle(
                                            color: ColorData.inActiveIconColor,
                                            fontSize: Styles.textSizRegular)))),
                            // Padding(
                            //     padding: EdgeInsets.only(
                            //         top: 10, bottom: 10, left: 10, right: 10),
                            //     child: VerticalDivider(
                            //       width: 1.0,
                            //       color: Colors.grey,
                            //     )),
                            // Padding(
                            //     padding: EdgeInsets.only(top: 10, bottom: 10),
                            //     child: Center(
                            //         child: Text(
                            //             fitnesss[i].mealPlan == null
                            //                 ? "None"
                            //                 : fitnesss[i].mealPlan,
                            //             style: TextStyle(
                            //                 color: ColorData.inActiveIconColor,
                            //                 fontSize: Styles.textSizRegular))))
                          ],
                        )),
                    Center(
                        child: Center(
                      child: SizedBox(
                          height: 25,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ColorData.toColor(
                                            widget.colorCode != null
                                                ? widget.colorCode
                                                : "A81B8D")),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                )))),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(8)),
                            onPressed: () {
                              if (i == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FacilityDiet(
                                      facilityId: widget.facilityId,
                                      colorCode: widget.colorCode,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FacilityWorkout(
                                      facilityId: widget.facilityId,
                                      colorCode: widget.colorCode,
                                    ),
                                  ),
                                );
                              }
                            },
                            // color: ColorData.toColor(widget.colorCode != null
                            //     ? widget.colorCode
                            //     : "A81B8D"),
                            child: Text(tr('getstarted'),
                                style: TextStyle(
                                  color: ColorData.whiteColor,
                                  fontSize: 14.0,
                                  fontFamily: tr("currFontFamilyMedium"),
                                  fontWeight: FontWeight.w400,
                                )),
                          )),
                    ))
                  ],
                ),
              ))

              // color: Colors.white,
              // child: Text(fitnesss[i].imageName),
            ],
          );
        },
      ),
    );
  }
}
