import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/network/GMCore.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';

class GeneralRepo {
  Future<Meta> getOnlineCountryList() async {
    GMAPIService gmApiService = GMAPIService();
    Meta metaCountry =
        await gmApiService.processGetURL(URLUtils().getCountryListUrl(), "");
    if (metaCountry.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_COUNTRY, metaCountry);
    }

    return metaCountry;
  }

  Future<Meta> getNationalityList() async {
    Meta metaNationality =
        await Utils().getOfflineData(TableDetails.CID_NATIONALITY);
    if (metaNationality.statusCode != 200) {
      metaNationality = await getOnlineNationalityList();
    } else if (metaNationality.statusCode == 200 &&
        SPUtil.getString(Constants.SaveDate)
                .compareTo(SlcDateUtils().getTodayDateDefaultFormat()) !=
            0) {
      getOnlineNationalityList();
    }
    return metaNationality;
  }

  Future<Meta> getOnlineNationalityList() async {
    GMAPIService gmApiService = GMAPIService();
    Meta metaNationality = await gmApiService.processGetURL(
        URLUtils().getNationalityListUrl(), "");
    if (metaNationality.statusCode == 200) {
      await Utils()
          .saveOfflineData(TableDetails.CID_NATIONALITY, metaNationality);
    }
    return metaNationality;
  }

  Future<Meta> getGenderList() async {
    Meta metaGender = await Utils().getOfflineData(TableDetails.CID_GENDER);
    if (metaGender.statusCode != 200) {
      metaGender = await getOnlineGenderList();
    } else if (metaGender.statusCode == 200 &&
        SPUtil.getString(Constants.SaveDate)
                .compareTo(SlcDateUtils().getTodayDateDefaultFormat()) !=
            0) {
      getOnlineGenderList();
    }
    return metaGender;
  }

  Future<Meta> getOnlineGenderList() async {
    GMAPIService gmApiService = GMAPIService();
    Meta metaGender =
        await gmApiService.processGetURL(URLUtils().getGenderUrl(), "");
    if (metaGender.statusCode == 200) {
      await Utils().saveOfflineData(TableDetails.CID_GENDER, metaGender);
    }
    return metaGender;
  }
}
