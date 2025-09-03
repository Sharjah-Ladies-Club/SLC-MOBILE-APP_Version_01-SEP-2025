class Recommendation {
  String obb_ReceiptDate;
  String spa_ReceiptDate;
  String obb_Name;
  String spa_Name;
  String obb_EmailID;
  String spa_EmailID;
  String hairAssessment;
  String hairTreatment;
  String hairAdvice;
  String combinedHairRecommendation;
  String followUpTreatment;
  String nextVisit;
  String dailyUse;
  String weeklyUse;
  String specialAdvice;
  String therapistAdvice;
  String therapistDiagnosis;
  String therapistName;
  int userInfoId;
  int recommendationID;

  Recommendation({
    this.obb_ReceiptDate,
    this.spa_ReceiptDate,
    this.obb_Name,
    this.spa_Name,
    this.obb_EmailID,
    this.spa_EmailID,
    this.hairAssessment,
    this.hairTreatment,
    this.hairAdvice,
    this.combinedHairRecommendation,
    this.followUpTreatment,
    this.nextVisit,
    this.dailyUse,
    this.weeklyUse,
    this.specialAdvice,
    this.therapistAdvice,
    this.therapistDiagnosis,
    this.therapistName,
    this.userInfoId,
    this.recommendationID,
  });
  Recommendation.fromJson(Map<String, dynamic> json) {
    this.obb_ReceiptDate = json['obb_ReceiptDate'];
    this.spa_ReceiptDate = json['spa_ReceiptDate'];
    this.obb_Name = json['obb_Name'];
    this.spa_Name = json['spa_Name'];
    this.obb_EmailID = json['obb_EmailID'];
    this.spa_EmailID = json['spa_EmailID'];
    this.hairAssessment = json['hairAssessment'];
    this.hairTreatment = json['hairTreatment'];
    this.hairAdvice = json['hairAdvice'];
    this.combinedHairRecommendation = json['combinedHairRecommendation'];
    this.followUpTreatment = json['followUpTreatment'];
    this.nextVisit = json['nextVisit'];
    this.dailyUse = json['dailyUse'];
    this.weeklyUse = json['weeklyUse'];
    this.specialAdvice = json['specialAdvice'];
    this.therapistAdvice = json['therapistAdvice'];
    this.therapistDiagnosis = json['therapistDiagnosis'];
    this.therapistName = json['therapistName'];
    this.userInfoId = json['userInfoId'];
    this.recommendationID = json['recommendationID'];
  }
}

class FurtherRecommendation {
  int id;
  String date;
  String recommendation;
  String dailyUse;
  String weeklyUse;
  String specialAdvice;
  String dailyFacialSkinCare;
  String weeklyFacialSkinCare;
  String bodyCare;
  String therapistName;
  String nextVisit;
  FurtherRecommendation(
      {this.id,
      this.date,
      this.recommendation,
      this.dailyUse,
      this.weeklyUse,
      this.specialAdvice,
      this.dailyFacialSkinCare,
      this.weeklyFacialSkinCare,
      this.bodyCare,
      this.therapistName,
      this.nextVisit});
  FurtherRecommendation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    recommendation = json['recommendation'];
    dailyUse = json['dailyUse'];
    weeklyUse = json['weeklyUse'];
    specialAdvice = json['specialAdvice'];
    dailyFacialSkinCare = json['dailyFacialSkinCare'];
    weeklyFacialSkinCare = json['weeklyFacialSkinCare'];
    bodyCare = json['bodyCare'];
    therapistName = json['therapistName'];
    nextVisit = json['nextVisit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['recommendation'] = this.recommendation;
    data['dailyUse'] = this.dailyUse;
    data['weeklyUse'] = this.weeklyUse;
    data['specialAdvice'] = this.specialAdvice;
    data['dailyFacialSkinCare'] = this.dailyFacialSkinCare;
    data['weeklyFacialSkinCare'] = this.weeklyFacialSkinCare;
    data['bodyCare'] = this.bodyCare;
    data['therapistName'] = this.therapistName;
    data['nextVisit'] = this.nextVisit;
    return data;
  }
}

class DownloadData {
  String dtoken;
  String durl;

  DownloadData({this.dtoken, this.durl});

  DownloadData.fromJson(Map<String, dynamic> json) {
    dtoken = json['dtoken'];
    durl = json['durl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dtoken'] = this.dtoken;
    data['durl'] = this.durl;
    return data;
  }
}
