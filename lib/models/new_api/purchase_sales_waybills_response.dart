class PurchaseSalesWaybillsResponse {
  Waybills? waybills;

  PurchaseSalesWaybillsResponse({this.waybills});

  PurchaseSalesWaybillsResponse.fromJson(Map<String, dynamic> json) {
    waybills = json['waybills'] != null
        ? new Waybills.fromJson(json['waybills'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.waybills != null) {
      data['waybills'] = this.waybills!.toJson();
    }
    return data;
  }
}

class Waybills {
  List<PruchaseSalesWaybillsItems>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  Waybills({this.items, this.totalItems, this.page, this.pageSize});

  Waybills.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <PruchaseSalesWaybillsItems>[];
      json['items'].forEach((v) {
        items!.add(new PruchaseSalesWaybillsItems.fromJson(v));
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

class PruchaseSalesWaybillsItems {
  String? waybillId;
  String? ficheNo;
  String? ficheDate;
  String? customer;
  String? shippingMethod;
  String? warehouse;
  String? lineCount;
  int? orderStatus;
  String? totalQty;
  String? total;
  String? waybillStatus;
  String? erpSendMessage;
  String? orderFicheNo;

  PruchaseSalesWaybillsItems({
    this.waybillId,
    this.ficheNo,
    this.ficheDate,
    this.customer,
    this.shippingMethod,
    this.warehouse,
    this.lineCount,
    this.orderStatus,
    this.totalQty,
    this.total,
    this.waybillStatus,
    this.erpSendMessage,
    this.orderFicheNo,
  });

  PruchaseSalesWaybillsItems.fromJson(Map<String, dynamic> json) {
    waybillId = json['waybillId'];
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    customer = json['customer'];
    shippingMethod = json['shippingMethod'];
    warehouse = json['warehouse'];
    lineCount = json['lineCount'];
    orderStatus = json['orderStatus'];
    totalQty = json['totalQty'];
    total = json['total'];
    waybillStatus = json['waybillStatus'];
    erpSendMessage = json['erpSendMessage'];
    orderFicheNo = json['orderFicheNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waybillId'] = this.waybillId;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['customer'] = this.customer;
    data['shippingMethod'] = this.shippingMethod;
    data['warehouse'] = this.warehouse;
    data['lineCount'] = this.lineCount;
    data['orderStatus'] = this.orderStatus;
    data['totalQty'] = this.totalQty;
    data['total'] = this.total;
    data['waybillStatus'] = this.waybillStatus;
    data['erpSendMessage'] = this.erpSendMessage;
    data['orderFicheNo'] = this.orderFicheNo;
    return data;
  }
}
