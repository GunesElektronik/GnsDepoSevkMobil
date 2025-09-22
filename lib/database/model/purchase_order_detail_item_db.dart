class PurchaseOrderDetailItemDB {
  String? purchaseOrderId;
  String? orderItemId;
  String? productId;
  String? warehouseId;
  String? stockLocationId;
  String? ficheNo;
  String? productName;
  String? productBarcode;
  String? warehouse;
  bool? isProductLocatin;
  String? stockLocationName;
  int? serilotType;
  int? scannedQty;
  int? qty;
  int? shippedQty;

  PurchaseOrderDetailItemDB({
    this.purchaseOrderId,
    this.orderItemId,
    this.productId,
    this.warehouseId,
    this.stockLocationId,
    this.ficheNo,
    this.productName,
    this.productBarcode,
    this.warehouse,
    this.isProductLocatin,
    this.stockLocationName,
    this.serilotType,
    this.scannedQty,
    this.qty,
    this.shippedQty,
  });

  PurchaseOrderDetailItemDB.fromJson(Map<String, dynamic> json) {
    purchaseOrderId = json['purchaseOrderId'];
    orderItemId = json['orderItemId'];
    productId = json['productId'];
    warehouseId = json['warehouseId'];
    stockLocationId = json['stockLocationId'];
    ficheNo = json['ficheNo'];
    productName = json['productName'];
    productBarcode = json['productBarcode'];
    warehouse = json['warehouse'];
    isProductLocatin = json['isProductLocatin'];
    stockLocationName = json['stockLocationName'];
    serilotType = json['serilotType'];
    scannedQty = json['scannedQty'];
    qty = json['qty'];
    shippedQty = json['shippedQty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purchaseOrderId'] = this.purchaseOrderId;
    data['orderItemId'] = this.orderItemId;
    data['productId'] = this.productId;
    data['warehouseId'] = this.warehouseId;
    data['stockLocationId'] = this.stockLocationId;
    data['productName'] = this.productName;
    data['ficheNo'] = this.ficheNo;
    data['productBarcode'] = this.productBarcode;
    data['warehouse'] = this.warehouse;
    data['isProductLocatin'] = this.isProductLocatin;
    data['stockLocationName'] = this.stockLocationName;
    data['serilotType'] = this.serilotType;
    data['scannedQty'] = this.scannedQty;
    data['qty'] = this.qty;
    data['shippedQty'] = this.shippedQty;

    return data;
  }
}
