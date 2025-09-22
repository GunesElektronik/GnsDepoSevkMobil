class WaybillScannedItemDB {
  int? recid;
  String? waybillsId;
  String? productId;
  String? productBarcode;
  String? warehouse;
  String? stockLocationId;
  String? stockLocationName;
  int? numberOfPieces;

  WaybillScannedItemDB({
    this.recid,
    this.waybillsId,
    this.productId,
    this.productBarcode,
    this.warehouse,
    this.stockLocationId,
    this.stockLocationName,
    this.numberOfPieces,
  });

  WaybillScannedItemDB.fromJson(Map<String, dynamic> json) {
    recid = json['recid'];
    waybillsId = json['waybillsId'];
    productId = json['productId'];
    productBarcode = json['productBarcode'];
    warehouse = json['warehouse'];
    numberOfPieces = json['numberOfPieces'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recid'] = this.recid;
    data['waybillsId'] = this.waybillsId;
    data['productId'] = this.productId;
    data['productBarcode'] = this.productBarcode;
    data['warehouse'] = this.warehouse;
    data['numberOfPieces'] = this.numberOfPieces;

    return data;
  }
}
