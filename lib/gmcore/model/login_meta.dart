class LoginMeta {
  int statusCode;
  String statusMsg;
  String level2token;

  LoginMeta({this.statusCode, this.statusMsg});

  LoginMeta.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMsg = json['statusMsg'];
    statusMsg = json['level2token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['statusMsg'] = this.statusMsg;
    data['level2token'] = this.level2token;
    return data;
  }
}
