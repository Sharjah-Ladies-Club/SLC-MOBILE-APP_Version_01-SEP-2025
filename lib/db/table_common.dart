class CommonTable {
  int id;
  String cid;
  String englishContent;
  String arabicContent;

  CommonTable({this.cid, this.arabicContent, this.englishContent});

  CommonTable.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    englishContent = json['englishContent'];
    arabicContent = json['arabicContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['englishContent'] = this.englishContent;
    data['arabicContent'] = this.arabicContent;
    return data;
  }

  void setId(int id) {
    this.id = id;
  }
}
