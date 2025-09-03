class ResendOTPRequest {
  int userId;
  int otpTypeId;

  ResendOTPRequest({this.userId, this.otpTypeId});

  ResendOTPRequest.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    otpTypeId = json['otpTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['otpTypeId'] = this.otpTypeId;
    return data;
  }
}
