import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/model/login_meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/Change_password_request.dart';
import 'package:slc/repo/register_repo.dart';
import 'package:slc/repo/splash_repository.dart';
import 'package:slc/utils/constant.dart';

import './bloc.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc(ChangePasswordState initialState)
      : super(InitialChangePasswordState());

  ChangePasswordState get initialState => InitialChangePasswordState();

  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvent event,
  ) async* {
    if (event is OnLanguagechangeInReg) {
      yield ShowProgressBar();
      try {
        await getCountryCodeDetails();

        yield HideProgressBar();
        yield LanguageSwitchedSuccess();
      } catch (error) {
        yield LanguageSwitchedFailure(error: error);
        yield HideProgressBar();
      }
    } else if (event is ConfirmBtnPressed) {
      try {
        yield ShowProgressBar();

        ChangePasswordRequest req = ChangePasswordRequest();

        req.userId = event.userId;
        req.password = event.password;

        LoginMeta m1 = await RegisterRepository().changePasswordSave(req);

        if (m1.statusCode == 200) {
          yield OnSuccess(
              response: (m1.statusMsg), responseType: "otpValidateResponse");
        } else {
          yield OnFailure(
              error: m1.statusMsg, responseType: "otpValidateResponse");
        }

        yield HideProgressBar();
      } catch (err) {
        yield HideProgressBar();
        yield OnFailure(error: err, responseType: "otpValidateResponse");
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
