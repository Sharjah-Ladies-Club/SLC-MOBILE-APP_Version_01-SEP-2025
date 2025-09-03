import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class RegistrationSubmit extends RegistrationEvent {
  final String mobileNumber;
  final String email;

  const RegistrationSubmit({@required this.mobileNumber, @required this.email});

  @override
  // TODO: implement props
  List<Object> get props => [mobileNumber, email];

  @override
  String toString() =>
      'RegistrationSubmit{ mobileNumber: $mobileNumber, email: $email }';
}
