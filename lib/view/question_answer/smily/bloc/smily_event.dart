import 'package:equatable/equatable.dart';
import 'package:slc/model/survey_question_request.dart';

abstract class SmilyEvent extends Equatable {
  const SmilyEvent();
}

class SmilyCardCreateEvent extends SmilyEvent {
  final SurveyQuestionRequest cardListValue;
  final int cardPosition;

  const SmilyCardCreateEvent({this.cardListValue, this.cardPosition});

  @override
  // TODO: implement props
  List<Object> get props => [cardListValue, cardPosition];
}

class CardAnimationEvent extends SmilyEvent {
  final bool isAnimate;

  const CardAnimationEvent({this.isAnimate});

  @override
  // TODO: implement props
  List<Object> get props => [isAnimate];
}

class RefreshSmilyEvent extends SmilyEvent {
  final bool isAnimate;

  const RefreshSmilyEvent({this.isAnimate});

  @override
  // TODO: implement props
  List<Object> get props => [isAnimate];
}
