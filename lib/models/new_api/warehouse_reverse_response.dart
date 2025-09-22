class WarehouseReverseResponse {
  Warehouse? warehouse;

  WarehouseReverseResponse({this.warehouse});

  WarehouseReverseResponse.fromJson(Map<String, dynamic> json) {
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.toJson();
    }
    return data;
  }
}

class Warehouse {
  String? warehouseId;
  String? code;
  String? definition;
  Departments? departments;

  Warehouse({this.warehouseId, this.code, this.definition, this.departments});

  Warehouse.fromJson(Map<String, dynamic> json) {
    warehouseId = json['warehouseId'];
    code = json['code'];
    definition = json['definition'];
    departments = json['departments'] != null
        ? new Departments.fromJson(json['departments'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warehouseId'] = this.warehouseId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    if (this.departments != null) {
      data['departments'] = this.departments!.toJson();
    }
    return data;
  }
}

class Departments {
  String? departmentId;
  String? code;
  String? definition;
  Workplace? workplace;

  Departments({this.departmentId, this.code, this.definition, this.workplace});

  Departments.fromJson(Map<String, dynamic> json) {
    departmentId = json['departmentId'];
    code = json['code'];
    definition = json['definition'];
    workplace = json['workplace'] != null
        ? new Workplace.fromJson(json['workplace'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['departmentId'] = this.departmentId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    if (this.workplace != null) {
      data['workplace'] = this.workplace!.toJson();
    }
    return data;
  }
}

class Workplace {
  String? workplaceId;
  String? code;
  String? definition;

  Workplace({this.workplaceId, this.code, this.definition});

  Workplace.fromJson(Map<String, dynamic> json) {
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
