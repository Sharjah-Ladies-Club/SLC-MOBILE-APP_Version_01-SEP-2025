class NotificationRequestById {
  int notificationUserId;

  NotificationRequestById({this.notificationUserId});

  NotificationRequestById.fromJson(Map<String, dynamic> json) {
    notificationUserId = json['notificationUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationUserId'] = this.notificationUserId;
    return data;
  }
}
