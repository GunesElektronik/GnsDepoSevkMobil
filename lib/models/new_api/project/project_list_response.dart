class ProjectListResponse {
  Projects? projects;

  ProjectListResponse({this.projects});

  ProjectListResponse.fromJson(Map<String, dynamic> json) {
    projects = json['projects'] != null
        ? new Projects.fromJson(json['projects'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projects != null) {
      data['projects'] = this.projects!.toJson();
    }
    return data;
  }
}

class Projects {
  List<ProjectItems>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  Projects({this.items, this.totalItems, this.page, this.pageSize});

  Projects.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ProjectItems>[];
      json['items'].forEach((v) {
        items!.add(new ProjectItems.fromJson(v));
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

class ProjectItems {
  String? projectId;
  String? code;
  String? definition;
  String? erpId;
  String? erpCode;

  ProjectItems(
      {this.projectId, this.code, this.definition, this.erpId, this.erpCode});

  ProjectItems.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    code = json['code'];
    definition = json['definition'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    return data;
  }
}
