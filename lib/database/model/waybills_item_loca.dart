class WaybillItemLocalModel {
  int? recid;
  String? waybillsId;
  String? orderId;
  String? orderItemId;
  String? productId;
  String? description;
  String? warehouseId;
  String? warehouseName;
  String? stockLocationId;
  String? stockLocationName;
  bool? isProductLocatin;
  double? productPrice;
  int? shippedQty;
  int? scannedQty;
  int? qty;
  double? total;
  double? discount;
  double? tax;
  double? nettotal;
  String? unitId;
  String? unitConversionId;
  int? currencyId;
  String? barcode;
  String? productName;
  DateTime? ficheDate;
  String? erpId;
  String? erpCode;

  WaybillItemLocalModel({
    this.recid,
    this.orderId,
    this.orderItemId,
    this.waybillsId,
    this.productId,
    this.description,
    this.warehouseId,
    this.warehouseName,
    this.stockLocationId,
    this.stockLocationName,
    this.isProductLocatin,
    this.productPrice,
    this.shippedQty,
    this.scannedQty,
    this.qty,
    this.total,
    this.discount,
    this.tax,
    this.nettotal,
    this.unitId,
    this.unitConversionId,
    this.currencyId,
    this.barcode,
    this.productName,
    this.ficheDate,
    this.erpId,
    this.erpCode,
  });

  WaybillItemLocalModel.fromJson(Map<String, dynamic> json) {
    recid = json['recid'];
    waybillsId = json['waybillsId'];
    orderId = json['orderId'];
    orderItemId = json['orderItemId'];
    productId = json['productId'];
    description = json['description'];
    warehouseId = json['warehouseId'];
    warehouseName = json['warehouseName'];
    stockLocationId = json['stockLocationId'];
    stockLocationName = json['stockLocationName'];
    isProductLocatin = json['isProductLocatin'];
    productPrice = json['productPrice'];
    shippedQty = json['shippedQty'];
    scannedQty = json['scannedQty'];
    qty = json['qty'];
    total = json['total'];
    discount = json['discount'];
    tax = json['tax'];
    nettotal = json['nettotal'];
    unitId = json['unitId'];
    unitConversionId = json['unitConversionId'];
    currencyId = json['currencyId'];
    barcode = json['barcode'];
    productName = json['productName'];
    ficheDate = DateTime.parse(json['ficheDate']);
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }
  /*
      : this(
          json['waybillsId'],
          json['productId'],
          json['description_'],
          json['warehouseId'],
          json['productPrice'],
          json['shippedQty'],
          json['scannedQty'],
          json['qty'],
          json['total'],
          json['discount'],
          json['tax'],
          json['nettotal'],
          json['unitId'],
          json['unitConversionId'],
          json['currencyId'],
        );
        */

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["recid"] = recid;
    map["waybillsId"] = waybillsId;
    map["orderId"] = orderId;
    map["orderItemId"] = orderItemId;
    map["productId"] = productId;
    map["description"] = description;
    map["warehouseId"] = warehouseId;
    map['warehouseName'] = warehouseName;
    map["stockLocationId"] = stockLocationId;
    map["stockLocationName"] = stockLocationName;
    map["isProductLocatin"] = isProductLocatin;
    map["productPrice"] = productPrice;
    map["shippedQty"] = shippedQty;
    map["scannedQty"] = scannedQty;
    map["qty"] = qty;
    map["total"] = total;
    map["discount"] = discount;
    map["tax"] = tax;
    map["nettotal"] = nettotal;
    map["unitId"] = unitId;
    map["unitConversionId"] = unitConversionId;
    map["currencyId"] = currencyId;
    map['barcode'] = barcode;
    map['productName'] = productName;
    map['ficheDate'] = ficheDate;
    map['erpId'] = erpId;
    map['erpCode'] = erpCode;
    return map;
  }
}
