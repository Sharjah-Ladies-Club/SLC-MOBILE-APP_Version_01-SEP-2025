import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/model/login_meta.dart';
import 'package:slc/gmcore/network/GMCore.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/user_login.dart';
import 'package:slc/model/validate.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/url_utils.dart';

class LoginRepository {
  Future<LoginMeta> authorizeLogin(UserLogin userLogin) async {
    LoginMeta meta = LoginMeta();
    var clientKey = SPUtil.getString(Constants.AppKey);
    GMAPIService gmapiService = GMAPIService();
    if (clientKey.isEmpty) {
      gmapiService.logPrinting("Login - Client key is missing");
      meta.statusMsg = "Client key is missing";
      meta.statusCode = 201;
      return meta;
    } else {
      Validate v = new Validate(
          clientKey: SPUtil.getString(Constants.AppKey), clientType: "AppKey");

      return await getLevel2Token(
          userLogin,
          (await gmapiService.getLevel1Token(
                  URLUtils().getValidateUrl(), v.toJson()))
              .statusMsg);
    }
  }

  Future<LoginMeta> getLevel2Token(UserLogin userLogin, String token) async {
    GMAPIService gmapiService = GMAPIService();
    return await gmapiService.getLevel2Token(
        URLUtils().getAuthorizeLoginUrl(), userLogin.toJson(), token);
  }

  Future<Meta> deactivateUser() async {
    GMAPIService gmapiService = GMAPIService();
    var identifier = new Map<String, dynamic>();
    identifier['UserId'] = SPUtil.getInt(Constants.USERID);
    Meta m = await gmapiService.processPutURL(URLUtils().getDeactivateUrl(),
        identifier, SPUtil.getString(Constants.KEY_TOKEN_1));
    return m;
  }
}
