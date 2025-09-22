class StockLocationsListResponse {
  StockLocations? stockLocations;

  StockLocationsListResponse({this.stockLocations});

  StockLocationsListResponse.fromJson(Map<String, dynamic> json) {
    stockLocations = json['stockLocations'] != null
        ? new StockLocations.fromJson(json['stockLocations'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stockLocations != null) {
      data['stockLocations'] = this.stockLocations!.toJson();
    }
    return data;
  }
}

class StockLocations {
  List<Items>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  StockLocations({this.items, this.totalItems, this.page, this.pageSize});

  StockLocations.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
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

class Items {
  String? stockLocationId;
  String? code;
  String? name;
  String? barcode;
  String? description;
  StockLocationStreet? stockLocationStreet;
  Warehouse? warehouse;
  double? height;
  double? width;
  double? length;
  double? weight;
  double? maxDesi;
  double? maxWeight;
  String? erpId;
  String? erpCode;

  Items(
      {this.stockLocationId,
      this.code,
      this.name,
      this.barcode,
      this.description,
      this.stockLocationStreet,
      this.warehouse,
      this.height,
      this.width,
      this.length,
      this.weight,
      this.maxDesi,
      this.maxWeight,
      this.erpId,
      this.erpCode});

  Items.fromJson(Map<String, dynamic> json) {
    stockLocationId = json['stockLocationId'];
    code = json['code'];
    name = json['name'];
    barcode = json['barcode'];
    description = json['description'];
    stockLocationStreet = json['stockLocationStreet'] != null
        ? new StockLocationStreet.fromJson(json['stockLocationStreet'])
        : null;
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
    height = json['height'];
    width = json['width'];
    length = json['length'];
    weight = json['weight'];
    maxDesi = json['maxDesi'];
    maxWeight = json['maxWeight'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockLocationId'] = this.stockLocationId;
    data['code'] = this.code;
    data['name'] = this.name;
    data['barcode'] = this.barcode;
    data['description'] = this.description;
    if (this.stockLocationStreet != null) {
      data['stockLocationStreet'] = this.stockLocationStreet!.toJson();
    }
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.toJson();
    }
    data['height'] = this.height;
    data['width'] = this.width;
    data['length'] = this.length;
    data['weight'] = this.weight;
    data['maxDesi'] = this.maxDesi;
    data['maxWeight'] = this.maxWeight;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
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

class Warehouse {
  String? warehouseId;
  String? code;
  String? definition;
  int? groupCode1;
  int? groupCode2;

  Warehouse({
    this.warehouseId,
    this.code,
    this.definition,
    this.groupCode1,
    this.groupCode2,
  });

  Warehouse.fromJson(Map<String, dynamic> json) {
    warehouseId = json['warehouseId'];
    code = json['code'];
    definition = json['definition'];

    groupCode1 = json['groupCode1'];
    groupCode2 = json['groupCode2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warehouseId'] = this.warehouseId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    ;
    data['groupCode1'] = this.groupCode1;
    data['groupCode2'] = this.groupCode2;
    return data;
  }
}
