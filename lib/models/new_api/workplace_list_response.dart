class WorkplaceListResponse {
  Workplaces? workplaces;

  WorkplaceListResponse({this.workplaces});

  WorkplaceListResponse.fromJson(Map<String, dynamic> json) {
    workplaces = json['workplaces'] != null
        ? new Workplaces.fromJson(json['workplaces'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.workplaces != null) {
      data['workplaces'] = this.workplaces!.toJson();
    }
    return data;
  }
}

class Workplaces {
  List<WorkplaceListItems>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  Workplaces({this.items, this.totalItems, this.page, this.pageSize});

  Workplaces.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <WorkplaceListItems>[];
      json['items'].forEach((v) {
        items!.add(new WorkplaceListItems.fromJson(v));
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

class WorkplaceListItems {
  String? workplaceId;
  String? code;
  String? definition;
  List<Departments>? departments;

  WorkplaceListItems(
      {this.workplaceId, this.code, this.definition, this.departments});

  WorkplaceListItems.fromJson(Map<String, dynamic> json) {
    workplaceId = json['workplaceId'];
    code = json['code'];
    definition = json['definition'];
    if (json['departments'] != null) {
      departments = <Departments>[];
      json['departments'].forEach((v) {
        departments!.add(new Departments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workplaceId'] = this.workplaceId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    if (this.departments != null) {
      data['departments'] = this.departments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Departments {
  String? departmentId;
  String? code;
  String? definition;
  List<WorkplaceWarehouse>? warehouse;

  Departments({this.departmentId, this.code, this.definition, this.warehouse});

  Departments.fromJson(Map<String, dynamic> json) {
    departmentId = json['departmentId'];
    code = json['code'];
    definition = json['definition'];
    if (json['warehouse'] != null) {
      warehouse = <WorkplaceWarehouse>[];
      json['warehouse'].forEach((v) {
        warehouse!.add(new WorkplaceWarehouse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['departmentId'] = this.departmentId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkplaceWarehouse {
  String? warehouseId;
  String? code;
  String? definition;

  WorkplaceWarehouse({this.warehouseId, this.code, this.definition});

  WorkplaceWarehouse.fromJson(Map<String, dynamic> json) {
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
