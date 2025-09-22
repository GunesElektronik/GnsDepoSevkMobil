class CreateUserWarehouseSpecialSettingsBody {
  String? userId;
  int? userSpecialSettingCardId;
  List<String>? warehouseIds;

  CreateUserWarehouseSpecialSettingsBody(
      {this.userId, this.userSpecialSettingCardId, this.warehouseIds});

  CreateUserWarehouseSpecialSettingsBody.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userSpecialSettingCardId = json['userSpecialSettingCardId'];
    warehouseIds = json['warehouseIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userSpecialSettingCardId'] = this.userSpecialSettingCardId;
    data['warehouseIds'] = this.warehouseIds;
    return data;
  }
}
