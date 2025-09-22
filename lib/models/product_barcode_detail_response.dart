class ProductBarcodeDetailResponse {
  Data? data;

  ProductBarcodeDetailResponse({this.data});

  ProductBarcodeDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  ProductDetail? product;
  PorductUnit? unit;
  UnitConversion? unitConversion;
  String? barcode;

  Data({this.product, this.unit, this.unitConversion, this.barcode});

  Data.fromJson(Map<String, dynamic> json) {
    product = json['product'] != null
        ? new ProductDetail.fromJson(json['product'])
        : null;
    unit = json['unit'] != null ? new PorductUnit.fromJson(json['unit']) : null;
    unitConversion = json['unitConversion'] != null
        ? new UnitConversion.fromJson(json['unitConversion'])
        : null;
    barcode = json['barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.unit != null) {
      data['unit'] = this.unit!.toJson();
    }
    if (this.unitConversion != null) {
      data['unitConversion'] = this.unitConversion!.toJson();
    }
    data['barcode'] = this.barcode;
    return data;
  }
}

class ProductDetail {
  String? productId;
  String? code;
  String? definition;
  String? definition2;
  int? vatRate;
  Brand? brand;
  bool? isActive;
  bool? isProductLocatin;
  String? barcode;
  ProductInUnit? unit;
  String? erpId;
  String? erpCode;
  String? productTrackingMethod;
  int? productItemTypeId;
  int? onHandStock;
  int? realStock;

  ProductDetail(
      {this.productId,
      this.code,
      this.definition,
      this.definition2,
      this.vatRate,
      this.brand,
      this.isActive,
      this.isProductLocatin,
      this.barcode,
      this.unit,
      this.erpId,
      this.erpCode,
      this.productTrackingMethod,
      this.productItemTypeId,
      this.onHandStock,
      this.realStock});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    code = json['code'];
    definition = json['definition'];
    definition2 = json['definition2'];
    vatRate = json['vatRate'];
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    isActive = json['isActive'];
    isProductLocatin = json['isProductLocatin'];
    barcode = json['barcode'];
    unit =
        json['unit'] != null ? new ProductInUnit.fromJson(json['unit']) : null;
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    productTrackingMethod = json['productTrackingMethod'];
    productItemTypeId = json['productItemTypeId'];
    onHandStock = json['onHandStock'];
    realStock = json['realStock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    data['definition2'] = this.definition2;
    data['vatRate'] = this.vatRate;
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    data['isActive'] = this.isActive;
    data['isProductLocatin'] = this.isProductLocatin;
    data['barcode'] = this.barcode;
    if (this.unit != null) {
      data['unit'] = this.unit!.toJson();
    }
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    data['productTrackingMethod'] = this.productTrackingMethod;
    data['productItemTypeId'] = this.productItemTypeId;
    data['onHandStock'] = this.onHandStock;
    data['realStock'] = this.realStock;
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

class ProductInUnit {
  String? unitId;
  String? description;
  String? code;
  List<Conversions>? conversions;

  ProductInUnit({this.unitId, this.description, this.code, this.conversions});

  ProductInUnit.fromJson(Map<String, dynamic> json) {
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

class PorductUnit {
  String? unitId;
  String? description;
  String? code;

  PorductUnit({this.unitId, this.description, this.code});

  PorductUnit.fromJson(Map<String, dynamic> json) {
    unitId = json['unitId'];
    description = json['description'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitId'] = this.unitId;
    data['description'] = this.description;
    data['code'] = this.code;
    return data;
  }
}

class UnitConversion {
  String? unitConversionId;
  String? code;
  String? description;
  int? convParam1;
  int? convParam2;
  int? height;
  int? width;
  int? length;
  int? weight;

  UnitConversion(
      {this.unitConversionId,
      this.code,
      this.description,
      this.convParam1,
      this.convParam2,
      this.height,
      this.width,
      this.length,
      this.weight});

  UnitConversion.fromJson(Map<String, dynamic> json) {
    unitConversionId = json['unitConversionId'];
    code = json['code'];
    description = json['description'];
    convParam1 = json['convParam1'];
    convParam2 = json['convParam2'];
    height = json['height'];
    width = json['width'];
    length = json['length'];
    weight = json['weight'];
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
    return data;
  }
}
