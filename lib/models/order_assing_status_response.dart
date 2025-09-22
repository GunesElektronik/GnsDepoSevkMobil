class OrderAssingStatusResponse {
  OrderAssingStatusData? data;
  Message? message;

  OrderAssingStatusResponse({this.data, this.message});

  OrderAssingStatusResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new OrderAssingStatusData.fromJson(json['data'])
        : null;
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class OrderAssingStatusData {
  int? operationType;
  bool? isSuccess;

  OrderAssingStatusData({this.operationType, this.isSuccess});

  OrderAssingStatusData.fromJson(Map<String, dynamic> json) {
    operationType = json['operationType'];
    isSuccess = json['isSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operationType'] = operationType;
    data['isSuccess'] = isSuccess;
    return data;
  }
}

class Message {
  String? title;
  String? description;
  List<CallToActions>? callToActions;
  int? callToActionType;

  Message(
      {this.title,
      this.description,
      this.callToActions,
      this.callToActionType});

  Message.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    if (json['callToActions'] != null) {
      callToActions = <CallToActions>[];
      json['callToActions'].forEach((v) {
        callToActions!.add(new CallToActions.fromJson(v));
      });
    }
    callToActionType = json['callToActionType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = title;
    data['description'] = description;
    if (callToActions != null) {
      data['callToActions'] = callToActions!.map((v) => v.toJson()).toList();
    }
    data['callToActionType'] = callToActionType;
    return data;
  }
}

class CallToActions {
  String? name;
  String? text;

  CallToActions({this.name, this.text});

  CallToActions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['text'] = text;
    return data;
  }
}
