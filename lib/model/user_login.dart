class UserLogin {
  String userName;
  String password;

  // bool isRequestFromWeb;
  int countryId;
  int applicationId;
  String fcmToken;

  UserLogin(
      {this.userName,
      this.password,
      // this.isRequestFromWeb
      this.countryId,
      this.applicationId,
      this.fcmToken});

  UserLogin.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'];
    password = json['Password'];
    //isRequestFromWeb = json['IsRequestFromWeb'];
    applicationId = json['ApplicationId'];
    countryId = json['CountryId'];
    fcmToken = json['PushTokenKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Username'] = this.userName;
    data['Password'] = this.password;
    //data['IsRequestFromWeb'] = this.isRequestFromWeb;
    data['CountryId'] = this.countryId;
    data['ApplicationId'] = this.applicationId;
    data['PushTokenKey'] = this.fcmToken;

    return data;
  }
}
