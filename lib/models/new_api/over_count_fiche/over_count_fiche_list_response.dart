class OverCountFicheListResponse {
  OverCountFiches? overCountFiches;

  OverCountFicheListResponse({this.overCountFiches});

  OverCountFicheListResponse.fromJson(Map<String, dynamic> json) {
    overCountFiches = json['overCountFiches'] != null
        ? new OverCountFiches.fromJson(json['overCountFiches'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.overCountFiches != null) {
      data['overCountFiches'] = this.overCountFiches!.toJson();
    }
    return data;
  }
}

class OverCountFiches {
  List<OverCountFicheItems>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  OverCountFiches({this.items, this.totalItems, this.page, this.pageSize});

  OverCountFiches.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <OverCountFicheItems>[];
      json['items'].forEach((v) {
        items!.add(new OverCountFicheItems.fromJson(v));
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

class OverCountFicheItems {
  String? overCountFicheId;
  bool? direction;
  Customer? customer;
  int? transactionTypeId;
  String? transactionTypeName;
  String? ficheNo;
  String? ficheDate;
  String? ficheTime;
  String? docNo;
  InWorkplace? inWorkplace;
  InDepartment? inDepartment;
  InWarehouse? inWarehouse;
  int? cancelled;
  String? description;
  // Null? transporter;
  // Null? customerAddress;
  // Null? overCountFicheItems;

  OverCountFicheItems({
    this.overCountFicheId,
    this.direction,
    this.customer,
    this.transactionTypeId,
    this.transactionTypeName,
    this.ficheNo,
    this.ficheDate,
    this.ficheTime,
    this.docNo,
    this.inWorkplace,
    this.inDepartment,
    this.inWarehouse,
    this.cancelled,
    this.description,
    // this.transporter,
    // this.customerAddress,
    // this.overCountFicheItems,
  });

  OverCountFicheItems.fromJson(Map<String, dynamic> json) {
    overCountFicheId = json['overCountFicheId'];
    direction = json['direction'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    transactionTypeId = json['transactionTypeId'];
    transactionTypeName = json['transactionTypeName'];
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    ficheTime = json['ficheTime'];
    docNo = json['docNo'];
    inWorkplace = json['inWorkplace'] != null
        ? new InWorkplace.fromJson(json['inWorkplace'])
        : null;
    inDepartment = json['inDepartment'] != null
        ? new InDepartment.fromJson(json['inDepartment'])
        : null;
    inWarehouse = json['inWarehouse'] != null
        ? new InWarehouse.fromJson(json['inWarehouse'])
        : null;
    cancelled = json['cancelled'];
    description = json['description'];
    // transporter = json['transporter'];
    // customerAddress = json['customerAddress'];
    // overCountFicheItems = json['overCountFicheItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['overCountFicheId'] = this.overCountFicheId;
    data['direction'] = this.direction;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['transactionTypeId'] = this.transactionTypeId;
    data['transactionTypeName'] = this.transactionTypeName;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['ficheTime'] = this.ficheTime;
    data['docNo'] = this.docNo;
    if (this.inWorkplace != null) {
      data['inWorkplace'] = this.inWorkplace!.toJson();
    }
    if (this.inDepartment != null) {
      data['inDepartment'] = this.inDepartment!.toJson();
    }
    if (this.inWarehouse != null) {
      data['inWarehouse'] = this.inWarehouse!.toJson();
    }
    data['cancelled'] = this.cancelled;
    data['description'] = this.description;
    // data['transporter'] = this.transporter;
    // data['customerAddress'] = this.customerAddress;
    // data['overCountFicheItems'] = this.overCountFicheItems;
    return data;
  }
}

class Customer {
  String? customerId;
  String? code;
  String? name;

  Customer({this.customerId, this.code, this.name});

  Customer.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class InWorkplace {
  String? workplaceId;
  String? code;
  String? definition;

  InWorkplace({this.workplaceId, this.code, this.definition});

  InWorkplace.fromJson(Map<String, dynamic> json) {
    workplaceId = json['workplaceId'];
    code = json['code'];
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workplaceId'] = this.workplaceId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    return data;
  }
}

class InDepartment {
  String? departmentId;
  String? code;
  String? definition;

  InDepartment({this.departmentId, this.code, this.definition});

  InDepartment.fromJson(Map<String, dynamic> json) {
    departmentId = json['departmentId'];
    code = json['code'];
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['departmentId'] = this.departmentId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    return data;
  }
}

class InWarehouse {
  String? warehouseId;
  String? code;
  String? definition;

  InWarehouse({this.warehouseId, this.code, this.definition});

  InWarehouse.fromJson(Map<String, dynamic> json) {
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
