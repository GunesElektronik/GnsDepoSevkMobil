class OrderDetailScannedItemDB {
  int? recid;
  String? ficheNo;
  String? orderItemId;
  String? productBarcode;
  String? warehouse;
  String? stockLocationId;
  String? stockLocationName;
  int? numberOfPieces;

  OrderDetailScannedItemDB({
    this.recid,
    this.ficheNo,
    this.orderItemId,
    this.productBarcode,
    this.warehouse,
    this.stockLocationId,
    this.stockLocationName,
    this.numberOfPieces,
  });

  OrderDetailScannedItemDB.fromJson(Map<String, dynamic> json) {
    recid = json['recid'];
    ficheNo = json['ficheNo'];
    orderItemId = json['orderItemId'];
    productBarcode = json['productBarcode'];
    warehouse = json['warehouse'];
    stockLocationId = json['stockLocationId'];
    stockLocationName = json['stockLocationName'];
    numberOfPieces = json['numberOfPieces'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recid'] = this.recid;
    data['ficheNo'] = this.ficheNo;
    data['orderItemId'] = this.orderItemId;
    data['productBarcode'] = this.productBarcode;
    data['warehouse'] = this.warehouse;
    data['stockLocationId'] = this.stockLocationId;
    data['stockLocationName'] = this.stockLocationName;
    data['numberOfPieces'] = this.numberOfPieces;

    return data;
  }
}
