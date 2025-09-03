class BasicInfoOneRequest {
  String mobileNumber;
  String email;
  int countryId;

  BasicInfoOneRequest({this.mobileNumber, this.email, this.countryId});

  BasicInfoOneRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
    email = json['Email'];
    countryId = json['CountryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MobileNumber'] = this.mobileNumber;
    data['Email'] = this.email;
    data['CountryId'] = this.countryId;
    return data;
  }
}
