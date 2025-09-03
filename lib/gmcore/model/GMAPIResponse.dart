class GMAPIResponse {
  String id;
  String result;
  String token;
  String error;

  GMAPIResponse({this.id, this.result, this.token, this.error});

  GMAPIResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    result = json['Y77T3XP2B'];
    token = json['E6DYES1Q2'];
    error = json['SXVI7XCEU'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['Y77T3XP2B'] = this.result;
    data['E6DYES1Q2'] = this.token;
    data['SXVI7XCEU'] = this.error;
    return data;
  }
}
