class WayybillsRequestBodyNew {
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
  String? projectId;
  String? orderId;
  int? waybillTypeId;
  List<WaybillItemsNew>? waybillItems;
  List<GlobalWaybillItemDetails>? globalWaybillItemDetails;

  WayybillsRequestBodyNew({
    this.customerId,
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
    this.projectId,
    this.orderId,
    this.waybillTypeId,
    this.waybillItems,
    this.globalWaybillItemDetails,
  });

  WayybillsRequestBodyNew.fromJson(Map<String, dynamic> json) {
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
    projectId = json['projectId'];
    orderId = json['orderId'];
    waybillTypeId = json['waybillTypeId'];
    if (json['waybillItems'] != null) {
      waybillItems = <WaybillItemsNew>[];
      json['waybillItems'].forEach((v) {
        waybillItems!.add(new WaybillItemsNew.fromJson(v));
      });
    }
    if (json['globalWaybillItemDetails'] != null) {
      globalWaybillItemDetails = <GlobalWaybillItemDetails>[];
      json['globalWaybillItemDetails'].forEach((v) {
        globalWaybillItemDetails!.add(new GlobalWaybillItemDetails.fromJson(v));
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
    data['projectId'] = this.projectId;
    data['orderId'] = this.orderId;
    data['waybillTypeId'] = this.waybillTypeId;
    if (this.waybillItems != null) {
      data['waybillItems'] = this.waybillItems!.map((v) => v.toJson()).toList();
    }
    if (this.globalWaybillItemDetails != null) {
      data['globalWaybillItemDetails'] = this.globalWaybillItemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WaybillItemsNew {
  String? productId;
  String? orderLineId;
  String? description;
  String? warehouseId;
  double? productPrice;
  int? qty;
  double? total;
  double? discount;
  double? tax;
  double? nettotal;
  String? unitId;
  String? unitConversionId;
  List<StockLocationRelations>? stockLocationRelations;
  int? currencyId;
  String? erpId;
  String? erpCode;
  String? projectId;
  String? orderReferance;
  int? erpOrderReferance;
  int? waybillItemTypeId;
  List<WaybillItemDetails>? waybillItemDetails;

  WaybillItemsNew({
    this.productId,
    this.orderLineId,
    this.description,
    this.warehouseId,
    this.productPrice,
    this.qty,
    this.total,
    this.discount,
    this.tax,
    this.nettotal,
    this.unitId,
    this.unitConversionId,
    this.stockLocationRelations,
    this.currencyId,
    this.erpId,
    this.erpCode,
    this.projectId,
    this.orderReferance,
    this.erpOrderReferance,
    this.waybillItemTypeId,
    this.waybillItemDetails,
  });

  WaybillItemsNew.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    orderLineId = json['orderLineId'];
    description = json['description_'];
    warehouseId = json['warehouseId'];
    productPrice = json['productPrice'];
    qty = json['qty'];
    total = json['total'];
    discount = json['discount'];
    tax = json['tax'];
    nettotal = json['nettotal'];
    unitId = json['unitId'];
    unitConversionId = json['unitConversionId'];
    if (json['stockLocationRelations'] != null) {
      stockLocationRelations = <StockLocationRelations>[];
      json['stockLocationRelations'].forEach((v) {
        stockLocationRelations!.add(new StockLocationRelations.fromJson(v));
      });
    }
    currencyId = json['currencyId'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    projectId = json['projectId'];
    orderReferance = json['orderReferance'];
    erpOrderReferance = json['erpOrderReferance'];
    waybillItemTypeId = json['waybillItemTypeId'];
    if (json['waybillItemDetails'] != null) {
      waybillItemDetails = <WaybillItemDetails>[];
      json['waybillItemDetails'].forEach((v) {
        waybillItemDetails!.add(new WaybillItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['orderLineId'] = this.orderLineId;
    data['description_'] = this.description;
    data['warehouseId'] = this.warehouseId;
    data['productPrice'] = this.productPrice;
    data['qty'] = this.qty;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['nettotal'] = this.nettotal;
    data['unitId'] = this.unitId;
    data['unitConversionId'] = this.unitConversionId;
    if (this.stockLocationRelations != null) {
      data['stockLocationRelations'] = this.stockLocationRelations!.map((v) => v.toJson()).toList();
    }
    data['currencyId'] = this.currencyId;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    data['projectId'] = this.projectId;
    data['orderReferance'] = this.orderReferance;
    data['erpOrderReferance'] = this.erpOrderReferance;
    data['waybillItemTypeId'] = this.waybillItemTypeId;
    if (this.waybillItemDetails != null) {
      data['waybillItemDetails'] = this.waybillItemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StockLocationRelations {
  String? stockLocationId;
  int? qty;

  StockLocationRelations({this.stockLocationId, this.qty});

  StockLocationRelations.fromJson(Map<String, dynamic> json) {
    stockLocationId = json['stockLocationId'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockLocationId'] = this.stockLocationId;
    data['qty'] = this.qty;
    return data;
  }
}

class WaybillItemDetails {
  int? waybillItemTypeId;
  int? lineNr;
  bool? isGlobal;
  bool? calcType;
  double? qty;
  double? total;
  double? discountPercent;
  String? erpId;
  String? erpCode;

  WaybillItemDetails(
      {this.waybillItemTypeId,
      this.lineNr,
      this.isGlobal,
      this.calcType,
      this.qty,
      this.total,
      this.discountPercent,
      this.erpId,
      this.erpCode});

  WaybillItemDetails.fromJson(Map<String, dynamic> json) {
    waybillItemTypeId = json['waybillItemTypeId'];
    lineNr = json['lineNr'];
    isGlobal = json['isGlobal'];
    calcType = json['calcType'];
    qty = json['qty'];
    total = json['total'];
    discountPercent = json['discountPercent'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waybillItemTypeId'] = this.waybillItemTypeId;
    data['lineNr'] = this.lineNr;
    data['isGlobal'] = this.isGlobal;
    data['calcType'] = this.calcType;
    data['qty'] = this.qty;
    data['total'] = this.total;
    data['discountPercent'] = this.discountPercent;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    return data;
  }
}

class GlobalWaybillItemDetails {
  int? waybillItemTypeId;
  int? lineNr;
  bool? isGlobal;
  bool? calcType;
  double? qty;
  double? total;
  double? discountPercent;
  String? erpId;
  String? erpCode;

  GlobalWaybillItemDetails(
      {this.waybillItemTypeId,
      this.lineNr,
      this.isGlobal,
      this.calcType,
      this.qty,
      this.total,
      this.discountPercent,
      this.erpId,
      this.erpCode});

  GlobalWaybillItemDetails.fromJson(Map<String, dynamic> json) {
    waybillItemTypeId = json['waybillItemTypeId'];
    lineNr = json['lineNr'];
    isGlobal = json['isGlobal'];
    calcType = json['calcType'];
    qty = json['qty'];
    total = json['total'];
    discountPercent = json['discountPercent'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waybillItemTypeId'] = this.waybillItemTypeId;
    data['lineNr'] = this.lineNr;
    data['isGlobal'] = this.isGlobal;
    data['calcType'] = this.calcType;
    data['qty'] = this.qty;
    data['total'] = this.total;
    data['discountPercent'] = this.discountPercent;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    return data;
  }
}
