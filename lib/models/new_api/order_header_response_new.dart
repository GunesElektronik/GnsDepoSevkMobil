class OrderSummaryListResponseNew {
  OrderSummaryList? orders;

  OrderSummaryListResponseNew({this.orders});

  OrderSummaryListResponseNew.fromJson(Map<String, dynamic> json) {
    orders = json['orders'] != null
        ? new OrderSummaryList.fromJson(json['orders'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.toJson();
    }
    return data;
  }
}

class OrderSummaryList {
  List<OrderSummaryItem>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  OrderSummaryList({this.items, this.totalItems, this.page, this.pageSize});

  OrderSummaryList.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <OrderSummaryItem>[];
      json['items'].forEach((v) {
        items!.add(new OrderSummaryItem.fromJson(v));
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

class OrderSummaryItem {
  String? orderId;
  String? ficheNo;
  DateTime? ficheDate;
  String? customer;
  String? shippingMethod;
  String? warehouse;
  String? lineCount;
  String? orderStatus;
  String? totalQty;
  String? total;
  bool? isAssing;
  String? assingmentEmail;
  String? assingCode;
  String? assingmetFullname;
  bool? isPartialOrder;

  OrderSummaryItem({
    this.orderId,
    this.ficheNo,
    this.ficheDate,
    this.customer,
    this.shippingMethod,
    this.warehouse,
    this.lineCount,
    this.orderStatus,
    this.totalQty,
    this.total,
    this.isAssing,
    this.assingmentEmail,
    this.assingCode,
    this.assingmetFullname,
    this.isPartialOrder,
  });

  OrderSummaryItem.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    ficheNo = json['ficheNo'];
    ficheDate = DateTime.parse(json['ficheDate']);
    customer = json['customer'];
    shippingMethod = json['shippingMethod'];
    warehouse = json['warehouse'];
    lineCount = json['lineCount'];
    orderStatus = json['orderStatus'];
    totalQty = json['totalQty'];
    total = json['total'];
    isAssing = json['isAssing'];
    assingmentEmail = json['assingmentEmail'];
    assingCode = json['assingCode'];
    assingmetFullname = json['assingmetFullname'];
    isPartialOrder = json['isPartialOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['customer'] = this.customer;
    data['shippingMethod'] = this.shippingMethod;
    data['warehouse'] = this.warehouse;
    data['lineCount'] = this.lineCount;
    data['orderStatus'] = this.orderStatus;
    data['totalQty'] = this.totalQty;
    data['total'] = this.total;
    data['isAssing'] = this.isAssing;
    data['assingmentEmail'] = this.assingmentEmail;
    data['assingCode'] = this.assingCode;
    data['assingmetFullname'] = this.assingmetFullname;
    data['isPartialOrder'] = this.isPartialOrder;
    return data;
  }
}
