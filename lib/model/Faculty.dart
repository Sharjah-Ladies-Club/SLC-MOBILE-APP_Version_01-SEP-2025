class Faculty {
  int facilityItemId;
  int facilityId;
  int facultyId;
  String facultyName;

  Faculty({
    this.facilityItemId,
    this.facilityId,
    this.facultyId,
    this.facultyName,
  });

  Faculty.fromJson(Map<String, dynamic> json) {
    facilityItemId = json['facilityItemId'];
    facilityId = json['facilityId'];
    facultyId = json['facultyId'];
    facultyName = json['facultyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityItemId'] = this.facilityItemId;
    data['facilityId'] = this.facilityId;
    data['facultyId'] = this.facultyId;
    data['facultyName'] = this.facultyName;
    return data;
  }
}
