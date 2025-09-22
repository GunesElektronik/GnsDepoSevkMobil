class NewOrderItem {
  Orders? orders;

  NewOrderItem({this.orders});

  NewOrderItem.fromJson(Map<String, dynamic> json) {
    orders =
        json['orders'] != null ? new Orders.fromJson(json['orders']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.toJson();
    }
    return data;
  }
}

class Orders {
  List<OrderItemHeader>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  Orders({this.items, this.totalItems, this.page, this.pageSize});

  Orders.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <OrderItemHeader>[];
      json['items'].forEach((v) {
        items!.add(new OrderItemHeader.fromJson(v));
      });
    }
    totalItems = json['totalItems'];
    page = json['page'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['totalItems'] = this.totalItems;
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    return data;
  }
}

class OrderItemHeader {
  String? orderId;
  //String? customerId;
  bool? moveType;
  int? transactionType;
  String? ficheNo;
  DateTime? ficheDate;
  String? ficheTime;
  String? docNo;
  //String? workPlaceId;
  //String? department;
  //String? warehouse;
  double? currencyId;
  double? totaldiscounted;
  double? totalvat;
  double? grossTotal;
  //String? transporterId;
  //String? shippingAccountId;
  //String? shippingAddressId;
  String? description;
  //String? shippingTypeId;
  bool? isAssing;
  String? assingmentEmail;
  String? assingCode;
  String? assingmetFullname;
  String? salesmanId;
  int? orderStatusId;
  String? orderStatusName;
  bool? isPartialOrder;
  List<OrderItems>? orderItems;

  OrderItemHeader(
      {this.orderId,
      //this.customerId,
      this.moveType,
      this.transactionType,
      this.ficheNo,
      this.ficheDate,
      this.ficheTime,
      this.docNo,
      //this.workPlaceId,
      //this.department,
      //this.warehouse,
      this.currencyId,
      this.totaldiscounted,
      this.totalvat,
      this.grossTotal,
      // this.transporterId,
      //this.shippingAccountId,
      //this.shippingAddressId,
      this.description,
      //this.shippingTypeId,
      this.isAssing,
      this.assingmentEmail,
      this.assingCode,
      this.assingmetFullname,
      //this.salesmanId,
      this.orderStatusId,
      this.isPartialOrder,
      this.orderItems});

