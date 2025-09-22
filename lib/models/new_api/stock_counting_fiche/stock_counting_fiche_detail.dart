class StockCountingFicheDetail {
  StockCountingFiche? stockCountingFiche;

  StockCountingFicheDetail({this.stockCountingFiche});

  StockCountingFicheDetail.fromJson(Map<String, dynamic> json) {
    stockCountingFiche = json['stockCountingFiche'] != null
        ? new StockCountingFiche.fromJson(json['stockCountingFiche'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stockCountingFiche != null) {
      data['stockCountingFiche'] = this.stockCountingFiche!.toJson();
    }
    return data;
  }
}

class StockCountingFiche {
  String? stockCountingFicheId;
  String? ficheNo;
  String? ficheDate;
  String? countingStartDate;
  String? description;
  StockCountingTeam? stockCountingTeam;
  Warehouse? warehouse;
  List<StockCountingFicheItems>? stockCountingFicheItems;
  bool? isClosed;
  String? erpId;
  String? erpCode;

  StockCountingFiche(
      {this.stockCountingFicheId,
      this.ficheNo,
      this.ficheDate,
      this.countingStartDate,
      this.description,
      this.stockCountingTeam,
      this.warehouse,
      this.stockCountingFicheItems,
      this.isClosed,
      this.erpId,
      this.erpCode});

  StockCountingFiche.fromJson(Map<String, dynamic> json) {
    stockCountingFicheId = json['stockCountingFicheId'];
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    countingStartDate = json['countingStartDate'];
    description = json['description_'];
    stockCountingTeam = json['stockCountingTeam'] != null
        ? new StockCountingTeam.fromJson(json['stockCountingTeam'])
        : null;
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
    if (json['stockCountingFicheItems'] != null) {
      stockCountingFicheItems = <StockCountingFicheItems>[];
      json['stockCountingFicheItems'].forEach((v) {
        stockCountingFicheItems!.add(new StockCountingFicheItems.fromJson(v));
      });
    }
    isClosed = json['isClosed'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockCountingFicheId'] = this.stockCountingFicheId;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['countingStartDate'] = this.countingStartDate;
    data['description_'] = this.description;
    if (this.stockCountingTeam != null) {
      data['stockCountingTeam'] = this.stockCountingTeam!.toJson();
    }
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.toJson();
    }
    if (this.stockCountingFicheItems != null) {
      data['stockCountingFicheItems'] =
          this.stockCountingFicheItems!.map((v) => v.toJson()).toList();
    }
    data['isClosed'] = this.isClosed;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    return data;
  }
}

class StockCountingTeam {
  String? stockCountingTeamId;
  String? name;
  String? surName;
  bool? isManager;
  String? otherTeamMembers;
  String? userId;

  StockCountingTeam(
      {this.stockCountingTeamId,
      this.name,
      this.surName,
      this.isManager,
      this.otherTeamMembers,
      this.userId});

  StockCountingTeam.fromJson(Map<String, dynamic> json) {
    stockCountingTeamId = json['stockCountingTeamId'];
    name = json['name'];
    surName = json['surName'];
    isManager = json['isManager'];
    otherTeamMembers = json['otherTeamMembers'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockCountingTeamId'] = this.stockCountingTeamId;
    data['name'] = this.name;
    data['surName'] = this.surName;
    data['isManager'] = this.isManager;
    data['otherTeamMembers'] = this.otherTeamMembers;
    data['userId'] = this.userId;
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

class StockCountingFicheItems {
  String? stockCountingFicheItemId;
  Product? product;
  int? lineNr;
  String? description;
  double? qty;
  String? unitId;
  String? unitName;
  String? unitConversionId;
  String? unitConversionName;
  Unit? unit;
  StockLocation? stockLocation;
  String? erpId;
  String? erpCode;

  StockCountingFicheItems(
      {this.stockCountingFicheItemId,
      this.product,
      this.lineNr,
      this.description,
      this.qty,
      this.unitId,
      this.unitName,
      this.unitConversionId,
      this.unitConversionName,
      this.unit,
      this.stockLocation,
      this.erpId,
      this.erpCode});

  StockCountingFicheItems.fromJson(Map<String, dynamic> json) {
    stockCountingFicheItemId = json['stockCountingFicheItemId'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    lineNr = json['lineNr'];
    description = json['description_'];
    qty = json['qty'];
    unitId = json['unitId'];
    unitName = json['unitName'];
    unitConversionId = json['unitConversionId'];
    unitConversionName = json['unitConversionName'];
    unit = json['unit'] != null ? new Unit.fromJson(json['unit']) : null;
    stockLocation = json['stockLocation'] != null
        ? new StockLocation.fromJson(json['stockLocation'])
        : null;
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockCountingFicheItemId'] = this.stockCountingFicheItemId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['lineNr'] = this.lineNr;
    data['description_'] = this.description;
    data['qty'] = this.qty;
    data['unitId'] = this.unitId;
    data['unitName'] = this.unitName;
    data['unitConversionId'] = this.unitConversionId;
    data['unitConversionName'] = this.unitConversionName;
    if (this.unit != null) {
      data['unit'] = this.unit!.toJson();
    }
    if (this.stockLocation != null) {
      data['stockLocation'] = this.stockLocation!.toJson();
    }
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
  int? productItemTypeId;
  String? productItemTypeName;
  String? manufacturer;
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
      this.manufacturer,
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
    manufacturer = json['manufacturer'];
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
    data['manufacturer'] = this.manufacturer;
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

class Unit {
  String? unitId;
  String? description;
  String? code;
  List<Conversions>? conversions;

  Unit({this.unitId, this.description, this.code, this.conversions});

  Unit.fromJson(Map<String, dynamic> json) {
    unitId = json['unitId'];
    description = json['description'];
    code = json['code'];
    if (json['conversions'] != null) {
      conversions = <Conversions>[];
      json['conversions'].forEach((v) {
        conversions!.add(new Conversions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitId'] = this.unitId;
    data['description'] = this.description;
    data['code'] = this.code;
    if (this.conversions != null) {
      data['conversions'] = this.conversions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Conversions {
  String? unitConversionId;
  String? code;
  String? description;
  int? convParam1;
  int? convParam2;
  int? height;
  int? width;
  int? length;
  int? weight;
  List<Barcodes>? barcodes;

  Conversions(
      {this.unitConversionId,
      this.code,
      this.description,
      this.convParam1,
      this.convParam2,
      this.height,
      this.width,
      this.length,
      this.weight,
      this.barcodes});

  Conversions.fromJson(Map<String, dynamic> json) {
    unitConversionId = json['unitConversionId'];
    code = json['code'];
    description = json['description'];
    convParam1 = json['convParam1'];
    convParam2 = json['convParam2'];
    height = json['height'];
    width = json['width'];
    length = json['length'];
    weight = json['weight'];
    if (json['barcodes'] != null) {
      barcodes = <Barcodes>[];
      json['barcodes'].forEach((v) {
        barcodes!.add(new Barcodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitConversionId'] = this.unitConversionId;
    data['code'] = this.code;
    data['description'] = this.description;
    data['convParam1'] = this.convParam1;
    data['convParam2'] = this.convParam2;
    data['height'] = this.height;
    data['width'] = this.width;
    data['length'] = this.length;
    data['weight'] = this.weight;
    if (this.barcodes != null) {
      data['barcodes'] = this.barcodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Barcodes {
  String? productBarcodeId;
  String? barcode;

  Barcodes({this.productBarcodeId, this.barcode});

  Barcodes.fromJson(Map<String, dynamic> json) {
    productBarcodeId = json['productBarcodeId'];
    barcode = json['barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productBarcodeId'] = this.productBarcodeId;
    data['barcode'] = this.barcode;
    return data;
  }
}

class StockLocation {
  String? stockLocationId;
  String? code;
  String? name;
  String? barcode;

  StockLocation({this.stockLocationId, this.code, this.name, this.barcode});

  StockLocation.fromJson(Map<String, dynamic> json) {
    stockLocationId = json['stockLocationId'];
    code = json['code'];
    name = json['name'];
    barcode = json['barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockLocationId'] = this.stockLocationId;
    data['code'] = this.code;
    data['name'] = this.name;
    data['barcode'] = this.barcode;
    return data;
  }
}
