class ChangePasswordRequest {
  int userId;
  String password;

  ChangePasswordRequest({this.userId, this.password});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['password'] = this.password;
    return data;
  }
}
