import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/network/GMCore.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/model/facility_request.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';

class HomeRepository {
  Future<Meta> getFacilityGroup() async {
    if (await GMUtils().isInternetConnected()) {
      return await getOnlineFacilityGroup();
    } else {
      Meta m = await Utils().getOfflineData(TableDetails.CID_FACILITY_GROUP);
      if (m.statusCode == 200) {
        return m;
      } else {
        return await getOnlineFacilityGroup();
      }
    }
  }

  Future<Meta> getOnlineFacilityGroup() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(URLUtils().getFacilityGroupUrl(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      SPUtil.putBool(Constants.IS_FACILITY_GROUP_RETRY, false);
      await Utils().saveOfflineData(TableDetails.CID_FACILITY_GROUP, m);
    }
    return m;
  }

  Future<Meta> getFacilityById(FacilityRequest request) async {
    bool isAvailable = await GMUtils().isInternetConnected();
    if (isAvailable) {
      return await getOnlineFacilityData(request);
    } else {
      Meta m = await getOfflineFacilityData(request);

      if (m.statusCode == 200) {
        return m;
      } else {
        return await getOnlineFacilityData(request);
      }
    }
  }

  Future<Meta> getOnlineShopFacilityData(FacilityRequest request) async {
    GMAPIService gmapiService = GMAPIService();

    Meta m = await gmapiService.processPostURL(
        URLUtils().getFacilityShopCategoryUrl(),
        request.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {}
    return m;
  }

  Future<Meta> getOfflineFacilityData(FacilityRequest request) async {
    return await Utils().getOfflineData(TableDetails.CID_FACILITY_INDIVIDUAL +
        request.facilityGroupId.toString());
  }

  Future<Meta> getOnlineFacilityData(FacilityRequest request) async {
    GMAPIService gmapiService = GMAPIService();

    Meta m = await gmapiService.processPostURL(
        URLUtils().getFacilityCategoryUrl(),
        request.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      SPUtil.putBool(Constants.IS_FACILITY_RETRY, false);
      await Utils().saveOfflineData(
          TableDetails.CID_FACILITY_INDIVIDUAL +
              request.facilityGroupId.toString(),
          m);
    }
    return m;
  }

  Future<Meta> getCarouselList() async {
    if (await GMUtils().isInternetConnected()) {
      return await getCarouselOnlineData();
    } else {
      Meta m = await Utils().getOfflineData(TableDetails.CID_CAROUSEL);
      if (m.statusCode == 200) {
        return m;
      } else {
        return await getCarouselOnlineData();
      }
    }
  }

  Future<Meta> getCarouselOnlineData() async {
    GMAPIService gmapiService = GMAPIService();

    Meta m = await gmapiService.processGetURL(URLUtils().getCarouselDataUrl(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      SPUtil.putBool(Constants.IS_CAROUSEL_RETRY, false);
      await Utils().saveOfflineData(TableDetails.CID_CAROUSEL, m);
    }
    return m;
  }

  Future<Meta> getMemberQuestionData() async {
    GMAPIService gmapiService = GMAPIService();

    Meta m = await gmapiService.processGetURL(
        URLUtils().getMemberQuestionDataUrl() +
            "&userid=" +
            SPUtil.getInt(Constants.USERID).toString(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {}
    return m;
  }

  Future<Meta> saveMarketingAnswer(int marketingQuestionId, int answer) async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['MarketingQuestionId'] = marketingQuestionId;
    identifier['Answer'] = answer;
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    Meta m = await gmapiService.processPostURL(
        URLUtils().saveMarketingAnswerUrl(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }
}
