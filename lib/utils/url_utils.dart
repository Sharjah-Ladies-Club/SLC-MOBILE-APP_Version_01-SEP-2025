import 'dart:convert';

import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/chatbot_launch_request.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/utils.dart';

import '../flavor.dart';

class URLUtils {
  String getValidateUrl() {
    return Injector().baseUrl + "api/authenticate/validate";
  }

  String getNetSpeedUrl() {
    return Injector().baseUrl + "api/lookups/netspeed";
  }

  String getAuthorizeLoginUrl() {
    return Injector().baseUrl + "api/authorize/user" + selectedLanguage();
  }

  String getCountryListUrl() {
    return Injector().baseUrl +
        "api/lookups/countries/active" +
        selectedLanguage();
  }

  String getNationalityListUrl() {
    return Injector().baseUrl +
        "api/lookups/nationalities/active" +
        selectedLanguage();
  }

  String getGenderUrl() {
    return Injector().baseUrl +
        "api/lookups/genders/active" +
        selectedLanguage();
  }

  String registrationUrl() {
    return Injector().baseUrl +
        "api/users/registration/basic" +
        selectedLanguage();
  }

  String sendOtpUrl() {
    return Injector().baseUrl +
        "api/users/registration/otp" +
        selectedLanguage();
  }

//duplicate
  String resendOtpUrl() {
    return Injector().baseUrl + "api/users/otp" + selectedLanguage();
  }

//duplicate
  String validateOtpUrl() {
    return Injector().baseUrl + "api/users/otp/validate" + selectedLanguage();
  }

  String getFacilityGroupUrl() {
    return Injector().baseUrl +
        "api/lookups/facilitygroups/active" +
        selectedLanguage() +
        netSpeed();
  }

