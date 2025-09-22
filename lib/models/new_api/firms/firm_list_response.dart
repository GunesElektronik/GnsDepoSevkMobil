class FirmListResponse {
  Firms? firms;

  FirmListResponse({this.firms});

  FirmListResponse.fromJson(Map<String, dynamic> json) {
    firms = json['firms'] != null ? new Firms.fromJson(json['firms']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.firms != null) {
      data['firms'] = this.firms!.toJson();
    }
    return data;
  }
}

class Firms {
  List<Items>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  Firms({this.items, this.totalItems, this.page, this.pageSize});

  Firms.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
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

class Items {
  String? firmId;
  String? title;
  String? street;
  String? road;
  String? doorNr;
  String? district;
  String? city;
  String? country;
  String? zipCode;
  String? phone1;
  String? phone2;
  String? taxNr;
  String? taxOff;
  String? traderEgisNo;
  String? mersisNo;
  String? earCentPass;
  String? earCentUser;
  String? earCentDefAddr;
  String? erpId;
  String? erpCode;

  Items(
      {this.firmId,
      this.title,
      this.street,
      this.road,
      this.doorNr,
      this.district,
      this.city,
      this.country,
      this.zipCode,
      this.phone1,
      this.phone2,
      this.taxNr,
      this.taxOff,
      this.traderEgisNo,
      this.mersisNo,
      this.earCentPass,
      this.earCentUser,
      this.earCentDefAddr,
      this.erpId,
      this.erpCode});

  Items.fromJson(Map<String, dynamic> json) {
    firmId = json['firmId'];
    title = json['title'];
    street = json['street'];
    road = json['road'];
    doorNr = json['doorNr'];
    district = json['district'];
    city = json['city'];
    country = json['country'];
    zipCode = json['zipCode'];
    phone1 = json['phone1'];
    phone2 = json['phone2'];
    taxNr = json['taxNr'];
    taxOff = json['taxOff'];
    traderEgisNo = json['traderEgisNo'];
    mersisNo = json['mersisNo'];
    earCentPass = json['earCentPass'];
    earCentUser = json['earCentUser'];
    earCentDefAddr = json['earCentDefAddr'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firmId'] = this.firmId;
    data['title'] = this.title;
    data['street'] = this.street;
    data['road'] = this.road;
    data['doorNr'] = this.doorNr;
    data['district'] = this.district;
    data['city'] = this.city;
    data['country'] = this.country;
    data['zipCode'] = this.zipCode;
    data['phone1'] = this.phone1;
    data['phone2'] = this.phone2;
    data['taxNr'] = this.taxNr;
    data['taxOff'] = this.taxOff;
    data['traderEgisNo'] = this.traderEgisNo;
    data['mersisNo'] = this.mersisNo;
    data['earCentPass'] = this.earCentPass;
    data['earCentUser'] = this.earCentUser;
    data['earCentDefAddr'] = this.earCentDefAddr;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    return data;
  }
}
