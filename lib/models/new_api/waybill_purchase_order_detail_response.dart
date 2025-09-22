class WaybillPurchaseOrderDetailResponse {
  Waybill? waybill;

  WaybillPurchaseOrderDetailResponse({this.waybill});

  WaybillPurchaseOrderDetailResponse.fromJson(Map<String, dynamic> json) {
    waybill =
        json['waybill'] != null ? new Waybill.fromJson(json['waybill']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.waybill != null) {
      data['waybill'] = this.waybill!.toJson();
    }
    return data;
  }
}

class Waybill {
  String? waybillId;
  Customer? customer;
  bool? direction;
  int? transactionTypeId;
  String? transactionTypeName;
  String? erpInvoiceRef;
  String? ficheNo;
  String? ficheDate;
  String? ficheTime;
  String? docNo;
  String? shippDate;
  String? createdDate;
  Workplace? workplace;
  Department? department;
  Warehouse? warehouse;
  int? cancelled;
  String? description;
  double? totaldiscounted;
  double? totalvat;
  double? grossTotal;
  int? currencyId;
  String? currencyName;
  Transporter? transporter;
  Salesman? salesman;
  ShippingType? shippingType;
  int? waybillStatusId;
  String? waybillStatusName;
  Customer? shippingAccount;
  ShippingAddress? shippingAddress;
  List<WaybillItems>? waybillItems;
  String? erpId;
  String? erpCode;
  Project? project;

  Waybill({
    this.waybillId,
    this.customer,
    this.direction,
    this.transactionTypeId,
    this.transactionTypeName,
    this.erpInvoiceRef,
    this.ficheNo,
    this.ficheDate,
    this.ficheTime,
    this.docNo,
    this.shippDate,
    this.createdDate,
    this.workplace,
    this.department,
    this.warehouse,
    this.cancelled,
    this.description,
    this.totaldiscounted,
    this.totalvat,
    this.grossTotal,
    this.currencyId,
    this.currencyName,
    this.transporter,
    this.salesman,
    this.shippingType,
    this.waybillStatusId,
    this.waybillStatusName,
    this.shippingAccount,
    this.shippingAddress,
    this.waybillItems,
    this.erpId,
    this.erpCode,
    this.project,
  });

