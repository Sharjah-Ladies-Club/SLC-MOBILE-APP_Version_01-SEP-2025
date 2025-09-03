class Country {
  int statusCode;
  String statusMsg;

  Country({this.statusCode, this.statusMsg});

  Country.fromJson(Map<String, dynamic> json) {
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

class CountryRes {
  List<dynamic> response;
  String successMessage;

  CountryRes({this.response, this.successMessage});

  CountryRes.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    successMessage = json['successMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['successMessage'] = this.successMessage;
    return data;
  }
}
