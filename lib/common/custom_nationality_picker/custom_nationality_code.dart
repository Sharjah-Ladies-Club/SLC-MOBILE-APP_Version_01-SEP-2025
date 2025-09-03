mixin ToAlias {}

@deprecated
class CElement = NationalityResponse with ToAlias;

/// nationality element. This is the element that contains all the information
class NationalityResponse {
  /// the nationality code (IT,AF..)
//  String code;
  int nationalityId;

//  String dialCode;

  /// the name of the nationality
//  String name;
  String nationalityName;

  /// the flag of the nationality
//  String flagUri;

  /// the dial code (+39,+93..)
  // String dialCode;

  bool isActive;

//  nationalityCode({this.name, this.flagUri, this.code, this.dialCode});
  NationalityResponse(
      {this.nationalityId, this.nationalityName, this.isActive});

  NationalityResponse.fromJson(Map<String, dynamic> json) {
    nationalityId = json['nationalityId'];
    nationalityName = json['nationalityName'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nationalityId'] = this.nationalityId;
    data['nationalityName'] = this.nationalityName;
    data['isActive'] = this.isActive;
    return data;
  }

  @override
  String toString() => "$nationalityId";

  String toLongString() =>
      // "$dialCode" +
      "$nationalityId"
      "$nationalityName";

  String toNationalityStringOnly() => '$nationalityName';

/*  String toString() => "$dialCode";
  String toLongString() => "$dialCode $name";
  String tonationalityStringOnly() => '$name';  */
}
