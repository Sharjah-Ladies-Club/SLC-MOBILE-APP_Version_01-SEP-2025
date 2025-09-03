import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/repo/survey_repository.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/view/survey/bloc/bloc.dart';

class NSurveyBloc extends Bloc<NSurveyEvent, NSurveyState> {
  NSurveyBloc() : super(null);

  NSurveyState get initialState => InitialSurveyState();

  Stream<NSurveyState> mapEventToState(NSurveyEvent event) async* {
    if (event is RetryTapped) {
      if (await GMUtils().isInternetConnected()) {
        yield InitialSurveyState();
        yield ShowProgressState();
        Meta m = await SurveyRepository().getSurveyFacilityList();
        if (m.statusCode == 200) {
          yield HideProgressState();
        } else {
          yield RetryState(
              error: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                      Constants.LANGUAGE_ARABIC
                  ? Strings.retryArbStr
                  : Strings.retryEngStr);
        }
      } else {
        yield FailureState(
            error: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                    Constants.LANGUAGE_ARABIC
                ? Strings.chknetArbStr
                : Strings.chknetEngStr);
      }
    } else if (event is SurveyShowProgressBarEvent) {
      yield ShowProgressState();
    } else if (event is SurveyHideProgressBarEvent) {
      yield HideProgressState();
    } else if (event is SurveyFailureEvent) {
      yield FailureState(error: event.error);
    } else if (event is SurveySuccessEvent) {
      yield SuccessState();
    } else if (event is PullToRefreshEvent) {
      yield InitialSurveyState();
      yield PullToRefreshState();
    } else if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    }
  }
}
