import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/network/GMCore.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/model/notification_get_by_id.dart';
import 'package:slc/model/user_info_request.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';

class NotificationRepository {
  Future<Meta> getNotificationListById(UserInfoRequest request) async {
    bool isAvailable = await GMUtils().isInternetConnected();
    if (isAvailable) {
      return await getOnlineNotificationListData(request);
    } else {
      return await getOfflineNotificationListData(request);
    }
  }

  Future<Meta> getOnlineNotificationListData(UserInfoRequest request) async {
    GMAPIService gmapiService = GMAPIService();

    Meta m = await gmapiService.processPostURL(
        URLUtils().getNotificationListUrl(),
        request.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      // SPUtil.putBool(Constants.IS_NOTIFICATION_LIST_RETRY, false);
      await Utils().saveOfflineData(
          TableDetails.CID_NOTIFICATION_LIST + request.userId.toString(), m);
    }
    return m;
  }

  Future<Meta> getOfflineNotificationListData(UserInfoRequest request) async {
    return await Utils().getOfflineData(
        TableDetails.CID_NOTIFICATION_LIST + request.userId.toString());
  }

  // ignore: missing_return
  Future<Meta> getNotificationCardById(NotificationRequestById request) async {
    bool isAvailable = await GMUtils().isInternetConnected();
    if (isAvailable) {
      return await getOnlineNotificationCardById(request);
    } else {
      Meta m = await getOfflineNotificationCardById(request);
      if (m.statusCode == 200) {
        return m;
      }
    }
  }

  Future<Meta> getOnlineNotificationCardById(
      NotificationRequestById request) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processPostURL(URLUtils().getNotificationById(),
        request.toJson(), SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(
          TableDetails.CID_NOTIFICATION_DETAILS +
              request.notificationUserId.toString(),
          m);
    }
    return m;
  }

  Future<Meta> getOfflineNotificationCardById(
      NotificationRequestById request) async {
    return await Utils().getOfflineData(TableDetails.CID_NOTIFICATION_DETAILS +
        request.notificationUserId.toString());
  }

  // ignore: missing_return
  Future<Meta> getNotificationReadStatusById(
      NotificationRequestById request) async {
    bool isAvailable = await GMUtils().isInternetConnected();
    if (isAvailable) {
      return await getOnlineNotificationReadStatusById(request);
    }
  }

  Future<Meta> getOnlineNotificationReadStatusById(
      NotificationRequestById request) async {
    GMAPIService gmapiService = GMAPIService();

    Meta m = await gmapiService.processPutURL(
        URLUtils().notificationReadStatus(),
        request.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      // SPUtil.putBool(Constants.IS_NOTIFICATION_LIST_RETRY, false);
      await Utils().saveOfflineData(
          TableDetails.CID_NOTIFICATION_DETAILS +
              request.notificationUserId.toString(),
          m);
    }
    return m;
  }

  // ignore: missing_return
  Future<Meta> clearAllNotificationById(UserInfoRequest request) async {
    bool isAvailable = await GMUtils().isInternetConnected();
    if (isAvailable
        // && SPUtil.getBool(Constants.IS_NOTIFICATION_LIST_RETRY)
        ) {
      return await getOnlineClearAllNotificationById(request);
    }
  }

  Future<Meta> getOnlineClearAllNotificationById(
      UserInfoRequest request) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processPutURL(
        URLUtils().notificationListClearUrl(),
        request.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      // SPUtil.putBool(Constants.IS_NOTIFICATION_LIST_RETRY, false);
      await Utils().saveOfflineData(
          TableDetails.CID_NOTIFICATION_LIST + request.userId.toString(), m);
    }
    return m;
  }

  Future<Meta> getNotificationBadge() async {
    GMAPIService gmapiService = GMAPIService();

    if (await GMUtils().isInternetConnected()) {
      var identifier = new Map<String, int>();
      identifier['userId'] = SPUtil.getInt(Constants.USERID);
      return await gmapiService.processPostURL(
          URLUtils().getNotificationBadge(),
          identifier,
          SPUtil.getString(Constants.KEY_TOKEN_1));
    } else {
      return Meta(statusCode: 201, statusMsg: '');
    }
  }
}
