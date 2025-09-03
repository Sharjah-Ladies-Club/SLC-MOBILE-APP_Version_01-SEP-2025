import 'event_participant.dart';

class EventParticipantResponse {
  int userId;
  int eventId;
  String name;
  String shortDescription;
  String startDate;
  String endDate;
  String dateRange;
  String startTime;
  String endTime;
  String timeRange;
  String venue;
  bool isAddMe;
  double totalParticipantAmount;
  List<EventParticipant> eventParticipantList;
  List<EventProdCategory> eventProdCategoryList;

  EventParticipantResponse(
      {this.userId,
      this.eventId,
      this.name,
      this.shortDescription,
      this.startDate,
      this.endDate,
      this.dateRange,
      this.startTime,
      this.endTime,
      this.timeRange,
      this.venue,
      this.isAddMe,
      this.totalParticipantAmount,
      this.eventParticipantList,
      this.eventProdCategoryList});

  EventParticipantResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    eventId = json['eventId'];
    name = json['name'];
    shortDescription = json['shortDescription'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    dateRange = json['dateRange'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    timeRange = json['timeRange'];
    isAddMe = json['isAddMe'];
    venue = json['venue'];
    totalParticipantAmount = json['totalParticipantAmount'];
    if (json['eventParticipantList'] != null) {
      eventParticipantList = [];
      json['eventParticipantList'].forEach((v) {
        eventParticipantList.add(new EventParticipant.fromJson(v));
      });
    }
    if (json['eventProdCategoryList'] != null) {
      eventProdCategoryList = [];
      json['eventProdCategoryList'].forEach((v) {
        eventProdCategoryList.add(new EventProdCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['eventId'] = this.eventId;
    data['name'] = this.name;
    data['shortDescription'] = this.shortDescription;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['dateRange'] = this.dateRange;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['timeRange'] = this.timeRange;
    data['venue'] = this.venue;
    data['isAddMe'] = this.isAddMe;
    data['totalParticipantAmount'] = this.totalParticipantAmount;
    if (this.eventParticipantList != null) {
      data['eventParticipantList'] =
          this.eventParticipantList.map((v) => v.toJson()).toList();
    }
    if (this.eventProdCategoryList != null) {
      data['eventProdCategoryList'] =
          this.eventProdCategoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
