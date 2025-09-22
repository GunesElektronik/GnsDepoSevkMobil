class CreateSalesOrderRequest {
  String? customerId;
  String? ficheNo;
  String? ficheDate;
  String? ficheTime;
  String? docNo;
  String? workPlaceId;
  String? departmentId;
  String? warehouseId;
  int? currencyId;
  int? totaldiscounted;
  int? totalvat;
  int? grossTotal;
  String? transporterId;
  String? shippingAccountId;
  String? shippingAddressId;
  String? description;
  String? shippingTypeId;
  bool? isAssing;
  String? assingmentEmail;
  String? assingCode;
  String? assingmetFullname;
  String? salesmanId;
  int? orderStatusId;
  bool? isPartialOrder;
  String? payPlan;
  String? specode;
  String? erpId;
  String? erpCode;
  String? projectId;
  List<SalesOrderItems>? orderItems;

  CreateSalesOrderRequest(
      {this.customerId,
      this.ficheNo,
      this.ficheDate,
      this.ficheTime,
      this.docNo,
      this.workPlaceId,
      this.departmentId,
      this.warehouseId,
      this.currencyId,
      this.totaldiscounted,
      this.totalvat,
      this.grossTotal,
      this.transporterId,
      this.shippingAccountId,
      this.shippingAddressId,
      this.description,
      this.shippingTypeId,
      this.isAssing,
      this.assingmentEmail,
      this.assingCode,
      this.assingmetFullname,
      this.salesmanId,
      this.orderStatusId,
      this.isPartialOrder,
      this.payPlan,
      this.specode,
      this.erpId,
      this.erpCode,
      this.projectId,
      this.orderItems});

  CreateSalesOrderRequest.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    ficheTime = json['ficheTime'];
    docNo = json['docNo'];
    workPlaceId = json['workPlaceId'];
    departmentId = json['departmentId'];
    warehouseId = json['warehouseId'];
    currencyId = json['currencyId'];
    totaldiscounted = json['totaldiscounted'];
    totalvat = json['totalvat'];
    grossTotal = json['grossTotal'];
    transporterId = json['transporterId'];
    shippingAccountId = json['shippingAccountId'];
    shippingAddressId = json['shippingAddressId'];
    description = json['description_'];
    shippingTypeId = json['shippingTypeId'];
    isAssing = json['isAssing'];
    assingmentEmail = json['assingmentEmail'];
    assingCode = json['assingCode'];
    assingmetFullname = json['assingmetFullname'];
    salesmanId = json['salesmanId'];
    orderStatusId = json['orderStatusId'];
    isPartialOrder = json['isPartialOrder'];
    payPlan = json['payPlan'];
    specode = json['specode'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    projectId = json['projectId'];
    if (json['orderItems'] != null) {
      orderItems = <SalesOrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new SalesOrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['ficheTime'] = this.ficheTime;
    data['docNo'] = this.docNo;
    data['workPlaceId'] = this.workPlaceId;
    data['departmentId'] = this.departmentId;
    data['warehouseId'] = this.warehouseId;
    data['currencyId'] = this.currencyId;
    data['totaldiscounted'] = this.totaldiscounted;
    data['totalvat'] = this.totalvat;
    data['grossTotal'] = this.grossTotal;
    data['transporterId'] = this.transporterId;
    data['shippingAccountId'] = this.shippingAccountId;
    data['shippingAddressId'] = this.shippingAddressId;
    data['description_'] = this.description;
    data['shippingTypeId'] = this.shippingTypeId;
    data['isAssing'] = this.isAssing;
    data['assingmentEmail'] = this.assingmentEmail;
    data['assingCode'] = this.assingCode;
    data['assingmetFullname'] = this.assingmetFullname;
    data['salesmanId'] = this.salesmanId;
    data['orderStatusId'] = this.orderStatusId;
    data['isPartialOrder'] = this.isPartialOrder;
    data['payPlan'] = this.payPlan;
    data['specode'] = this.specode;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    data['projectId'] = this.projectId;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesOrderItems {
  String? productId;
  String? description;
  String? warehouseId;
  int? productPrice;
  int? qty;
  int? shippedQty;
  int? total;
  int? discount;
  int? tax;
  int? nettotal;
  String? unitId;
  String? unitConversionId;
  String? erpId;
  String? erpCode;
  int? currencyId;
  int? orderitemtype;
  String? projectId;

  SalesOrderItems(
      {this.productId,
      this.description,
      this.warehouseId,
      this.productPrice,
      this.qty,
      this.shippedQty,
      this.total,
      this.discount,
      this.tax,
      this.nettotal,
      this.unitId,
      this.unitConversionId,
      this.erpId,
      this.erpCode,
      this.currencyId,
      this.orderitemtype,
      this.projectId});

  SalesOrderItems.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    description = json['description_'];
    warehouseId = json['warehouseId'];
    productPrice = json['productPrice'];
    qty = json['qty'];
    shippedQty = json['shippedQty'];
    total = json['total'];
    discount = json['discount'];
    tax = json['tax'];
    nettotal = json['nettotal'];
    unitId = json['unitId'];
    unitConversionId = json['unitConversionId'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    currencyId = json['currencyId'];
    orderitemtype = json['orderitemtype'];
    projectId = json['projectId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['description_'] = this.description;
    data['warehouseId'] = this.warehouseId;
    data['productPrice'] = this.productPrice;
    data['qty'] = this.qty;
    data['shippedQty'] = this.shippedQty;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['nettotal'] = this.nettotal;
    data['unitId'] = this.unitId;
    data['unitConversionId'] = this.unitConversionId;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    data['currencyId'] = this.currencyId;
    data['orderitemtype'] = this.orderitemtype;
    data['projectId'] = this.projectId;
    return data;
  }
}
