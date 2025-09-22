class TransferFicheRequestBody {
  String? ficheNo;
  String? ficheDate;
  String? ficheTime;
  String? docNo;
  String? inWorkplaceId;
  String? inDepartmentId;
  String? inWarehouseId;
  String? description;
  String? transporterId;
  String? erpId;
  String? erpCode;
  String? projectId;
  List<TransferFicheItems>? transferFicheItems;

  TransferFicheRequestBody(
      {this.ficheNo,
      this.ficheDate,
      this.ficheTime,
      this.docNo,
      this.inWorkplaceId,
      this.inDepartmentId,
      this.inWarehouseId,
      this.description,
      this.transporterId,
      this.erpId,
      this.erpCode,
      this.projectId,
      this.transferFicheItems});

  TransferFicheRequestBody.fromJson(Map<String, dynamic> json) {
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    ficheTime = json['ficheTime'];
    docNo = json['docNo'];
    inWorkplaceId = json['inWorkplaceId'];
    inDepartmentId = json['inDepartmentId'];
    inWarehouseId = json['inWarehouseId'];
    description = json['description'];
    transporterId = json['transporterId'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    projectId = json['projectId'];
    if (json['transferFicheItems'] != null) {
      transferFicheItems = <TransferFicheItems>[];
      json['transferFicheItems'].forEach((v) {
        transferFicheItems!.add(new TransferFicheItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['ficheTime'] = this.ficheTime;
    data['docNo'] = this.docNo;
    data['inWorkplaceId'] = this.inWorkplaceId;
    data['inDepartmentId'] = this.inDepartmentId;
    data['inWarehouseId'] = this.inWarehouseId;
    data['description'] = this.description;
    data['transporterId'] = this.transporterId;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    data['projectId'] = this.projectId;
    if (this.transferFicheItems != null) {
      data['transferFicheItems'] =
          this.transferFicheItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransferFicheItems {
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

  TransferFicheItems({
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

  TransferFicheItems.fromJson(Map<String, dynamic> json) {
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
