class SalesmenListResponse {
  Salesmen? salesmen;

  SalesmenListResponse({this.salesmen});

  SalesmenListResponse.fromJson(Map<String, dynamic> json) {
    salesmen = json['salesmen'] != null
        ? new Salesmen.fromJson(json['salesmen'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.salesmen != null) {
      data['salesmen'] = this.salesmen!.toJson();
    }
    return data;
  }
}

class Salesmen {
  List<SalesmenItems>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  Salesmen({this.items, this.totalItems, this.page, this.pageSize});

  Salesmen.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <SalesmenItems>[];
      json['items'].forEach((v) {
        items!.add(new SalesmenItems.fromJson(v));
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

class SalesmenItems {
  String? salesmanId;
  String? code;
  String? name;
  String? erpId;
  String? erpCode;

  SalesmenItems(
      {this.salesmanId, this.code, this.name, this.erpId, this.erpCode});

  SalesmenItems.fromJson(Map<String, dynamic> json) {
    salesmanId = json['salesmanId'];
    code = json['code'];
    name = json['name'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesmanId'] = this.salesmanId;
    data['code'] = this.code;
    data['name'] = this.name;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    return data;
  }
}
