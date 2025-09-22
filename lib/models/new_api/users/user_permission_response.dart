class UserPermissionResponse {
  List<Permissions>? permissions;

  UserPermissionResponse({this.permissions});

  UserPermissionResponse.fromJson(Map<String, dynamic> json) {
    if (json['permissions'] != null) {
      permissions = <Permissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(new Permissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Permissions {
  String? permissionName;
  bool? isAuth;

  Permissions({this.permissionName, this.isAuth});

  Permissions.fromJson(Map<String, dynamic> json) {
    permissionName = json['permissionName'];
    isAuth = json['isAuth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['permissionName'] = this.permissionName;
    data['isAuth'] = this.isAuth;
    return data;
  }
}
