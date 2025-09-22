class NewCustomerListResponse {
  Customers? customers;

  NewCustomerListResponse({this.customers});

  NewCustomerListResponse.fromJson(Map<String, dynamic> json) {
    customers = json['customers'] != null
        ? new Customers.fromJson(json['customers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customers != null) {
      data['customers'] = this.customers!.toJson();
    }
    return data;
  }
}

class Customers {
  List<CustomerItems>? items;
  int? totalItems;
  int? page;
  int? pageSize;

  Customers({this.items, this.totalItems, this.page, this.pageSize});

  Customers.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <CustomerItems>[];
      json['items'].forEach((v) {
        items!.add(new CustomerItems.fromJson(v));
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

class CustomerItems {
  String? customerId;
  String? name;
  String? code;
  String? emailPrimary;
  String? emailSecondary;
  String? phoneNumberPrimary;
  String? phoneNumberSecondary;
  List<CustomerSpecifications>? customerSpecifications;
  List<Addresses>? addresses;

  CustomerItems(
      {this.customerId,
      this.name,
      this.code,
      this.emailPrimary,
      this.emailSecondary,
      this.phoneNumberPrimary,
      this.phoneNumberSecondary,
      this.customerSpecifications,
      this.addresses});

  CustomerItems.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    name = json['name'];
    code = json['code'];
    emailPrimary = json['emailPrimary'];
    emailSecondary = json['emailSecondary'];
    phoneNumberPrimary = json['phoneNumberPrimary'];
    phoneNumberSecondary = json['phoneNumberSecondary'];
    if (json['customerSpecifications'] != null) {
      customerSpecifications = <CustomerSpecifications>[];
      json['customerSpecifications'].forEach((v) {
        customerSpecifications!.add(new CustomerSpecifications.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['name'] = this.name;
    data['code'] = this.code;
    data['emailPrimary'] = this.emailPrimary;
    data['emailSecondary'] = this.emailSecondary;
    data['phoneNumberPrimary'] = this.phoneNumberPrimary;
    data['phoneNumberSecondary'] = this.phoneNumberSecondary;
    if (this.customerSpecifications != null) {
      data['customerSpecifications'] =
          this.customerSpecifications!.map((v) => v.toJson()).toList();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerSpecifications {
  Specification? specification;
  SpecificationValue? specificationValue;

  CustomerSpecifications({this.specification, this.specificationValue});

  CustomerSpecifications.fromJson(Map<String, dynamic> json) {
    specification = json['specification'] != null
        ? new Specification.fromJson(json['specification'])
        : null;
    specificationValue = json['specificationValue'] != null
        ? new SpecificationValue.fromJson(json['specificationValue'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.specification != null) {
      data['specification'] = this.specification!.toJson();
    }
    if (this.specificationValue != null) {
      data['specificationValue'] = this.specificationValue!.toJson();
    }
    return data;
  }
}

class Specification {
  String? specificationId;
  String? code;
  String? name;

  Specification({this.specificationId, this.code, this.name});

  Specification.fromJson(Map<String, dynamic> json) {
    specificationId = json['specificationId'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specificationId'] = this.specificationId;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class SpecificationValue {
  String? specificationValueId;
  String? code;
  String? name;

  SpecificationValue({this.specificationValueId, this.code, this.name});

  SpecificationValue.fromJson(Map<String, dynamic> json) {
    specificationValueId = json['specificationValueId'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specificationValueId'] = this.specificationValueId;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class Addresses {
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
      {this.name,
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
