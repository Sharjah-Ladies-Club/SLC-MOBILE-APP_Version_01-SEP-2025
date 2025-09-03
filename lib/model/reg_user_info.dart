class UserInfo {
  int userId;
  String firstName;
  String lastName;
  int genderId;
  String dateOfBirth;
  int nationalityId;
  bool isDoNotDisturb;
  bool isDoNotDisturbAr;
  String password;
  int marketingSourceId;
  String referredByMobileNumber;

  UserInfo(
      {this.userId,
      this.firstName,
      this.lastName,
      this.genderId,
      this.dateOfBirth,
      this.nationalityId,
      this.isDoNotDisturb,
      this.isDoNotDisturbAr,
      this.password,
      this.marketingSourceId,
      this.referredByMobileNumber});

  UserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    genderId = json['GenderId'];
    dateOfBirth = json['DateOfBirth'];
    nationalityId = json['NationalityId'];
    isDoNotDisturb = json['IsDoNotDisturb'];
    isDoNotDisturbAr = json['IsDoNotDisturbAr'];
    password = json['Password'];
    marketingSourceId = json['MarketingSourceId'];
    referredByMobileNumber = json['ReferredByMobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['GenderId'] = this.genderId;
    data['DateOfBirth'] = this.dateOfBirth;
    data['NationalityId'] = this.nationalityId;
    data['IsDoNotDisturb'] = this.isDoNotDisturb;
    data['IsDoNotDisturbAr'] = this.isDoNotDisturbAr;
    data['Password'] = this.password;
    data['MarketingSourceId'] = this.marketingSourceId;
    data['ReferredByMobileNumber'] = this.referredByMobileNumber;
    return data;
  }
}
