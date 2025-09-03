import 'package:equatable/equatable.dart';
import 'package:slc/model/survey_question_request.dart';

abstract class QuestionAnswerState extends Equatable {
  const QuestionAnswerState();
}

class InitialQuestionAnswerState extends QuestionAnswerState {
  @override
  List<Object> get props => [];
}

class PopulateQAListState extends QuestionAnswerState {
  final List<SurveyQuestionRequest> surveySaveRequestList;
  final int id;

  const PopulateQAListState({this.surveySaveRequestList, this.id});

  @override
  // TODO: implement props
  List<Object> get props => [surveySaveRequestList];
}
