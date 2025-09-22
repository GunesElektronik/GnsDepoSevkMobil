class StockResponse {
  List<Stocks>? stocks;

  StockResponse({this.stocks});

  StockResponse.fromJson(Map<String, dynamic> json) {
    if (json['stocks'] != null) {
      stocks = <Stocks>[];
      json['stocks'].forEach((v) {
        stocks!.add(new Stocks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stocks != null) {
      data['stocks'] = this.stocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stocks {
  String? stockId;
  String? productId;
  Warehouse? warehouse;
  String? erpProductId;
  double? onHandStock;
  double? realStock;
  double? reserved;

  Stocks(
      {this.stockId,
      this.productId,
      this.warehouse,
      this.erpProductId,
      this.onHandStock,
      this.realStock,
      this.reserved});

  Stocks.fromJson(Map<String, dynamic> json) {
    stockId = json['stockId'];
    productId = json['productId'];
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
    erpProductId = json['erpProductId'];
    onHandStock = json['onHandStock'];
    realStock = json['realStock'];
    reserved = json['reserved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockId'] = this.stockId;
    data['productId'] = this.productId;
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.toJson();
    }
    data['erpProductId'] = this.erpProductId;
    data['onHandStock'] = this.onHandStock;
    data['realStock'] = this.realStock;
    data['reserved'] = this.reserved;
    return data;
  }
}

class Warehouse {
  String? warehouseId;
  String? code;
  String? definition;

  Warehouse({this.warehouseId, this.code, this.definition});

  Warehouse.fromJson(Map<String, dynamic> json) {
    warehouseId = json['warehouseId'];
    code = json['code'];
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warehouseId'] = this.warehouseId;
    data['code'] = this.code;
    data['definition'] = this.definition;
    return data;
  }
}
