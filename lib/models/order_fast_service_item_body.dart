class OrderFastServiceItem {
  String? id;
  String? productId;
  String? warehouseId;
  int? shippedQty;
  String? description;

  OrderFastServiceItem(
      {required this.id,
      required this.productId,
      required this.warehouseId,
      required this.shippedQty,
      required this.description});

  OrderFastServiceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    warehouseId = json['warehouseId'];
    shippedQty = json['shippedQty'];
    description = json['description_'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['warehouseId'] = this.warehouseId;
    data['shippedQty'] = this.shippedQty;
    data['description_'] = this.description;
    return data;
  }
}
