class TransporterListResponse {
  Transporters? transporters;

  TransporterListResponse({this.transporters});

  TransporterListResponse.fromJson(Map<String, dynamic> json) {
    transporters = json['transporters'] != null
        ? new Transporters.fromJson(json['transporters'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transporters != null) {
      data['transporters'] = this.transporters!.toJson();
    }
    return data;
  }
}

class Transporters {
  List<TransporterListItems>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  Transporters({this.items, this.totalItems, this.page, this.pageSize});

  Transporters.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <TransporterListItems>[];
      json['items'].forEach((v) {
        items!.add(new TransporterListItems.fromJson(v));
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

class TransporterListItems {
  String? transporterId;
  String? code;
  String? description;
  String? identityOrTax;
  String? erpId;
  String? erpCode;

  TransporterListItems(
      {this.transporterId,
      this.code,
      this.description,
      this.identityOrTax,
      this.erpId,
      this.erpCode});

  TransporterListItems.fromJson(Map<String, dynamic> json) {
    transporterId = json['transporterId'];
    code = json['code'];
    description = json['description'];
    identityOrTax = json['identityOrTax'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transporterId'] = this.transporterId;
    data['code'] = this.code;
    data['description'] = this.description;
    data['identityOrTax'] = this.identityOrTax;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    return data;
  }
}
