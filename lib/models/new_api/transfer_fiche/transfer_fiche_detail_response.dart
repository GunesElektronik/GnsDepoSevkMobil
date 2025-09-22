class TransferFicheDetailResponse {
  TransferFiche? transferFiche;

  TransferFicheDetailResponse({this.transferFiche});

  TransferFicheDetailResponse.fromJson(Map<String, dynamic> json) {
    transferFiche = json['transferFiche'] != null
        ? new TransferFiche.fromJson(json['transferFiche'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transferFiche != null) {
      data['transferFiche'] = this.transferFiche!.toJson();
    }
    return data;
  }
}

class TransferFiche {
  String? transferFicheId;
  bool? direction;
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
  List<TransferFicheItems>? transferFicheItems;
  Project? project;

  TransferFiche({
    this.transferFicheId,
    this.direction,
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
    this.transferFicheItems,
    this.project,
  });

  TransferFiche.fromJson(Map<String, dynamic> json) {
    transferFicheId = json['transferFicheId'];
    direction = json['direction'];
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
    if (json['transferFicheItems'] != null) {
      transferFicheItems = <TransferFicheItems>[];
      json['transferFicheItems'].forEach((v) {
        transferFicheItems!.add(new TransferFicheItems.fromJson(v));
      });
    }

    project =
        json['project'] != null ? new Project.fromJson(json['project']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transferFicheId'] = this.transferFicheId;
    data['direction'] = this.direction;
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
    if (this.transferFicheItems != null) {
      data['transferFicheItems'] =
          this.transferFicheItems!.map((v) => v.toJson()).toList();
    }
    if (this.project != null) {
      data['project'] = this.project!.toJson();
    }
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

class TransferFicheItems {
  String? transferFicheItemId;
  Product? product;
  int? transactionTypeId;
  String? transactionTypeName;
  // double? linenr;
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
  int? productLocationId;
  String? productLocationName;
  Project? project;

  TransferFicheItems({
    this.transferFicheItemId,
    this.product,
    this.transactionTypeId,
    this.transactionTypeName,
    // this.linenr,
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

  TransferFicheItems.fromJson(Map<String, dynamic> json) {
    transferFicheItemId = json['transferFicheItemId'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    transactionTypeId = json['transactionTypeId'];
    transactionTypeName = json['transactionTypeName'];
    // linenr = json['linenr'];
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
    data['transferFicheItemId'] = this.transferFicheItemId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['transactionTypeId'] = this.transactionTypeId;
    data['transactionTypeName'] = this.transactionTypeName;
    // data['linenr'] = this.linenr;
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
