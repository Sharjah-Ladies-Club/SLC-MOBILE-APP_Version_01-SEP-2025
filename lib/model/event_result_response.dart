class EventResultResponse {
  int id;
  int eventId;
  String label;
  String label_Arabic;
  int inputType;
  bool isRequired;
  String validationMessage;
  String validationMessage_Arabic;
  int displayOrder;

  EventResultResponse(
      {this.id,
      this.eventId,
      this.label,
      this.label_Arabic,
      this.inputType,
      this.isRequired,
      this.validationMessage,
      this.validationMessage_Arabic,
      this.displayOrder});

  EventResultResponse.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    eventId = json['EventId'];
    label = json['Label'];
    label_Arabic = json['Label_Arabic'];
    inputType = json['InputType'];
    isRequired = json['IsRequired'];
    validationMessage = json['ValidationMessage'];
    validationMessage_Arabic = json['ValidationMessage_Arabic'];
    displayOrder = json['DisplayOrder'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['EventId'] = this.eventId;
    data['Label'] = this.label;
    data['Label_Arabic'] = this.label_Arabic;
    data['InputType'] = this.inputType;
    data['IsRequired'] = this.isRequired;
    data['ValidationMessage'] = this.validationMessage;
    data['ValidationMessage_Arabic'] = this.validationMessage_Arabic;
    data['DisplayOrder'] = this.displayOrder;
    return data;
  }
}
