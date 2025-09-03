class ChatBotLaunchRequest {
  int userId;
  int userType;
  String token;

  ChatBotLaunchRequest({this.userId, this.userType, this.token});

  ChatBotLaunchRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userType = json['user_type'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['user_type'] = this.userType;
    data['token'] = this.token;
    return data;
  }
}
