class WarehouseTransferCreateBody {
  String? customerId;
  String? ficheNo;
  String? ficheDate;
  String? ficheTime;
  String? docNo;
  String? outWorkplaceId;
  String? outDepartmentId;
  String? outWarehouseId;
  String? inWorkplaceId;
  String? inDepartmentId;
  String? inWarehouseId;
  String? description;
  String? transporterId;
  String? customerAddressId;
  String? erpId;
  String? erpCode;
  int? waybillTypeId;
  String? projectId;
  List<WarehouseTransferItems>? warehouseTransferItems;

  WarehouseTransferCreateBody({
    this.customerId,
    this.ficheNo,
    this.ficheDate,
    this.ficheTime,
    this.docNo,
    this.outWorkplaceId,
    this.outDepartmentId,
    this.outWarehouseId,
    this.inWorkplaceId,
    this.inDepartmentId,
    this.inWarehouseId,
    this.description,
    this.transporterId,
    this.customerAddressId,
    this.erpId,
    this.erpCode,
    this.waybillTypeId,
    this.projectId,
    this.warehouseTransferItems,
  });

  WarehouseTransferCreateBody.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    ficheTime = json['ficheTime'];
    docNo = json['docNo'];
    outWorkplaceId = json['outWorkplaceId'];
    outDepartmentId = json['outDepartmentId'];
    outWarehouseId = json['outWarehouseId'];
    inWorkplaceId = json['inWorkplaceId'];
    inDepartmentId = json['inDepartmentId'];
    inWarehouseId = json['inWarehouseId'];
    description = json['description'];
    transporterId = json['transporterId'];
    customerAddressId = json['customerAddressId'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    waybillTypeId = json['waybillTypeId'];
    projectId = json['projectId'];
    if (json['warehouseTransferItems'] != null) {
      warehouseTransferItems = <WarehouseTransferItems>[];
      json['warehouseTransferItems'].forEach((v) {
        warehouseTransferItems!.add(new WarehouseTransferItems.fromJson(v));
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
    data['outWorkplaceId'] = this.outWorkplaceId;
    data['outDepartmentId'] = this.outDepartmentId;
    data['outWarehouseId'] = this.outWarehouseId;
    data['inWorkplaceId'] = this.inWorkplaceId;
    data['inDepartmentId'] = this.inDepartmentId;
    data['inWarehouseId'] = this.inWarehouseId;
    data['description'] = this.description;
    data['transporterId'] = this.transporterId;
    data['customerAddressId'] = this.customerAddressId;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    data['waybillTypeId'] = this.waybillTypeId;
    data['projectId'] = this.projectId;
    if (this.warehouseTransferItems != null) {
      data['warehouseTransferItems'] =
          this.warehouseTransferItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WarehouseTransferItems {
  String? productId;
  String? description;
  String? outWarehouseId;
  String? inWarehouseId;
  String? unitId;
  String? unitConversionId;
  int? qty;
  String? productLocationRelationId;
  String? projectId;
  String? erpId;
  String? erpCode;

  WarehouseTransferItems(
      {this.productId,
      this.description,
      this.outWarehouseId,
      this.inWarehouseId,
      this.unitId,
      this.unitConversionId,
      this.qty,
      this.productLocationRelationId,
      this.projectId,
      this.erpId,
      this.erpCode});

  WarehouseTransferItems.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    description = json['description'];
    outWarehouseId = json['outWarehouseId'];
    inWarehouseId = json['inWarehouseId'];
    unitId = json['unitId'];
    unitConversionId = json['unitConversionId'];
    qty = json['qty'];
    productLocationRelationId = json['productLocationRelationId'];
    projectId = json['projectId'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['description'] = this.description;
    data['outWarehouseId'] = this.outWarehouseId;
    data['inWarehouseId'] = this.inWarehouseId;
    data['unitId'] = this.unitId;
    data['unitConversionId'] = this.unitConversionId;
    data['qty'] = this.qty;
    data['productLocationRelationId'] = this.productLocationRelationId;
    data['projectId'] = this.projectId;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    return data;
  }
}
