class Validate {
  String clientKey;
  String clientType;

  Validate({this.clientKey, this.clientType});

  Validate.fromJson(Map<String, dynamic> json) {
    clientKey = json['clientKey'];
    clientType = json['clientType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientKey'] = this.clientKey;
    data['clientType'] = this.clientType;
    return data;
  }
}
