class SystemSettingsListResponse {
  List<SystemSettings>? systemSettings;

  SystemSettingsListResponse({this.systemSettings});

  SystemSettingsListResponse.fromJson(Map<String, dynamic> json) {
    if (json['systemSettings'] != null) {
      systemSettings = <SystemSettings>[];
      json['systemSettings'].forEach((v) {
        systemSettings!.add(new SystemSettings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.systemSettings != null) {
      data['systemSettings'] =
          this.systemSettings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SystemSettings {
  int? systemSettingId;
  String? name;
  String? descr;
  String? value;

  SystemSettings({this.systemSettingId, this.name, this.descr, this.value});

  SystemSettings.fromJson(Map<String, dynamic> json) {
    systemSettingId = json['systemSettingId'];
    name = json['name'];
    descr = json['descr'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['systemSettingId'] = this.systemSettingId;
    data['name'] = this.name;
    data['descr'] = this.descr;
    data['value'] = this.value;
    return data;
  }
}
