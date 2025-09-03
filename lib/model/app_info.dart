class AppInfo {
  int appVersionNum;
  String vectorKey;
  String secretKey;
  int eventRegistrationCount;
  String appKey;
  double netSpeed;

  AppInfo(
      {this.appVersionNum,
        this.vectorKey,
        this.secretKey,
        this.eventRegistrationCount,
        this.appKey,
        this.netSpeed});

  AppInfo.fromJson(Map<String, dynamic> json) {
    appVersionNum = json['appVersionNum'];
    vectorKey = json['vectorKey'];
    secretKey = json['secretKey'];
    eventRegistrationCount = json['eventRegistrationCount'];
    appKey = json['appKey'];
    netSpeed = json['netSpeed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appVersionNum'] = this.appVersionNum;
    data['vectorKey'] = this.vectorKey;
    data['secretKey'] = this.secretKey;
    data['eventRegistrationCount'] = this.eventRegistrationCount;
    data['appKey'] = this.appKey;
    data['netSpeed'] = this.netSpeed;
    return data;
  }
}