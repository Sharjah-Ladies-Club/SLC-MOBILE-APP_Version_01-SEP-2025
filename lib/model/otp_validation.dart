class OtpValidation {
  int userId;
  String otp;
  bool isCorporate;

  OtpValidation({this.userId, this.otp, this.isCorporate = false});

  OtpValidation.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    otp = json['otp'];
    isCorporate = json['isCorporate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['otp'] = this.otp;
    data['isCorporate'] = isCorporate;
    return data;
  }
}
