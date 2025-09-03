import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/model/survey_facility_question_request.dart';
import 'package:slc/model/survey_question_request.dart';
import 'package:slc/repo/survey_repository.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/view/survey/bloc/bloc.dart';

import './bloc.dart';

class SurveyQuestionBloc
    extends Bloc<SurveyQuestionEvent, SurveyQuestionState> {
  NSurveyBloc surveyBloc;

  SurveyQuestionBloc({this.surveyBloc}) : super(null);

  SurveyQuestionState get initialState => InitialSurveyQuestionState();

  Stream<SurveyQuestionState> mapEventToState(
    SurveyQuestionEvent event,
  ) async* {
    if (event is GetSurveyQuestionListEvent) {
      surveyBloc..add(SurveyShowProgressBarEvent());
      if (await GMUtils().isInternetConnected()) {
        var id = event.id;
        SurveyFacilityQuestionRequest request = SurveyFacilityQuestionRequest(
            facilityId: id, userId: SPUtil.getInt(Constants.USERID));
        Meta m = await SurveyRepository().getSurveyQuestion(request);
        if (m.statusCode == 200) {
          surveyBloc..add(SurveyHideProgressBarEvent());
          final List<SurveyQuestionRequest> surveySaveRequestList = [];
          jsonDecode(m.statusMsg)['response'].forEach((f) =>
              surveySaveRequestList.add(new SurveyQuestionRequest.fromJson(f)));
          yield UpdateSurveyQuestionListState(
              surveySaveRequestList: surveySaveRequestList, facilityId: id);
        } else {
          surveyBloc..add(SurveyFailureEvent(error: m.statusMsg));
        }
      } else {
        surveyBloc
          ..add(SurveyFailureEvent(
              error: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                      Constants.LANGUAGE_ARABIC
                  ? Strings.chknetArbStr
                  : Strings.chknetEngStr));
      }
    } else if (event is SurveySaveBtnPressed) {
      surveyBloc..add(SurveyShowProgressBarEvent());
      if (await GMUtils().isInternetConnected()) {
        Meta m = await SurveyRepository().saveSurvey(event.request);
        if (m.statusCode == 200) {
          surveyBloc..add(SurveyHideProgressBarEvent());
          surveyBloc..add(SurveySuccessEvent());
        } else {
          surveyBloc..add(SurveyFailureEvent(error: m.statusMsg));
        }
      } else {
        surveyBloc
          ..add(SurveyFailureEvent(
              error: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                      Constants.LANGUAGE_ARABIC
                  ? Strings.chknetArbStr
                  : Strings.chknetEngStr));
      }
    } else if (event is SelectedSmilyDetailsEvent) {
      yield SelectedSmilyDetailsState(
          smilyPosition: event.smilyPosition, cardPosition: event.cardPosition);
    }
  }
}
