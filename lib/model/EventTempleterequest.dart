class EventTempleteRequest {
  int eventParticipantId;
  int userId;
  List<EventTemplateDetails> EventParticipantResults;
  EventTempleteRequest(
      {this.eventParticipantId, this.userId, this.EventParticipantResults});

  factory EventTempleteRequest.fromJson(Map<String, dynamic> json) {
    return EventTempleteRequest(
      eventParticipantId: json['eventParticipantId'],
      userId: json['userId'],
      EventParticipantResults: json['EventParticipantResults'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventParticipantId'] = this.eventParticipantId;
    data['userId'] = this.userId;
    data['EventParticipantResults'] = this.EventParticipantResults;
    return data;
  }
}

class EventTemplateDetails {
  int id;
  String value;
  EventTemplateDetails({this.id, this.value});

  factory EventTemplateDetails.fromJson(Map<String, dynamic> json) {
    return EventTemplateDetails(
      id: json['id'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    return data;
  }
}
