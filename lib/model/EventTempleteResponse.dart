class EventTempleteResponse {
  int displayOrder;
  String encryptedEmployeeId;
  String encryptedId;
  int eventId;
  int id;
  int inputType;
  bool isRequired;
  String label;
  String label_Arabic;
  bool postStatus;
  String postStatusMessage;
  String validationMessage;
  String validationMessage_Arabic;
  String Value;
  EventTempleteResponse(
      {this.displayOrder,
      this.encryptedEmployeeId,
      this.encryptedId,
      this.eventId,
      this.id,
      this.inputType,
      this.isRequired,
      this.label,
      this.label_Arabic,
      this.postStatus,
      this.postStatusMessage,
      this.validationMessage,
      this.validationMessage_Arabic,
      this.Value});

  factory EventTempleteResponse.fromJson(Map<String, dynamic> json) {
    return EventTempleteResponse(
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
      postStatus: json['postStatus'],
      postStatusMessage:
          json['postStatusMessage'] != null ? json['postStatusMessage'] : null,
      validationMessage: json['validationMessage'],
      validationMessage_Arabic: json['validationMessage_Arabic'],
      Value: json['Value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayOrder'] = this.displayOrder;
    data['eventId'] = this.eventId;
    data['id'] = this.id;
    data['inputType'] = this.inputType;
    data['isRequired'] = this.isRequired;
    data['label'] = this.label;
    data['label_Arabic'] = this.label_Arabic;
    data['postStatus'] = this.postStatus;
    data['validationMessage'] = this.validationMessage;
    data['validationMessage_Arabic'] = this.validationMessage_Arabic;
    if (this.encryptedEmployeeId != null) {
      data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    }
    if (this.encryptedId != null) {
      data['encryptedId'] = this.encryptedId;
    }
    if (this.postStatusMessage != null) {
      data['postStatusMessage'] = this.postStatusMessage;
    }
    if (this.Value != null) {
      data['Value'] = this.Value;
    }
    return data;
  }
}
