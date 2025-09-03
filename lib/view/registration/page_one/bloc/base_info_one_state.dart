import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class BaseInfoOneState extends Equatable {
  const BaseInfoOneState();
}

class InitialBaseInfoOneState extends BaseInfoOneState {
  @override
  List<Object> get props => [];
}

class LanguageSwitched extends BaseInfoOneState {
  @override
  List<Object> get props => null;
}

class ShowProgressBar extends BaseInfoOneState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideProgressBar extends BaseInfoOneState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnSuccess extends BaseInfoOneState {
  final int userId;

  const OnSuccess({@required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnFailure extends BaseInfoOneState {
  final String error;

  const OnFailure({@required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
