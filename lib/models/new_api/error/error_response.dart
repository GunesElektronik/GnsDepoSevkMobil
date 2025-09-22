class ErrorResponse {
  String? type;
  String? title;
  int? status;
  String? detail;
  String? instance;
  Extensions? extensions;

  ErrorResponse(
      {this.type,
      this.title,
      this.status,
      this.detail,
      this.instance,
      this.extensions});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    status = json['status'];
    detail = json['detail'];
    instance = json['instance'];
    extensions = json['extensions'] != null
        ? new Extensions.fromJson(json['extensions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['title'] = this.title;
    data['status'] = this.status;
    data['detail'] = this.detail;
    data['instance'] = this.instance;
    if (this.extensions != null) {
      data['extensions'] = this.extensions!.toJson();
    }
    return data;
  }
}

class Extensions {
  String? traceId;

  Extensions({this.traceId});

  Extensions.fromJson(Map<String, dynamic> json) {
    traceId = json['traceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['traceId'] = this.traceId;
    return data;
  }
}
