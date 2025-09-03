

class BaseResponse {
  dynamic response;
  String successMessage;

  BaseResponse({this.response, this.successMessage});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    successMessage = json['successMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
      data['successMessage'] = this.successMessage;
    }
    return data;
  }
}
