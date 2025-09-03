import 'package:equatable/equatable.dart';
import 'package:slc/model/survey_answer.dart';

abstract class RadioWidgetState extends Equatable {
  const RadioWidgetState();
}

class InitialRadioWidgetState extends RadioWidgetState {
  @override
  List<Object> get props => [];
}

class CreateRadioWidgetState extends RadioWidgetState {
  final List<SurveyAnswer> answerList;
  final int cardPosition;
  final int selectedPosition;
  final String feedbackType;

  const CreateRadioWidgetState(
      {this.answerList,
      this.cardPosition,
      this.selectedPosition,
      this.feedbackType});

  @override
  // TODO: implement props
  List<Object> get props =>
      [cardPosition, answerList, selectedPosition, feedbackType];
}

class CreateNewRadioWidgetState extends RadioWidgetState {
  final List<SurveyAnswer> answerList;
  final int cardPosition;
  final int selectedPosition;
  final String feedbackType;

  const CreateNewRadioWidgetState(
      {this.answerList,
      this.cardPosition,
      this.selectedPosition,
      this.feedbackType});

  @override
  // TODO: implement props
  List<Object> get props =>
      [cardPosition, answerList, selectedPosition, feedbackType];
}
