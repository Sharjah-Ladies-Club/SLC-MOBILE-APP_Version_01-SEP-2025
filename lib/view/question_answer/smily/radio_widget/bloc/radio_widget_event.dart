import 'package:equatable/equatable.dart';
import 'package:slc/model/survey_answer.dart';

abstract class RadioWidgetEvent extends Equatable {
  const RadioWidgetEvent();
}

class CreateRadioWidgetEvent extends RadioWidgetEvent {
  final List<SurveyAnswer> answerList;
  final int cardPosition;
  final int selectedPosition;
  final String feedbackType;

  const CreateRadioWidgetEvent(
      {this.answerList,
      this.cardPosition,
      this.selectedPosition,
      this.feedbackType});

  @override
  // TODO: implement props
  List<Object> get props =>
      [cardPosition, answerList, selectedPosition, feedbackType];
}
