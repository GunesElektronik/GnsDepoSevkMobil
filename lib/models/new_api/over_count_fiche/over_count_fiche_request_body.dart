class OverCountFicheRequestBody {
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
  List<OverCountFicheItem>? overCountFicheItem;

  OverCountFicheRequestBody(
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
      this.overCountFicheItem});

  OverCountFicheRequestBody.fromJson(Map<String, dynamic> json) {
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
    if (json['overCountFicheItem'] != null) {
      overCountFicheItem = <OverCountFicheItem>[];
      json['overCountFicheItem'].forEach((v) {
        overCountFicheItem!.add(new OverCountFicheItem.fromJson(v));
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
    if (this.overCountFicheItem != null) {
      data['overCountFicheItem'] =
          this.overCountFicheItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OverCountFicheItem {
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

  OverCountFicheItem({
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

  OverCountFicheItem.fromJson(Map<String, dynamic> json) {
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
