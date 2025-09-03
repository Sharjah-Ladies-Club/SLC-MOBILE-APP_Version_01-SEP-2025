class eventresulttemplate {
  int id;
  int eventId;
  String label;
  String labelArabic;
  int inputType;
  bool isRequired;
  String validationMessage;
  String validationMessageArabic;
  int displayOrder;
  Null encryptedId;
  Null encryptedEmployeeId;
  Null postStatusMessage;
  bool postStatus;
  String value;

  eventresulttemplate(
      {this.id,
      this.eventId,
      this.label,
      this.labelArabic,
      this.inputType,
      this.isRequired,
      this.validationMessage,
      this.validationMessageArabic,
      this.displayOrder,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus,
      this.value});

  eventresulttemplate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['eventId'];
    label = json['label'];
    labelArabic = json['label_Arabic'];
    inputType = json['inputType'];
    isRequired = json['isRequired'];
    validationMessage = json['validationMessage'];
    validationMessageArabic = json['validationMessage_Arabic'];
    displayOrder = json['displayOrder'];
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eventId'] = this.eventId;
    data['label'] = this.label;
    data['label_Arabic'] = this.labelArabic;
    data['inputType'] = this.inputType;
    data['isRequired'] = this.isRequired;
    data['validationMessage'] = this.validationMessage;
    data['validationMessage_Arabic'] = this.validationMessageArabic;
    data['displayOrder'] = this.displayOrder;
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    data['value'] = this.value;
    return data;
  }
}
