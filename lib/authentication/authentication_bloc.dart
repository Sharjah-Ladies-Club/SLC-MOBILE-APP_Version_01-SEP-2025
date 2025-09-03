import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:slc/authentication/authentication.dart';
import 'package:slc/repo/splash_repository.dart';
import 'package:slc/repo/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  final SplashRepository splashRepository;

  AuthenticationBloc(
      {@required this.userRepository, @required this.splashRepository})
      : assert(userRepository != null),
        assert(splashRepository != null),
        super(null);

  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is Authendicated) {
      yield AuthenticationAuthenticated();
    }
    if (event is UnAuthendicated) {
      yield AuthenticationUnauthenticated();
    }
    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
