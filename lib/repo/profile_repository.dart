import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/network/GMCore.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';

class ProfileRepo {
  Future<Meta> getProfileDetail() async {
    if (await GMUtils().isInternetConnected()) {
      return await getOnlineProfileDetail();
    } else {
      return await Utils().getOfflineData(TableDetails.CID_USER_PROFILE);
    }
  }

  Future<Meta> getOnlineProfileDetail() async {
    GMAPIService gmApiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['userId'] = SPUtil.getInt(Constants.USERID);

    Meta m = await gmApiService.processPostURL(URLUtils().getProfileDetail(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_USER_PROFILE, m);
      SPUtil.putString(Constants.IsProfileOfflineSupport,
          SlcDateUtils().getTodayDateDefaultFormat());
    }
    return m;
  }

  Future<Meta> updateProfileInfo(UserProfileInfo request) async {
    if (!await GMUtils().isInternetConnected()) {
      Meta meta = Meta();
      meta.statusCode = 201;
      meta.statusMsg =
          SPUtil.getInt(Constants.CURRENT_LANGUAGE) == Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr;
      return meta;
    }
    GMAPIService gmApiService = GMAPIService();
    return await gmApiService.processPostURL(URLUtils().updateProfileDetail(),
        request.toJson(), SPUtil.getString(Constants.KEY_TOKEN_1));
  }

  Future<Meta> getEnquiryProfileDetail() async {
    if (await GMUtils().isInternetConnected()) {
      return await getOnlineEnquiryProfileDetail();
    } else {
      return await getOnlineEnquiryProfileDetail();
    }
  }

  Future<Meta> getOnlineEnquiryProfileDetail() async {
    GMAPIService gmApiService = GMAPIService();
    var identifier = new Map<String, int>();
    identifier['userId'] = SPUtil.getInt(Constants.USERID);

    Meta m = await gmApiService.processPostURL(
        URLUtils().getEnquiryProfileDetail(),
        identifier,
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {}
    return m;
  }
}
