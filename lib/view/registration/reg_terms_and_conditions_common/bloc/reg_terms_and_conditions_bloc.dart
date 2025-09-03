import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/hear_about_us_detail.dart';
import 'package:slc/repo/reg_terms_and_conditions_repository.dart';
import 'package:slc/repo/splash_repository.dart';
import 'package:slc/utils/constant.dart';

import 'bloc.dart';

class RegisterTermsAndConditionsBloc extends Bloc<
    RegisterTermsAndConditionsEvent, RegisterTermsAndConditionsState> {
  RegisterTermsAndConditionsBloc(RegisterTermsAndConditionsState initialState)
      : super(initialState);

  RegisterTermsAndConditionsState get initialState =>
      InitialRegisterTermsAndConditionsState();

  Stream<RegisterTermsAndConditionsState> mapEventToState(
    RegisterTermsAndConditionsEvent event,
  ) async* {
    if (event is FetchHearAboutUsListEvent) {
      try {
        yield ShowRegisterTermsAndConditionsProgressBarState();
        List<Meta> m1 = [
          await RegTermsAndConditionsRepository().getHearAboutUsHinList(),
          //await RegTermsAndConditionsRepository().getCountryList()
        ];

        if (m1[0].statusCode == 200
            //  && m1[1].statusCode == 200
            ) {
          await getCountryCodeDetails();
          yield HideRegisterTermsAndConditionsProgressBarState();
          final List<HearAboutUsDetail> hearAboutList = [];
          jsonDecode(m1[0].statusMsg)['response'].forEach(
              (f) => hearAboutList.add(new HearAboutUsDetail.fromJson(f)));
          yield HearAboutUsListSuccessListener(hearAboutList);
        } else {
          yield HideRegisterTermsAndConditionsProgressBarState();
          yield RegisterTermsAndConditionsOnFailure(
              error: jsonDecode(m1[0].statusMsg));
        }
      } catch (err) {
        yield HideRegisterTermsAndConditionsProgressBarState();
        yield RegisterTermsAndConditionsOnFailure(error: err);
      }
    } else if (event is FetchHearAboutUsListLanguageEvent) {
      try {
        List<Meta> m = [];
        var db = new DatabaseHelper();
        var hearAboutUsDetail =
            await db.getContentByCID(TableDetails.CID_HEAR_ABOUT_US_LIST);

        if (hearAboutUsDetail.arabicContent == null ||
            hearAboutUsDetail.englishContent == null) {
          yield ShowRegisterTermsAndConditionsProgressBarState();
          m = await Future.wait([
            RegTermsAndConditionsRepository().getHearAboutUsHinList(),
            // RegTermsAndConditionsRepository().getCountryList()
          ]);

          if (m[0].statusCode == 200) {
            await db.saveOrUpdateContent(
                TableDetails.CID_HEAR_ABOUT_US_LIST, jsonEncode(m[0]));
            // this is to avoid the country english or arabic content null issue
            // await db.saveOrUpdateContent(
            //     TableDetails.CID_COUNTRY, jsonEncode(m[1]));

            final List<HearAboutUsDetail> hearAboutList = [];
            await jsonDecode(m[0].statusMsg)['response'].forEach(
                (f) => hearAboutList.add(new HearAboutUsDetail.fromJson(f)));
            await getCountryCodeDetails();
            yield HearAboutUsListSuccessListener(hearAboutList);
            yield HideRegisterTermsAndConditionsProgressBarState();
          } else {
            yield HideRegisterTermsAndConditionsProgressBarState();
            yield RegisterTermsAndConditionsOnFailure(
                error: jsonDecode(m[0].statusMsg));
          }
        }
      } catch (e) {
        yield HideRegisterTermsAndConditionsProgressBarState();
        yield RegisterTermsAndConditionsOnFailure(error: e);
      }
    } else if (event is RegistrationSaveEvent) {
      try {
        yield ShowRegisterTermsAndConditionsProgressBarState();

        Meta m1 = await RegTermsAndConditionsRepository()
            .registerCustomer(event.userInfo);
        if (m1.statusCode == 200) {
          yield HideRegisterTermsAndConditionsProgressBarState();
          yield RegisterTermsAndConditionsOnSuccess();
        } else {
          yield HideRegisterTermsAndConditionsProgressBarState();
          yield RegisterTermsAndConditionsOnFailure(
              error: jsonDecode(m1.statusMsg));
        }
      } catch (err) {
        yield HideRegisterTermsAndConditionsProgressBarState();
        yield RegisterTermsAndConditionsOnFailure(error: jsonDecode(err));
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
