class ProductStockWarehouseResponse {
  List<PStockWarehouse>? stockWarehouse;

  ProductStockWarehouseResponse({this.stockWarehouse});

  ProductStockWarehouseResponse.fromJson(Map<String, dynamic> json) {
    if (json['stockWarehouse'] != null) {
      stockWarehouse = <PStockWarehouse>[];
      json['stockWarehouse'].forEach((v) {
        stockWarehouse!.add(new PStockWarehouse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stockWarehouse != null) {
      data['stockWarehouse'] =
          this.stockWarehouse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PStockWarehouse {
  String? productId;
  String? warehouseId;
  String? warehouseName;
  String? locationId;
  String? locationName;
  int? quantity;
  int? reservedQuantity;

  PStockWarehouse(
      {this.productId,
      this.warehouseId,
      this.warehouseName,
      this.locationId,
      this.locationName,
      this.quantity,
      this.reservedQuantity});

  PStockWarehouse.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    warehouseId = json['warehouseId'];
    warehouseName = json['warehouseName'];
    locationId = json['locationId'];
    locationName = json['locationName'];
    quantity = json['quantity'];
    reservedQuantity = json['reservedQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['warehouseId'] = this.warehouseId;
    data['warehouseName'] = this.warehouseName;
    data['locationId'] = this.locationId;
    data['locationName'] = this.locationName;
    data['quantity'] = this.quantity;
    data['reservedQuantity'] = this.reservedQuantity;
    return data;
  }
}
