import 'dart:io';

import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/network/GMCore.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/model/EventTempleterequest.dart';
import 'package:slc/model/event_registration_request.dart';
import 'package:slc/model/review_feed_back_request.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/event_people_list/image_picker_provider.dart';

import '../model/facility_item.dart';

class EventRepository {
  ImagePickerProvider _imagePickerProvider = new ImagePickerProvider();
  Future<Meta> getEventList() async {
    if (await GMUtils().isInternetConnected()) {
      return await getOnlineEventList();
    } else {
      return await Utils().getOfflineData(TableDetails.CID_EVENT_LIST);
    }
  }

  Future<Meta> getOnlineEventList() async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['userId'] = SPUtil.getInt(Constants.USERID);

    Meta m = await gmapiService.processPostURL(URLUtils().getEventListUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_EVENT_LIST, m);
    }
    return m;
  }

  Future<Meta> getOnlineEventDetails(int eventId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['userId'] = SPUtil.getInt(Constants.USERID);
    identifier['eventId'] = eventId;

    Meta m = await gmapiService.processPostURL(URLUtils().getEventDetailsUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(
          TableDetails.CID_EVENT_DETAIL + eventId.toString(), m);
    }
    return m;
  }

  Future<Meta> getPaymentOrderRequest(
      int eventId, double discountAmount, int discountId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['EventId'] = eventId;
    identifier['offerAmount'] = discountAmount;
    identifier['offerId'] = discountId;
    identifier['discountId'] = discountId;

    // print("object" + identifier.toString());
    Meta m = await gmapiService.processPostURL(URLUtils().getPaymentRequest(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getTemplateEvent(int eventId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['Id'] = eventId;
    // print("object" + identifier.toString());
    Meta m = await gmapiService.processPostURL(
        URLUtils().getEventParticipantResultListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getEventParticipantResultList(int eventId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['EventId'] = eventId;
    // print("object" + identifier.toString());
    Meta m = await gmapiService.processPostURL(
        URLUtils().getEventParticipantResultListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getEventParticipantTemplateResult(int eventId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['EventId'] = eventId;
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    // print("object" + identifier.toString());
    Meta m = await gmapiService.processPostURL(
        URLUtils().getEventParticipantTemplateResultListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> saveEventTemplateResults(EventTempleteRequest request) async {
    if (await GMUtils().isInternetConnected()) {
      GMAPIService gmapiService = GMAPIService();
      return await gmapiService.processPostURL(
          URLUtils().saveEventTemplateResultUrl(),
          request.toJson(),
          SPUtil.getString(Constants.KEY_TOKEN_1));
    } else {
      Meta meta = Meta();
      meta.statusCode = 201;
      meta.statusMsg =
          SPUtil.getInt(Constants.CURRENT_LANGUAGE) == Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr;
      return meta;
    }
  }

  Future<Meta> getEventDelete(int eventId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['Id'] = eventId;
    // print("object" + identifier.toString());
    Meta m = await gmapiService.processPostURL(URLUtils().getEventDeleteUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> saveEventRegistration(EventRegistrationRequest request) async {
    if (await GMUtils().isInternetConnected()) {
      GMAPIService gmapiService = GMAPIService();
      return await gmapiService.processPostURL(
          URLUtils().saveEventMemberRegistrationUrl(),
          request.toJson(),
          SPUtil.getString(Constants.KEY_TOKEN_1));
    } else {
      Meta meta = Meta();
      meta.statusCode = 201;
      meta.statusMsg =
          SPUtil.getInt(Constants.CURRENT_LANGUAGE) == Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr;
      return meta;
    }
  }

  Future<Meta> getEventParticipantList(int eventId) async {
    if (await GMUtils().isInternetConnected()) {
      return getOnlineParticipantList(eventId);
    } else {
      return await Utils().getOfflineData(
          TableDetails.CID_EVENT_PARTICIPANT_LIST + eventId.toString());
    }
  }

  Future<Meta> getOnlineParticipantList(int eventId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['userId'] = SPUtil.getInt(Constants.USERID);
    identifier['eventId'] = eventId;
    Meta m = await gmapiService.processPostURL(
        URLUtils().getEventParticipantListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));

    if (m.statusCode == 200) {
      await Utils().saveOfflineData(
          TableDetails.CID_EVENT_PARTICIPANT_LIST + eventId.toString(), m);
    }
    return m;
  }

  Future<Meta> getEventReviewWriteList(int eventId) async {
    if (await GMUtils().isInternetConnected()) {
      return getOnlineReviewWriteList(eventId);
    } else {
      return await Utils().getOfflineData(
          TableDetails.CID_EVENT_REVIEW_WRITE_QUESTION_LIST +
              eventId.toString());
    }
  }

  Future<Meta> getOnlineReviewWriteList(int eventId) async {
    GMAPIService gmApiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['userId'] = SPUtil.getInt(Constants.USERID);
    identifier['EventId'] = eventId;
    Meta m = await gmApiService.processPostURL(
        URLUtils().getFeedBackQuestions(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));

    // print(URLUtils().getFeedBackQuestions());
    // print(identifier.toString());
    // print(m.statusMsg);

    if (m.statusCode == 200) {
      await Utils().saveOfflineData(
          TableDetails.CID_EVENT_REVIEW_WRITE_QUESTION_LIST +
              eventId.toString(),
          m);
    }
    return m;
  }

  Future<Meta> getReviewList() async {
    if (await GMUtils().isInternetConnected()) {
      return await getOnlineReviewList();
    } else {
      return await Utils().getOfflineData(TableDetails.CID_EVENT_REVIEW_LIST);
    }
  }

  Future<Meta> getOnlineReviewList() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getEventReviewListUrl(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_EVENT_REVIEW_LIST, m);
    }
    return m;
  }

  Future<Meta> saveEventReviewForm(ReviewFeedBackRequest request) async {
    if (await GMUtils().isInternetConnected()) {
      GMAPIService gmApiService = GMAPIService();
      Meta meta = await gmApiService.processPostURL(URLUtils().saveReviewForm(),
          request.toJson(), SPUtil.getString(Constants.KEY_TOKEN_1));

      return meta;
    } else {
      Meta meta = Meta();
      meta.statusCode = 201;
      meta.statusMsg =
          SPUtil.getInt(Constants.CURRENT_LANGUAGE) == Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr;
      return meta;
    }
  }

  Future<Meta> getTopReviewDetails(int eventId) async {
    if (await GMUtils().isInternetConnected()) {
      return await getOnlineTopReviewDetails(eventId);
    } else {
      return await Utils().getOfflineData(TableDetails.CID_EVENT_REVIEW_DETAIL);
    }
  }

  Future<Meta> getOnlineTopReviewDetails(int eventId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, int>();
    identifier['EventId'] = eventId;

    Meta m = await gmapiService.processPostURL(URLUtils().getTop5ReviewUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_EVENT_REVIEW_DETAIL, m);
    }
    // print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    // print(m.statusMsg);
    return m;
  }

  Future<File> getImage() => _imagePickerProvider.getImage();

  Future<File> takeImage() => _imagePickerProvider.takeImage();
}
