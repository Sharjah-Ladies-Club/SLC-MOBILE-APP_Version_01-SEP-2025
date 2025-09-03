import 'package:equatable/equatable.dart';
import 'package:slc/model/survey_answer.dart';

abstract class SmilyWidgetEvent extends Equatable {
  const SmilyWidgetEvent();
}

class CreateSmilyWidgetEvent extends SmilyWidgetEvent {
  final List<SurveyAnswer> answerList;
  final int cardPosition;
  final int selectedPosition;
  final String feedbackType;

  const CreateSmilyWidgetEvent(
      {this.answerList,
      this.cardPosition,
      this.selectedPosition,
      this.feedbackType});

  @override
  // TODO: implement props
  List<Object> get props =>
      [cardPosition, answerList, selectedPosition, feedbackType];
}