  String getFacilityCategoryUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/facilitygroupid" +
        selectedLanguage() +
        netSpeed();
  }

  String getFacilityShopCategoryUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/facilityshopgroupid" +
        selectedLanguage() +
        netSpeed();
  }

  String getCarouselDataUrl() {
    return Injector().baseUrl +
        "api/lookups/dashboard/carousel" +
        selectedLanguage() +
        netSpeed();
  }

  String getMemberQuestionDataUrl() {
    return Injector().baseUrl +
        "api/lookups/marketing/questions" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String getFacilityDetailUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/basic" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String getFacilityCategoryDetailUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/items" +
        selectedLanguage() +
        netSpeed();
  }

  String getFitnessFacilityCategoryDetailUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/fitnessitemspackage" +
        selectedLanguage() +
        netSpeed();
  }

  String getDiscountDetailUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/billDiscounts" +
        selectedLanguage() +
        netSpeed();
  }

  String getEventDiscountDetailUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/eventbillDiscounts" +
        selectedLanguage() +
        netSpeed();
  }

  String getVoucherListUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/loyaltyVoucher" +
        selectedLanguage() +
        netSpeed();
  }

  String getMembershipVoucherListUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/membershipVoucher" +
        selectedLanguage() +
        netSpeed();
  }

  String getPointsUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/pointsAvailable" +
        selectedLanguage() +
        netSpeed();
  }

  String getRedemptionListUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/redemptionVoucher" +
        selectedLanguage() +
        netSpeed();
  }

  String getFitnessRedemptionListUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/fitnessredemptionVoucher" +
        selectedLanguage() +
        netSpeed();
  }

  String saveVoucherRedemptionUrl() {
    return Injector().baseUrl +
        "api/facilities/redemption/add" +
        selectedLanguage() +
        netSpeed();
  }

  String postEntryExitUrl() {
    return Injector().baseUrl +
        "api/facilities/notification/entryexit" +
        selectedLanguage() +
        netSpeed();
  }

  String saveVoucherUsedUrl() {
    return Injector().baseUrl +
        "api/facilities/redemption/otp" +
        selectedLanguage() +
        netSpeed();
  }

  String saveVoucherOTPUrl() {
    return Injector().baseUrl +
        "api/facilities/redemption/validate" +
        selectedLanguage() +
        netSpeed();
  }

  String checkDiscountVoucherCouponUrl() {
    return Injector().baseUrl +
        "api/facilities/discount/validate" +
        selectedLanguage() +
        netSpeed();
  }

  String checkEventDiscountVoucherCouponUrl() {
    return Injector().baseUrl +
        "api/facilities/eventdiscount/validate" +
        selectedLanguage() +
        netSpeed();
  }

  String shareVoucherUrl() {
    return Injector().baseUrl +
        "api/facilities/redemption/share" +
        selectedLanguage() +
        netSpeed();
  }

  String getBookingTableListUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/getAvailableTables" +
        selectedLanguage() +
        netSpeed();
  }

  String saveTableBookingUrl() {
    return Injector().baseUrl +
        "api/facilities/Tablebooking/ManageBookings" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String getPricelistDetailUrl() {
    return Injector().baseUrl +
        "api/facilities/facilityitem/pricelevelitems" +
        selectedLanguage() +
        netSpeed();
  }

  String getRecommendationUrl() {
    return Injector().baseUrl + "api/facilities/obb/recommendations";
  }

  String getFurtherRecommendationUrl() {
    return Injector().baseUrl + "api/facilities/obb/furtherrecommendations";
  }

  String getOBBDownloadUrl() {
    return Injector().baseUrl +
        "api/facilities/obb/downloadurl" +
        selectedEngLanguage() +
        netSpeed();
  }

  String getRetailItemlistDetailUrl() {
    return Injector().baseUrl +
        "api/facilities/retailItems" +
        selectedLanguage() +
        netSpeed();
  }

  String getPartyHallItemsUrl() {
    return Injector().baseUrl +
        "api/facilities/partyHallItems" +
        selectedLanguage() +
        netSpeed();
  }

  String getRetailCartItemlistDetailUrl() {
    return Injector().baseUrl +
        "api/facilities/retailCartItems" +
        selectedLanguage() +
        netSpeed();
  }

  String getRetailDeliveryAddressUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/deliveryaddress" +
        selectedLanguage() +
        netSpeed();
  }

  String getRetailDeliveryChargesUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/deliverycharge" +
        selectedLanguage() +
        netSpeed();
  }

  String getFacilityTransportChargesUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/transportcharges" +
        selectedLanguage() +
        netSpeed();
  }

  String getKunoozDocumentTypeUrl() {
    return Injector().baseUrl +
        "api/lookups/kunooz/documenttypes" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String getItemEnquiryListUrl() {
    return Injector().baseUrl +
        "api/facilities/enquirydetails" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String getEnquiryTrainersListUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/Trainers" +
        selectedLanguage() +
        netSpeed();
  }

  String getEnquiryTimeTableListUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/BookingDetails" +
        selectedLanguage() +
        netSpeed();
  }

  String getEnquiryAllTimeTableListUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/AllBookingDetails" +
        selectedLanguage() +
        netSpeed();
  }

  String getFitnessTrainersListUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/fitnessTrainers" +
        selectedLanguage() +
        netSpeed();
  }

  String getFitnessTimeTableUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/timetable" +
        selectedLanguage() +
        netSpeed();
  }

  String getKunoozContractDownloadUrl() {
    return Injector().baseUrl +
        "api/facilities/kunooz/bookingcontract" +
        selectedEngLanguage() +
        netSpeed();
  }

  String getKunoozAmendmentDownloadUrl() {
    return Injector().baseUrl +
        "api/facilities/kunooz/amendmentcontract" +
        selectedEngLanguage() +
        netSpeed();
  }

  String getKunoozCancelBookingUrl() {
    return Injector().baseUrl +
        "api/facilities/kunooz/cancelbooking" +
        selectedEngLanguage() +
        netSpeed();
  }

  String getFitnessPTPackageUrl() {
    // return Injector().baseUrl +
    //     "api/lookups/facilities/ptdetails" +
    //     selectedLanguage() +
    //     netSpeed();
    return Injector().baseUrl +
        "api/lookups/facilities/mypackagebookingdetails" +
        selectedLanguage() +
        netSpeed();
  }

  String getFitnessSpaceBookingListUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/classbookingdetails" +
        selectedLanguage() +
        netSpeed();
  }

  String getTermsListUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/terms" +
        selectedLanguage() +
        netSpeed();
  }

  String getOrderStatusUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/paymentstatus" +
        selectedLanguage() +
        netSpeed();
  }

  String getKunoozOrderStatusUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/kunoozpaymentstatus" +
        selectedLanguage() +
        netSpeed();
  }

  String getMemberQuestionsUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/memberquestions" +
        selectedLanguage() +
        netSpeed();
  }

  String getFitnessMemberQuestionsUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/fitnessmemberquestions" +
        selectedLanguage();
  }

  String getTransactionListUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/invoice" +
        selectedLanguage() +
        netSpeed();
  }

  String getTransactionDetailListUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/invoicedetail" +
        selectedLanguage() +
        netSpeed();
  }

  String saveFeedbackUrl() {
    return Injector().baseUrl +
        "api/facilities/postfeedback" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String getEventListUrl() {
    return Injector().baseUrl +
//        "api/lookups/event/list" +
        "api/lookups/event/list/dashboard" +
        selectedLanguage() +
        netSpeed();
  }

  String getImageUploadUrl() {
    return Injector().baseUrl + "/api/test/upload";
  }

  String getImageFacilityUploadUrl() {
    return Injector().baseUrl + "/api/test/uploadkunooz";
  }

  String getImageResultUrl() {
    return Injector().baseUrl;
  }

  //POST
  String getEventDetailsUrl() {
    return Injector().baseUrl +
        "api/lookups/event/view" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String getEventDeleteUrl() {
    return Injector().baseUrl +
        "api/events/participant/remove" +
        selectedLanguage() +
        netSpeed();
  }

  String getPaymentRequest() {
    return Injector().baseUrl +
        "api/events/participant/pay" +
        selectedLanguage(); //+
    //   netSpeed();
  }

  String getEnquiryPaymentRequest() {
    return Injector().baseUrl +
        "api/facilities/facility/pay" +
        selectedLanguage(); //+
    //   netSpeed();
  }

  String getFacilityHallPaymentRequest() {
    return Injector().baseUrl +
        "api/facilities/facility/payadvance" +
        selectedLanguage(); //+
    //   netSpeed();
  }

  String getApplePayReponseUrl() {
    return Injector().baseUrl +
        "api/facilities/facility/applepay" +
        selectedLanguage(); //+
    //   netSpeed();
  }

  //POST
  String getEventParticipantListUrl() {
    return Injector().baseUrl +
        "api/lookups/event/participant/list" +
        selectedLanguage() +
        netSpeed();
  }

  // GET
  String getEventParticipantResultListUrl() {
    return Injector().baseUrl +
        "api/events/result-template" +
        selectedLanguage() +
        netSpeed();
  }

  String getEventParticipantTemplateResultListUrl() {
    return Injector().baseUrl +
        "api/events/participant/result/list" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String saveEventTemplateResultUrl() {
    return Injector().baseUrl +
        "api/events/participant/result" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String saveEventMemberRegistrationUrl() {
    return Injector().baseUrl +
        "api/events/participant/add" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String getFacilityGalleryDetailUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/gallery" +
        selectedLanguage() +
        netSpeed();
  }

  String selectedLanguage() {
    return "?languageid=" +
        SPUtil.getInt(Constants.CURRENT_LANGUAGE,
                defValue: Constants.LANGUAGE_ENGLISH)
            .toString();
  }

  String selectedEngLanguage() {
    return "?languageid=1";
  }

  String netSpeed() {
    return "&qualityid=${Utils().getInterNetSpeed()}";
  }

  //POST
  String getNotificationListUrl() {
    return Injector().baseUrl +
        "api/lookups/notification/all" +
        selectedLanguage() +
        netSpeed();
  }

  //POST  // It will used for the push notification view option for future use
  String getNotificationById() {
    return Injector().baseUrl +
        "api/lookups/notification/id" +
        selectedLanguage() +
        netSpeed();
  } //POST

  String getNotificationBadge() {
    return Injector().baseUrl +
        "api/lookups/notification/badges" +
        selectedLanguage() +
        netSpeed();
  }

  //PUT
  String notificationReadStatus() {
    return Injector().baseUrl +
        "api/dashboard/manualnotification" +
        selectedLanguage() +
        netSpeed();
  }

//PUT
  String notificationListClearUrl() {
    return Injector().baseUrl + "api/dashboard/notification/clearall"
        //  + selectedLanguage()
        //  + netSpeed()
        ;
  }

//GET
  String getHearAboutUsUrl() {
    return Injector().baseUrl +
        "api/lookups/marketingsources/active" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String basicInfoOneRegisterUrl() {
    return Injector().baseUrl +
            "api/users/registration/otp" +
            selectedLanguage()
        //  + netSpeed()
        ;
  }

  //POST
  String basicInfoOneChangePasswordUrl() {
    return Injector().baseUrl +
            "api/users/changepassword/otp" +
            selectedLanguage()
        //  + netSpeed()
        ;
  }

  //POST
  String validateOTPUrl() {
    return Injector().baseUrl + "api/users/otp/validate" + selectedLanguage()
        //  + netSpeed()
        ;
  }

  //POST
  String resendOTPUrl() {
    return Injector().baseUrl + "api/users/otp" + selectedLanguage()
        //  + netSpeed()
        ;
  }

  //POST
  String userFinalPageRegisterUrl() {
    return Injector().baseUrl +
            "api/users/registration/basic" +
            selectedLanguage()
        //  + netSpeed()
        ;
  }

  //POST
  String changePasswordUrl() {
    return Injector().baseUrl +
            "api/users/changepassword/save" +
            selectedLanguage()
        //  + netSpeed()
        ;
  }

  String getTermsAndConditionURL() {
    String languageDetermine = SPUtil.getInt(Constants.CURRENT_LANGUAGE,
                defValue: Constants.LANGUAGE_ENGLISH) ==
            Constants.LANGUAGE_ENGLISH
        ? ""
        : "_arabic";
    return Injector().baseUrl +
        "Template/TermsAndConditions" +
        languageDetermine +
        ".html";
  }

//POST
  String saveEnquiryDetailsUrl() {
    return Injector().baseUrl +
        "api/facilities/enquiry/add" +
        selectedLanguage() +
        netSpeed();
  }

  String cancelEnquiryDetailsUrl() {
    return Injector().baseUrl +
        "api/facilities/enquiry/edit" +
        selectedLanguage() +
        netSpeed();
  }

  String updateEnquiryDetailsUrl() {
    return Injector().baseUrl +
        "api/facilities/enquiry/update" +
        selectedLanguage() +
        netSpeed();
  }

  String saveEnquiryQuestionDetailsUrl() {
    return Injector().baseUrl +
        "api/facilities/savememberanswers" +
        selectedLanguage() +
        netSpeed();
  }

  String saveEnquiryBookingsUrl() {
    return Injector().baseUrl +
        "api/facilities/booking/maintain" +
        selectedLanguage() +
        netSpeed();
  }

  String getEnquiryFamilyListUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/familydetails" +
        selectedLanguage() +
        netSpeed();
  }

  String getProfileDetail() {
    return Injector().baseUrl +
            "api/lookups/myprofile/view" +
            selectedLanguage()
        //  + netSpeed()
        ;
  }

  String getEnquiryProfileDetail() {
    return Injector().baseUrl +
            "api/lookups/myprofile/renewal" +
            selectedLanguage()
        //  + netSpeed()
        ;
  }

  //POST
  String updateProfileDetail() {
    return Injector().baseUrl + "api/users/myprofile/save" + selectedLanguage()
        //  + netSpeed()
        ;
  }

  String getSurveyFacilityListUrl() {
    return Injector().baseUrl +
//        "api/lookups/facility/all" +
        "api/lookups/facility/survey" +
        selectedLanguage() +
        netSpeed();
  }

  String getSurveyQuestionListUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/questions" +
        selectedLanguage() +
        netSpeed();
  }

  String saveSurveyUrl() {
    return Injector().baseUrl +
        "api/facilities/useranswer/save" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String getEventReviewListUrl() {
    return Injector().baseUrl +
        "api/lookups/event/reviewhistory" +
        selectedLanguage() +
        netSpeed();
  }

  //POST
  String saveReviewForm() {
    return Injector().baseUrl +
        "api/events/feedback/save" +
        selectedLanguage() +
        netSpeed();
  }

  /*POST*/
  String getFeedBackQuestions() {
    return Injector().baseUrl +
        "api/lookups/event/feedbackquestions" +
        selectedLanguage() +
        netSpeed();
  }

  /*Get*/
  String getTop5ReviewUrl() {
    return Injector().baseUrl +
        "api/lookups/event/reviewhistory/id" +
        selectedLanguage() +
        netSpeed();
  }

  String chatBotUrl() {
    return Injector().botBaseUrl +
        '&client_params=' +
        json.encode(ChatBotLaunchRequest(
            userId: SPUtil.getInt(Constants.USERID, defValue: 0),
            userType: SPUtil.getInt(Constants.USER_TYPEID, defValue: 0),
            token: SPUtil.getString(Constants.KEY_TOKEN_1)));
  }

  String getDeleteDocumentUrl() {
    return Injector().baseUrl +
        "api/facilities/enquiry/deleteimage" +
        selectedLanguage() +
        netSpeed();
  }

  String getDeletePartyHalDocumentUrl() {
    return Injector().baseUrl +
        "api/facilities/partyhall/deleteimage" +
        selectedLanguage() +
        netSpeed();
  }

  String getFitnessVideoListUrl() {
    return Injector().baseUrl +
        "api/lookups/uservideos/all" +
        selectedLanguage() +
        netSpeed();
  }

  String getFitnessDietListUrl() {
    return Injector().baseUrl +
        "api/lookups/usermeals/all" +
        selectedLanguage() +
        netSpeed();
  }

  String getFoodListUrl() {
    return Injector().baseUrl +
        "api/lookups/meals/all" +
        selectedLanguage() +
        netSpeed();
  }

  String saveDietDetailsUrl() {
    return Injector().baseUrl +
        "api/facilities/diet/add" +
        selectedLanguage() +
        netSpeed();
  }

  String savePartyHallDetailsUrl() {
    return Injector().baseUrl +
        "api/facilities/partyhall/add" +
        selectedLanguage() +
        netSpeed();
  }

  String saveKunoozDetailsUrl() {
    return Injector().baseUrl +
        "api/facilities/kunooz/savebooking" +
        selectedLanguage() +
        netSpeed();
  }

  String getKunoozDetailsUrl() {
    return Injector().baseUrl + "api/facilities/kunooz/bookingbyid";
  }

  String getKunoozRevertAmendmentUrl() {
    return Injector().baseUrl +
        "api/facilities/kunooz/revertamendment" +
        selectedLanguage() +
        netSpeed();
  }

  String getKunoozAmendContractUrl() {
    return Injector().baseUrl +
        "/api/facilities/amendmentdetails" +
        selectedLanguage() +
        netSpeed();
  }

  String getItemPartyHallEnquiryListUrl() {
    return Injector().baseUrl +
        "api/facilities/partyhallenquirydetails" +
        selectedLanguage() +
        netSpeed();
  }

  String getPartyHallEnquiryUrl() {
    return Injector().baseUrl +
        "api/facilities/contract/partyhall" +
        selectedLanguage() +
        netSpeed();
  }

  String updatePartyHallDetailsUrl() {
    return Injector().baseUrl +
        "api/facilities/partyhall/update" +
        selectedLanguage() +
        netSpeed();
  }

  String getPartyHallPaymentRequest() {
    return Injector().baseUrl +
        "api/facilities/facility/partyhallpay" +
        selectedLanguage(); //+
    //   netSpeed();
  }

  String getEventTypeListUrl() {
    return Injector().baseUrl +
        "api/lookups/partyhall/eventtypes" +
        selectedLanguage() +
        netSpeed();
  }

  String getVenueListUrl() {
    return Injector().baseUrl +
        "api/lookups/partyhall/venue" +
        selectedLanguage() +
        netSpeed();
  }

  String saveMarketingAnswerUrl() {
    return Injector().baseUrl +
        "api/facilities/marketingquestionans/add" +
        selectedLanguage() +
        netSpeed();
  }

  String getGiftCardImagesUrl() {
    return Injector().baseUrl +
        "api/lookups/giftcard/giftcardimages" +
        selectedLanguage() +
        netSpeed();
  }

  String getGiftCardUIDataUrl() {
    return Injector().baseUrl +
        "api/lookups/giftcard/carduidata" +
        selectedLanguage() +
        netSpeed();
  }

  String getGiftVouchers() {
    return Injector().baseUrl +
        "api/lookups/giftcard/giftcardvouchers" +
        selectedLanguage() +
        "&userId=" +
        SPUtil.getInt(Constants.USERID, defValue: 0).toString();
  }

  String getGiftAllVouchers() {
    return Injector().baseUrl +
        "api/lookups/giftcard/allgiftcardvouchers" +
        selectedLanguage() +
        "&userId=" +
        SPUtil.getInt(Constants.USERID, defValue: 0).toString();
  }

  String getGiftVouchersOtp() {
    return Injector().baseUrl +
        "api/facilities/giftcard/otp" +
        selectedLanguage() +
        netSpeed();
  }

  String getGiftVouchersValidateOtp() {
    return Injector().baseUrl +
        "api/facilities/giftcard/validate" +
        selectedLanguage() +
        netSpeed();
  }

  String getActiveFacility() {
    return Injector().baseUrl +
        "api/lookups/facilities/active" +
        selectedLanguage() +
        netSpeed();
  }

  String getVoucherDetailReport() {
    return Injector().baseUrl +
        "api/lookups/facility/giftcarddetailslist" +
        selectedLanguage() +
        netSpeed();
  }

  String getPaymentTerms() {
    return Injector().baseUrl +
        "api/lookups/facility/paymentterms" +
        selectedLanguage() +
        netSpeed();
  }

  String getCheckInOutUrl() {
    return Injector().baseUrl +
        "api/lookups/facility/gymqr" +
        selectedLanguage() +
        netSpeed();
  }

  String getAddToFitnessClassUrl() {
    return Injector().baseUrl +
        "api/facilities/fitnessclass/addtoclass" +
        selectedLanguage() +
        netSpeed();
  }

  String getRemoveFitnessClassUrl() {
    return Injector().baseUrl +
        "api/facilities/fitnessclass/removeclass" +
        selectedLanguage() +
        netSpeed();
  }

  String getTrainerProfilesUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/trainersprofile" +
        selectedLanguage() +
        netSpeed();
  }

  String getFitnessItemsUrl(int fitnessGroupItemId) {
    return Injector().baseUrl +
        "api/lookups/facilities/fitnessgroupitem" +
        selectedLanguage() +
        "&fitnessGroupItemId=" +
        fitnessGroupItemId.toString();
  }

  String getUserMembershipUrl(int userId) {
    return Injector().baseUrl +
        "api/lookups/facilities/fitnessmembership" +
        selectedLanguage() +
        "&userId=" +
        userId.toString();
  }

  String getUserMembershipfacilityUrl() {
    return Injector().baseUrl +
        "api/lookups/facilities/fitnessmembership" +
        selectedLanguage() +
        netSpeed();
  }

  String getAppDescriptiontUrl(int moduleId) {
    return Injector().baseUrl +
        "api/lookups/facilities/appmodulecontent" +
        selectedLanguage() +
        "&moduleId=" +
        moduleId.toString();
  }

  String getDeactivateUrl() {
    return Injector().baseUrl +
        "api/users/disableaccount" +
        selectedLanguage() +
        netSpeed();
  }

  String getBookingImageListUrl(int id) {
    return Injector().baseUrl +
        "api/facilities/kunooz/getimages" +
        selectedLanguage() +
        netSpeed() +
        "&id=" +
        id.toString();
  }
}
