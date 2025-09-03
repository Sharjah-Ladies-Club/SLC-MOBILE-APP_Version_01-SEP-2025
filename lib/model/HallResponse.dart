class HallResponse {
  int hallId;
  String hallName;

  HallResponse({this.hallId, this.hallName});

  HallResponse.fromJson(Map<String, dynamic> json) {
    hallId = json['hallId'];
    hallName = json['genderName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hallId'] = this.hallId;
    data['genderName'] = this.hallName;
    return data;
  }
}

class CateringTypeResponse {
  int cateringTypeId;
  String cateringTypeName;

  CateringTypeResponse({this.cateringTypeId, this.cateringTypeName});

  CateringTypeResponse.fromJson(Map<String, dynamic> json) {
    cateringTypeId = json['cateringTypeId'];
    cateringTypeName = json['cateringTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cateringTypeId'] = this.cateringTypeId;
    data['cateringTypeName'] = this.cateringTypeName;
    return data;
  }
}
