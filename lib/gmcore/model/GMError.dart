class GMError {
  String message;
  String errorCode;

  GMError({this.message, this.errorCode});

  GMError.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errorCode = json['errorcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['message'] = this.message;
    data['errorcode'] = this.errorCode;
    return data;
  }
}
