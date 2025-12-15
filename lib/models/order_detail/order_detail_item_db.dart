class OrderDetailItemDB {
  String? orderId;
  String? orderItemId;
  String? productId;
  String? warehouseId;
  String? stockLocationId;
  String? stockLocationName;
  String? ficheNo;
  String? productName;
  String? productBarcode;
  String? warehouse;
  bool? isProductLocatin;
  bool? isExceededStockCount;
  int? serilotType;
  int? scannedQty;
  int? qty;
  int? shippedQty;
  int? lineNr;

  OrderDetailItemDB({
    this.orderId,
    this.orderItemId,
    this.productId,
    this.warehouseId,
    this.stockLocationId,
    this.stockLocationName,
    this.ficheNo,
    this.productName,
    this.productBarcode,
    this.warehouse,
    this.isProductLocatin,
    this.isExceededStockCount,
    this.serilotType,
    this.scannedQty,
    this.qty,
    this.shippedQty,
    this.lineNr,
  });

  OrderDetailItemDB.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderItemId = json['orderItemId'];
    productId = json['productId'];
    warehouseId = json['warehouseId'];
    stockLocationId = json['stockLocationId'];
    stockLocationName = json['stockLocationName'];
    ficheNo = json['ficheNo'];
    productName = json['productName'];
    productBarcode = json['productBarcode'];
    warehouse = json['warehouse'];
    isProductLocatin = json['isProductLocatin'];
    isExceededStockCount = json['isExceededStockCount'];
    serilotType = json['serilotType'];
    scannedQty = json['scannedQty'];
    qty = json['qty'];
    shippedQty = json['shippedQty'];
    lineNr = json['lineNr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderItemId'] = this.orderItemId;
    data['productId'] = this.productId;
    data['warehouseId'] = this.warehouseId;
    data['stockLocationId'] = this.stockLocationId;
    data['stockLocationName'] = this.stockLocationName;
    data['productName'] = this.productName;
    data['ficheNo'] = this.ficheNo;
    data['productBarcode'] = this.productBarcode;
    data['warehouse'] = this.warehouse;
    data['isProductLocatin'] = this.isProductLocatin;
    data['isExceededStockCount'] = this.isExceededStockCount;
    data['serilotType'] = this.serilotType;
    data['scannedQty'] = this.scannedQty;
    data['qty'] = this.qty;
    data['shippedQty'] = this.shippedQty;
    data['lineNr'] = this.lineNr;

    return data;
  }
}
