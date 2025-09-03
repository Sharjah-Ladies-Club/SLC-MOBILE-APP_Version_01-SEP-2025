import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/network/GMCore.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/survey_facility_question_request.dart';
import 'package:slc/model/survey_save_request.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/url_utils.dart';

class SurveyRepository {
  Future<Meta> getSurveyFacilityList() async {
    GMAPIService gmapiService = GMAPIService();

    return await gmapiService.processGetURL(
        URLUtils().getSurveyFacilityListUrl(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
  }

  Future<Meta> getSurveyQuestion(SurveyFacilityQuestionRequest request) async {
    GMAPIService gmapiService = GMAPIService();

    return await gmapiService.processPostURL(
        URLUtils().getSurveyQuestionListUrl(),
        request.toJson(),
        SPUtil.getString(Constants.KEY_TOKEN_1));
  }

  Future<Meta> saveSurvey(SurveySaveRequest request) async {
    GMAPIService gmapiService = GMAPIService();

    return await gmapiService.processPostURL(URLUtils().saveSurveyUrl(),
        request.toJson(), SPUtil.getString(Constants.KEY_TOKEN_1));
  }
}
