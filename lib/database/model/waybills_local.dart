class WaybillLocalModel {
  String? waybillsId;
  String? docNo;
  String? ficheNo;
  String? customerId;
  String? customerName;
  String? salesmanId;
  DateTime? ficheDate;
  DateTime? shipDate;
  String? workplaceId;
  String? departmentId;
  String? warehouseId;
  String? warehouseName;
  String? transporterId;
  String? shippingTypeId;
  int? waybillStatusId;
  int? currencyId;
  double? totaldiscounted;
  double? totalvat;
  double? grosstotal;
  String? shippingAccountId;
  String? shippingAddressId;
  String? description;

  WaybillLocalModel(
    this.waybillsId,
    this.docNo,
    this.ficheNo,
    this.customerId,
    this.customerName,
    this.salesmanId,
    this.ficheDate,
    this.shipDate,
    this.workplaceId,
    this.departmentId,
    this.warehouseId,
    this.warehouseName,
    this.transporterId,
    this.shippingTypeId,
    this.waybillStatusId,
    this.currencyId,
    this.totaldiscounted,
    this.totalvat,
    this.grosstotal,
    this.shippingAccountId,
    this.shippingAddressId,
    this.description,
  );

  WaybillLocalModel.fromJson(Map<String, dynamic> json)
      : this(
          json['waybillsId'],
          json['docNo'],
          json['ficheNo'],
          json['customerId'],
          json['customerName'],
          json['salesmanId'],
          DateTime.parse(json['ficheDate']),
          DateTime.parse(json['shipDate']),
          json['workplaceId'],
          json['departmentId'],
          json['warehouseId'],
          json['warehouseName'],
          json['transporterId'],
          json['shippingTypeId'],
          json['waybillStatusId'],
          json['currencyId'],
          json['totaldiscounted'],
          json['totalvat'],
          json['grosstotal'],
          json['shippingAccountId'],
          json['shippingAddressId'],
          json['description'],
        );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["waybillsId"] = waybillsId;
    map["docNo"] = docNo;
    map["ficheNo"] = ficheNo;
    map["customerId"] = customerId;
    map['customerName'] = customerName;
    map["salesmanId"] = salesmanId;
    map["ficheDate"] = ficheDate;
    map["shipDate"] = shipDate;
    map["workplaceId"] = workplaceId;
    map["departmentId"] = departmentId;
    map["warehouseId"] = warehouseId;
    map['warehouseName'] = warehouseName;
    map["transporterId"] = transporterId;
    map["shippingTypeId"] = shippingTypeId;
    map["waybillStatusId"] = waybillStatusId;
    map["currencyId"] = currencyId;
    map["totaldiscounted"] = totaldiscounted;
    map["totalvat"] = totalvat;
    map["grosstotal"] = grosstotal;
    map["shippingAccountId"] = shippingAccountId;
    map["shippingAddressId"] = shippingAddressId;
    map["description"] = description;
    return map;
  }
}
