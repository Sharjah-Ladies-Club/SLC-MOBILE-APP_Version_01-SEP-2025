import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class InitialLoginState extends LoginState {
  @override
  List<Object> get props => null;
}

class LanguageSwitched extends LoginState {
  @override
  List<Object> get props => null;
}

class ShowProgressBar extends LoginState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideProgressBar extends LoginState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnSuccess extends LoginState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnSuccessWithResetPassword extends LoginState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnFailure extends LoginState {
  final String error;

  const OnFailure({@required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnSuccessRegister extends LoginState {
  final int userId;

  const OnSuccessRegister({@required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => null;
}
