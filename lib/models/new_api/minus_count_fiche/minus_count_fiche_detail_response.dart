class MinusCountFicheDetailResponse {
  MinusCountFiche? minusCountFiche;

  MinusCountFicheDetailResponse({this.minusCountFiche});

  MinusCountFicheDetailResponse.fromJson(Map<String, dynamic> json) {
    minusCountFiche = json['minusCountFiche'] != null
        ? new MinusCountFiche.fromJson(json['minusCountFiche'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.minusCountFiche != null) {
      data['minusCountFiche'] = this.minusCountFiche!.toJson();
    }
    return data;
  }
}

class MinusCountFiche {
  String? minusCountFicheId;
  bool? direction;
  Customer? customer;
  int? transactionTypeId;
  String? transactionTypeName;
  String? ficheNo;
  String? ficheDate;
  String? ficheTime;
  String? docNo;
  InWorkplace? inWorkplace;
  InDepartment? inDepartment;
  InWarehouse? inWarehouse;
  int? cancelled;
  String? description;
  // Null? transporter;
  CustomerAddress? customerAddress;
  List<MinusCountFicheItems>? minusCountFicheItems;
  Project? project;

  MinusCountFiche({
    this.minusCountFicheId,
    this.direction,
    this.customer,
    this.transactionTypeId,
    this.transactionTypeName,
    this.ficheNo,
    this.ficheDate,
    this.ficheTime,
    this.docNo,
    this.inWorkplace,
    this.inDepartment,
    this.inWarehouse,
    this.cancelled,
    this.description,
    // this.transporter,
    this.customerAddress,
    this.minusCountFicheItems,
    this.project,
  });

  MinusCountFiche.fromJson(Map<String, dynamic> json) {
    minusCountFicheId = json['minusCountFicheId'];
    direction = json['direction'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    transactionTypeId = json['transactionTypeId'];
    transactionTypeName = json['transactionTypeName'];
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    ficheTime = json['ficheTime'];
    docNo = json['docNo'];
    inWorkplace = json['inWorkplace'] != null
        ? new InWorkplace.fromJson(json['inWorkplace'])
        : null;
    inDepartment = json['inDepartment'] != null
        ? new InDepartment.fromJson(json['inDepartment'])
        : null;
    inWarehouse = json['inWarehouse'] != null
        ? new InWarehouse.fromJson(json['inWarehouse'])
        : null;
    cancelled = json['cancelled'];
    description = json['description'];
    // transporter = json['transporter'];
    customerAddress = json['customerAddress'] != null
        ? new CustomerAddress.fromJson(json['customerAddress'])
        : null;
    if (json['minusCountFicheItems'] != null) {
      minusCountFicheItems = <MinusCountFicheItems>[];
      json['minusCountFicheItems'].forEach((v) {
        minusCountFicheItems!.add(new MinusCountFicheItems.fromJson(v));
      });
    }
    project =
        json['project'] != null ? new Project.fromJson(json['project']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minusCountFicheId'] = this.minusCountFicheId;
    data['direction'] = this.direction;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['transactionTypeId'] = this.transactionTypeId;
    data['transactionTypeName'] = this.transactionTypeName;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['ficheTime'] = this.ficheTime;
    data['docNo'] = this.docNo;
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
    // data['transporter'] = this.transporter;
    if (this.customerAddress != null) {
      data['customerAddress'] = this.customerAddress!.toJson();
    }
    if (this.minusCountFicheItems != null) {
      data['minusCountFicheItems'] =
          this.minusCountFicheItems!.map((v) => v.toJson()).toList();
    }
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

class InWorkplace {
  String? workplaceId;
  String? code;
  String? definition;

  InWorkplace({this.workplaceId, this.code, this.definition});

  InWorkplace.fromJson(Map<String, dynamic> json) {
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

class InDepartment {
  String? departmentId;
  String? code;
  String? definition;

  InDepartment({this.departmentId, this.code, this.definition});

  InDepartment.fromJson(Map<String, dynamic> json) {
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

class InWarehouse {
  String? warehouseId;
  String? code;
  String? definition;

  InWarehouse({this.warehouseId, this.code, this.definition});

  InWarehouse.fromJson(Map<String, dynamic> json) {
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

class CustomerAddress {
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

  CustomerAddress(
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

  CustomerAddress.fromJson(Map<String, dynamic> json) {
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

class MinusCountFicheItems {
  String? minusCountFicheItemId;
  Product? product;
  int? transactionTypeId;
  String? transactionTypeName;
  int? linenr;
  String? description;
  bool? direction;
  String? outWarehouse;
  InWarehouse? inWarehouse;
  String? unitId;
  String? unitCode;
  String? unitConversionId;
  String? unitConversionCode;
  String? erpId;
  String? erpCode;
  double? qty;
  String? productLocationId;
  String? productLocationName;
  Project? project;

  MinusCountFicheItems({
    this.minusCountFicheItemId,
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
    this.productLocationName,
    this.project,
  });

  MinusCountFicheItems.fromJson(Map<String, dynamic> json) {
    minusCountFicheItemId = json['minusCountFicheItemId'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    transactionTypeId = json['transactionTypeId'];
    transactionTypeName = json['transactionTypeName'];
    linenr = json['linenr'];
    description = json['description'];
    direction = json['direction'];
    outWarehouse = json['outWarehouse'];
    inWarehouse = json['inWarehouse'] != null
        ? new InWarehouse.fromJson(json['inWarehouse'])
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
    project =
        json['project'] != null ? new Project.fromJson(json['project']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minusCountFicheItemId'] = this.minusCountFicheItemId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['transactionTypeId'] = this.transactionTypeId;
    data['transactionTypeName'] = this.transactionTypeName;
    data['linenr'] = this.linenr;
    data['description'] = this.description;
    data['direction'] = this.direction;
    data['outWarehouse'] = this.outWarehouse;
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
  String? productItemTypeName;
  // Null? brand;

  Product({
    this.productId,
    this.code,
    this.definition,
    this.definition2,
    this.isProductLocatin,
    this.barcode,
    this.productTrackingMethod,
    this.productItemTypeId,
    this.productItemTypeName,
    // this.brand,
  });

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
    // brand = json['brand'];
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
    // data['brand'] = this.brand;
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
