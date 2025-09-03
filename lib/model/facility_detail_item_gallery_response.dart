import 'image_detail.dart';

class FacilityGalleryDetail {
  int facilityId;
  String facilityGalleryTypeName;
  String facilityGalleryTypeNameArabic;
  int facilityGalleryTypeId;
  List<ImageDetails> imageList;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;

  FacilityGalleryDetail(
      {this.facilityId,
      this.facilityGalleryTypeName,
      this.facilityGalleryTypeNameArabic,
      this.facilityGalleryTypeId,
      this.imageList,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus});

  FacilityGalleryDetail.fromJson(Map<String, dynamic> json) {
    facilityId = json['facilityId'];
    facilityGalleryTypeName = json['facilityGalleryTypeName'];
    facilityGalleryTypeNameArabic = json['facilityGalleryTypeNameArabic'];
    facilityGalleryTypeId = json['facilityGalleryTypeId'];
    if (json['imageList'] != null) {
      imageList = [];
      json['imageList'].forEach((v) {
        imageList.add(new ImageDetails.fromJson(v));
      });
    }
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityId'] = this.facilityId;
    data['facilityGalleryTypeName'] = this.facilityGalleryTypeName;
    data['facilityGalleryTypeNameArabic'] = this.facilityGalleryTypeNameArabic;
    data['facilityGalleryTypeId'] = this.facilityGalleryTypeId;
    if (this.imageList != null) {
      data['imageList'] = this.imageList.map((v) => v.toJson()).toList();
    }
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    return data;
  }
}
