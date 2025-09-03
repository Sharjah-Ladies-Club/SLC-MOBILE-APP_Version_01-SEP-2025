import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:slc/model/survey_save_request.dart';

abstract class SurveyQuestionEvent extends Equatable {
  const SurveyQuestionEvent();
}

class GetSurveyQuestionListEvent extends SurveyQuestionEvent {
  final int id;

  const GetSurveyQuestionListEvent({this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class SurveySaveBtnPressed extends SurveyQuestionEvent {
  final SurveySaveRequest request;

  const SurveySaveBtnPressed({
    @required this.request,
  });

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SurveySaveBtnPressed {}';
}

class SelectedSmilyDetailsEvent extends SurveyQuestionEvent {
  final int smilyPosition;
  final int cardPosition;

  const SelectedSmilyDetailsEvent({this.smilyPosition, this.cardPosition});

  @override
  // TODO: implement props
  List<Object> get props => [smilyPosition];
}
