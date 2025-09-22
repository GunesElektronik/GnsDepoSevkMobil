class ShippingTypeListResponse {
  ShippingType? shippingType;

  ShippingTypeListResponse({this.shippingType});

  ShippingTypeListResponse.fromJson(Map<String, dynamic> json) {
    shippingType = json['shippingType'] != null
        ? new ShippingType.fromJson(json['shippingType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shippingType != null) {
      data['shippingType'] = this.shippingType!.toJson();
    }
    return data;
  }
}

class ShippingType {
  List<ShippingTypeItems>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  ShippingType({this.items, this.totalItems, this.page, this.pageSize});

  ShippingType.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ShippingTypeItems>[];
      json['items'].forEach((v) {
        items!.add(new ShippingTypeItems.fromJson(v));
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

class ShippingTypeItems {
  String? shippingTypeId;
  String? code;
  String? definition;

  ShippingTypeItems({this.shippingTypeId, this.code, this.definition});

  ShippingTypeItems.fromJson(Map<String, dynamic> json) {
    shippingTypeId = json['shippingTypeId'];
    code = json['code'];
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shippingTypeId'] = this.shippingTypeId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    return data;
  }
}
