import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/model/login_meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/GenderResponse.dart';
import 'package:slc/model/resend_otp_request.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/repo/generic_repo.dart';
import 'package:slc/repo/profile_repository.dart';
import 'package:slc/repo/register_repo.dart';
import 'package:slc/utils/constant.dart';

import './bloc.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileState> {
  ProfileBloc(ProfileState initialState) : super(initialState);

  ProfileState get initialState => InitialProfileState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvents event) async* {
    if (event is ProfileSaveBtnPressed) {
      yield ShowProgressBar();
      Meta m = await ProfileRepo().updateProfileInfo(event.profileDetails);
      if (m.statusCode == 200) {
        SPUtil.putString(
            Constants.USER_FIRSTNAME, event.profileDetails.firstName);
        SPUtil.putString(
            Constants.USER_LASTNAME, event.profileDetails.lastName);
        SPUtil.putString(Constants.USER_DOB, event.profileDetails.dateOfBirth);
        SPUtil.putInt(Constants.USER_GENDERID, event.profileDetails.genderId);
        SPUtil.putInt(
            Constants.USER_NATIONALITYID, event.profileDetails.nationalityId);

        yield HideProgressBar();
        yield OnProfileSuccess();
      } else {
        yield HideProgressBar();
        yield OnProfileFailure(error: m.statusMsg);
      }
    } else if (event is GeneralList) {
      try {
        yield ShowProgressBar();
        yield ShowNewProgressBar();
        List<Meta> generalList = [
          await GeneralRepo().getNationalityList(),
          await GeneralRepo().getGenderList(),
          await ProfileRepo().getProfileDetail()
        ];

        if (generalList[0].statusCode == 200 &&
            generalList[1].statusCode == 200 &&
            generalList[2].statusCode == 200) {
          yield HideProgressBar();

          List<NationalityResponse> nationalityResponse = [];

          jsonEncode(jsonDecode(generalList[0].statusMsg)["response"].forEach(
              (f) => nationalityResponse
                  .add(new NationalityResponse.fromJson(f))));

          List<GenderResponse> genderResponse = [];

          jsonEncode(jsonDecode(generalList[1].statusMsg)["response"].forEach(
              (f) => genderResponse.add(new GenderResponse.fromJson(f))));

          UserProfileInfo userProfileInfo = new UserProfileInfo.fromJson(
              jsonDecode(generalList[2].statusMsg)["response"]);

          yield OnGeneralListSuccess(
              genderList: genderResponse,
              nationalityList: nationalityResponse,
              userProfileInfo: userProfileInfo);
        } else {
          yield HideProgressBar();
          yield FailureState(
              error: generalList[0].statusCode == 200
                  ? generalList[1].statusCode == 200
                      ? generalList[2].statusCode == 200
                          ? ""
                          : generalList[2].statusMsg
                      : generalList[1].statusMsg
                  : generalList[0].statusMsg);
        }
      } catch (error) {
        yield HideProgressBar();
        yield FailureState(error: error);
      }
    } else if (event is ResendOtpPressed) {
      try {
        yield ShowProgressBar();

        ResendOTPRequest req = ResendOTPRequest();
        // req.mobileNumber = event.mobileNumber;
        // req.email = event.email;
        // req.countryId = event.countryId;
        req.userId = event.userId;
        req.otpTypeId = event.otpTypeId;

        LoginMeta m1 = await RegisterRepository().resendOTP(req);

        print('m1---> ${m1.statusMsg}');

        if (m1.statusCode == 200) {
          yield OnSuccessOTPResend(
              response: jsonDecode(m1.statusMsg)["successMessage"]);
        } else {
          yield OnFailureOTPResend(error: m1.statusMsg);
        }

        yield HideProgressBar();
      } catch (err) {
        yield HideProgressBar();

        yield OnFailureOTPResend(error: err);
      }
    } else if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    }
  }
}
