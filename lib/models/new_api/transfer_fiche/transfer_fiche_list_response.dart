class TransferFicheListResponse {
  TransferFiches? transferFiches;

  TransferFicheListResponse({this.transferFiches});

  TransferFicheListResponse.fromJson(Map<String, dynamic> json) {
    transferFiches = json['transferFiches'] != null
        ? new TransferFiches.fromJson(json['transferFiches'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transferFiches != null) {
      data['transferFiches'] = this.transferFiches!.toJson();
    }
    return data;
  }
}

class TransferFiches {
  List<TransferFicheItems>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  TransferFiches({this.items, this.totalItems, this.page, this.pageSize});

  TransferFiches.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <TransferFicheItems>[];
      json['items'].forEach((v) {
        items!.add(new TransferFicheItems.fromJson(v));
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

class TransferFicheItems {
  String? transferFicheId;
  bool? direction;
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

  TransferFicheItems({
    this.transferFicheId,
    this.direction,
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
  });

  TransferFicheItems.fromJson(Map<String, dynamic> json) {
    transferFicheId = json['transferFicheId'];
    direction = json['direction'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transferFicheId'] = this.transferFicheId;
    data['direction'] = this.direction;
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
