class CustomerRiskLimitResponse {
  CustomerRiskLimit? customerRiskLimit;

  CustomerRiskLimitResponse({this.customerRiskLimit});

  CustomerRiskLimitResponse.fromJson(Map<String, dynamic> json) {
    customerRiskLimit = json['customerRiskLimit'] != null
        ? new CustomerRiskLimit.fromJson(json['customerRiskLimit'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customerRiskLimit != null) {
      data['customerRiskLimit'] = this.customerRiskLimit!.toJson();
    }
    return data;
  }
}

class CustomerRiskLimit {
  double? accRiskLimit;
  double? myCRiskLimit;
  double? cstCsRiskLimit;
  double? cstCiroRiskLimit;
  double? despRiskLimit;
  double? despRiskLimitSug;
  double? ordRiskLimit;
  double? ordRiskLimitSugg;
  double? cstCsRiskTotal;
  double? accRiskTotal;
  double? despRiskTotal;
  double? ordRiskTotal;
  double? ordRiskTotalSugg;
  double? canUseRiskLimit;

  CustomerRiskLimit(
      {this.accRiskLimit,
      this.myCRiskLimit,
      this.cstCsRiskLimit,
      this.cstCiroRiskLimit,
      this.despRiskLimit,
      this.despRiskLimitSug,
      this.ordRiskLimit,
      this.ordRiskLimitSugg,
      this.cstCsRiskTotal,
      this.accRiskTotal,
      this.despRiskTotal,
      this.ordRiskTotal,
      this.ordRiskTotalSugg,
      this.canUseRiskLimit});

  CustomerRiskLimit.fromJson(Map<String, dynamic> json) {
    accRiskLimit = _parseToDouble(json['accRiskLimit']);
    myCRiskLimit = _parseToDouble(json['myCRiskLimit']);
    cstCsRiskLimit = _parseToDouble(json['cstCsRiskLimit']);
    cstCiroRiskLimit = _parseToDouble(json['cstCiroRiskLimit']);
    despRiskLimit = _parseToDouble(json['despRiskLimit']);
    despRiskLimitSug = _parseToDouble(json['despRiskLimitSug']);
    ordRiskLimit = _parseToDouble(json['ordRiskLimit']);
    ordRiskLimitSugg = _parseToDouble(json['ordRiskLimitSugg']);
    cstCsRiskTotal = _parseToDouble(json['cstCsRiskTotal']);
    accRiskTotal = _parseToDouble(json['accRiskTotal']);
    despRiskTotal = _parseToDouble(json['despRiskTotal']);
    ordRiskTotal = _parseToDouble(json['ordRiskTotal']);
    ordRiskTotalSugg = _parseToDouble(json['ordRiskTotalSugg']);
    canUseRiskLimit = _parseToDouble(json['canUseRiskLimit']);
  }

  double _parseToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else {
      return value;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accRiskLimit'] = this.accRiskLimit;
    data['myCRiskLimit'] = this.myCRiskLimit;
    data['cstCsRiskLimit'] = this.cstCsRiskLimit;
    data['cstCiroRiskLimit'] = this.cstCiroRiskLimit;
    data['despRiskLimit'] = this.despRiskLimit;
    data['despRiskLimitSug'] = this.despRiskLimitSug;
    data['ordRiskLimit'] = this.ordRiskLimit;
    data['ordRiskLimitSugg'] = this.ordRiskLimitSugg;
    data['cstCsRiskTotal'] = this.cstCsRiskTotal;
    data['accRiskTotal'] = this.accRiskTotal;
    data['despRiskTotal'] = this.despRiskTotal;
    data['ordRiskTotal'] = this.ordRiskTotal;
    data['ordRiskTotalSugg'] = this.ordRiskTotalSugg;
    data['canUseRiskLimit'] = this.canUseRiskLimit;
    return data;
  }
}
