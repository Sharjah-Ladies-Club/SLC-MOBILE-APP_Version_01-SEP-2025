import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/base_response.dart';
import 'package:slc/model/notification_badge_response.dart';
import 'package:slc/repo/notification_repository.dart';

import './bloc.dart';

class CustomAppBarBloc extends Bloc<CustomAppBarEvent, CustomAppBarState> {
  CustomAppBarBloc() : super(null);
  // @override
  CustomAppBarState get initialState => InitialCustomAppBarState();

  @override
  Stream<CustomAppBarState> mapEventToState(
    CustomAppBarEvent event,
  ) async* {
    if (event is GetNotificationBadgeStatus) {
      Meta m = await NotificationRepository().getNotificationBadge();
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(m.statusMsg));
      NotificationBadgeCountResponse resp =
          NotificationBadgeCountResponse.fromJson(baseResponse.response);
      yield UpdateNotificationBadge(isShowBadge: resp.isShowNotificationBadge);
    }
  }
}
