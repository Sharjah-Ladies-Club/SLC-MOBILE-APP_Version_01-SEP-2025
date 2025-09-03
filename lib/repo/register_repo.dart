import 'package:slc/gmcore/model/login_meta.dart';
import 'package:slc/gmcore/network/GMCore.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/BasicInfoOneRequest.dart';
import 'package:slc/model/Change_password_request.dart';
import 'package:slc/model/otp_validation.dart';
import 'package:slc/model/resend_otp_request.dart';
import 'package:slc/model/validate.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/url_utils.dart';

class RegisterRepository {
  Future<LoginMeta> registerUserPost(
      BasicInfoOneRequest req, String pagePath) async {
    GMAPIService gmapiService = GMAPIService();

    LoginMeta m = LoginMeta();
    var clientKey = SPUtil.getString(Constants.AppKey);
    if (clientKey.isEmpty) {
      gmapiService.logPrinting("Login - Client key is missing");
      m.statusMsg = "Client key is missing";
      m.statusCode = 201;
      return m;
    } else {
      Validate v = new Validate(
          clientKey: SPUtil.getString(Constants.AppKey), clientType: "AppKey");

      var fullToken = (await gmapiService.getLevel1Token(
          URLUtils().getValidateUrl(), v.toJson()));

      String token = fullToken.statusMsg;

      LoginMeta m;
      if (pagePath == "registerFlow") {
        m = await gmapiService.getLevel2Token(
            URLUtils().basicInfoOneRegisterUrl(), req.toJson(), token);
      } else if (pagePath == "changePassFlow") {
        m = await gmapiService.getLevel2Token(
            URLUtils().basicInfoOneChangePasswordUrl(), req.toJson(), token);
      }

      if (m.statusCode == 200) {
        return m;
      } else {
        return m;
      }
    }
  }

  Future<LoginMeta> resendOTP(ResendOTPRequest req) async {
    GMAPIService gmapiService = GMAPIService();

    LoginMeta m = LoginMeta();
    var clientKey = SPUtil.getString(Constants.AppKey);
    if (clientKey.isEmpty) {
      gmapiService.logPrinting("Login - Client key is missing");
      m.statusMsg = "Client key is missing";
      m.statusCode = 201;
      return m;
    } else {
      Validate v = new Validate(
          clientKey: SPUtil.getString(Constants.AppKey), clientType: "AppKey");

      String getLevel1Token = (await gmapiService.getLevel1Token(
              URLUtils().getValidateUrl(), v.toJson()))
          .statusMsg;

      m = await gmapiService.getLevel2Token(
          URLUtils().resendOTPUrl(), req.toJson(), getLevel1Token
          // .statusMsg
          );

      if (m.statusCode == 200) {
        return m;
      } else {
        return m;
      }
    }
  }

//validate otp
  Future<LoginMeta> validateOTP(OtpValidation req) async {
    GMAPIService gmapiService = GMAPIService();

    LoginMeta m = LoginMeta();
    var clientKey = SPUtil.getString(Constants.AppKey);
    if (clientKey.isEmpty) {
      gmapiService.logPrinting("Login - Client key is missing");
      m.statusMsg = "Client key is missing";
      m.statusCode = 201;
      return m;
    } else {
      Validate v = new Validate(
          clientKey: SPUtil.getString(Constants.AppKey), clientType: "AppKey");

      String getLevel1Token = (await gmapiService.getLevel1Token(
              URLUtils().getValidateUrl(), v.toJson()))
          .statusMsg;

      m = await gmapiService.getLevel2Token(
          URLUtils().validateOTPUrl(), req.toJson(), getLevel1Token
          // .statusMsg
          );

      if (m.statusCode == 200) {
        return m;
      } else {
        return m;
      }
    }
  }

  Future<LoginMeta> changePasswordSave(ChangePasswordRequest req) async {
    GMAPIService gmapiService = GMAPIService();

    LoginMeta m = LoginMeta();
    var clientKey = SPUtil.getString(Constants.AppKey);
    if (clientKey.isEmpty) {
      gmapiService.logPrinting("Login - Client key is missing");
      m.statusMsg = "Client key is missing";
      m.statusCode = 201;
      return m;
    } else {
      Validate v = new Validate(
          clientKey: SPUtil.getString(Constants.AppKey), clientType: "AppKey");

      String getLevel1Token = (await gmapiService.getLevel1Token(
              URLUtils().getValidateUrl(), v.toJson()))
          .statusMsg;

      m = await gmapiService.getLevel2Token(
          URLUtils().changePasswordUrl(), req.toJson(), getLevel1Token);

      if (m.statusCode == 200) {
        return m;
      } else {
        return m;
      }
    }
  }
}
