import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class InitialRegistration extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String error;

  const RegistrationFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}
