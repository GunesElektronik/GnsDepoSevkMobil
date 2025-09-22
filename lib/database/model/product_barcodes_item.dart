class ProductBarcodesItemLocal {
  int? recid;
  String? orderId;
  String? productId;
  String? barcode;
  String? code;
  int? convParam1;
  int? convParam2;

  ProductBarcodesItemLocal({
    this.recid,
    this.orderId,
    this.productId,
    this.barcode,
    this.code,
    this.convParam1,
    this.convParam2,
  });

  ProductBarcodesItemLocal.fromJson(Map<String, dynamic> json) {
    recid = json['recid'];
    orderId = json['orderId'];
    productId = json['productId'];
    barcode = json['barcode'];
    code = json['code'];
    convParam1 = json['convParam1'];
    convParam2 = json['convParam2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recid'] = this.recid;
    data['orderId'] = this.orderId;
    data['productId'] = this.productId;
    data['barcode'] = this.barcode;
    data['code'] = this.code;
    data['convParam1'] = this.convParam1;
    data['convParam2'] = this.convParam2;
    return data;
  }
}
