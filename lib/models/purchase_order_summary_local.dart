class PurchaseOrderSummaryLocal {
  String id;
  String ficheNo;
  DateTime ficheDate;
  String? customer;
  String? shippingMethod;
  String? warehouse;
  String? lineCount;
  String? orderStatus;
  String? totalQty;
  String? total;
  bool isAssing = false;
  String? assingmentEmail;
  String? assingCode;
  String? assingmetFullname;
  bool? isPartialOrder;

  PurchaseOrderSummaryLocal(
    this.id,
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
  );

  PurchaseOrderSummaryLocal.fromJson(Map<String, dynamic> json)
      : this(
          json['id'],
          json['ficheNo'],
          DateTime.parse(json['ficheDate']),
          json['customer'].toString(),
          json['shippingMethod'].toString(),
          json['warehouse'].toString(),
          json['lineCount'].toString(),
          json['orderStatus'].toString(),
          json['totalQty'].toString(),
          json['total'].toString(),
          json['isAssing'],
          json['assingmentEmail'].toString(),
          json['assingCode'].toString(),
          json['assingmetFullname'].toString(),
          json['isPartialOrder'],
        );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["id"] = id;
    map["ficheNo"] = ficheNo;
    map["ficheDate"] = ficheDate;
    map["customer"] = customer;
    map["shippingMethod"] = shippingMethod;
    map["warehouse"] = warehouse;
    map["lineCount"] = lineCount;
    map["orderStatus"] = orderStatus;
    map["totalQty"] = totalQty;
    map["total"] = total;
    map["isAssing"] = isAssing;
    map["assingmentEmail"] = assingmentEmail;
    map["assingCode"] = assingCode;
    map["assingmetFullname"] = assingmetFullname;
    map["isPartialOrder"] = isPartialOrder;
    return map;
  }
}
