class WarehouseTransferListResponse {
  WarehouseTransfers? warehouseTransfers;

  WarehouseTransferListResponse({this.warehouseTransfers});

  WarehouseTransferListResponse.fromJson(Map<String, dynamic> json) {
    warehouseTransfers = json['warehouseTransfers'] != null
        ? new WarehouseTransfers.fromJson(json['warehouseTransfers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.warehouseTransfers != null) {
      data['warehouseTransfers'] = this.warehouseTransfers!.toJson();
    }
    return data;
  }
}

class WarehouseTransfers {
  List<WarehouseTransferListItems>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  WarehouseTransfers({this.items, this.totalItems, this.page, this.pageSize});

  WarehouseTransfers.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <WarehouseTransferListItems>[];
      json['items'].forEach((v) {
        items!.add(new WarehouseTransferListItems.fromJson(v));
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

class WarehouseTransferListItems {
  String? warehouseTransferId;
  Customer? customer;
  bool? direction;
  int? transactionTypeId;
  String? transactionTypeName;
  String? ficheNo;
  String? ficheDate;
  String? ficheTime;
  String? docNo;
  OutWorkplace? outWorkplace;
  OutDepartment? outDepartment;
  OutWarehouse? outWarehouse;
  OutWorkplace? inWorkplace;
  OutDepartment? inDepartment;
  OutWarehouse? inWarehouse;
  int? cancelled;
  String? description;
  Transporter? transporter;
  String? customerAddress;
  List<WarehouseTransferItems>? warehouseTransferItems;

  WarehouseTransferListItems(
      {this.warehouseTransferId,
      this.customer,
      this.direction,
      this.transactionTypeId,
      this.transactionTypeName,
      this.ficheNo,
      this.ficheDate,
      this.ficheTime,
      this.docNo,
      this.outWorkplace,
      this.outDepartment,
      this.outWarehouse,
      this.inWorkplace,
      this.inDepartment,
      this.inWarehouse,
      this.cancelled,
      this.description,
      this.transporter,
      this.customerAddress,
      this.warehouseTransferItems});

  WarehouseTransferListItems.fromJson(Map<String, dynamic> json) {
    warehouseTransferId = json['warehouseTransferId'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    direction = json['direction'];
    transactionTypeId = json['transactionTypeId'];
    transactionTypeName = json['transactionTypeName'];
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    ficheTime = json['ficheTime'];
    docNo = json['docNo'];
    outWorkplace = json['outWorkplace'] != null
        ? new OutWorkplace.fromJson(json['outWorkplace'])
        : null;
    outDepartment = json['outDepartment'] != null
        ? new OutDepartment.fromJson(json['outDepartment'])
        : null;
    outWarehouse = json['outWarehouse'] != null
        ? new OutWarehouse.fromJson(json['outWarehouse'])
        : null;
    inWorkplace = json['inWorkplace'] != null
        ? new OutWorkplace.fromJson(json['inWorkplace'])
        : null;
    inDepartment = json['inDepartment'] != null
        ? new OutDepartment.fromJson(json['inDepartment'])
        : null;
    inWarehouse = json['inWarehouse'] != null
        ? new OutWarehouse.fromJson(json['inWarehouse'])
        : null;
    cancelled = json['cancelled'];
    description = json['description'];
    transporter = json['transporter'] != null
        ? new Transporter.fromJson(json['transporter'])
        : null;
    customerAddress = json['customerAddress'];
    if (json['warehouseTransferItems'] != null) {
      warehouseTransferItems = <WarehouseTransferItems>[];
      json['warehouseTransferItems'].forEach((v) {
        warehouseTransferItems!.add(new WarehouseTransferItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warehouseTransferId'] = this.warehouseTransferId;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['direction'] = this.direction;
    data['transactionTypeId'] = this.transactionTypeId;
    data['transactionTypeName'] = this.transactionTypeName;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['ficheTime'] = this.ficheTime;
    data['docNo'] = this.docNo;
    if (this.outWorkplace != null) {
      data['outWorkplace'] = this.outWorkplace!.toJson();
    }
    if (this.outDepartment != null) {
      data['outDepartment'] = this.outDepartment!.toJson();
    }
    if (this.outWarehouse != null) {
      data['outWarehouse'] = this.outWarehouse!.toJson();
    }
    if (this.inWorkplace != null) {
      data['inWorkplace'] = this.inWorkplace!.toJson();
    }
    if (this.inDepartment != null) {
      data['inDepartment'] = this.inDepartment!.toJson();
    }
    if (this.inWarehouse != null) {
      data['inWarehouse'] = this.inWarehouse!.toJson();
    }
    data['cancelled'] = this.cancelled;
    data['description'] = this.description;
    if (this.transporter != null) {
      data['transporter'] = this.transporter!.toJson();
    }
    data['customerAddress'] = this.customerAddress;
    if (this.warehouseTransferItems != null) {
      data['warehouseTransferItems'] =
          this.warehouseTransferItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  String? customerId;
  String? code;
  String? name;

  Customer({this.customerId, this.code, this.name});

  Customer.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class OutWorkplace {
  String? workplaceId;
  String? code;
  String? definition;

  OutWorkplace({this.workplaceId, this.code, this.definition});

  OutWorkplace.fromJson(Map<String, dynamic> json) {
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

class OutDepartment {
  String? departmentId;
  String? code;
  String? definition;

  OutDepartment({this.departmentId, this.code, this.definition});

  OutDepartment.fromJson(Map<String, dynamic> json) {
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

class OutWarehouse {
  String? warehouseId;
  String? code;
  String? definition;

  OutWarehouse({this.warehouseId, this.code, this.definition});

  OutWarehouse.fromJson(Map<String, dynamic> json) {
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

class WarehouseTransferItems {
  String? warehouseTransferItemId;
  Product? product;
  int? transactionTypeId;
  String? transactionTypeName;
  int? linenr;
  String? description;
  bool? direction;
  OutWarehouse? outWarehouse;
  OutWarehouse? inWarehouse;
  String? unitId;
  String? unitCode;
  String? unitConversionId;
  String? unitConversionCode;
  String? erpId;
  String? erpCode;
  double? qty;
  String? productLocationId;
  String? productLocationName;

  WarehouseTransferItems(
      {this.warehouseTransferItemId,
      this.product,
      this.transactionTypeId,
      this.transactionTypeName,
      this.linenr,
      this.description,
      this.direction,
      this.outWarehouse,
      this.inWarehouse,
      this.unitId,
      this.unitCode,
      this.unitConversionId,
      this.unitConversionCode,
      this.erpId,
      this.erpCode,
      this.qty,
      this.productLocationId,
      this.productLocationName});

  WarehouseTransferItems.fromJson(Map<String, dynamic> json) {
    warehouseTransferItemId = json['warehouseTransferItemId'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    transactionTypeId = json['transactionTypeId'];
    transactionTypeName = json['transactionTypeName'];
    linenr = json['linenr'];
    description = json['description'];
    direction = json['direction'];
    outWarehouse = json['outWarehouse'] != null
        ? new OutWarehouse.fromJson(json['outWarehouse'])
        : null;
    inWarehouse = json['inWarehouse'] != null
        ? new OutWarehouse.fromJson(json['inWarehouse'])
        : null;
    unitId = json['unitId'];
    unitCode = json['unitCode'];
    unitConversionId = json['unitConversionId'];
    unitConversionCode = json['unitConversionCode'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    qty = json['qty'];
    productLocationId = json['productLocationId'];
    productLocationName = json['productLocationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warehouseTransferItemId'] = this.warehouseTransferItemId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['transactionTypeId'] = this.transactionTypeId;
    data['transactionTypeName'] = this.transactionTypeName;
    data['linenr'] = this.linenr;
    data['description'] = this.description;
    data['direction'] = this.direction;
    if (this.outWarehouse != null) {
      data['outWarehouse'] = this.outWarehouse!.toJson();
    }
    if (this.inWarehouse != null) {
      data['inWarehouse'] = this.inWarehouse!.toJson();
    }
    data['unitId'] = this.unitId;
    data['unitCode'] = this.unitCode;
    data['unitConversionId'] = this.unitConversionId;
    data['unitConversionCode'] = this.unitConversionCode;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    data['qty'] = this.qty;
    data['productLocationId'] = this.productLocationId;
    data['productLocationName'] = this.productLocationName;
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
  String? productItemTypeName;
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
