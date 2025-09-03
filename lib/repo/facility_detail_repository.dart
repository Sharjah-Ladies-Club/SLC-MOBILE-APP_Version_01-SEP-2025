import 'dart:developer';

import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/network/GMCore.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/model/enquiry_answers.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/facility_item_request.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/model/knooz_response_dto.dart';
import 'package:slc/model/partyhall_response.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';

class FacilityDetailRepository {
  Future<Meta> getFacilityDetails(int facilityId) async {
    if (await GMUtils().isInternetConnected()) {
      return await getOnlineFacilityDetail(facilityId);
    } else {
      Meta m = await Utils().getOfflineData(
          TableDetails.CID_FACILITY_DETAIL + facilityId.toString());
      if (m.statusCode == 200) {
        return m;
      } else {
        return await getOnlineFacilityDetail(facilityId);
      }
    }
  }

  Future<Meta> getOnlineFacilityDetail(int facilityId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['facilityId'] = facilityId;
    identifier['loginUserId'] = SPUtil.getInt(Constants.USERID);
    Meta m = await gmapiService.processPostURL(
        URLUtils().getFacilityDetailUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    log("XXXXXXXXXXXXXXXXXXXXXXXXXXXX" + m.statusMsg);
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(
          TableDetails.CID_FACILITY_DETAIL + facilityId.toString(), m);
    }
    return m;
  }

  Future<Meta> getFacilityCategoryDetails(
      int facilityId, int facilityCategoryId) async {
    String cid = TableDetails.CID_FACILITY_DETAIL +
        facilityId.toString() +
        TableDetails.CID_FACILITY_ITEM +
        facilityCategoryId.toString();
    if (await GMUtils().isInternetConnected()) {
      return await getOnlineFacilityCategoryDetail(
          facilityId, facilityCategoryId);
    } else {
      Meta m = await Utils().getOfflineData(cid);
      if (m.statusCode == 200) {
        return m;
      } else {
        return await getOnlineFacilityCategoryDetail(
            facilityId, facilityCategoryId);
      }
    }
  }

  Future<Meta> getOnlineFacilityCategoryDetail(
      int facilityId, int facilityCategoryId) async {
    String cid = TableDetails.CID_FACILITY_DETAIL +
        facilityId.toString() +
        TableDetails.CID_FACILITY_ITEM +
        facilityCategoryId.toString();

    FacilityItemRequest facilityItemRequest = FacilityItemRequest(
        facilityId: facilityId, mobileItemCategoryId: facilityCategoryId);

    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processPostURL(
        URLUtils().getFacilityCategoryDetailUrl(),
        facilityItemRequest.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));

    if (m.statusCode == 200) {
      await Utils().saveOfflineData(cid, m);
    }

