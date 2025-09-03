import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:slc/authentication/authentication.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/repo/splash_repository.dart';
import 'package:slc/repo/user_repository.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';

import './bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  SplashBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null),
        super(null);

  SplashState get initialState => InitialSplashState();

  Stream<SplashState> mapEventToState(
    SplashEvent event,
  ) async* {
//    if (event is NetAvailable) {
    if (event is AppStarted) {
      Meta fcmMeta = await SplashRepository().getFCMToken();
      if (fcmMeta.statusCode == 200) {
        List<Meta> m = await SplashRepository().getRemoteKeys();

        SPUtil.putString(Constants.FCM_TOKEN, fcmMeta.statusMsg);

        if (m.length == 1) {
          if (m[0].statusCode == 200) {
            var db = new DatabaseHelper();
            await db.saveOrUpdateContent(
                TableDetails.CID_COUNTRY, jsonEncode(m[0]));

            SPUtil.putString(
                Constants.SaveDate, SlcDateUtils().getTodayDateDefaultFormat());

            action();
          } else {
            yield FailureState(
                error: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                        Constants.LANGUAGE_ARABIC
                    ? Strings.retryArbStr
                    : Strings.retryEngStr);
          }
        } else {
          action();
        }
      } else {
        if (fcmMeta.statusCode == 10000) {
          yield FailureState(error: fcmMeta.statusMsg);
        } else if (SPUtil.getInt(Constants.USERID, defValue: 0) > 0) {
          action();
        } else {
          yield FailureState(error: fcmMeta.statusMsg);
        }
      }
    } else if (event is NetNotAvailable) {
      if (SPUtil.getInt(Constants.USERID, defValue: 0) > 0) {
        action();
      } else {
        yield FailureState(
            error: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                    Constants.LANGUAGE_ARABIC
                ? Strings.chknetArbStr
                : Strings.chknetEngStr);
      }
    }
  }

  void action() {
    if (SPUtil.getInt(Constants.USERID, defValue: 0) > 0) {
      authenticationBloc.add(Authendicated());
    } else {
      authenticationBloc.add(UnAuthendicated());
    }
  }
}
