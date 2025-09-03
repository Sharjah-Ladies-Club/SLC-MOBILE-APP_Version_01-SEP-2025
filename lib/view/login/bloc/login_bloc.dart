import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/model/login_meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/base_response.dart';
import 'package:slc/model/login_response.dart';
import 'package:slc/model/user_login.dart';
import 'package:slc/repo/login_repository.dart';
import 'package:slc/repo/splash_repository.dart';
import 'package:slc/utils/constant.dart';

import '../../../model/BasicInfoOneRequest.dart';
import '../../../repo/register_repo.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(null);

  LoginState get initialState => InitialLoginState();

  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield ShowProgressBar();

      try {
        UserLogin request = UserLogin(
            applicationId: event.applicationId,
            countryId: event.countryId,
            fcmToken: SPUtil.getString(Constants.FCM_TOKEN),
            password: event.password,
            userName: event.username);
        LoginMeta meta = await LoginRepository().authorizeLogin(request);

        if (meta.statusCode == 200) {
          BaseResponse baseResponse =
              BaseResponse.fromJson(jsonDecode(meta.statusMsg));
          SPUtil.putString(Constants.KEY_TOKEN_1, meta.level2token);
          LoginResponse loginResponse =
              LoginResponse.fromJson(baseResponse.response);
          SPUtil.putString(Constants.USER_EMAIL, loginResponse.email);
          SPUtil.putString(Constants.USER_FIRSTNAME, loginResponse.name);
          SPUtil.putString(Constants.USER_LASTNAME, loginResponse.lastName);
          SPUtil.putString(Constants.USER_TYPE, loginResponse.bridgeUserType);
          SPUtil.putInt(Constants.USER_TYPEID, loginResponse.bridgeUserTypeId);
          SPUtil.putString(Constants.USER_MOBILE, loginResponse.mobileNumber);
          SPUtil.putString(
              Constants.USER_COUNTRYDIALCODE, loginResponse.dialCode);
          SPUtil.putInt(Constants.USER_COUNTRYID, loginResponse.countryId);
          SPUtil.putString(Constants.USER_DOB, loginResponse.dateOfBirth);
          SPUtil.putInt(Constants.USER_GENDERID, loginResponse.genderId);
          SPUtil.putInt(
              Constants.USER_NATIONALITYID, loginResponse.nationalityId);
          SPUtil.putInt(Constants.USERID, loginResponse.userId);
          SPUtil.putInt(
              Constants.USER_EMPLOYEETYPE, loginResponse.bridgeUserCategoryId);
          SPUtil.putString(
              Constants.USER_EMPLOYEEID, loginResponse.bridgeUserCategoryType);
          SPUtil.putInt(Constants.USER_CUSTOMERID, loginResponse.customerId);
          SPUtil.putInt(
              Constants.USER_CLUBMEMBERSHIPID, loginResponse.clubMembershipId);
          SPUtil.putInt(Constants.USER_FITNESSMEMBERSHIPID,
              loginResponse.fitnessMembershipId);
          SPUtil.putInt(Constants.USER_CORPORATEID, loginResponse.corporateId);
          SPUtil.putInt(Constants.USER_CORPORATECATID,
              loginResponse.corporateStaffCategoryId);
          Constants.USERID_CHECK = loginResponse.userId;
          debugPrint("this is " + loginResponse.corporateId.toString());
          debugPrint(
              "this is " + loginResponse.corporateStaffCategoryId.toString());
          yield HideProgressBar();
          if (!loginResponse.corporateFirstLogin) {
            yield OnSuccess();
          } else {
            yield OnSuccessWithResetPassword();
          }
        } else {
          yield HideProgressBar();
          yield OnFailure(error: meta.statusMsg);
        }
      } catch (error) {
        yield HideProgressBar();
        yield OnFailure(error: error.toString());
      }
    } else if (event is OnLanguagechange) {
      yield ShowProgressBar();
      try {
        print('calling LanguageSwitched');

        await getCountryCodeDetails();

        yield HideProgressBar();
        yield LanguageSwitched();
      } catch (error) {
        yield HideProgressBar();
      }
    } else if (event is PageOneContinueButtonPressed) {
      try {
        yield ShowProgressBar();
        BasicInfoOneRequest req = BasicInfoOneRequest();
        req.mobileNumber = event.mobileNumber;
        req.email = event.email;
        req.countryId = event.countryId;
        LoginMeta m1;
        m1 = await RegisterRepository().registerUserPost(req, event.pagePath);
        //  }

        if (m1.statusCode == 200) {
          yield OnSuccessRegister(
              userId: jsonDecode(m1.statusMsg)["response"]["userId"]);
        } else {
          yield OnFailure(error: m1.statusMsg);
          // yield OnFailure(error: jsonDecode(m1.statusMsg));
        }

        yield HideProgressBar();
      } catch (err) {
        yield HideProgressBar();

        yield OnFailure(error: err);
      }
    }
  }

  Future getCountryCodeDetails() async {
    List<Meta> m = [];
    var db = new DatabaseHelper();
    var countryDetails = await db.getContentByCID(TableDetails.CID_COUNTRY);

    if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
        Constants.LANGUAGE_ARABIC) {
      if (countryDetails.arabicContent == null) {
        m = await Future.wait([SplashRepository().getCountryList()]);
        if (m[0].statusCode == 200) {
          await db.saveOrUpdateContent(
              TableDetails.CID_COUNTRY, jsonEncode(m[0]));
        }
      }
    } else {
      if (countryDetails.englishContent == null) {
        m = await Future.wait([SplashRepository().getCountryList()]);
        if (m[0].statusCode == 200) {
          await db.saveOrUpdateContent(
              TableDetails.CID_COUNTRY, jsonEncode(m[0]));
        }
      }
    }
  }
}
