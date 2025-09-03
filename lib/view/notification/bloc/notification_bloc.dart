import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/notification_get_by_id.dart';
import 'package:slc/model/notification_list_response.dart';
import 'package:slc/model/user_info_request.dart';
import 'package:slc/repo/notification_repository.dart';

import './bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(null);

  NotificationState get initialState => InitialNotificationState();

  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is NotificationGetList) {
      try {
        yield ShowProgressBar();

        UserInfoRequest req = UserInfoRequest();
        req.userId = event.userId;

        Meta m1 = await NotificationRepository().getNotificationListById(req);

        if (m1.statusCode == 200) {
          yield OnNotificationGetListSuccess(meta: m1);
        } else {
          yield OnNotificationGetListFailure(error: m1.statusMsg);
        }

        yield HideProgressBar();
      } catch (err) {
        yield HideProgressBar();

        yield OnNotificationGetListFailure(error: err);
      }
    } else if (event is NotificationGetReadStatus) {
      try {
        yield ShowProgressBar();

        NotificationRequestById req = NotificationRequestById();
        req.notificationUserId = event.notificationCardId;

        Meta m2 =
            await NotificationRepository().getNotificationReadStatusById(req);

        if (m2.statusCode == 200) {
          NotificationListResponse notificationResponse =
              new NotificationListResponse();

          notificationResponse = NotificationListResponse.fromJson(
              jsonDecode(m2.statusMsg)['response']);

          yield OnNotificationGetReadStatusSuccess(
              notificationListResponse: notificationResponse,
              title: notificationResponse.title,
              message: notificationResponse.message,
              imgUrl: notificationResponse.imageUrl,
              notificationUserId: notificationResponse.notificationUserId);

          yield HideProgressBar();
        } else {
          yield HideProgressBar();
          yield OnNotificationGetReadStatusFailure(error: (m2.statusMsg));
        }
      } catch (err) {
        yield HideProgressBar();

        yield OnNotificationGetReadStatusFailure(error: err);
      }
    } else if (event is NotificationCardClicked) {
      try {
        yield ShowProgressBar();

        NotificationRequestById req = NotificationRequestById();
        req.notificationUserId = event.notificationCardId;

        Meta m2 = await NotificationRepository().getNotificationCardById(req);

        if (m2.statusCode == 200) {
          NotificationListResponse notificationDetailResponse =
              new NotificationListResponse();

          notificationDetailResponse = jsonDecode(m2.statusMsg)['response'];

          yield OnNotificationCardDetailsGetSuccess(
            title: notificationDetailResponse.title,
            message: notificationDetailResponse.message,
          );
          yield HideProgressBar();
        } else {
          yield HideProgressBar();
          yield OnNotificationGetListFailure(error: jsonDecode(m2.statusMsg));
        }

        // UserInfoRequest request =  UserInfoRequest(userId:

      } catch (err) {
        yield HideProgressBar();

        yield OnNotificationCardDetailsGetFailure(error: err);
      }
    } else if (event is ClearAllClicked) {
      try {
        yield ShowProgressBar();

        UserInfoRequest req = UserInfoRequest();
        req.userId = event.userId;

        Meta m1 = await NotificationRepository().clearAllNotificationById(req);

        if (m1.statusCode == 200) {
          yield OnNotificationClearSuccess();
          yield HideProgressBar();
        } else {
          yield HideProgressBar();
          yield OnNotificationGetListFailure(error: jsonDecode(m1.statusMsg));
        }
      } catch (err) {
        yield HideProgressBar();

        yield OnNotificationClearFailure(error: err);
      }
    } else if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    }
  }
}
