import 'package:equatable/equatable.dart';
import 'package:slc/model/survey_question_request.dart';

abstract class SmilyState extends Equatable {
  const SmilyState();
}

class InitialSmilyState extends SmilyState {
  @override
  List<Object> get props => [];
}

class SmilyCardCreateState extends SmilyState {
  final SurveyQuestionRequest cardListValue;
  final int cardPosition;

  const SmilyCardCreateState({this.cardListValue, this.cardPosition});

  @override
  // TODO: implement props
  List<Object> get props => [cardListValue, cardPosition];
}

class SmilyCardCreateNewState extends SmilyState {
  final SurveyQuestionRequest cardListValue;
  final int cardPosition;

  const SmilyCardCreateNewState({this.cardListValue, this.cardPosition});

  @override
  // TODO: implement props
  List<Object> get props => [cardListValue, cardPosition];
}

class CardAnimationState extends SmilyState {
  final bool isAnimate;

  const CardAnimationState({this.isAnimate});

  @override
  // TODO: implement props
  List<Object> get props => [isAnimate];
}

class RefreshSmilyState extends SmilyState {
  final bool isAnimate;
  final int cardPosition;
  final SurveyQuestionRequest cardListValue;
  const RefreshSmilyState(
      {this.isAnimate, this.cardListValue, this.cardPosition});

  @override
  // TODO: implement props
  List<Object> get props => [isAnimate];
}
