import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/model/login_meta.dart';
import 'package:slc/gmcore/network/GMCore.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/model/reg_user_info.dart';
import 'package:slc/model/validate.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';

class RegTermsAndConditionsRepository {
  Future<Meta> getHearAboutUsHinList() async {
    if (await GMUtils().isInternetConnected()) {
      return await getOnlineHearAboutUsHinList();
    } else {
      Meta m =
          await Utils().getOfflineData(TableDetails.CID_HEAR_ABOUT_US_LIST);
      if (m.statusCode == 200) {
        return m;
      } else {
        return await getOnlineHearAboutUsHinList();
      }
    }
  }

  Future<Meta> getOnlineHearAboutUsHinList() async {
    GMAPIService gmapiService = GMAPIService();
    Meta m = await gmapiService.processGetURL(URLUtils().getHearAboutUsUrl(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
    if (m.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_HEAR_ABOUT_US_LIST, m);
    }
    return m;
  }

  Future<Meta> registerCustomer(UserInfo userInfo) async {
    if (!await GMUtils().isInternetConnected()) {
      Meta meta = Meta();
      meta.statusCode = 201;
      meta.statusMsg =
          SPUtil.getInt(Constants.CURRENT_LANGUAGE) == Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr;
      return meta;
    }
    GMAPIService gmapiService = GMAPIService();

    LoginMeta m = LoginMeta();
    var clientKey = SPUtil.getString(Constants.AppKey);
    if (clientKey.isEmpty) {
      Meta mError = Meta();
      gmapiService.logPrinting("Login - Client key is missing");
      mError.statusMsg = "Client key is missing";
      mError.statusCode = 201;
      return mError;
    } else {
      Validate v = new Validate(
          clientKey: SPUtil.getString(Constants.AppKey), clientType: "AppKey");
      String token = (await gmapiService.getLevel1Token(
              URLUtils().getValidateUrl(), v.toJson()))
          .statusMsg;

      m = await gmapiService.getLevel2Token(
          URLUtils().userFinalPageRegisterUrl(), userInfo.toJson(), token);

      Meta reslut = Meta();
      reslut.statusCode = m.statusCode;
      reslut.statusMsg = m.statusMsg;
      if (reslut.statusCode == 200) {
        return reslut;
      } else {
        Meta mError = Meta();
        mError.statusMsg = "Internal error.";
        mError.statusCode = 201;
        return mError;
      }
    }
  }
}
