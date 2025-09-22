class CustomerAddressesResponse {
  List<Addresses>? addresses;

  CustomerAddressesResponse({this.addresses});

  CustomerAddressesResponse.fromJson(Map<String, dynamic> json) {
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  String? customerAddressId;
  String? name;
  String? description;
  String? district;
  String? townName;
  String? cityName;
  String? countryName;
  String? emailPrimary;
  String? emailSecondary;
  String? phoneNumberPrimary;
  String? phoneNumberSecondary;
  String? relatedPersonPrimary;
  String? relatedPersonSecondary;
  bool? isDefault;

  Addresses(
      {this.customerAddressId,
      this.name,
      this.description,
      this.district,
      this.townName,
      this.cityName,
      this.countryName,
      this.emailPrimary,
      this.emailSecondary,
      this.phoneNumberPrimary,
      this.phoneNumberSecondary,
      this.relatedPersonPrimary,
      this.relatedPersonSecondary,
      this.isDefault});

  Addresses.fromJson(Map<String, dynamic> json) {
    customerAddressId = json['customerAddressId'];
    name = json['name'];
    description = json['description'];
    district = json['district'];
    townName = json['townName'];
    cityName = json['cityName'];
    countryName = json['countryName'];
    emailPrimary = json['emailPrimary'];
    emailSecondary = json['emailSecondary'];
    phoneNumberPrimary = json['phoneNumberPrimary'];
    phoneNumberSecondary = json['phoneNumberSecondary'];
    relatedPersonPrimary = json['relatedPersonPrimary'];
    relatedPersonSecondary = json['relatedPersonSecondary'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerAddressId'] = this.customerAddressId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['district'] = this.district;
    data['townName'] = this.townName;
    data['cityName'] = this.cityName;
    data['countryName'] = this.countryName;
    data['emailPrimary'] = this.emailPrimary;
    data['emailSecondary'] = this.emailSecondary;
    data['phoneNumberPrimary'] = this.phoneNumberPrimary;
    data['phoneNumberSecondary'] = this.phoneNumberSecondary;
    data['relatedPersonPrimary'] = this.relatedPersonPrimary;
    data['relatedPersonSecondary'] = this.relatedPersonSecondary;
    data['isDefault'] = this.isDefault;
    return data;
  }
}
