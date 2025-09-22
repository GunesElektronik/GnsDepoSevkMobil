class MinusCountFicheRequestBody {
  String? customerId;
  String? ficheNo;
  String? ficheDate;
  String? ficheTime;
  String? docNo;
  String? inWorkplaceId;
  String? inDepartmentId;
  String? inWarehouseId;
  String? description;
  String? customerAddressId;
  String? erpId;
  String? erpCode;
  String? projectId;
  List<MinusCountFicheItem>? minusCountFicheItem;

  MinusCountFicheRequestBody(
      {this.customerId,
      this.ficheNo,
      this.ficheDate,
      this.ficheTime,
      this.docNo,
      this.inWorkplaceId,
      this.inDepartmentId,
      this.inWarehouseId,
      this.description,
      this.customerAddressId,
      this.erpId,
      this.erpCode,
      this.projectId,
      this.minusCountFicheItem});

  MinusCountFicheRequestBody.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    ficheTime = json['ficheTime'];
    docNo = json['docNo'];
    inWorkplaceId = json['inWorkplaceId'];
    inDepartmentId = json['inDepartmentId'];
    inWarehouseId = json['inWarehouseId'];
    description = json['description'];
    customerAddressId = json['customerAddressId'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    projectId = json['projectId'];
    if (json['minusCountFicheItem'] != null) {
      minusCountFicheItem = <MinusCountFicheItem>[];
      json['minusCountFicheItem'].forEach((v) {
        minusCountFicheItem!.add(new MinusCountFicheItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['ficheTime'] = this.ficheTime;
    data['docNo'] = this.docNo;
    data['inWorkplaceId'] = this.inWorkplaceId;
    data['inDepartmentId'] = this.inDepartmentId;
    data['inWarehouseId'] = this.inWarehouseId;
    data['description'] = this.description;
    data['customerAddressId'] = this.customerAddressId;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    data['projectId'] = this.projectId;
    if (this.minusCountFicheItem != null) {
      data['minusCountFicheItem'] =
          this.minusCountFicheItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MinusCountFicheItem {
  String? productId;
  String? description;
  String? inWarehouseId;
  String? unitId;
  String? unitConversionId;
  int? qty;
  String? productLocationRelationId;
  String? erpId;
  String? erpCode;
  String? projectId;

  MinusCountFicheItem({
    this.productId,
    this.description,
    this.inWarehouseId,
    this.unitId,
    this.unitConversionId,
    this.qty,
    this.productLocationRelationId,
    this.erpId,
    this.erpCode,
    this.projectId,
  });

  MinusCountFicheItem.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    description = json['description'];
    inWarehouseId = json['inWarehouseId'];
    unitId = json['unitId'];
    unitConversionId = json['unitConversionId'];
    qty = json['qty'];
    productLocationRelationId = json['productLocationRelationId'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    projectId = json['projectId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['description'] = this.description;
    data['inWarehouseId'] = this.inWarehouseId;
    data['unitId'] = this.unitId;
    data['unitConversionId'] = this.unitConversionId;
    data['qty'] = this.qty;
    data['productLocationRelationId'] = this.productLocationRelationId;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    data['projectId'] = this.projectId;
    return data;
  }
}
