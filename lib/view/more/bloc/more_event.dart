import 'package:equatable/equatable.dart';

abstract class MoreEvent extends Equatable {
  const MoreEvent();
}

class LogoutEvent extends MoreEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class DeactivateEvent extends MoreEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class GetHomePageData extends MoreEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorDialogEvent extends MoreEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}
