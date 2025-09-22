import 'package:gns_warehouse/models/new_api/order_change_qty_item_model.dart';

class ShippedQtyRequestBody {
  String? orderId;
  List<OrderUpdateQtyItem>? shippedQty;

  ShippedQtyRequestBody({this.orderId, this.shippedQty});

  ShippedQtyRequestBody.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    if (json['shippedQty'] != null) {
      shippedQty = <OrderUpdateQtyItem>[];
      json['shippedQty'].forEach((v) {
        shippedQty!.add(new OrderUpdateQtyItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    if (this.shippedQty != null) {
      data['shippedQty'] = this.shippedQty!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
