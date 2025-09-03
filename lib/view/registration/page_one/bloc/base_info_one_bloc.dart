import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/model/login_meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/BasicInfoOneRequest.dart';
import 'package:slc/repo/register_repo.dart';
import 'package:slc/repo/splash_repository.dart';
import 'package:slc/utils/constant.dart';

import './bloc.dart';

class BaseInfoOneBloc extends Bloc<BaseInfoOneEvent, BaseInfoOneState> {
  BaseInfoOneBloc(BaseInfoOneState initialState) : super(null);

  BaseInfoOneState get initialState => InitialBaseInfoOneState();

  Stream<BaseInfoOneState> mapEventToState(
    BaseInfoOneEvent event,
  ) async* {
    if (event is PageOneContinueButtonPressed) {
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
          yield OnSuccess(
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
    } else if (event is OnLanguagechangeInReg) {
      yield ShowProgressBar();
      try {
        await getCountryCodeDetails();

        yield HideProgressBar();
        yield LanguageSwitched();
      } catch (error) {
        yield HideProgressBar();
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
