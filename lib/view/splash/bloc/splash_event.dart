import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();
}

class AppStarted extends SplashEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class NetNotAvailable extends SplashEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class NetAvailable extends SplashEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
