class NotificationBadgeCountResponse {
  int userId;
  bool isShowNotificationBadge;

  NotificationBadgeCountResponse({this.userId, this.isShowNotificationBadge});

  NotificationBadgeCountResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    isShowNotificationBadge = json['isShowNotificationBadge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['isShowNotificationBadge'] = this.isShowNotificationBadge;
    return data;
  }
}
