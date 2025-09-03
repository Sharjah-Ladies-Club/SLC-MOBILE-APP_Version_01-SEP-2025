import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/model/facility_response.dart';
import 'package:slc/repo/survey_repository.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/view/survey/bloc/bloc.dart';

import './bloc.dart';

class SurveyFacilityBloc
    extends Bloc<SurveyFacilityEvent, SurveyFacilityState> {
  NSurveyBloc surveyBloc;

  SurveyFacilityBloc({this.surveyBloc}) : super(null);

  SurveyFacilityState get initialState => InitialSurveyFacilityState();

  Stream<SurveyFacilityState> mapEventToState(
    SurveyFacilityEvent event,
  ) async* {
    if (event is GetSurveyFacilityEvent) {
      surveyBloc..add(SurveyShowProgressBarEvent());
      if (await GMUtils().isInternetConnected()) {
        Meta m = await SurveyRepository().getSurveyFacilityList();
        if (m.statusCode == 200) {
          surveyBloc..add(SurveyHideProgressBarEvent());
          final List<FacilityResponse> facilityResponseList = [];
          jsonDecode(m.statusMsg)['response'].forEach((f) =>
              facilityResponseList.add(new FacilityResponse.fromJson(f)));

          yield UpdateSurveyFacilityState(
              facilityResponseList: facilityResponseList);
        } else {
          surveyBloc
            ..add(SurveyFailureEvent(
                error: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                        Constants.LANGUAGE_ARABIC
                    ? Strings.retryArbStr
                    : Strings.retryEngStr));
        }
      } else {
        surveyBloc
          ..add(SurveyFailureEvent(
              error: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                      Constants.LANGUAGE_ARABIC
                  ? Strings.chknetArbStr
                  : Strings.chknetEngStr));
      }
    }
  }
}
