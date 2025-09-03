import 'package:equatable/equatable.dart';
import 'package:slc/model/survey_question_request.dart';

abstract class QuestionAnswerEvent extends Equatable {
  const QuestionAnswerEvent();
}

class PopulateQAListEvent extends QuestionAnswerEvent {
  final List<SurveyQuestionRequest> surveySaveRequestList;
  final int id;

  const PopulateQAListEvent({this.surveySaveRequestList, this.id});

  @override
  // TODO: implement props
  List<Object> get props => [surveySaveRequestList];
}
