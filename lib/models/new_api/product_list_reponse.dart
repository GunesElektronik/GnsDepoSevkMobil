class ProductListReponse {
  Products? products;

  ProductListReponse({this.products});

  ProductListReponse.fromJson(Map<String, dynamic> json) {
    products = json['products'] != null
        ? new Products.fromJson(json['products'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    return data;
  }
}

class Products {
  List<ProductItems>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  Products({this.items, this.totalItems, this.page, this.pageSize});

  Products.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ProductItems>[];
      json['items'].forEach((v) {
        items!.add(new ProductItems.fromJson(v));
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

class ProductItems {
  String? productId;
  String? code;
  String? definition;
  String? definition2;
  int? vatRate;
  Brand? brand;
  String? manufacturer;
  bool? isActive;
  bool? isProductLocatin;
  String? barcode;
  Unit? unit;
  String? erpId;
  String? erpCode;
  String? productTrackingMethod;
  int? productItemTypeId;
  double? onHandStock;
  double? realStock;

  ProductItems({
    this.productId,
    this.code,
    this.definition,
    this.definition2,
    this.vatRate,
    this.brand,
    this.manufacturer,
    this.isActive,
    this.isProductLocatin,
    this.barcode,
    this.unit,
    this.erpId,
    this.erpCode,
    this.productTrackingMethod,
    this.productItemTypeId,
    this.onHandStock,
    this.realStock,
  });

  ProductItems.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    code = json['code'];
    definition = json['definition'];
    definition2 = json['definition2'];
    vatRate = json['vatRate'];
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    manufacturer = json['manufacturer'];
    isActive = json['isActive'];
    isProductLocatin = json['isProductLocatin'];
    barcode = json['barcode'];
    unit = json['unit'] != null ? new Unit.fromJson(json['unit']) : null;
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
    data['manufacturer'] = this.manufacturer;
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
  double? height;
  double? width;
  double? length;
  double? weight;
  String? barcodes;

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
    barcodes = json['barcodes'];
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
    data['barcodes'] = this.barcodes;
    return data;
  }
}
