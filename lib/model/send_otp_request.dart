class SendOtpRequest {
  String mobileNumber;
  String email;
  String dialCode;

  SendOtpRequest({this.mobileNumber, this.email, this.dialCode});

  SendOtpRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    dialCode = json['dialCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobileNumber'] = this.mobileNumber;
    data['email'] = this.email;
    data['dialCode'] = this.dialCode;
    return data;
  }
}
