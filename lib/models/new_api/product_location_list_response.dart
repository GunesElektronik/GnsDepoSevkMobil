class ProductLocationResponse {
  List<ProductLocations>? productLocations;

  ProductLocationResponse({this.productLocations});

  ProductLocationResponse.fromJson(Map<String, dynamic> json) {
    if (json['productLocations'] != null) {
      productLocations = <ProductLocations>[];
      json['productLocations'].forEach((v) {
        productLocations!.add(new ProductLocations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productLocations != null) {
      data['productLocations'] =
          this.productLocations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductLocations {
  String? productLocationRelationId;
  Product? product;
  Warehouse? warehouse;
  StockLocationStreet? stockLocationStreet;
  StockLocation? stockLocation;
  String? erpId;
  String? erpCode;

  ProductLocations(
      {this.productLocationRelationId,
      this.product,
      this.warehouse,
      this.stockLocationStreet,
      this.stockLocation,
      this.erpId,
      this.erpCode});

  ProductLocations.fromJson(Map<String, dynamic> json) {
    productLocationRelationId = json['productLocationRelationId'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
    stockLocationStreet = json['stockLocationStreet'] != null
        ? new StockLocationStreet.fromJson(json['stockLocationStreet'])
        : null;
    stockLocation = json['stockLocation'] != null
        ? new StockLocation.fromJson(json['stockLocation'])
        : null;
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productLocationRelationId'] = this.productLocationRelationId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.toJson();
    }
    if (this.stockLocationStreet != null) {
      data['stockLocationStreet'] = this.stockLocationStreet!.toJson();
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

  Product({this.productId, this.code, this.definition});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    code = json['code'];
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
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

class StockLocationStreet {
  String? stockLocationStreetId;
  String? code;
  String? definition;

  StockLocationStreet({this.stockLocationStreetId, this.code, this.definition});

  StockLocationStreet.fromJson(Map<String, dynamic> json) {
    stockLocationStreetId = json['stockLocationStreetId'];
    code = json['code'];
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockLocationStreetId'] = this.stockLocationStreetId;
    data['code'] = this.code;
    data['definition'] = this.definition;
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
