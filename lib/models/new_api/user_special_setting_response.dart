class UserSpecialSettingsResponse {
  List<UserSpecialSettings>? userSpecialSettings;

  UserSpecialSettingsResponse({this.userSpecialSettings});

  UserSpecialSettingsResponse.fromJson(Map<String, dynamic> json) {
    if (json['userSpecialSettings'] != null) {
      userSpecialSettings = <UserSpecialSettings>[];
      json['userSpecialSettings'].forEach((v) {
        userSpecialSettings!.add(new UserSpecialSettings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userSpecialSettings != null) {
      data['userSpecialSettings'] =
          this.userSpecialSettings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserSpecialSettings {
  String? id;
  int? userSpecialSettingCardId;
  String? userId;
  String? value;

  UserSpecialSettings(
      {this.id, this.userSpecialSettingCardId, this.userId, this.value});

  UserSpecialSettings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userSpecialSettingCardId = json['userSpecialSettingCardId'];
    userId = json['userId'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userSpecialSettingCardId'] = this.userSpecialSettingCardId;
    data['userId'] = this.userId;
    data['value'] = this.value;
    return data;
  }
}
