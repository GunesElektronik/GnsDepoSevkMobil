class OrderHeader {
  String id;
  String ficheNo;
  int ficheDate;
  String? customer;
  String? shippingMethod;
  String? warehouse;
  String? lineCount;
  String? orderStatus;
  String? totalQty;
  String? total;
  int isAssing = 0;
  String? assingmentEmail;
  String? assingCode;
  String? assingmetFullname;

  //{
  //       "id": "1d29f686-01d3-4a21-5b98-08dbf4a54634",
  //       "ficheNo": "fisno",
  //       "ficheDate": "12/4/2023 12:00:00 AM",
  //       "customer": "120.08-güneş elektronik cihazlar tic. ltd.şti",
  //       "shippingMethod": null,
  //       "warehouse": "Merkez Dep-Merkez Depo",
  //       "lineCount": "1",
  //       "orderStatus": "Ödendi",
  //       "totalQty": "12",
  //       "total": "55",
  //       "isAssing": true,
  //       "assingmentEmail": "emiralacaci@gmail.com",
  //       "assingCode": null,
  //       "assingmetFullname": "emir alacaci"
  //     }

  OrderHeader(
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
      this.assingmetFullname);

  OrderHeader.fromJson(Map<String, dynamic> json)
      : this(
            json['id'],
            json['ficheNo'],
            json['ficheDate'],
            json['customer'],
            json['shippingMethod'],
            json['warehouse'],
            json['lineCount'],
            json['orderStatus'],
            json['totalQty'],
            json['total'],
            json['isAssing'],
            json['assingmentEmail'],
            json['assingCode'],
            json['assingmetFullname']);

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

    return map;
  }
}
