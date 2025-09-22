class OrderDetailResponse {
  OrderDetailData? data;

  OrderDetailResponse({this.data});

  OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new OrderDetailData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OrderDetailData {
  String? id;
  List<OrderItems>? orderItems;
  bool? isAssing;
  bool? isPartialOrder;
  String? ficheNo;
  String? ficheDate;
  String? assingmetFullname;
  double? grossTotal;
  Customer? customer;
  Warehouse? warehouse;
  OrderStatus? orderStatus;
  OrderDetailData({
    this.id,
    this.orderItems,
    this.isAssing,
    this.isPartialOrder,
    this.ficheNo,
    this.ficheDate,
    this.assingmetFullname,
    this.grossTotal,
    this.customer,
    this.warehouse,
    this.orderStatus,
  });

  OrderDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['orderItems'] != null) {
      orderItems = <OrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    isAssing = json['isAssing'];
    isPartialOrder = json['isPartialOrder'];

    if (json['grossTotal'] is int) {
      grossTotal = (json['grossTotal'] as int).toDouble();
    } else if (json['grossTotal'] is double) {
      grossTotal = json['grossTotal'];
    } else {
      grossTotal = 0.0;
    }
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    assingmetFullname = json['assingmetFullname'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
    orderStatus = json['orderStatus'] != null
        ? new OrderStatus.fromJson(json['orderStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    data['isAssing'] = this.isAssing;
    data['isPartialOrder'] = this.isPartialOrder;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['assingmetFullname'] = this.assingmetFullname;
    data['grossTotal'] = this.grossTotal;
    if (customer != null) {
      data['product'] = customer!.toJson();
    }
    if (warehouse != null) {
      data['warehouse'] = warehouse!.toJson();
    }
    if (orderStatus != null) {
      data['orderStatus'] = orderStatus!.toJson();
    }
    return data;
  }
}

class OrderStatus {
  String? name;
  int? id;
  String? displayName;

  OrderStatus({this.name, this.id, this.displayName});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['displayName'] = this.displayName;
    return data;
  }
}

class Customer {
  String? name;
  String? id;

  Customer({this.name, this.id});

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

class OrderItems {
  String? id;
  Product? product;
  TransactionType? transactionType;
  OrderItemType? orderItemType;
  String? description;
  Direction? direction;
  Warehouse? warehouse;
  Qty? qty;
  Price? price;
  int? shippedQty;
  double? total;
  double? discount;
  double? tax;
  double? nettotal;
  Unit? unit;
  UnitConversion? unitConversion;
  String? createdBy;
  String? modifiedBy;
  String? createdTime;
  String? modifiedTime;
  bool? isDeleted;

  OrderItems(
      {this.id,
      this.product,
      this.transactionType,
      this.orderItemType,
      this.description,
      this.direction,
      this.warehouse,
      this.qty,
      this.shippedQty,
      this.price,
      this.total,
      this.discount,
      this.tax,
      this.nettotal,
      this.unit,
      this.unitConversion,
      this.createdBy,
      this.modifiedBy,
      this.createdTime,
      this.modifiedTime,
      this.isDeleted});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    transactionType = json['transactionType'] != null
        ? new TransactionType.fromJson(json['transactionType'])
        : null;
    orderItemType = json['orderItemType'] != null
        ? new OrderItemType.fromJson(json['orderItemType'])
        : null;
    description = json['description_'];
    direction = json['direction'] != null
        ? new Direction.fromJson(json['direction'])
        : null;
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
    qty = json['qty'] != null ? new Qty.fromJson(json['qty']) : null;
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;

    if (json['total'] is int) {
      total = (json['total'] as int).toDouble();
    } else if (json['total'] is double) {
      total = json['total'];
    } else {
      total = 0.0;
    }
    shippedQty = json['shippedQty'];
    if (json['discount'] is int) {
      discount = (json['discount'] as int).toDouble();
    } else if (json['discount'] is double) {
      discount = json['discount'];
    } else {
      discount = 0.0;
    }
    if (json['tax'] is int) {
      tax = (json['tax'] as int).toDouble();
    } else if (json['tax'] is double) {
      tax = json['tax'];
    } else {
      tax = 0.0;
    }
    if (json['nettotal'] is int) {
      nettotal = (json['nettotal'] as int).toDouble();
    } else if (json['nettotal'] is double) {
      nettotal = json['nettotal'];
    } else {
      nettotal = 0.0;
    }
    unit = json['unit'] != null ? new Unit.fromJson(json['unit']) : null;
    unitConversion = json['unitConversion'] != null
        ? new UnitConversion.fromJson(json['unitConversion'])
        : null;
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    createdTime = json['createdTime'];
    modifiedTime = json['modifiedTime'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (transactionType != null) {
      data['transactionType'] = transactionType!.toJson();
    }
    if (orderItemType != null) {
      data['orderItemType'] = orderItemType!.toJson();
    }
    data['description_'] = description;
    if (direction != null) {
      data['direction'] = direction!.toJson();
    }
    if (warehouse != null) {
      data['warehouse'] = warehouse!.toJson();
    }
    if (qty != null) {
      data['qty'] = qty!.toJson();
    }
    if (price != null) {
      data['price'] = price!.toJson();
    }
    data['total'] = total;
    data['discount'] = discount;
    data['shippedQty'] = shippedQty;
    data['tax'] = tax;
    data['nettotal'] = nettotal;
    if (unit != null) {
      data['unit'] = unit!.toJson();
    }
    if (unitConversion != null) {
      data['unitConversion'] = unitConversion!.toJson();
    }
    data['createdBy'] = createdBy;
    data['modifiedBy'] = modifiedBy;
    data['createdTime'] = createdTime;
    data['modifiedTime'] = modifiedTime;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

class Product {
  String? id;
  List<Events>? events;
  String? code;
  String? definition;
  String? definition2;
  int? vatRate;
  Brand? brand;
  bool? isActive;
  bool? isProductLocatin;
  String? barcode;
  int? serilotType;
  Unit? unit;
  String? createdBy;
  String? modifiedBy;
  String? createdTime;
  String? modifiedTime;
  bool? isDeleted;

  Product(
      {this.id,
      this.events,
      this.code,
      this.definition,
      this.definition2,
      this.vatRate,
      this.brand,
      this.isActive,
      this.isProductLocatin,
      this.barcode,
      this.serilotType,
      this.unit,
      this.createdBy,
      this.modifiedBy,
      this.createdTime,
      this.modifiedTime,
      this.isDeleted});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
    code = json['code'];
    definition = json['definition'];
    definition2 = json['definition2'];
    vatRate = json['vatRate'];
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    isActive = json['isActive'];
    isProductLocatin = json['isProductLocatin'];
    barcode = json['barcode'];
    serilotType = json['serilotType'];
    unit = json['unit'] != null ? new Unit.fromJson(json['unit']) : null;
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    createdTime = json['createdTime'];
    modifiedTime = json['modifiedTime'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    data['code'] = code;
    data['definition'] = definition;
    data['definition2'] = definition2;
    data['vatRate'] = vatRate;
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    data['isActive'] = isActive;
    data['isProductLocatin'] = isProductLocatin;
    data['barcode'] = barcode;
    data['serilotType'] = serilotType;
    if (unit != null) {
      data['unit'] = unit!.toJson();
    }
    data['createdBy'] = createdBy;
    data['modifiedBy'] = modifiedBy;
    data['createdTime'] = createdTime;
    data['modifiedTime'] = modifiedTime;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

class Events {
  String? occuredOn;
  String? recordId;
  bool? isItAffectedByEntityStateUnchanged;

  Events(
      {this.occuredOn, this.recordId, this.isItAffectedByEntityStateUnchanged});

  Events.fromJson(Map<String, dynamic> json) {
    occuredOn = json['occuredOn'];
    recordId = json['recordId'];
    isItAffectedByEntityStateUnchanged =
        json['isItAffectedByEntityStateUnchanged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['occuredOn'] = occuredOn;
    data['recordId'] = recordId;
    data['isItAffectedByEntityStateUnchanged'] =
        isItAffectedByEntityStateUnchanged;
    return data;
  }
}

class Brand {
  String? id;
  List<Events>? events;
  String? name;
  String? createdBy;
  String? modifiedBy;
  String? createdTime;
  String? modifiedTime;
  bool? isDeleted;

  Brand(
      {this.id,
      this.events,
      this.name,
      this.createdBy,
      this.modifiedBy,
      this.createdTime,
      this.modifiedTime,
      this.isDeleted});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
    name = json['name'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    createdTime = json['createdTime'];
    modifiedTime = json['modifiedTime'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['createdBy'] = createdBy;
    data['modifiedBy'] = modifiedBy;
    data['createdTime'] = createdTime;
    data['modifiedTime'] = modifiedTime;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

class Unit {
  String? id;
  List<Events>? events;
  bool? isDeleted;
  String? createdTime;
  String? modifiedTime;
  String? createdBy;
  String? modifiedBy;
  String? code;
  String? description;

  Unit(
      {this.id,
      this.events,
      this.isDeleted,
      this.createdTime,
      this.modifiedTime,
      this.createdBy,
      this.modifiedBy,
      this.code,
      this.description});

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
    isDeleted = json['isDeleted'];
    createdTime = json['createdTime'];
    modifiedTime = json['modifiedTime'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    code = json['code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    data['isDeleted'] = isDeleted;
    data['createdTime'] = createdTime;
    data['modifiedTime'] = modifiedTime;
    data['createdBy'] = createdBy;
    data['modifiedBy'] = modifiedBy;
    data['code'] = code;
    data['description'] = description;
    return data;
  }
}

class TransactionType {
  String? name;
  int? id;
  String? displayName;

  TransactionType({this.name, this.id, this.displayName});

  TransactionType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['id'] = id;
    data['displayName'] = displayName;
    return data;
  }
}

class OrderItemType {
  String? name;
  int? id;
  String? displayName;

  OrderItemType({this.name, this.id, this.displayName});

  OrderItemType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['id'] = id;
    data['displayName'] = displayName;
    return data;
  }
}

class Direction {
  bool? value;

  Direction({this.value});

  Direction.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = value;
    return data;
  }
}

class Warehouse {
  String? id;
  String? code;
  String? definition;

  Warehouse({this.code, this.definition});

  Warehouse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    id = json['id'];
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = code;
    data['id'] = id;
    data['definition'] = definition;
    return data;
  }
}

class Qty {
  int? value;

  Qty({this.value});

  Qty.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    return data;
  }
}

class Price {
  double? value;

  Price({this.value});

  Price.fromJson(Map<String, dynamic> json) {
    if (json['value'] is int) {
      value = (json['value'] as int).toDouble();
    } else if (json['value'] is double) {
      value = json['value'];
    } else {
      value = 0.0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    return data;
  }
}

class UnitConversion {
  String? id;
  List<Events>? events;
  String? createdBy;
  String? modifiedBy;
  String? createdTime;
  String? modifiedTime;
  bool? isDeleted;
  String? code;
  String? description;
  int? convParam1;
  int? convParam2;
  Unit? units;

  UnitConversion(
      {this.id,
      this.events,
      this.createdBy,
      this.modifiedBy,
      this.createdTime,
      this.modifiedTime,
      this.isDeleted,
      this.code,
      this.description,
      this.convParam1,
      this.convParam2,
      this.units});

  UnitConversion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    createdTime = json['createdTime'];
    modifiedTime = json['modifiedTime'];
    isDeleted = json['isDeleted'];
    code = json['code'];
    description = json['description'];
    convParam1 = json['convParam1'];
    convParam2 = json['convParam2'];
    units = json['units'] != null ? new Unit.fromJson(json['units']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    data['createdBy'] = createdBy;
    data['modifiedBy'] = modifiedBy;
    data['createdTime'] = createdTime;
    data['modifiedTime'] = modifiedTime;
    data['isDeleted'] = isDeleted;
    data['code'] = code;
    data['description'] = description;
    data['convParam1'] = convParam1;
    data['convParam2'] = convParam2;
    if (units != null) {
      data['units'] = units!.toJson();
    }
    return data;
  }
}
