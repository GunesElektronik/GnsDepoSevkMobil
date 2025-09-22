class SettingResult {
  String? apiUrl;

  SettingResult({this.apiUrl});

  factory SettingResult.fromJson(Map<String, dynamic> json) {
    return SettingResult(
      apiUrl: json['apiUrl'],
    );
  }
}
