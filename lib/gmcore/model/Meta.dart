class Meta {
  int statusCode;
  String statusMsg;

  Meta({this.statusCode, this.statusMsg});

  Meta.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMsg = json['statusMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['statusMsg'] = this.statusMsg;
    return data;
  }
}

class CheckDistance {
  bool allow;
  double distance;
}