    return m;
  }

  Future<Meta> getOnlineFitnessFacilityCategoryDetail(
      int facilityId, int facilityCategoryId) async {
    String cid = TableDetails.CID_FACILITY_DETAIL +
        facilityId.toString() +
        TableDetails.CID_FACILITY_ITEM +
        facilityCategoryId.toString();

    FacilityItemRequest facilityItemRequest = FacilityItemRequest(
        facilityId: facilityId, mobileItemCategoryId: facilityCategoryId);

    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processPostURL(
        URLUtils().getFitnessFacilityCategoryDetailUrl(),
        facilityItemRequest.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));

    if (m.statusCode == 200) {
      await Utils().saveOfflineData(cid, m);
    }

    return m;
  }

  Future<Meta> getFacilityGalleryDetail(
      int facilityId, int facilityCategoryId) async {
    String cid = TableDetails.CID_FACILITY_DETAIL +
        facilityId.toString() +
        TableDetails.CID_FACILITY_ITEM +
        facilityCategoryId.toString();
    if (await GMUtils().isInternetConnected()) {
      return await getOnlineFacilityGalleryDetail(
          facilityId, facilityCategoryId);
    } else {
      Meta m = await Utils().getOfflineData(cid);
      if (m.statusCode == 200) {
        return m;
      } else {
        return await getOnlineFacilityGalleryDetail(
            facilityId, facilityCategoryId);
      }
    }
  }

  Future<Meta> getOnlineFacilityGalleryDetail(
      int facilityId, int facilityCategoryId) async {
    String cid = TableDetails.CID_FACILITY_DETAIL +
        facilityId.toString() +
        TableDetails.CID_FACILITY_ITEM +
        facilityCategoryId.toString();

    FacilityItemRequest facilityItemRequest = FacilityItemRequest(
        facilityId: facilityId, mobileItemCategoryId: facilityCategoryId);

    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processPostURL(
        URLUtils().getFacilityGalleryDetailUrl(),
        facilityItemRequest.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));

    if (m.statusCode == 200) {
      await Utils().saveOfflineData(cid, m);
    }

    return m;
  }

  Future<Meta> getOnlineFacilityItemsPriceList(
      int facilityId, int facilityItemGroupID) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, int>();
    identifier['FacilityId'] = facilityId;
    identifier['FacilityItemGroupId'] = facilityItemGroupID;
    identifier['userId'] = SPUtil.getInt(Constants.USERID);

    Meta m = await gmapiService.processPostURL(
        URLUtils().getPricelistDetailUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getRecommendationList(int facilityId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['FacilityId'] = facilityId;
    identifier['MobileNo'] = SPUtil.getString(Constants.USER_MOBILE);
    identifier['LanguageId'] = SPUtil.getInt(Constants.CURRENT_LANGUAGE,
            defValue: Constants.LANGUAGE_ENGLISH)
        .toString();

    Meta m = await gmapiService.processPostURL(
        URLUtils().getRecommendationUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getOBBDownload(int userInfoId, int facilityId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['RecommendationId'] = userInfoId;
    identifier['FacilityId'] = facilityId;
    identifier['LanguageId'] = SPUtil.getInt(Constants.CURRENT_LANGUAGE,
            defValue: Constants.LANGUAGE_ENGLISH)
        .toString();
    ;

    Meta m = await gmapiService.processPostURL(URLUtils().getOBBDownloadUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getFurtherRecommendationList(
      int facilityId, int recommendationId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['FacilityId'] = facilityId;
    identifier['RecommendationId'] = recommendationId;
    identifier['LanguageId'] = SPUtil.getInt(Constants.CURRENT_LANGUAGE,
            defValue: Constants.LANGUAGE_ENGLISH)
        .toString();

    Meta m = await gmapiService.processPostURL(
        URLUtils().getFurtherRecommendationUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    // if (m.statusCode == 200) {
    //   await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    // }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getItemEnquiryList(
      int facilityItemId, int enquiryDetailId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, int>();
    identifier['FacilityItemId'] = facilityItemId;
    identifier['EnquiryDetailId'] = enquiryDetailId;
    identifier['userId'] = SPUtil.getInt(Constants.USERID);

    Meta m = await gmapiService.processPostURL(
        URLUtils().getItemEnquiryListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getTermsList(int facilityId) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getTermsListUrl() +
            "&facilityid=" +
            facilityId.toString() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getMemberQuestionsList(
      int facilityId, int enquiryDetailId) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getMemberQuestionsUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString() +
            "&enquiryDetailId=" +
            enquiryDetailId.toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getFitnessMemberQuestionsList(
      int facilityId, int enquiryDetailId) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getFitnessMemberQuestionsUrl() +
            "&enquiryDetailId=" +
            enquiryDetailId.toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  // Future<Meta> getFitnessMemberQuestionsList(
  //     int facilityId, int enquiryDetailId) async {
  //   GMAPIService gmapiService = GMAPIService();
  //
  //   var identifier = new Map<String, dynamic>();
  //   identifier['FacilityId'] = facilityId;
  //   identifier['EnquiryDetailId'] = enquiryDetailId;
  //   identifier['UserId'] = SPUtil.getInt(Constants.USERID).toString();
  //   identifier['languageId'] =
  //       SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString();
  //
  //   Meta m = await gmapiService.processPostURL(
  //       URLUtils().getFitnessMemberQuestionsUrl(),
  //       identifier,
  //       SPUtil.getString(Constants.KEY_TOKEN_1));
  //
  //   // Meta m = await gmapiService.processGetURL(
  //   //     URLUtils().getFitnessMemberQuestionsUrl() +
  //   //         "&languageid=" +
  //   //         SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString() +
  //   //         "&enquiryDetailId=" +
  //   //         enquiryDetailId.toString(),
  //   //     SPUtil.getString(Constants.KEY_TOKEN_1));
  //   return m;
  // }

  Future<Meta> getEnquiryTrainersList(
      int enquiryDetailId, String fromDate, String toDate) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['EnquiryId'] = enquiryDetailId;
    identifier['FromDate'] = fromDate;
    identifier['ToDate'] = toDate;

    Meta m = await gmapiService.processPostURL(
        URLUtils().getEnquiryTrainersListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getEnquiryTimeTableList(
      int enquiryDetailId, int trainerId, String fromDate) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['EnquiryId'] = enquiryDetailId;
    identifier['FromDate'] = fromDate;
    identifier['trainerId'] = trainerId;

    Meta m = await gmapiService.processPostURL(
        URLUtils().getEnquiryTimeTableListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      //await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getEnquiryAllTimeTableList(String fromDate) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['FromDate'] = fromDate;
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);

    Meta m = await gmapiService.processPostURL(
        URLUtils().getEnquiryAllTimeTableListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getEnquiryFamilyList() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getEnquiryFamilyListUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString() +
            "&userid=" +
            SPUtil.getInt(Constants.USERID).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> saveBooking(int enquiryDetailId, int reservationId,
      int reservationTemplateId, bool isCancel, int bookingId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['EnquiryId'] = enquiryDetailId;
    identifier['ReservationId'] = reservationId;
    identifier['ReservationTemplateId'] = reservationTemplateId;
    identifier['IsCancel'] = isCancel;
    identifier['BookingId'] = bookingId;

    Meta m = await gmapiService.processPostURL(
        URLUtils().saveEnquiryBookingsUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getEnquiryPaymentOrderRequest(
    int facilityId,
    int enquiryDetailId,
    List<FacilityBeachRequest> facilityItemRequest,
    int tableNo, {
    DeliveryAddress address,
    DeliveryCharges charges,
    BillDiscounts billDiscount,
    GiftVocuher giftVoucher,
    double discountAmt = 0,
    double tipsAmount = 0,
    double grossAmount = 0,
    double taxAmount = 0,
    double netAmount = 0,
    double deliveryAmount = 0,
    double deliveryTaxAmount = 0,
    double giftVoucherAmount = 0,
    int giftCategoryId = 0,
    double giftCategoryPrice = 0,
    String giftCardText = "",
    int giftCardImageId = 0,
    String giftSharedMobileNo = "",
    int giftToId = 0,
    int bookingId = 0,
    int moduleId = 0,
  }) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['FacilityId'] = facilityId;
    identifier['EnquiryDetailId'] = enquiryDetailId;
    identifier['facilityItems'] = facilityItemRequest;
    identifier['tableNo'] = tableNo;
    if (address != null) {
      identifier['deliveryDetail'] = address;
    }
    if (charges != null) {
      identifier['deliveryCharges'] = charges;
    }

    if (billDiscount != null && billDiscount.discountName != null) {
      identifier['offerCode'] = billDiscount.discountName;
      identifier['offerAmount'] = discountAmt;
      identifier['offerId'] = billDiscount.discountId;
      identifier['discountId'] = billDiscount.billDiscountId;
    } else {
      identifier['offerCode'] = "";
      identifier['offerAmount'] = 0;
      identifier['offerId'] = 0;
      identifier['discountId'] = 0;
    }
    if (tipsAmount != null) {
      identifier['tipsAmount'] = tipsAmount;
    } else {
      identifier['tipsAmount'] = 0;
    }
    identifier['grossAmount'] = grossAmount.toStringAsFixed(2);
    identifier['taxAmount'] = taxAmount.toStringAsFixed(2);
    identifier['netAmount'] = netAmount.toStringAsFixed(2);
    identifier['deliveryAmount'] = deliveryAmount.toStringAsFixed(2);
    identifier['deliveryTaxAmount'] = deliveryTaxAmount.toStringAsFixed(2);
    if (giftVoucher != null && giftVoucher.giftVoucherId != null) {
      identifier['giftVoucherId'] = giftVoucher.giftVoucherId;
      identifier['giftCardText'] = giftVoucher.giftCardText;
      identifier['giftVoucherBalanceAmount'] = giftVoucher.balanceAmount;
      identifier['giftVoucherRedeemAmount'] = giftVoucherAmount;
    } else {
      identifier['giftVoucherId'] = 0;
      identifier['giftCardText'] = "";
      identifier['giftVoucherBalanceAmount'] = 0;
      identifier['giftVoucherRedeemAmount'] = 0;
    }
    identifier['giftCategoryId'] = giftCategoryId;
    identifier['giftCategoryPrice'] = giftCategoryPrice;
    identifier['giftCardText'] = giftCardText;
    identifier['giftCardImageId'] = giftCardImageId;
    identifier['giftSharedMobileNo'] = giftSharedMobileNo;
    identifier['giftToId'] = giftToId;
    identifier['bookingId'] = bookingId;
    identifier['moduleId'] = moduleId;
    // print("object" + identifier.toString());
    Meta m = await gmapiService.processPostURL(
        URLUtils().getEnquiryPaymentRequest(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getFacilityPaymentOrderRequest(
      int facilityId, int bookingId, int userId, double netAmount) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['facilityId'] = facilityId;
    identifier['bookingId'] = bookingId;
    identifier['userId'] = userId;
    identifier['netAmount'] = netAmount;
    print("object" + identifier.toString());
    Meta m = await gmapiService.processPostURL(
        URLUtils().getFacilityHallPaymentRequest(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> saveEnquiryDetails(
      EnquiryDetailResponse enquiryDetail, bool isCancel) async {
    GMAPIService gmapiService = GMAPIService();
    enquiryDetail.userID = SPUtil.getInt(Constants.USERID);
    Meta m = await gmapiService.processPostURL(
        isCancel
            ? URLUtils().cancelEnquiryDetailsUrl()
            : URLUtils().saveEnquiryDetailsUrl(),
        enquiryDetail.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> updateEnquiryDetails(int enquiryDetailId, int enquiryStatusId,
      bool isActive, int enquiryProcessId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['EnquiryDetailId'] = enquiryDetailId;
    identifier['EnquiryStatusId'] = enquiryStatusId;
    identifier['EnquiryProcessStatus'] = enquiryProcessId;
    identifier['IsActive'] = isActive;
    identifier['erpCustomerId'] = 0;

    Meta m = await gmapiService.processPostURL(
        URLUtils().updateEnquiryDetailsUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> saveEnquiryQuestionDetails(
      MemberAnswerRequest enquiryAnswers) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processPostURL(
        URLUtils().saveEnquiryQuestionDetailsUrl(),
        enquiryAnswers.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getTransactionList() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getTransactionListUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString() +
            "&userid=" +
            SPUtil.getInt(Constants.USERID).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getTransactionDetailList(int orderid) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getTransactionDetailListUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString() +
            "&orderId=" +
            orderid.toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> postTransactionFeedback(int orderId, int feedbackPoints) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['orderId'] = orderId;
    identifier['Feedback'] = feedbackPoints;

    Meta m = await gmapiService.processPostURL(URLUtils().saveFeedbackUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getOnlineRetailItemsPriceList(
      int facilityId, String retailItemSetId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['qrid'] = retailItemSetId;
    identifier['languageId'] = SPUtil.getInt(Constants.CURRENT_LANGUAGE);
    identifier['userId'] = SPUtil.getInt(Constants.USERID);

    Meta m = await gmapiService.processPostURL(
        URLUtils().getRetailItemlistDetailUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getOnlineRetailCartItemsPriceList(
      int facilityId, int retailItemSetId) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getRetailCartItemlistDetailUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString() +
            "&facilityId=" +
            facilityId.toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getOrderStatus(String merchantReferenceNo) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['MerchantReferenceno'] = merchantReferenceNo;
    identifier['userId'] = SPUtil.getInt(Constants.USERID);

    Meta m = await gmapiService.processPostURL(URLUtils().getOrderStatusUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getKunoozOrderStatus(String merchantReferenceNo) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['MerchantReferenceno'] = merchantReferenceNo;
    identifier['userId'] = SPUtil.getInt(Constants.USERID);

    Meta m = await gmapiService.processPostURL(
        URLUtils().getKunoozOrderStatusUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getOnlineRetailDeliveryAddress() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getRetailDeliveryAddressUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString() +
            "&userId=" +
            SPUtil.getInt(Constants.USERID).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getOnlineRetailDeliveryCharges(int facilityId) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getRetailDeliveryChargesUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString() +
            "&facilityId=" +
            facilityId.toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getOnlineFacilityTransportCharges(int itemGroup) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getFacilityTransportChargesUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString() +
            "&itemGroup=" +
            itemGroup.toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getKunoozDocumentType() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getKunoozDocumentTypeUrl(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getDiscountList(int facilityId, double billAmount,
      {int itemId = 0}) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['userType'] = SPUtil.getInt(Constants.USER_TYPEID);
    identifier['userCategory'] = SPUtil.getInt(Constants.USER_EMPLOYEETYPE);
    identifier['facilityId'] = facilityId;
    identifier['billAmount'] = billAmount;
    identifier['corporateId'] = SPUtil.getInt(Constants.USER_CORPORATEID);
    identifier['corporateCategoryId'] =
        SPUtil.getInt(Constants.USER_CORPORATECATID);
    identifier['FacilityItemId'] = itemId;

    Meta m = await gmapiService.processPostURL(
        URLUtils().getDiscountDetailUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getEventDiscountList(int eventId, double billAmount) async {
    GMAPIService gmapiService = GMAPIService();
    print("SSSSSSSSSSSSSSSUserType" +
        SPUtil.getInt(Constants.USER_TYPEID).toString());
    print("SSSSSSSSSSSSSSSUserCategory" +
        SPUtil.getInt(Constants.USER_EMPLOYEETYPE).toString());
    print("USER_CORPORATEID::::::::::::::" +
        SPUtil.getInt(Constants.USER_CORPORATEID).toString());
    print("USER_CORPORATECATID::::::::::" +
        SPUtil.getInt(Constants.USER_CORPORATECATID).toString());
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['userType'] = SPUtil.getInt(Constants.USER_TYPEID);
    identifier['userCategory'] = SPUtil.getInt(Constants.USER_EMPLOYEETYPE);
    identifier['corporateId'] = SPUtil.getInt(Constants.USER_CORPORATEID);
    identifier['corporateCategoryId'] =
        SPUtil.getInt(Constants.USER_CORPORATECATID);
    identifier['billAmount'] = billAmount;
    identifier['facilityId'] = eventId;

    print("USER_CORPORATECATID::::::::::" + eventId.toString());

    Meta m = await gmapiService.processPostURL(
        URLUtils().getEventDiscountDetailUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getVoucherList(int facilityId, double billAmount) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['userType'] = SPUtil.getInt(Constants.USER_TYPEID);
    identifier['userCategory'] = SPUtil.getInt(Constants.USER_EMPLOYEETYPE);
    identifier['facilityId'] = facilityId;
    identifier['billAmount'] = billAmount;
    identifier['corporateId'] = SPUtil.getInt(Constants.USER_CORPORATEID);
    identifier['corporateCategoryId'] =
        SPUtil.getInt(Constants.USER_CORPORATECATID);

    Meta m = await gmapiService.processPostURL(URLUtils().getVoucherListUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getRedemptionList(
      int facilityId, double billAmount, int voucherType) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['userType'] = SPUtil.getInt(Constants.USER_TYPEID);
    identifier['userCategory'] = SPUtil.getInt(Constants.USER_EMPLOYEETYPE);
    identifier['facilityId'] = facilityId;
    identifier['billAmount'] = billAmount;
    identifier['voucherType'] = voucherType;
    Meta m = await gmapiService.processPostURL(
        URLUtils().getRedemptionListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getFitnessRedemptionList(
      int facilityId, double billAmount, int voucherType) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['userType'] = SPUtil.getInt(Constants.USER_TYPEID);
    identifier['userCategory'] = SPUtil.getInt(Constants.USER_EMPLOYEETYPE);
    identifier['facilityId'] = facilityId;
    identifier['billAmount'] = billAmount;
    identifier['voucherType'] = voucherType;
    Meta m = await gmapiService.processPostURL(
        URLUtils().getFitnessRedemptionListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> saveTableBooking(int roomId, String bookingDate,
      String startTime, String endTime, int guests) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['roomId'] = roomId;
    identifier['start'] = bookingDate + " " + startTime;
    identifier['end'] = bookingDate + " " + endTime;
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier["NoOfGuests"] = guests;
    Meta m = await gmapiService.processPostURL(URLUtils().saveTableBookingUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getBookingTableList(String areaName, String bookingDate,
      String startTime, String endTime) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['AreaName'] = areaName;
    identifier['BookingDate'] = bookingDate;
    identifier['StartTime'] = startTime;
    identifier['EndTime'] = endTime;

    Meta m = await gmapiService.processPostURL(
        URLUtils().getBookingTableListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> saveVoucherRedemption(
      int loyaltyVoucherSlabId, int requirePoints, int redemptionPoints) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['id'] = 0;
    identifier['RedeemPoints'] = redemptionPoints;
    identifier['RequiredPoints'] = requirePoints;
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier["LoyaltyVoucherSlabsId"] = loyaltyVoucherSlabId;
    Meta m = await gmapiService.processPostURL(
        URLUtils().saveVoucherRedemptionUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> postEntryExit(String eventType) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier["EventType"] = eventType;
    Meta m = await gmapiService.processPostURL(URLUtils().postEntryExitUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> saveVoucherUse(int redemptionId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['LoyaltyRedemptionId'] = redemptionId;
    /*identifier['RedeemPoints'] = 0;
    identifier['RequiredPoints'] = 0;*/
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    /*identifier["LoyaltyVoucherSlabsId"] = 0;*/
    Meta m = await gmapiService.processPostURL(URLUtils().saveVoucherUsedUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> checkVoucherOtp(int redemptionId, String otp) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['LoyaltyRedemptionId'] = redemptionId;
    identifier['OTP'] = otp;
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    Meta m = await gmapiService.processPostURL(URLUtils().saveVoucherOTPUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> saveGiftCardUse(
      int redemptionId, String amount, int facilityId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['LoyaltyRedemptionId'] = redemptionId;
    identifier['RedeemAmount'] = amount;
    identifier['FacilityId'] = facilityId;
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    /*identifier["LoyaltyVoucherSlabsId"] = 0;*/
    Meta m = await gmapiService.processPostURL(URLUtils().getGiftVouchersOtp(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> checkGiftCardOtp(
      int redemptionId, String otp, String amount, int facilityId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['LoyaltyRedemptionId'] = redemptionId;
    identifier['OTP'] = otp;
    identifier['RedeemAmount'] = amount;
    identifier['FacilityId'] = facilityId;
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    Meta m = await gmapiService.processPostURL(
        URLUtils().getGiftVouchersValidateOtp(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> checkDiscountCoupon(int discountId, String couponCode) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['LoyaltyRedemptionId'] = discountId;
    identifier['OTP'] = couponCode;
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    Meta m = await gmapiService.processPostURL(
        URLUtils().checkDiscountVoucherCouponUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> checkEventDiscountCoupon(
      int discountId, String couponCode) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['LoyaltyRedemptionId'] = discountId;
    identifier['OTP'] = couponCode;
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    print("AAAAAAAAAAAAAAAA $identifier");
    Meta m = await gmapiService.processPostURL(
        URLUtils().checkEventDiscountVoucherCouponUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> shareVoucher(int redemptionId, String mobileNo) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['LoyaltyRedemptionId'] = redemptionId;
    identifier['MobileNo'] = mobileNo;
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    Meta m = await gmapiService.processPostURL(URLUtils().shareVoucherUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getPoints() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getPointsUrl() +
            "&userId=" +
            SPUtil.getInt(Constants.USERID).toString() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> deleteUploadedDocument(
      int facilityId, String supportDocumentId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['RecordId'] = supportDocumentId;

    Meta m = await gmapiService.processPostURL(
        URLUtils().getDeleteDocumentUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> deleteFacilityUploadedDocument(
      int facilityId, String supportDocumentId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['RecordId'] = supportDocumentId;

    Meta m = await gmapiService.processPostURL(
        URLUtils().getDeletePartyHalDocumentUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> applePayResponse(
      String applePayToken, String applePayUrl, int orderId,
      {bool isSamsungPay = false, int FacilityId = 0}) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['OrderId'] = orderId;
    identifier['ApplePayUrl'] = applePayUrl;
    identifier['TokenResponse'] = applePayToken;
    identifier['SamsungPay'] = isSamsungPay;
    identifier['FacilityId'] = FacilityId;

    Meta m = await gmapiService.processPostURL(
        URLUtils().getApplePayReponseUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getFitnessVideoList(int facilityId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['facilityId'] = facilityId;
    identifier['userId'] = SPUtil.getInt(Constants.USERID);
    identifier['SearchText'] = "";

    Meta m = await gmapiService.processPostURL(
        URLUtils().getFitnessVideoListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getFitnessDietList(int facilityId, String selectedDate) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['facilityId'] = facilityId;
    identifier['userId'] = SPUtil.getInt(Constants.USERID);
    identifier['SearchText'] = selectedDate;

    Meta m = await gmapiService.processPostURL(
        URLUtils().getFitnessDietListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getFoodList() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getFoodListUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> saveDietDetails(FitnessUserDietEntry dietEntry) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processPostURL(URLUtils().saveDietDetailsUrl(),
        dietEntry.toJson(), SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> savePartyHallDetails(
      PartyHallResponse partyHallDetail, bool isCancel) async {
    GMAPIService gmapiService = GMAPIService();
    partyHallDetail.userID = SPUtil.getInt(Constants.USERID);
    Meta m = await gmapiService.processPostURL(
        isCancel
            ? URLUtils().cancelEnquiryDetailsUrl()
            : URLUtils().savePartyHallDetailsUrl(),
        partyHallDetail.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getUploadedImages(int id) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getBookingImageListUrl(id) +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> saveKunoozDetails(
      KunoozBookingDto partyHallDetail, bool isCancel) async {
    GMAPIService gmapiService = GMAPIService();
    partyHallDetail.userID = SPUtil.getInt(Constants.USERID);
    Meta m = await gmapiService.processPostURL(
        isCancel
            ? URLUtils().cancelEnquiryDetailsUrl()
            : URLUtils().saveKunoozDetailsUrl(),
        partyHallDetail.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getOnlinePartyHallItemPriceList(int facilityId) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getPartyHallItemsUrl() +
            "&facilityId=" +
            facilityId.toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getItemPartyHallEnquiryList(
      int facilityItemId, int enquiryDetailId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, int>();
    identifier['FacilityItemId'] = facilityItemId;
    identifier['EnquiryDetailId'] = enquiryDetailId;
    identifier['userId'] = SPUtil.getInt(Constants.USERID);

    Meta m = await gmapiService.processPostURL(
        URLUtils().getItemPartyHallEnquiryListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getPartyHallEnquiry(int enquiryDetailId) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getPartyHallEnquiryUrl() +
            "&Id=" +
            enquiryDetailId.toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> updatePartyHallDetails(int enquiryDetailId, int enquiryStatusId,
      bool isActive, int enquiryProcessId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['EnquiryDetailId'] = enquiryDetailId;
    identifier['EnquiryStatusId'] = enquiryStatusId;
    identifier['EnquiryProcessStatus'] = enquiryProcessId;
    identifier['IsActive'] = isActive;
    identifier['erpCustomerId'] = 0;

    Meta m = await gmapiService.processPostURL(
        URLUtils().updatePartyHallDetailsUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getPartyHallPaymentOrderRequest(
      int facilityId,
      int enquiryDetailId,
      List<FacilityBeachRequest> facilityItemRequest,
      int tableNo,
      {DeliveryAddress address,
      DeliveryCharges charges,
      BillDiscounts billDiscount,
      double discountAmt = 0,
      double tipsAmount = 0,
      double grossAmount = 0,
      double taxAmount = 0,
      double netAmount = 0,
      double deliveryAmount = 0,
      double deliveryTaxAmount = 0}) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['FacilityId'] = facilityId;
    identifier['EnquiryDetailId'] = enquiryDetailId;
    identifier['facilityItems'] = facilityItemRequest;
    identifier['tableNo'] = tableNo;
    if (address != null) {
      identifier['deliveryDetail'] = address;
    }
    if (charges != null) {
      identifier['deliveryCharges'] = charges;
    }

    if (billDiscount != null && billDiscount.discountName != null) {
      identifier['offerCode'] = billDiscount.discountName;
      identifier['offerAmount'] = discountAmt;
      identifier['offerId'] = billDiscount.discountId;
      identifier['discountId'] = billDiscount.billDiscountId;
    } else {
      identifier['offerCode'] = "";
      identifier['offerAmount'] = 0;
      identifier['offerId'] = 0;
      identifier['discountId'] = 0;
    }
    if (tipsAmount != null) {
      identifier['tipsAmount'] = tipsAmount;
    } else {
      identifier['tipsAmount'] = 0;
    }
    identifier['grossAmount'] = grossAmount.toStringAsFixed(2);
    identifier['taxAmount'] = taxAmount.toStringAsFixed(2);
    identifier['netAmount'] = netAmount.toStringAsFixed(2);
    identifier['deliveryAmount'] = deliveryAmount.toStringAsFixed(2);
    identifier['deliveryTaxAmount'] = deliveryTaxAmount.toStringAsFixed(2);

    // print("object" + identifier.toString());
    Meta m = await gmapiService.processPostURL(
        URLUtils().getPartyHallPaymentRequest(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getEventTypeList() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getEventTypeListUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getVenueList() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getVenueListUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getGiftCardImagesUrl() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getGiftCardImagesUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getGiftCardUIData() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getGiftCardUIDataUrl() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getGiftVouchers() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getGiftVouchers(), SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getAllGiftVouchers() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(URLUtils().getGiftAllVouchers(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getActiveFacility() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(URLUtils().getActiveFacility(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getGiftVoucherDetail(int voucherId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['giftVoucherId'] = voucherId;
    identifier['userId'] = SPUtil.getInt(Constants.USERID);
    Meta m = await gmapiService.processPostURL(
        URLUtils().getVoucherDetailReport(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    return m;
  }

  Future<Meta> getPaymentTerms(int facilityId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['facilityId'] = facilityId;
    identifier['userId'] = SPUtil.getInt(Constants.USERID);
    Meta m = await gmapiService.processPostURL(URLUtils().getPaymentTerms(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    print(identifier.toString());
    return m;
  }

  Future<Meta> getKunoozTermsList(int facilityId) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getTermsListUrl() +
            "&facilityid=" +
            facilityId.toString() +
            "&languageid=" +
            SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getKunoozContractDownload(int bookingId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = bookingId;

    Meta m = await gmapiService.processPostURL(
        URLUtils().getKunoozContractDownloadUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getKunoozAmendmentDownload(int amendId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = amendId;

    Meta m = await gmapiService.processPostURL(
        URLUtils().getKunoozAmendmentDownloadUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getKunoozCancelBooking(int bookingId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['BookingId'] = bookingId;
    identifier['CancelType'] = 1;
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['CancelReason'] = "User canceled this booking";

    Meta m = await gmapiService.processPostURL(
        URLUtils().getKunoozCancelBookingUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }

  Future<Meta> getFitnessTimeTableList(int trainerId, String fromDate) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['FromDate'] = fromDate;
    identifier['TrainerId'] = trainerId;

    Meta m = await gmapiService.processPostURL(
        URLUtils().getFitnessTimeTableUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      //await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getPTPackageDetails(String fromDate, int screenCode) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['FromDate'] = fromDate;
    identifier['CustomerId'] = SPUtil.getInt(Constants.USER_CUSTOMERID);
    identifier['TrainerId'] = screenCode;
    Meta m = await gmapiService.processPostURL(
        URLUtils().getFitnessPTPackageUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      //await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    return m;
  }

  Future<Meta> getFitnessTrainersList(String fromDate) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['FromDate'] = fromDate;

    Meta m = await gmapiService.processPostURL(
        URLUtils().getFitnessTrainersListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      //await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getFitnessSpaceBookingList(
      String fromDate, int trainerId, int customerId, int classMasterId) async {
    GMAPIService gmapiService = GMAPIService();

    var identifier = new Map<String, dynamic>();
    identifier['FromDate'] = fromDate;
    identifier['TrainerId'] = trainerId;
    identifier['CustomerId'] = customerId;
    identifier['ClassMasterId'] = classMasterId;
    log(identifier.toString());
    log("This is Customer ID" + customerId.toString());
    Meta m = await gmapiService.processPostURL(
        URLUtils().getFitnessSpaceBookingListUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      //await Utils().saveOfflineData(TableDetails.CID_FACILITY_ITEM_PRICE, m);
    }
    //print(identifier.toString());
    // print(URLUtils().getTop5ReviewUrl());
    //print(m.statusMsg);
    return m;
  }

  Future<Meta> getCheckInOut(
      String sqrCode, int locationId, int checkinStatus) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    identifier['ERPCustomerid'] = SPUtil.getInt(Constants.USER_CUSTOMERID);
    identifier['QrCode'] = sqrCode;
    identifier['RecordCheckInOut'] = checkinStatus;
    identifier['POSUSer'] = 0;
    identifier['LocationID'] = locationId;
    identifier['ContractID'] = 0;
    Meta m = await gmapiService.processPostURL(URLUtils().getCheckInOutUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    print(identifier.toString());
    return m;
  }

  Future<Meta> getAddToFitnessClass(int classId, int facilityItemId,
      int bookingId, int membershipTypeId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['ClassId'] = classId;
    identifier['ErpCustomerId'] = SPUtil.getInt(Constants.USERID);
    identifier['FacilityItemId'] = facilityItemId;
    identifier['BookingId'] = bookingId;
    identifier['CustomerType'] = membershipTypeId;
    log("TTTTTTTTTTTTTTTTT$identifier");
    Meta m = await gmapiService.processPostURL(
        URLUtils().getAddToFitnessClassUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    print("This is Passed" + identifier.toString());
    return m;
  }

  Future<Meta> removeFitnessClass(int classId, int bookingId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['ClassId'] = classId;
    identifier['ErpCustomerId'] = SPUtil.getInt(Constants.USER_CUSTOMERID);
    identifier['BookingId'] = bookingId;
    Meta m = await gmapiService.processPostURL(
        URLUtils().getRemoveFitnessClassUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    print("This is Passed" + identifier.toString());
    return m;
  }

  Future<Meta> getTrainersProfile(int trainerId, String fromdate) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = trainerId;
    identifier['FromDate'] = fromdate;
    identifier['ToDate'] = fromdate;
    Meta m = await gmapiService.processPostURL(
        URLUtils().getTrainerProfilesUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    print("This is Passed" + identifier.toString());
    return m;
  }

  Future<Meta> getFitnessItem(int fitnessGroupItemId) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getFitnessItemsUrl(fitnessGroupItemId),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    return m;
  }

  Future<Meta> getUserMembership() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getUserMembershipUrl(SPUtil.getInt(Constants.USERID)),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    return m;
  }

  Future<Meta> getUserMembershipfacilityUrl(int facilityId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['userId'] = SPUtil.getInt(Constants.USERID);
    identifier['facilityId'] = facilityId;
    identifier['languageId'] =
        SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString();

    Meta m = await gmapiService.processPostURL(
        URLUtils().getUserMembershipfacilityUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    return m;
  }

  Future<Meta> getAppContentDesc(int moduleId) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getAppDescriptiontUrl(moduleId),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    return m;
  }

  Future<String> uploadFitnessEnquiryImage(
      Map parameters, String url, String path) async {
    GMAPIService gmapiService = GMAPIService();
    String m = await gmapiService.imageUploadWithoutResponse(
        url, path, SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m != null) {
      log("XXXXXXXXXXXXXXXXXXXXXXXXXXXX" + m);
    } else {
      log("not uploaded");
    }
    return m;
  }

  Future<Meta> getKunoozBookingData(int bookingId) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getKunoozDetailsUrl() +
            "&id=" +
            bookingId.toString() +
            "&userid=" +
            SPUtil.getInt(Constants.USERID).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    return m;
  }

  Future<Meta> postKunoozBookingData(int bookingId) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['bookingid'] = bookingId.toString();
    identifier['userid'] = SPUtil.getInt(Constants.USERID).toString();
    identifier['languageId'] = SPUtil.getInt(Constants.CURRENT_LANGUAGE,
            defValue: Constants.LANGUAGE_ENGLISH)
        .toString();
    Meta m = await gmapiService.processPostURL(URLUtils().getKunoozDetailsUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    return m;
  }

  Future<Meta> postKunoozRevertAmendmentData(
      int bookingId, int isAccept) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['BookingId'] = bookingId;
    identifier['PosUseId'] = SPUtil.getInt(Constants.USERID).toString();
    identifier['AcceptOrReject'] = isAccept;
    // identifier['languageId'] =
    //     SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString();
    Meta m = await gmapiService.processPostURL(
        URLUtils().getKunoozRevertAmendmentUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    return m;
  }

  Future<Meta> getKunoozAmendContractData(int amendId) async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(
        URLUtils().getKunoozAmendContractUrl() + "&id=" + amendId.toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    print(m.statusMsg);
    return m;
  }
}
