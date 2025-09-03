import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/authentication/authentication_bloc.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/repo/user_repository.dart';
import 'package:slc/utils/connectivity_checker.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/splash/bloc/bloc.dart';
import 'package:store_redirect/store_redirect.dart';

class SplashPage extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final UserRepository userRepository;

  SplashPage({@required this.userRepository, this.analytics, this.observer});

  @override
  Widget build(BuildContext context) {
    /*Todo Have*/
    SPUtil.remove(Constants.REG_USER_EMAIL);
    SPUtil.remove(Constants.REG_USER_MOBILE);

    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return SplashBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          )..add(AppStarted());
        },
        child: _Splash(context),
      ),
    );
  }
}

// ignore: must_be_immutable
class _Splash extends StatefulWidget {
  BuildContext context;

  _Splash(this.context);

  @override
  State<StatefulWidget> createState() {
    return _SplashPage();
  }
}

class _SplashPage extends State<_Splash> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation animation;

//  Map _source = {ConnectivityResult.mobile: false};
  ConnectivityChecker _connectivity = ConnectivityChecker.instance;

  //Animation<double> _animation;

  bool _visible = false;

  @override
  void dispose() {
    _controller.dispose();
    _connectivity.disposeStream();
    super.dispose();
    //_controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    SPUtil.putBool(Constants.PREVENT_MULTIPLE_DIALOG, false);
    SPUtil.putBool(Constants.IS_SILENT_NOTIFICATION_CALLED_FOR_EVENT, false);
    SPUtil.remove(Constants.SELECTED_FACILITY_ID);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 6000), vsync: this, value: 0.6);
    //_animation = CurvedAnimation(parent: _controller, curve: Curves.easeInToLinear);
    _controller.forward();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      // setState(() {
      //   // _source = source;
      // });
      setState(() {
        _visible = true;
      });
    });
    // _controller =
    //     AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation = Tween(begin: 10.0, end: 20.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is FailureState) {
          state.error == "Version Number invalidate"
              ? getCustomForceUpdatePositiveBtnAlert(context, positive: () {
                  SPUtil.putBool(Constants.PREVENT_MULTIPLE_DIALOG, false);

                  StoreRedirect.redirect(
                      androidAppId: "com.sharjah.ladiesclub",
                      iOSAppId: "1498429469");
                },
                  title: tr('new_update_available'),
                  content: tr('update_avail_content'),
                  positiveBtnName: tr("update"))
              : Utils().customGetSnackBarWithActionButton(
                  tr('error_caps'), state.error, context);
        }
      },
      child: BlocBuilder<SplashBloc, SplashState>(
        builder: (context, state) {
//          if (_source.keys.toList()[0] == ConnectivityResult.none) {
//            BlocProvider.of<SplashBloc>(context).add(NetNotAvailable());
//          } else {
//            BlocProvider.of<SplashBloc>(context).add(NetAvailable());
//          }

          return showLogo();
        },
      ),
    );
  }

  Widget showLogo() {
    _controller.forward();
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(seconds: 5),
      child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            "assets/images/splash_screen.png",
            fit: BoxFit.cover,
          )),
    );
  }
}
