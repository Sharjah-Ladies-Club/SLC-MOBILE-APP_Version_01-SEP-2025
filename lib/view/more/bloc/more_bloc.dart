import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/repo/home_repository.dart';
import 'package:slc/repo/login_repository.dart';
import 'package:slc/repo/splash_repository.dart';
import 'package:slc/utils/constant.dart';

import './bloc.dart';

class MoreBloc extends Bloc<MoreEvent, MoreState> {
  MoreBloc() : super(null);
  //MoreBloc(MoreState initialState) : super(initialState);

  MoreState get initialState => InitialMoreState();

  Stream<MoreState> mapEventToState(
    MoreEvent event,
  ) async* {
    if (event is LogoutEvent) {
      try {
        yield ShowMoreProgressBarState();
        await getCountryCodeDetails();
        yield LogoutSuccess();
        yield HideMoreProgressBarState();
      } catch (e) {
        yield LogoutFailure(error: e);
      }
    } else if (event is GetHomePageData) {
      yield ShowMoreProgressBarState();

      await HomeRepository().getCarouselList();
      await HomeRepository().getFacilityGroup();
      yield HideMoreProgressBarState();
    } else if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    } else if (event is DeactivateEvent) {
      Meta m = await (new LoginRepository()).deactivateUser();
      if (m.statusCode == 200) {
        yield DeactivateSuccess();
      } else {
        yield DeactivateFailure(error: m.statusMsg);
      }
    }
  }

  Future getCountryCodeDetails() async {
    try {
      List<Meta> m = [];
      var db = new DatabaseHelper();
      var countryDetails = await db.getContentByCID(TableDetails.CID_COUNTRY);
      // print('countryDetails---> ${jsonEncode(countryDetails)}');
      if (countryDetails != null) {
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
    } catch (error) {
      print('error---> ${error.toString()}');
    }
  }
}
