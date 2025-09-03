import 'package:slc/model/survey_question_request.dart';

abstract class SurveyQuestionState {
  const SurveyQuestionState();
}

class InitialSurveyQuestionState extends SurveyQuestionState {
  List<Object> get props => [];
}

class UpdateSurveyQuestionListState extends SurveyQuestionState {
  final List<SurveyQuestionRequest> surveySaveRequestList;
  final int facilityId;

  const UpdateSurveyQuestionListState(
      {this.surveySaveRequestList, this.facilityId});

  List<Object> get props => [surveySaveRequestList];
}

class RefreshSurveyQuestionListState extends SurveyQuestionState {
  // TODO: implement props
  List<Object> get props => null;
}

class SelectedSmilyDetailsState extends SurveyQuestionState {
  final int smilyPosition;
  final int cardPosition;

  const SelectedSmilyDetailsState({this.smilyPosition, this.cardPosition});

  // TODO: implement props
  List<Object> get props => [smilyPosition];
}
