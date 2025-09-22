class WayybillsRequestBody {
  String? customerId;
  String? ficheNo;
  String? ficheDate;
  String? shipDate;
  String? ficheTime;
  String? docNo;
  String? erpInvoiceRef;
  String? workPlaceId;
  String? department;
  String? warehouse;
  int? currencyId;
  double? totaldiscounted;
  double? totalvat;
  double? grossTotal;
  String? transporterId;
  String? shippingAccountId;
  String? shippingAddressId;
  String? description;
  String? shippingTypeId;
  String? salesmanId;
  int? waybillStatusId;
  String? erpId;
  String? erpCode;
  List<WaybillItems>? waybillItems;

  WayybillsRequestBody(
      {this.customerId,
      this.ficheNo,
      this.ficheDate,
      this.shipDate,
      this.ficheTime,
      this.docNo,
      this.erpInvoiceRef,
      this.workPlaceId,
      this.department,
      this.warehouse,
      this.currencyId,
      this.totaldiscounted,
      this.totalvat,
      this.grossTotal,
      this.transporterId,
      this.shippingAccountId,
      this.shippingAddressId,
      this.description,
      this.shippingTypeId,
      this.salesmanId,
      this.waybillStatusId,
      this.erpId,
      this.erpCode,
      this.waybillItems});

  WayybillsRequestBody.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    shipDate = json['shipDate'];
    ficheTime = json['ficheTime'];
    docNo = json['docNo'];
    erpInvoiceRef = json['erpInvoiceRef'];
    workPlaceId = json['workPlaceId'];
    department = json['department'];
    warehouse = json['warehouse'];
    currencyId = json['currencyId'];
    totaldiscounted = json['totaldiscounted'];
    totalvat = json['totalvat'];
    grossTotal = json['grossTotal'];
    transporterId = json['transporterId'];
    shippingAccountId = json['shippingAccountId'];
    shippingAddressId = json['shippingAddressId'];
    description = json['description_'];
    shippingTypeId = json['shippingTypeId'];
    salesmanId = json['salesmanId'];
    waybillStatusId = json['waybillStatusId'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    if (json['waybillItems'] != null) {
      waybillItems = <WaybillItems>[];
      json['waybillItems'].forEach((v) {
        waybillItems!.add(new WaybillItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['shipDate'] = this.shipDate;
    data['ficheTime'] = this.ficheTime;
    data['docNo'] = this.docNo;
    data['erpInvoiceRef'] = this.erpInvoiceRef;
    data['workPlaceId'] = this.workPlaceId;
    data['department'] = this.department;
    data['warehouse'] = this.warehouse;
    data['currencyId'] = this.currencyId;
    data['totaldiscounted'] = this.totaldiscounted;
    data['totalvat'] = this.totalvat;
    data['grossTotal'] = this.grossTotal;
    data['transporterId'] = this.transporterId;
    data['shippingAccountId'] = this.shippingAccountId;
    data['shippingAddressId'] = this.shippingAddressId;
    data['description_'] = this.description;
    data['shippingTypeId'] = this.shippingTypeId;
    data['salesmanId'] = this.salesmanId;
    data['waybillStatusId'] = this.waybillStatusId;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    if (this.waybillItems != null) {
      data['waybillItems'] = this.waybillItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WaybillItems {
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
  int? qty;
  int? shippedQty;
  double? total;
  double? discount;
  double? tax;
  double? nettotal;
  String? unitId;
  String? unitConversionId;
  int? currencyId;
  DateTime? ficheDate;
  String? erpId;
  String? erpCode;
  String? barcode;
  String? productName;

  WaybillItems({
    this.orderId,
    this.orderItemId,
    this.productId,
    this.description,
    this.warehouseId,
    this.warehouseName,
    this.stockLocationId,
    this.stockLocationName,
    this.isProductLocatin,
    this.productPrice,
    this.qty,
    this.shippedQty,
    this.total,
    this.discount,
    this.tax,
    this.nettotal,
    this.unitId,
    this.unitConversionId,
    this.currencyId,
    required this.ficheDate,
    this.erpId,
    this.erpCode,
    this.barcode,
    this.productName,
  });

  WaybillItems.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderItemId = json['orderItemId'];
    productId = json['productId'];
    description = json['description_'];
    warehouseId = json['warehouseId'];
    warehouseName = json['warehouseName'];
    stockLocationId = json['stockLocationId'];
    stockLocationName = json['stockLocationName'];
    isProductLocatin = json['isProductLocatin'];
    productPrice = json['productPrice'];
    qty = json['qty'];
    shippedQty = json['shippedQty'];
    total = json['total'];
    discount = json['discount'];
    tax = json['tax'];
    nettotal = json['nettotal'];
    unitId = json['unitId'];
    unitConversionId = json['unitConversionId'];
    currencyId = json['currencyId'];
    ficheDate = DateTime.parse(json['ficheDate']);
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    barcode = json['barcode'];
    productName = json['productName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderItemId'] = this.orderItemId;
    data['productId'] = this.productId;
    data['description_'] = this.description;
    data['warehouseId'] = this.warehouseId;
    data['warehouseName'] = this.warehouseName;
    data["stockLocationId"] = stockLocationId;
    data["stockLocationName"] = stockLocationName;
    data["isProductLocatin"] = isProductLocatin;
    data['productPrice'] = this.productPrice;
    data['qty'] = this.qty;
    data['shippedQty'] = this.shippedQty;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['nettotal'] = this.nettotal;
    data['unitId'] = this.unitId;
    data['unitConversionId'] = this.unitConversionId;
    data['currencyId'] = this.currencyId;
    data['ficheDate'] = this.ficheDate;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    data['barcode'] = this.barcode;
    data['productName'] = this.productName;
    return data;
  }
}
