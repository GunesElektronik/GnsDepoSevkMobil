class PurchaseOrderDetailResponse {
  PurchaseOrderDetail? order;

  PurchaseOrderDetailResponse({this.order});

  PurchaseOrderDetailResponse.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null
        ? new PurchaseOrderDetail.fromJson(json['order'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class PurchaseOrderDetail {
  String? orderId;
  Customer? customer;
  bool? moveType;
  int? transactionTypeId;
  String? transactionTypeName;
  String? ficheNo;
  String? ficheDate;
  String? ficheTime;
  String? docNo;
  Workplace? workplace;
  Department? department;
  Warehouse? warehouse;
  int? currencyId;
  String? currencyName;
  double? totaldiscounted;
  double? totalvat;
  double? grossTotal;
  Transporter? transporter;
  Customer? shippingAccount;
  ShippingAddress? shippingAddress;
  String? description;
  OrderShippingType? orderShippingType;
  PurchaseOrderSalesman? salesman;
  bool? isAssing;
  String? assingmentEmail;
  String? assingCode;
  String? assingmetFullname;
  int? orderStatusId;
  String? orderStatusName;
  bool? isPartialOrder;
  List<OrderItems>? orderItems;
  List<GlobalOrderItemDetails>? globalOrderItemDetails;
  String? payPlan;
  String? specode;
  Project? project;

  PurchaseOrderDetail({
    this.orderId,
    this.customer,
    this.moveType,
    this.transactionTypeId,
    this.transactionTypeName,
    this.ficheNo,
    this.ficheDate,
    this.ficheTime,
    this.docNo,
    this.workplace,
    this.department,
    this.warehouse,
    this.currencyId,
    this.currencyName,
    this.totaldiscounted,
    this.totalvat,
    this.grossTotal,
    this.transporter,
    this.shippingAccount,
    this.shippingAddress,
    this.description,
    this.orderShippingType,
    this.salesman,
    this.isAssing,
    this.assingmentEmail,
    this.assingCode,
    this.assingmetFullname,
    this.orderStatusId,
    this.orderStatusName,
    this.isPartialOrder,
    this.orderItems,
    this.globalOrderItemDetails,
    this.payPlan,
    this.specode,
    this.project,
  });

  PurchaseOrderDetail.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    moveType = json['moveType'];
    transactionTypeId = json['transactionTypeId'];
    transactionTypeName = json['transactionTypeName'];
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    ficheTime = json['ficheTime'];
    docNo = json['docNo'];
    workplace = json['workplace'] != null
        ? new Workplace.fromJson(json['workplace'])
        : null;
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
    currencyId = json['currencyId'];
    currencyName = json['currencyName'];
    totaldiscounted = json['totaldiscounted'];
    totalvat = json['totalvat'];
    grossTotal = json['grossTotal'];
    transporter = json['transporter'] != null
        ? new Transporter.fromJson(json['transporter'])
        : null;
    shippingAccount = json['shippingAccount'] != null
        ? new Customer.fromJson(json['shippingAccount'])
        : null;
    shippingAddress = json['shippingAddress'] != null
        ? new ShippingAddress.fromJson(json['shippingAddress'])
        : null;
    description = json['description_'];
    orderShippingType = json['orderShippingType'] != null
        ? new OrderShippingType.fromJson(json['orderShippingType'])
        : null;
    salesman = json['salesman'] != null
        ? new PurchaseOrderSalesman.fromJson(json['salesman'])
        : null;
    isAssing = json['isAssing'];
    assingmentEmail = json['assingmentEmail'];
    assingCode = json['assingCode'];
    assingmetFullname = json['assingmetFullname'];
    orderStatusId = json['orderStatusId'];
    orderStatusName = json['orderStatusName'];
    isPartialOrder = json['isPartialOrder'];
    if (json['orderItems'] != null) {
      orderItems = <OrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    if (json['globalOrderItemDetails'] != null) {
      globalOrderItemDetails = <GlobalOrderItemDetails>[];
      json['globalOrderItemDetails'].forEach((v) {
        globalOrderItemDetails!.add(new GlobalOrderItemDetails.fromJson(v));
      });
    }
    payPlan = json['payPlan'];
    specode = json['specode'];
    project =
        json['project'] != null ? new Project.fromJson(json['project']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['moveType'] = this.moveType;
    data['transactionTypeId'] = this.transactionTypeId;
    data['transactionTypeName'] = this.transactionTypeName;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['ficheTime'] = this.ficheTime;
    data['docNo'] = this.docNo;
    if (this.workplace != null) {
      data['workplace'] = this.workplace!.toJson();
    }
    if (this.department != null) {
      data['department'] = this.department!.toJson();
    }
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.toJson();
    }
    data['currencyId'] = this.currencyId;
    data['currencyName'] = this.currencyName;
    data['totaldiscounted'] = this.totaldiscounted;
    data['totalvat'] = this.totalvat;
    data['grossTotal'] = this.grossTotal;
    if (this.transporter != null) {
      data['transporter'] = this.transporter!.toJson();
    }
    if (this.shippingAccount != null) {
      data['shippingAccount'] = this.shippingAccount!.toJson();
    }
    if (this.shippingAddress != null) {
      data['shippingAddress'] = this.shippingAddress!.toJson();
    }
    data['description_'] = this.description;
    if (this.orderShippingType != null) {
      data['orderShippingType'] = this.orderShippingType!.toJson();
    }
    data['isAssing'] = this.isAssing;
    data['assingmentEmail'] = this.assingmentEmail;
    data['assingCode'] = this.assingCode;
    data['assingmetFullname'] = this.assingmetFullname;
    data['orderStatusId'] = this.orderStatusId;
    data['orderStatusName'] = this.orderStatusName;
    data['isPartialOrder'] = this.isPartialOrder;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    if (this.globalOrderItemDetails != null) {
      data['globalOrderItemDetails'] =
          this.globalOrderItemDetails!.map((v) => v.toJson()).toList();
    }
    data['payPlan'] = this.payPlan;
    data['specode'] = this.specode;
    if (this.project != null) {
      data['project'] = this.project!.toJson();
    }
    return data;
  }
}

class Customer {
  String? customerId;
  String? code;
  String? name;
  bool? isPartialOrder;
  Salesman? salesman;

  Customer(
      {this.customerId,
      this.code,
      this.name,
      this.isPartialOrder,
      this.salesman});

  Customer.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    code = json['code'];
    name = json['name'];
    isPartialOrder = json['isPartialOrder'];
    salesman = json['salesman'] != null
        ? new Salesman.fromJson(json['salesman'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['code'] = this.code;
    data['name'] = this.name;
    data['isPartialOrder'] = this.isPartialOrder;
    if (this.salesman != null) {
      data['salesman'] = this.salesman!.toJson();
    }
    return data;
  }
}

class Salesman {
  String? salesmanId;
  String? code;
  String? name;

  Salesman({this.salesmanId, this.code, this.name});

  Salesman.fromJson(Map<String, dynamic> json) {
    salesmanId = json['salesmanId'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesmanId'] = this.salesmanId;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class Workplace {
  String? workplaceId;
  String? code;
  String? definition;

  Workplace({this.workplaceId, this.code, this.definition});

  Workplace.fromJson(Map<String, dynamic> json) {
    workplaceId = json['workplaceId'];
    code = json['code'];
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workplaceId'] = this.workplaceId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    return data;
  }
}

class Department {
  String? departmentId;
  String? code;
  String? definition;

  Department({this.departmentId, this.code, this.definition});

  Department.fromJson(Map<String, dynamic> json) {
    departmentId = json['departmentId'];
    code = json['code'];
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['departmentId'] = this.departmentId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    return data;
  }
}

class Warehouse {
  String? warehouseId;
  String? code;
  String? definition;

  Warehouse({this.warehouseId, this.code, this.definition});

  Warehouse.fromJson(Map<String, dynamic> json) {
    warehouseId = json['warehouseId'];
    code = json['code'];
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warehouseId'] = this.warehouseId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    return data;
  }
}

class Transporter {
  String? transporterId;
  String? code;
  String? description;
  String? identityOrTax;

  Transporter(
      {this.transporterId, this.code, this.description, this.identityOrTax});

  Transporter.fromJson(Map<String, dynamic> json) {
    transporterId = json['transporterId'];
    code = json['code'];
    description = json['description'];
    identityOrTax = json['identityOrTax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transporterId'] = this.transporterId;
    data['code'] = this.code;
    data['description'] = this.description;
    data['identityOrTax'] = this.identityOrTax;
    return data;
  }
}

class ShippingAddress {
  String? shippingAddressId;
  String? name;
  String? description;
  String? district;
  String? town;
  String? city;
  String? country;
  String? eMail;
  String? phoneNumber;
  String? relatedPerson;

  ShippingAddress(
      {this.shippingAddressId,
      this.name,
      this.description,
      this.district,
      this.town,
      this.city,
      this.country,
      this.eMail,
      this.phoneNumber,
      this.relatedPerson});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    shippingAddressId = json['shippingAddressId'];
    name = json['name'];
    description = json['description'];
    district = json['district'];
    town = json['town'];
    city = json['city'];
    country = json['country'];
    eMail = json['eMail'];
    phoneNumber = json['phoneNumber'];
    relatedPerson = json['relatedPerson'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shippingAddressId'] = this.shippingAddressId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['district'] = this.district;
    data['town'] = this.town;
    data['city'] = this.city;
    data['country'] = this.country;
    data['eMail'] = this.eMail;
    data['phoneNumber'] = this.phoneNumber;
    data['relatedPerson'] = this.relatedPerson;
    return data;
  }
}

class OrderShippingType {
  String? shippingTypeId;
  String? code;
  String? definition;

  OrderShippingType({this.shippingTypeId, this.code, this.definition});

  OrderShippingType.fromJson(Map<String, dynamic> json) {
    shippingTypeId = json['shippingTypeId'];
    code = json['code'];
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shippingTypeId'] = this.shippingTypeId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    return data;
  }
}

class PurchaseOrderSalesman {
  String? salesmanId;
  String? code;
  String? name;

  PurchaseOrderSalesman({this.salesmanId, this.code, this.name});

  PurchaseOrderSalesman.fromJson(Map<String, dynamic> json) {
    salesmanId = json['salesmanId'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesmanId'] = this.salesmanId;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class OrderItems {
  String? orderItemId;
  Product? product;
  int? productItemTypeId;
  int? transactionTypeId;
  String? description;
  String? warehouseId;
  String? warehouseName;
  double? productPrice;
  double? qty;
  double? shippedQty;
  double? total;
  double? discount;
  double? tax;
  double? nettotal;
  String? unitId;
  String? unitName;
  String? unitConversionId;
  String? unitConversionName;
  String? erpId;
  String? erpCode;
  List<OrderItemDetails>? orderItemDetails;
  Project? project;

  OrderItems({
    this.orderItemId,
    this.product,
    this.productItemTypeId,
    this.transactionTypeId,
    this.description,
    this.warehouseId,
    this.warehouseName,
    this.productPrice,
    this.qty,
    this.shippedQty,
    this.total,
    this.discount,
    this.tax,
    this.nettotal,
    this.unitId,
    this.unitName,
    this.unitConversionId,
    this.unitConversionName,
    this.erpId,
    this.erpCode,
    this.orderItemDetails,
    this.project,
  });

  OrderItems.fromJson(Map<String, dynamic> json) {
    orderItemId = json['orderItemId'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    productItemTypeId = json['productItemTypeId'];
    transactionTypeId = json['transactionTypeId'];
    description = json['description_'];
    warehouseId = json['warehouseId'];
    warehouseName = json['warehouseName'];
    productPrice = json['productPrice'];
    qty = json['qty'];
    shippedQty = json['shippedQty'];
    total = json['total'];
    discount = json['discount'];
    tax = json['tax'];
    nettotal = json['nettotal'];
    unitId = json['unitId'];
    unitName = json['unitName'];
    unitConversionId = json['unitConversionId'];
    unitConversionName = json['unitConversionName'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    if (json['orderItemDetails'] != null) {
      orderItemDetails = <OrderItemDetails>[];
      json['orderItemDetails'].forEach((v) {
        orderItemDetails!.add(new OrderItemDetails.fromJson(v));
      });
    }
    project =
        json['project'] != null ? new Project.fromJson(json['project']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderItemId'] = this.orderItemId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['productItemTypeId'] = this.productItemTypeId;
    data['transactionTypeId'] = this.transactionTypeId;
    data['description_'] = this.description;
    data['warehouseId'] = this.warehouseId;
    data['warehouseName'] = this.warehouseName;
    data['productPrice'] = this.productPrice;
    data['qty'] = this.qty;
    data['shippedQty'] = this.shippedQty;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['nettotal'] = this.nettotal;
    data['unitId'] = this.unitId;
    data['unitName'] = this.unitName;
    data['unitConversionId'] = this.unitConversionId;
    data['unitConversionName'] = this.unitConversionName;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    if (this.orderItemDetails != null) {
      data['orderItemDetails'] =
          this.orderItemDetails!.map((v) => v.toJson()).toList();
    }
    if (this.project != null) {
      data['project'] = this.project!.toJson();
    }
    return data;
  }
}

class OrderItemDetails {
  String? orderItemId;
  int? orderItemTypeId;
  String? orderItemTypeName;
  int? lineNr;
  bool? isGlobal;
  bool? calcType;
  double? qty;
  double? total;
  double? discountPercent;
  String? erpId;
  String? erpCode;

  OrderItemDetails(
      {this.orderItemId,
      this.orderItemTypeId,
      this.orderItemTypeName,
      this.lineNr,
      this.isGlobal,
      this.calcType,
      this.qty,
      this.total,
      this.discountPercent,
      this.erpId,
      this.erpCode});

  OrderItemDetails.fromJson(Map<String, dynamic> json) {
    orderItemId = json['orderItemId'];
    orderItemTypeId = json['orderItemTypeId'];
    orderItemTypeName = json['orderItemTypeName'];
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
    data['orderItemId'] = this.orderItemId;
    data['orderItemTypeId'] = this.orderItemTypeId;
    data['orderItemTypeName'] = this.orderItemTypeName;
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

class Product {
  String? productId;
  String? code;
  String? definition;
  String? definition2;
  bool? isProductLocatin;
  String? barcode;
  String? productTrackingMethod;

  Product(
      {this.productId,
      this.code,
      this.definition,
      this.definition2,
      this.isProductLocatin,
      this.barcode,
      this.productTrackingMethod});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    code = json['code'];
    definition = json['definition'];
    definition2 = json['definition2'];
    isProductLocatin = json['isProductLocatin'];
    barcode = json['barcode'];
    productTrackingMethod = json['productTrackingMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    data['definition2'] = this.definition2;
    data['isProductLocatin'] = this.isProductLocatin;
    data['barcode'] = this.barcode;
    data['productTrackingMethod'] = this.productTrackingMethod;
    return data;
  }
}

class GlobalOrderItemDetails {
  String? orderItemId;
  int? orderItemTypeId;
  String? orderItemTypeName;
  int? lineNr;
  bool? isGlobal;
  bool? calcType;
  double? qty;
  double? total;
  double? discountPercent;
  String? erpId;
  String? erpCode;

  GlobalOrderItemDetails(
      {this.orderItemId,
      this.orderItemTypeId,
      this.orderItemTypeName,
      this.lineNr,
      this.isGlobal,
      this.calcType,
      this.qty,
      this.total,
      this.discountPercent,
      this.erpId,
      this.erpCode});

  GlobalOrderItemDetails.fromJson(Map<String, dynamic> json) {
    orderItemId = json['orderItemId'];
    orderItemTypeId = json['orderItemTypeId'];
    orderItemTypeName = json['orderItemTypeName'];
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
    data['orderItemId'] = this.orderItemId;
    data['orderItemTypeId'] = this.orderItemTypeId;
    data['orderItemTypeName'] = this.orderItemTypeName;
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

class Project {
  String? projectId;
  String? code;
  String? definition;
  String? erpId;
  String? erpCode;

  Project(
      {this.projectId, this.code, this.definition, this.erpId, this.erpCode});

  Project.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    code = json['code'];
    definition = json['definition'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    return data;
  }
}
