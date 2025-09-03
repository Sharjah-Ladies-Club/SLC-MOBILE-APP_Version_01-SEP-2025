class EventParticipantTemplateResultResponse {
  EventParticipantTemplate template;
  EventParticipantResult value;

  EventParticipantTemplateResultResponse({
    this.template,
    this.value,
  });

  factory EventParticipantTemplateResultResponse.fromJson(
      Map<String, dynamic> json) {
    return EventParticipantTemplateResultResponse(
      template: new EventParticipantTemplate.fromJson(json['template']),
      value: new EventParticipantResult.fromJson(json['value']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['template'] = this.template;
    data['value'] = this.value;
    return data;
  }
}

class EventParticipantTemplate {
  int displayOrder;
  String encryptedEmployeeId;
  String encryptedId;
  int eventId;
  int id;
  int inputType;
  bool isRequired;
  String label;
  String label_Arabic;
  String validationMessage;
  String validationMessageArabic;

  Null postStatusMessage;
  bool postStatus;
  EventParticipantTemplate({
    this.displayOrder,
    this.encryptedEmployeeId,
    this.encryptedId,
    this.eventId,
    this.id,
    this.inputType,
    this.isRequired,
    this.label,
    this.label_Arabic,
    this.validationMessage,
    this.validationMessageArabic,
    this.postStatusMessage,
    this.postStatus,
  });

  factory EventParticipantTemplate.fromJson(Map<String, dynamic> json) {
    return EventParticipantTemplate(
      displayOrder: json['displayOrder'],
      encryptedEmployeeId: json['encryptedEmployeeId'] != null
          ? json['encryptedEmployeeId']
          : null,
      encryptedId: json['encryptedId'] != null ? json['encryptedId'] : null,
      eventId: json['eventId'],
      id: json['id'],
      inputType: json['inputType'],
      isRequired: json['isRequired'],
      label: json['label'],
      label_Arabic: json['label_Arabic'],
      postStatusMessage: json['postStatusMessage'],
      postStatus: json['postStatus'],
      validationMessage: json['validationMessage'],
      validationMessageArabic: json['validationMessageArabic'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayOrder'] = this.displayOrder;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['encryptedId'] = this.encryptedId;
    data['eventId'] = this.eventId;
    data['id'] = this.id;
    data['inputType'] = this.inputType;
    data['isRequired'] = this.isRequired;
    data['label'] = this.label;
    data['label_Arabic'] = this.label_Arabic;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    data['validationMessageArabic'] = this.validationMessageArabic;
    data['validationMessage'] = this.validationMessage;
    return data;
  }
}

class EventParticipantResult {
  int id;
  String value;
  int createdBy;
  EventParticipantResult({this.id, this.value, this.createdBy});

  factory EventParticipantResult.fromJson(Map<String, dynamic> json) {
    return EventParticipantResult(
      id: json['id'],
      value: json['value'],
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['createdBy'] = this.createdBy;
    return data;
  }
}
