import 'package:equatable/equatable.dart';

abstract class CustomAppBarEvent extends Equatable {
  const CustomAppBarEvent();
}

class GetNotificationBadgeStatus extends CustomAppBarEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
