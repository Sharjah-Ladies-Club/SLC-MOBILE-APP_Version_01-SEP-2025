import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/GenderResponse.dart';
import 'package:slc/repo/splash_repository.dart';
import 'package:slc/utils/constant.dart';

import './bloc.dart';

class BaseInfoTwoBloc extends Bloc<BaseInfoTwoEvent, BaseInfoTwoState> {
  BaseInfoTwoBloc(BaseInfoTwoState initialState) : super(initialState);

  BaseInfoTwoState get initialState => InitialBaseInfoTwoState();
  List<NationalityResponse> nationalityResponse = [];
  List<GenderResponse> genderResponse = [];

  Stream<BaseInfoTwoState> mapEventToState(
    BaseInfoTwoEvent event,
  ) async* {
    if (event is OnLanguagechangeInRegTwo) {
      yield ShowProgressBar();
      try {
        nationalityResponse.clear();

        NationalityResponse nationalityResponseObj = NationalityResponse();
        GenderResponse genderResponseObj = GenderResponse();
        genderResponse.clear();
        nationalityResponseObj.nationalityId = 0;
        nationalityResponseObj.nationalityName = tr('nationality');
        nationalityResponseObj.isActive = true;

        genderResponseObj.genderId = 0;
        genderResponseObj.genderName = tr('genderLabel');

        await getNationality(event.context);

        nationalityResponse.insert(0, nationalityResponseObj);
        genderResponse.insert(0, genderResponseObj);

        yield LanguageSwitched();
        yield HideProgressBar();
      } catch (error) {
        yield OnFailure(error: error);
        yield HideProgressBar();
      }
    }
  }

  Future getNationality(context) async {
    List<Meta> m = [];
    var db = new DatabaseHelper();
    var countryDetails = await db.getContentByCID(TableDetails.CID_NATIONALITY);

    if (countryDetails == null ||
        countryDetails.arabicContent == null ||
        countryDetails.englishContent == null) {
      m = await Future.wait([SplashRepository().getNationalityList()]);
      if (m[0].statusCode == 200) {
        await db.saveOrUpdateContent(
            TableDetails.CID_NATIONALITY, jsonEncode(m[0]));
      }
    }

    await getGender(context);
  }

  Future getGender(context) async {
    List<Meta> m = [];
    var db = new DatabaseHelper();
    var countryDetails = await db.getContentByCID(TableDetails.CID_GENDER);

    if (countryDetails == null ||
        countryDetails.arabicContent == null ||
        countryDetails.englishContent == null) {
      m = await Future.wait([SplashRepository().getGender()]);
      if (m[0].statusCode == 200) {
        await db.saveOrUpdateContent(TableDetails.CID_GENDER, jsonEncode(m[0]));
      }
    }

    await getCountryCodeDetails();
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