  OrderItemHeader.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    //customerId = json['customerId'];
    moveType = json['moveType'];
    transactionType = json['transactionType'];
    ficheNo = json['ficheNo'];
    ficheDate = DateTime.parse(json['ficheDate']);
    ficheTime = json['ficheTime'];
    docNo = json['docNo'];
    // workPlaceId = json['workPlaceId'];
    //department = json['department'];
    //warehouse = json['warehouse'];
    /*
    currencyId = json['currencyId'];
    totaldiscounted = json['totaldiscounted'];
    totalvat = json['totalvat'];
    grossTotal = json['grossTotal'];
    */
    if (json['currencyId'] is int) {
      currencyId = (json['currencyId'] as int).toDouble();
    } else if (json['currencyId'] is double) {
      currencyId = json['currencyId'];
    } else {
      currencyId = 0.0;
    }
    if (json['totaldiscounted'] is int) {
      totaldiscounted = (json['totaldiscounted'] as int).toDouble();
    } else if (json['totaldiscounted'] is double) {
      totaldiscounted = json['totaldiscounted'];
    } else {
      totaldiscounted = 0.0;
    }
    if (json['totalvat'] is int) {
      totalvat = (json['totalvat'] as int).toDouble();
    } else if (json['totalvat'] is double) {
      totalvat = json['totalvat'];
    } else {
      totalvat = 0.0;
    }
    if (json['grossTotal'] is int) {
      grossTotal = (json['grossTotal'] as int).toDouble();
    } else if (json['grossTotal'] is double) {
      grossTotal = json['grossTotal'];
    } else {
      grossTotal = 0.0;
    }
    //transporterId = json['transporterId'];
    //shippingAccountId = json['shippingAccountId'];
    //shippingAddressId = json['shippingAddressId'];
    description = json['description_'];
    //shippingTypeId = json['shippingTypeId'];
    isAssing = json['isAssing'];
    assingmentEmail = json['assingmentEmail'];
    assingCode = json['assingCode'];
    assingmetFullname = json['assingmetFullname'];
    salesmanId = json['salesmanId'];
    orderStatusId = json['orderStatusId'];
    orderStatusName = json['orderStatusName'];
    isPartialOrder = json['isPartialOrder'];
    if (json['orderItems'] != null) {
      orderItems = <OrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    //data['customerId'] = this.customerId;
    data['moveType'] = this.moveType;
    data['transactionType'] = this.transactionType;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['ficheTime'] = this.ficheTime;
    data['docNo'] = this.docNo;
    //data['workPlaceId'] = this.workPlaceId;
    //data['department'] = this.department;
    //data['warehouse'] = this.warehouse;
    data['currencyId'] = this.currencyId;
    data['totaldiscounted'] = this.totaldiscounted;
    data['totalvat'] = this.totalvat;
    data['grossTotal'] = this.grossTotal;
    //data['transporterId'] = this.transporterId;
    //data['shippingAccountId'] = this.shippingAccountId;
    //data['shippingAddressId'] = this.shippingAddressId;
    data['description_'] = this.description;
    //data['shippingTypeId'] = this.shippingTypeId;
    data['isAssing'] = this.isAssing;
    data['assingmentEmail'] = this.assingmentEmail;
    data['assingCode'] = this.assingCode;
    data['assingmetFullname'] = this.assingmetFullname;
    data['salesmanId'] = this.salesmanId;
    data['orderStatusId'] = this.orderStatusId;
    data['orderStatusName'] = this.orderStatusName;
    data['isPartialOrder'] = this.isPartialOrder;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  OrderId? orderId;
  Product? product;
  String? description;
  double? qty;
  double? shippedQty;
  double? total;
  double? discount;
  double? tax;
  double? nettotal;
  double? productPrice;
  OrderId? id;
  String? created;
  String? createdBy;

  OrderItems(
      {this.orderId,
      this.product,
      this.description,
      this.productPrice,
      this.qty,
      this.shippedQty,
      this.total,
      this.discount,
      this.tax,
      this.nettotal,
      this.id,
      this.created,
      this.createdBy});

  OrderItems.fromJson(Map<String, dynamic> json) {
    orderId =
        json['orderId'] != null ? new OrderId.fromJson(json['orderId']) : null;
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    description = json['description_'];

    if (json['qty'] is int) {
      qty = (json['qty'] as int).toDouble();
    } else if (json['qty'] is double) {
      qty = json['qty'];
    } else {
      qty = 0.0;
    }
    if (json['shippedQty'] is int) {
      shippedQty = (json['shippedQty'] as int).toDouble();
    } else if (json['shippedQty'] is double) {
      shippedQty = json['shippedQty'];
    } else {
      shippedQty = 0.0;
    }
    if (json['productPrice'] is int) {
      productPrice = (json['productPrice'] as int).toDouble();
    } else if (json['productPrice'] is double) {
      productPrice = json['productPrice'];
    } else {
      productPrice = 0.0;
    }
    if (json['total'] is int) {
      total = (json['total'] as int).toDouble();
    } else if (json['total'] is double) {
      total = json['total'];
    } else {
      total = 0.0;
    }
    if (json['discount'] is int) {
      discount = (json['discount'] as int).toDouble();
    } else if (json['discount'] is double) {
      discount = json['discount'];
    } else {
      discount = 0.0;
    }
    if (json['tax'] is int) {
      tax = (json['tax'] as int).toDouble();
    } else if (json['tax'] is double) {
      tax = json['tax'];
    } else {
      tax = 0.0;
    }
    if (json['nettotal'] is int) {
      nettotal = (json['nettotal'] as int).toDouble();
    } else if (json['nettotal'] is double) {
      nettotal = json['nettotal'];
    } else {
      nettotal = 0.0;
    }
    id = json['id'] != null ? new OrderId.fromJson(json['id']) : null;
    created = json['created'];
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderId != null) {
      data['orderId'] = this.orderId!.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['description_'] = this.description;
    data['productPrice'] = this.productPrice;
    data['qty'] = this.qty;
    data['shippedQty'] = this.shippedQty;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['nettotal'] = this.nettotal;
    if (this.id != null) {
      data['id'] = this.id!.toJson();
    }
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
    return data;
  }
}

class OrderId {
  String? value;

  OrderId({this.value});

  OrderId.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    return data;
  }
}

class Product {
  String? code;
  String? definition;
  String? definition2;
  int? vatRate;
  bool? isActive;
  bool? isProductLocatin;
  String? barcode;
  String? erpId;
  String? erpCode;
  String? productTrackingMethod;
  int? originalVersion;
  OrderId? id;
  String? created;
  String? createdBy;

  Product(
      {this.code,
      this.definition,
      this.definition2,
      this.vatRate,
      this.isActive,
      this.isProductLocatin,
      this.barcode,
      this.erpId,
      this.erpCode,
      this.productTrackingMethod,
      this.originalVersion,
      this.id,
      this.created,
      this.createdBy});

  Product.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    definition = json['definition'];
    definition2 = json['definition2'];
    vatRate = json['vatRate'];
    isActive = json['isActive'];
    isProductLocatin = json['isProductLocatin'];
    barcode = json['barcode'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    productTrackingMethod = json['productTrackingMethod'];
    originalVersion = json['originalVersion'];
    id = json['id'] != null ? new OrderId.fromJson(json['id']) : null;
    created = json['created'];
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['definition'] = this.definition;
    data['definition2'] = this.definition2;
    data['vatRate'] = this.vatRate;
    data['isActive'] = this.isActive;
    data['isProductLocatin'] = this.isProductLocatin;
    data['barcode'] = this.barcode;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;

    data['productTrackingMethod'] = this.productTrackingMethod;
    data['originalVersion'] = this.originalVersion;
    if (this.id != null) {
      data['id'] = this.id!.toJson();
    }
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
    return data;
  }
}
