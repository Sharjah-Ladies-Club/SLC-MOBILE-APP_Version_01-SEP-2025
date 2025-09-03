import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class InitialSplashState extends SplashState {
  @override
  List<Object> get props => [];
}

class FailureState extends SplashState {
  final String error;

  const FailureState({@required this.error});

  @override
  List<Object> get props => [error];
}
