class DocNumberGetFicheNumberResponse {
  Docnumber? docnumber;

  DocNumberGetFicheNumberResponse({this.docnumber});

  DocNumberGetFicheNumberResponse.fromJson(Map<String, dynamic> json) {
    docnumber = json['docnumber'] != null
        ? new Docnumber.fromJson(json['docnumber'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.docnumber != null) {
      data['docnumber'] = this.docnumber!.toJson();
    }
    return data;
  }
}

class Docnumber {
  String? lastNum;
  String? userId;
  Warehouse? warehouse;
  int? transactionTypeId;

  Docnumber(
      {this.lastNum, this.userId, this.warehouse, this.transactionTypeId});

  Docnumber.fromJson(Map<String, dynamic> json) {
    lastNum = json['lastNum'];
    userId = json['userId'];
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
    transactionTypeId = json['transactionTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastNum'] = this.lastNum;
    data['userId'] = this.userId;
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.toJson();
    }
    data['transactionTypeId'] = this.transactionTypeId;
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
