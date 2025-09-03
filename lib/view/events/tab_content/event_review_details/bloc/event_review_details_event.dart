import 'package:equatable/equatable.dart';

abstract class ReviewDetailsEvent extends Equatable {
  const ReviewDetailsEvent();
}

class ShowProgressBarEvent extends ReviewDetailsEvent {
  @override
  List<Object> get props => null;
}

class HideProgressBarEvent extends ReviewDetailsEvent {
  @override
  List<Object> get props => null;
}

class OnFailedEvent extends ReviewDetailsEvent {
  final String error;

  const OnFailedEvent({this.error});

  @override
  List<Object> get props => [error];
}

class ErrorDialogEvent extends ReviewDetailsEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

