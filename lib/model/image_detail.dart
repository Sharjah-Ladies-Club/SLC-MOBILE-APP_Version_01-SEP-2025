class ImageDetails {
  String imageName;
  String imageUrl;
  int recordId;
  int fileCategoryId;
  int displayOrder;
  bool isDefault;
  bool isActive;
  int documentTypeId;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;

  ImageDetails(
      {this.imageName,
      this.imageUrl,
      this.recordId,
      this.fileCategoryId,
      this.displayOrder,
      this.isDefault,
      this.isActive,
      this.documentTypeId,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus});

  ImageDetails.fromJson(Map<String, dynamic> json) {
    imageName = json['imageName'];
    imageUrl = json['imageUrl'];
    recordId = json['recordId'];
    fileCategoryId = json['fileCategoryId'];
    displayOrder = json['displayOrder'];
    isDefault = json['isDefault'];
    isActive = json['isActive'];
    documentTypeId = json['documentTypeId'];
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageName'] = this.imageName;
    data['imageUrl'] = this.imageUrl;
    data['recordId'] = this.recordId;
    data['fileCategoryId'] = this.fileCategoryId;
    data['displayOrder'] = this.displayOrder;
    data['isDefault'] = this.isDefault;
    data['isActive'] = this.isActive;
    data['documentTypeId'] = this.documentTypeId;
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    return data;
  }
}
