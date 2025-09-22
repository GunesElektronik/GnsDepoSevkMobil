class OrderUpdateQtyItem {
  String? orderItemId;
  String? productId;
  //String? warehouseId;
  int? shippedQty;

  OrderUpdateQtyItem(
      {required this.orderItemId,
      required this.productId,
      //required this.warehouseId,
      required this.shippedQty});

  OrderUpdateQtyItem.fromJson(Map<String, dynamic> json) {
    orderItemId = json['orderItemId'];
    productId = json['productId'];
    //warehouseId = json['warehouseId'];
    shippedQty = json['shippedQty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderItemId'] = this.orderItemId;
    data['productId'] = this.productId;
    //data['warehouseId'] = this.warehouseId;
    data['shippedQty'] = this.shippedQty;
    return data;
  }
}
