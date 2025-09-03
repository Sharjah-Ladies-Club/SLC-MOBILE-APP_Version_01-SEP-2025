class OrderStatus {
  int orderId;
  String orderNo;
  String merchantRefernceNo;
  int orderStatusId;
  String orderStatus;
  String colorCode;
  int facilityId;

  OrderStatus(
      {this.orderId,
      this.orderNo,
      this.merchantRefernceNo,
      this.orderStatusId,
      this.orderStatus,
      this.colorCode,
      this.facilityId});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderNo = json['orderNo'];
    merchantRefernceNo = json['merchantRefernceNo'];
    orderStatusId = json['orderStatusId'];
    orderStatus = json['orderStatus'];
    colorCode = json['colorCode'];
    facilityId = json['facilityId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderNo'] = this.orderNo;
    data['merchantRefernceNo'] = this.merchantRefernceNo;
    data['orderStatusId'] = this.orderStatusId;
    data['orderStatus'] = this.orderStatus;
    data['colorCode'] = this.colorCode;
    data['facilityId'] = this.facilityId;
    return data;
  }
}
