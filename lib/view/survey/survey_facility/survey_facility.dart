import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/surveypagecustomwidget/customdropdownstateful.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/facility_response.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/survey/survey_facility/bloc/bloc.dart';
import 'package:slc/view/survey/survey_question/bloc/bloc.dart';

// ignore: must_be_immutable
class SurveyFacilitySelection extends StatefulWidget {
  final double facilityViewHeight;
  int selectedFacilityId;
  SurveyFacilitySelection({this.facilityViewHeight, this.selectedFacilityId});

  @override
  State<StatefulWidget> createState() {
    return _SurveyFacilitySelection(selectedFacilityId: selectedFacilityId);
  }
}

List<FacilityResponse> facilityResponseList = [];

class _SurveyFacilitySelection extends State<SurveyFacilitySelection> {
  _SurveyFacilitySelection({this.selectedFacilityId});
  int selectedFacilityId = 0;

  @override
  void initState() {
    super.initState();
    if (selectedFacilityId == null || selectedFacilityId == 0) {
      selectedFacilityId =
          SPUtil.getInt(Constants.SELECTED_FACILITY_ID, defValue: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyFacilityBloc, SurveyFacilityState>(
      listener: (context, state) {
        if (state is UpdateSurveyFacilityState) {
          if (state.facilityResponseList != null &&
              state.facilityResponseList.length > 0) {
            int id = selectedFacilityId > 0
                ? selectedFacilityId
                : state.facilityResponseList[0].facilityId;

            BlocProvider.of<SurveyQuestionBloc>(context)
              ..add(GetSurveyQuestionListEvent(id: id));
          }
        }
      },
      child: BlocBuilder<SurveyFacilityBloc, SurveyFacilityState>(
        builder: (context, state) {
          if (state is UpdateSurveyFacilityState) {
            facilityResponseList = state.facilityResponseList;
          }
          return mainUI();
        },
      ),
    );
  }

  Widget mainUI() {
    // debugPrint(" FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFf " +
    //     widget.selectedFacilityId.toString());
    return Scaffold(
      backgroundColor: ColorData.whiteColor,
      body: Column(
        children: <Widget>[
          facilityResponseList.length > 0
              ? CustomDropdownStateful(
                  (FacilityResponse dropDownValue) => {
                    BlocProvider.of<SurveyQuestionBloc>(context)
                      ..add(GetSurveyQuestionListEvent(
                          id: dropDownValue.facilityId)),
                  },
                  facilityResponseList,
                  selectedFacilityId: widget.selectedFacilityId,
                  facilityViewHeight: (widget.facilityViewHeight -
                      (Localizations.localeOf(context).languageCode == "en"
                          ? 5
                          : 4)),
                )
              : Container(),
          Container(
              padding: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(top: 15.0)
                  : EdgeInsets.only(top: 14.0),
              child: Text(
                tr("hw_was_exp"),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: tr("currFontFamilyMedium"),
                ),
              )),
        ],
      ),
    );
  }
}
