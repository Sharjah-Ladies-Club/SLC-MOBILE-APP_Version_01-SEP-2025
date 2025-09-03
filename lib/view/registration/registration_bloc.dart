import 'dart:async';

import 'package:bloc/bloc.dart';

import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc(RegistrationState initialState) : super(initialState);

  RegistrationState get initialState => InitialRegistration();

  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is RegistrationSubmit) {
      yield RegistrationLoading();
    }
  }
}
