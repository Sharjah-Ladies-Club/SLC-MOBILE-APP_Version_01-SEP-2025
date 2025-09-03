import 'package:equatable/equatable.dart';
import 'package:slc/model/survey_answer.dart';

abstract class SmilyWidgetState extends Equatable {
  const SmilyWidgetState();
}

class InitialSmilyWidgetState extends SmilyWidgetState {
  @override
  List<Object> get props => [];
}

class CreateSmilyWidgetState extends SmilyWidgetState {
  final List<SurveyAnswer> answerList;
  final int cardPosition;
  final int selectedPosition;
  final String feedbackType;

  const CreateSmilyWidgetState(
      {this.answerList,
      this.cardPosition,
      this.selectedPosition,
      this.feedbackType});

  @override
  // TODO: implement props
  List<Object> get props =>
      [cardPosition, answerList, selectedPosition, feedbackType];
}

class CreateNewSmilyWidgetState extends SmilyWidgetState {
  final List<SurveyAnswer> answerList;
  final int cardPosition;
  final int selectedPosition;
  final String feedbackType;

  const CreateNewSmilyWidgetState(
      {this.answerList,
      this.cardPosition,
      this.selectedPosition,
      this.feedbackType});

  @override
  // TODO: implement props
  List<Object> get props =>
      [cardPosition, answerList, selectedPosition, feedbackType];
}
