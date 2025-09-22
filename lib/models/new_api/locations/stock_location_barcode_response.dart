class StockLocationBarcodeResponse {
  StockLocationBarcode? stockLocation;

  StockLocationBarcodeResponse({this.stockLocation});

  StockLocationBarcodeResponse.fromJson(Map<String, dynamic> json) {
    stockLocation = json['stockLocation'] != null
        ? new StockLocationBarcode.fromJson(json['stockLocation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stockLocation != null) {
      data['stockLocation'] = this.stockLocation!.toJson();
    }
    return data;
  }
}

class StockLocationBarcode {
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

  StockLocationBarcode(
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

  StockLocationBarcode.fromJson(Map<String, dynamic> json) {
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
  String? addr1;
  String? addr2;
  String? townCode;
  String? town;
  String? districtCode;
  String? district;
  String? cityCode;
  String? city;
  String? countryCode;
  String? country;
  String? telNr;
  String? email;
  int? groupCode1;
  String? groupName1;
  int? groupCode2;
  String? groupName2;

  Warehouse(
      {this.warehouseId,
      this.code,
      this.definition,
      this.addr1,
      this.addr2,
      this.townCode,
      this.town,
      this.districtCode,
      this.district,
      this.cityCode,
      this.city,
      this.countryCode,
      this.country,
      this.telNr,
      this.email,
      this.groupCode1,
      this.groupName1,
      this.groupCode2,
      this.groupName2});

  Warehouse.fromJson(Map<String, dynamic> json) {
    warehouseId = json['warehouseId'];
    code = json['code'];
    definition = json['definition'];
    addr1 = json['addr1'];
    addr2 = json['addr2'];
    townCode = json['townCode'];
    town = json['town'];
    districtCode = json['districtCode'];
    district = json['district'];
    cityCode = json['cityCode'];
    city = json['city'];
    countryCode = json['countryCode'];
    country = json['country'];
    telNr = json['telNr'];
    email = json['email'];
    groupCode1 = json['groupCode1'];
    groupName1 = json['groupName1'];
    groupCode2 = json['groupCode2'];
    groupName2 = json['groupName2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warehouseId'] = this.warehouseId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    data['addr1'] = this.addr1;
    data['addr2'] = this.addr2;
    data['townCode'] = this.townCode;
    data['town'] = this.town;
    data['districtCode'] = this.districtCode;
    data['district'] = this.district;
    data['cityCode'] = this.cityCode;
    data['city'] = this.city;
    data['countryCode'] = this.countryCode;
    data['country'] = this.country;
    data['telNr'] = this.telNr;
    data['email'] = this.email;
    data['groupCode1'] = this.groupCode1;
    data['groupName1'] = this.groupName1;
    data['groupCode2'] = this.groupCode2;
    data['groupName2'] = this.groupName2;
    return data;
  }
}
