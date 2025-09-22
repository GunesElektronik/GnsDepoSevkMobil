class CustomerListResponse {
  List<CustomerListData>? customerListData;
  int? totalCount;
  int? page;
  int? limit;
  bool? hasNextPage;
  int? next;
  int? prev;

  CustomerListResponse(
      {this.customerListData,
      this.totalCount,
      this.page,
      this.limit,
      this.hasNextPage,
      this.next,
      this.prev});

  CustomerListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      customerListData = <CustomerListData>[];
      json['data'].forEach((v) {
        customerListData!.add(new CustomerListData.fromJson(v));
      });
    }
    totalCount = json['totalCount'];
    page = json['page'];
    limit = json['limit'];
    hasNextPage = json['hasNextPage'];
    next = json['next'];
    prev = json['prev'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customerListData != null) {
      data['data'] = this.customerListData!.map((v) => v.toJson()).toList();
    }
    data['totalCount'] = this.totalCount;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['hasNextPage'] = this.hasNextPage;
    data['next'] = this.next;
    data['prev'] = this.prev;
    return data;
  }
}

class CustomerListData {
  String? id;
  String? code;
  String? name;
  Email? email;
  Email? phoneNumber;
  Email? relatedPerson;
  bool? isCustomer;
  IdentityNumber? identityNumber;
  Tax? tax;
  bool? isBlackList;
  bool? isPartialOrder;
  bool? isEWaybillShipment;
  EWaybillShipmentType? eWaybillShipmentType;
  Email? eWaybillShipmentEmailAddress;
  String? createdBy;
  String? modifiedBy;
  String? createdTime;
  String? modifiedTime;
  bool? isDeleted;

  CustomerListData(
      {this.id,
      this.code,
      this.name,
      this.email,
      this.phoneNumber,
      this.relatedPerson,
      this.isCustomer,
      this.identityNumber,
      this.tax,
      this.isBlackList,
      this.isPartialOrder,
      this.isEWaybillShipment,
      this.eWaybillShipmentType,
      this.eWaybillShipmentEmailAddress,
      this.createdBy,
      this.modifiedBy,
      this.createdTime,
      this.modifiedTime,
      this.isDeleted});

  CustomerListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    email = json['email'] != null ? new Email.fromJson(json['email']) : null;
    phoneNumber = json['phoneNumber'] != null
        ? new Email.fromJson(json['phoneNumber'])
        : null;
    relatedPerson = json['relatedPerson'] != null
        ? new Email.fromJson(json['relatedPerson'])
        : null;
    isCustomer = json['isCustomer'];
    identityNumber = json['identityNumber'] != null
        ? new IdentityNumber.fromJson(json['identityNumber'])
        : null;
    tax = json['tax'] != null ? new Tax.fromJson(json['tax']) : null;
    isBlackList = json['isBlackList'];
    isPartialOrder = json['isPartialOrder'];
    isEWaybillShipment = json['isEWaybillShipment'];
    eWaybillShipmentType = json['eWaybillShipmentType'] != null
        ? new EWaybillShipmentType.fromJson(json['eWaybillShipmentType'])
        : null;
    eWaybillShipmentEmailAddress = json['eWaybillShipmentEmailAddress'] != null
        ? new Email.fromJson(json['eWaybillShipmentEmailAddress'])
        : null;
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    createdTime = json['createdTime'];
    modifiedTime = json['modifiedTime'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    if (this.email != null) {
      data['email'] = this.email!.toJson();
    }
    if (this.phoneNumber != null) {
      data['phoneNumber'] = this.phoneNumber!.toJson();
    }
    if (this.relatedPerson != null) {
      data['relatedPerson'] = this.relatedPerson!.toJson();
    }
    data['isCustomer'] = this.isCustomer;
    if (this.identityNumber != null) {
      data['identityNumber'] = this.identityNumber!.toJson();
    }
    if (this.tax != null) {
      data['tax'] = this.tax!.toJson();
    }
    data['isBlackList'] = this.isBlackList;
    data['isPartialOrder'] = this.isPartialOrder;
    data['isEWaybillShipment'] = this.isEWaybillShipment;
    if (this.eWaybillShipmentType != null) {
      data['eWaybillShipmentType'] = this.eWaybillShipmentType!.toJson();
    }
    if (this.eWaybillShipmentEmailAddress != null) {
      data['eWaybillShipmentEmailAddress'] =
          this.eWaybillShipmentEmailAddress!.toJson();
    }
    data['createdBy'] = this.createdBy;
    data['modifiedBy'] = this.modifiedBy;
    data['createdTime'] = this.createdTime;
    data['modifiedTime'] = this.modifiedTime;
    data['isDeleted'] = this.isDeleted;
    return data;
  }
}

class Email {
  String? primary;
  String? secondary;

  Email({this.primary, this.secondary});

  Email.fromJson(Map<String, dynamic> json) {
    primary = json['primary'];
    secondary = json['secondary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['primary'] = this.primary;
    data['secondary'] = this.secondary;
    return data;
  }
}

class IdentityNumber {
  String? value;

  IdentityNumber({this.value});

  IdentityNumber.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    return data;
  }
}

class Tax {
  String? number;
  String? officeCode;

  Tax({this.number, this.officeCode});

  Tax.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    officeCode = json['officeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['officeCode'] = this.officeCode;
    return data;
  }
}

class EWaybillShipmentType {
  String? name;
  int? id;
  String? displayName;

  EWaybillShipmentType({this.name, this.id, this.displayName});

  EWaybillShipmentType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['displayName'] = this.displayName;
    return data;
  }
}