  Waybill.fromJson(Map<String, dynamic> json) {
    waybillId = json['waybillId'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    direction = json['direction'];
    transactionTypeId = json['transactionTypeId'];
    transactionTypeName = json['transactionTypeName'];
    erpInvoiceRef = json['erpInvoiceRef'];
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    ficheTime = json['ficheTime'];
    docNo = json['docNo'];
    shippDate = json['shippDate'];
    createdDate = json['createdDate'];
    workplace = json['workplace'] != null
        ? new Workplace.fromJson(json['workplace'])
        : null;
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
    cancelled = json['cancelled'];
    description = json['description_'];
    totaldiscounted = json['totaldiscounted'];
    totalvat = json['totalvat'];
    grossTotal = json['grossTotal'];
    currencyId = json['currencyId'];
    currencyName = json['currencyName'];
    transporter = json['transporter'] != null
        ? new Transporter.fromJson(json['transporter'])
        : null;
    salesman = json['salesman'] != null
        ? new Salesman.fromJson(json['salesman'])
        : null;
    shippingType = json['shippingType'] != null
        ? new ShippingType.fromJson(json['shippingType'])
        : null;
    waybillStatusId = json['waybillStatusId'];
    waybillStatusName = json['waybillStatusName'];
    shippingAccount = json['shippingAccount'] != null
        ? new Customer.fromJson(json['shippingAccount'])
        : null;
    shippingAddress = json['shippingAddress'] != null
        ? new ShippingAddress.fromJson(json['shippingAddress'])
        : null;
    if (json['waybillItems'] != null) {
      waybillItems = <WaybillItems>[];
      json['waybillItems'].forEach((v) {
        waybillItems!.add(new WaybillItems.fromJson(v));
      });
    }
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    project =
        json['project'] != null ? new Project.fromJson(json['project']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waybillId'] = this.waybillId;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['direction'] = this.direction;
    data['transactionTypeId'] = this.transactionTypeId;
    data['transactionTypeName'] = this.transactionTypeName;
    data['erpInvoiceRef'] = this.erpInvoiceRef;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['ficheTime'] = this.ficheTime;
    data['docNo'] = this.docNo;
    data['shippDate'] = this.shippDate;
    data['createdDate'] = this.createdDate;
    if (this.workplace != null) {
      data['workplace'] = this.workplace!.toJson();
    }
    if (this.department != null) {
      data['department'] = this.department!.toJson();
    }
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.toJson();
    }
    data['cancelled'] = this.cancelled;
    data['description_'] = this.description;
    data['totaldiscounted'] = this.totaldiscounted;
    data['totalvat'] = this.totalvat;
    data['grossTotal'] = this.grossTotal;
    data['currencyId'] = this.currencyId;
    data['currencyName'] = this.currencyName;
    if (this.transporter != null) {
      data['transporter'] = this.transporter!.toJson();
    }
    if (this.salesman != null) {
      data['salesman'] = this.salesman!.toJson();
    }
    if (this.shippingType != null) {
      data['shippingType'] = this.shippingType!.toJson();
    }
    data['waybillStatusId'] = this.waybillStatusId;
    data['waybillStatusName'] = this.waybillStatusName;
    if (this.shippingAccount != null) {
      data['shippingAccount'] = this.shippingAccount!.toJson();
    }
    if (this.shippingAddress != null) {
      data['shippingAddress'] = this.shippingAddress!.toJson();
    }
    if (this.waybillItems != null) {
      data['waybillItems'] = this.waybillItems!.map((v) => v.toJson()).toList();
    }
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
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

class ShippingType {
  String? shippingTypeId;
  String? code;
  String? definition;

  ShippingType({this.shippingTypeId, this.code, this.definition});

  ShippingType.fromJson(Map<String, dynamic> json) {
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

class WaybillItems {
  String? waybillItemId;
  Product? product;
  int? transactionTypeId;
  String? description;
  String? warehouseId;
  String? warehouseName;
  int? lineNr;
  double? productPrice;
  double? qty;
  double? total;
  double? discount;
  double? tax;
  double? nettotal;
  String? unitId;
  String? unitName;
  String? unitConversionId;
  String? unitConversionName;
  String? productLocationId;
  int? currencyId;
  String? currencyName;
  String? erpId;
  String? erpCode;
  Project? project;

  WaybillItems({
    this.waybillItemId,
    this.product,
    this.transactionTypeId,
    this.description,
    this.warehouseId,
    this.warehouseName,
    this.lineNr,
    this.productPrice,
    this.qty,
    this.total,
    this.discount,
    this.tax,
    this.nettotal,
    this.unitId,
    this.unitName,
    this.unitConversionId,
    this.unitConversionName,
    this.productLocationId,
    this.currencyId,
    this.currencyName,
    this.erpId,
    this.erpCode,
    this.project,
  });

  WaybillItems.fromJson(Map<String, dynamic> json) {
    waybillItemId = json['waybillItemId'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    transactionTypeId = json['transactionTypeId'];
    description = json['description_'];
    warehouseId = json['warehouseId'];
    warehouseName = json['warehouseName'];
    lineNr = json['lineNr'];
    productPrice = json['productPrice'];
    qty = json['qty'];
    total = json['total'];
    discount = json['discount'];
    tax = json['tax'];
    nettotal = json['nettotal'];
    unitId = json['unitId'];
    unitName = json['unitName'];
    unitConversionId = json['unitConversionId'];
    unitConversionName = json['unitConversionName'];
    productLocationId = json['productLocationId'];
    currencyId = json['currencyId'];
    currencyName = json['currencyName'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    project =
        json['project'] != null ? new Project.fromJson(json['project']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waybillItemId'] = this.waybillItemId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['transactionTypeId'] = this.transactionTypeId;
    data['description_'] = this.description;
    data['warehouseId'] = this.warehouseId;
    data['warehouseName'] = this.warehouseName;
    data['lineNr'] = this.lineNr;
    data['productPrice'] = this.productPrice;
    data['qty'] = this.qty;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['nettotal'] = this.nettotal;
    data['unitId'] = this.unitId;
    data['unitName'] = this.unitName;
    data['unitConversionId'] = this.unitConversionId;
    data['unitConversionName'] = this.unitConversionName;
    data['productLocationId'] = this.productLocationId;
    data['currencyId'] = this.currencyId;
    data['currencyName'] = this.currencyName;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    if (this.project != null) {
      data['project'] = this.project!.toJson();
    }
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
  int? productItemTypeId;
  Null? productItemTypeName;
  Brand? brand;

  Product(
      {this.productId,
      this.code,
      this.definition,
      this.definition2,
      this.isProductLocatin,
      this.barcode,
      this.productTrackingMethod,
      this.productItemTypeId,
      this.productItemTypeName,
      this.brand});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    code = json['code'];
    definition = json['definition'];
    definition2 = json['definition2'];
    isProductLocatin = json['isProductLocatin'];
    barcode = json['barcode'];
    productTrackingMethod = json['productTrackingMethod'];
    productItemTypeId = json['productItemTypeId'];
    productItemTypeName = json['productItemTypeName'];
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
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
    data['productItemTypeId'] = this.productItemTypeId;
    data['productItemTypeName'] = this.productItemTypeName;
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    return data;
  }
}

class Brand {
  String? brandId;
  String? name;
  String? erpId;
  String? erpCode;

  Brand({this.brandId, this.name, this.erpId, this.erpCode});

  Brand.fromJson(Map<String, dynamic> json) {
    brandId = json['brandId'];
    name = json['name'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandId'] = this.brandId;
    data['name'] = this.name;
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
