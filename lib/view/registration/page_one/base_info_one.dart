import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_footer/loginreg_footer.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_submitbtn/loginreg_submitbtn.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginregappbar/login_reg_appbar.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/imgutils.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/otp/otp_verification.dart';
import 'package:slc/view/registration/page_one/basic_info_one_pagerender.dart';
import 'package:slc/view/registration/page_one/bloc/bloc.dart';
import 'package:string_validator/string_validator.dart';

class BaseInfoOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await customAlertDialog(
              context,
              tr("discard_message"),
              tr("yes"),
              tr("no"),
              tr("otp"),
              tr("confirm"),
              () => {
                    Navigator.of(context).pop(),
                  })) ??
          false;
    }

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: BlocProvider(
        create: (context) {
          return BaseInfoOneBloc(null);
        },
        child: PageOne(),
      ),
    );
  }
}

class PageOne extends StatefulWidget {
  PageOne();

  @override
  _PageOnes createState() => _PageOnes();
}

class _PageOnes extends State<PageOne> {
  ProgressBarHandler _handler;
  Utils util = Utils();
  TextEditingController _mobilenoController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  int _selectedCountryId = 115;

  String _dialcode = "+971";

//  MaskedTextController _emailController =
//      new MaskedTextController(mask: Strings.maskEngEmailValidationStr);
  String countryCodeForMobile = "+971";

  RegExp regExp = new RegExp(
    Constants.UAE_MOBILE_PATTERN,
    caseSensitive: false,
    multiLine: false,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );
    return BlocListener<BaseInfoOneBloc, BaseInfoOneState>(
      listener: (BuildContext context, state) {
        if (state is OnSuccess) {
          if (state.userId != null) {
            _selectedCountryId == Constants.UAECountryId
                ? util.customGetSnackBarWithOutActionButton(
                    tr('success_caps'), tr('uae_otp'), context)
                : util.customGetSnackBarWithOutActionButton(
                    tr('success_caps'), tr('non_uae_otp'), context);
            Get.to(() => OtpVerification(_mobilenoController.text, state.userId,
                _dialcode, _emailController.text));
            // Get.to(BaseInfoTwo(""));
          }
        } else if (state is OnFailure) {
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        } else if (state is ShowProgressBar) {
          _handler.show();
        } else if (state is HideProgressBar) {
          _handler.dismiss();
        } else if (state is LanguageSwitched) {}
      },
      bloc: BlocProvider.of<BaseInfoOneBloc>(context),
      child: BlocBuilder<BaseInfoOneBloc, BaseInfoOneState>(
        builder: (BuildContext context, state) {
          return Stack(children: <Widget>[mainUI(), progressBar]);
        },
      ),
    );
  }

  Widget mainUI() {
    return GestureDetector(
      child: Scaffold(
        appBar: PreferredSize(
          child: Column(
            children: <Widget>[
              LoginRegAppBar(
                pageTitle: "BaseInfoOne",
                headerTitle: tr('welcome'),
                subTitle: Constants.isChangePassword == true
                    ? tr('changePasswordToCon')
                    : tr('registerToContinue'),
                assetImagePath: 'assets/images/Register_1.png',
                onLanguageChange: (val) {
                  BlocProvider.of<BaseInfoOneBloc>(context).add(
                    OnLanguagechangeInReg(context: context),
                  );
                },
              ),
            ],
          ),
          preferredSize: Size.fromHeight(210.0),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: constraints.copyWith(
                  minHeight: constraints.maxHeight,
                  maxHeight: double.infinity,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      LoginPageImage("register"),
                      PackageListHead.customTextView(context, 1.0,
                          tr('register_otp'), false, FontWeight.w500),
                      PackageListHead.customTextView(
                          context,
                          1.0,
                          ((_selectedCountryId == Constants.UAECountryId)
                                  ? tr('otp') + Strings.txtMTSpace
                                  : tr('emailLabelSmalLeter') +
                                      Strings.txtMTSpace) +
                              tr('verify_later'),
                          false,
                          FontWeight.w500),
                      BaseInfoOnePageRender(
                          mobilenoController: _mobilenoController,
                          emailController: _emailController,
                          onCountryCodeCallBack: (countryId, dialcode) {
                            // loginBtnPres(countryId);
                            setState(() {
                              _selectedCountryId = countryId;
                              _dialcode = dialcode;
                            });
                          }),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: LoginRegSubmitButton("continue", () {
                            if (_validateRegister()) {
                              _continueBtnPres();
                            }
                          }),
                        ),
                      ),
                      LoginRegFooter('reg', "BasicInfoOne"),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }

  _validateRegister() {
    if (_mobilenoController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('mobileNoErrorMessage'), context);
      return false;
    } else if (_mobilenoController.text.length !=
            Constants.UAEMobileNumberLength &&
        _selectedCountryId == Constants.UAECountryId) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('invalidMobileNumber'), context);
      return false;
    } else if ((_mobilenoController.text.length <
                Constants.OtherMinMobileNumberLength ||
            _mobilenoController.text.length >
                Constants.OtherMaxMobileNumberLength) &&
        _selectedCountryId != Constants.UAECountryId) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('invalidMobileNumber'), context);
      return false;
    } else if (_selectedCountryId == Constants.UAECountryId &&
        !regExp.hasMatch(_mobilenoController.text)) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('invalidMobileNumber'), context);
      return false;
    } else if (_emailController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('emailErrorMessage'), context);
      return false;
    } else if (!isEmail(_emailController.text)) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('invalidEmailError'), context);
      return false;
    }

    return true;
  }

  _continueBtnPres() {
    SPUtil.putString(Constants.REG_USER_EMAIL, _emailController.text);
    SPUtil.putString(Constants.REG_USER_MOBILE, _mobilenoController.text);
    BlocProvider.of<BaseInfoOneBloc>(context).add(
      PageOneContinueButtonPressed(
          mobileNumber: _mobilenoController.text,
          email: _emailController.text.toLowerCase(),
          countryId: _selectedCountryId,
          countrycode: "$_dialcode",
          pagePath:
              Constants.isChangePassword ? "changePassFlow" : "registerFlow"),
    );
  }
}
