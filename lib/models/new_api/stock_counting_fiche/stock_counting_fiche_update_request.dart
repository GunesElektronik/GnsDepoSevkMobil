class StockCountingFicheUpdateRequest {
  String? stockCountingFicheId;
  String? ficheNo;
  String? ficheDate;
  String? countingStartDate;
  String? description;
  String? stockCountingTeamId;
  String? warehouseId;
  bool? isClosed;
  List<Stockcountingficheitems>? stockcountingficheitems;

  StockCountingFicheUpdateRequest(
      {this.stockCountingFicheId,
      this.ficheNo,
      this.ficheDate,
      this.countingStartDate,
      this.description,
      this.stockCountingTeamId,
      this.warehouseId,
      this.isClosed,
      this.stockcountingficheitems});

  StockCountingFicheUpdateRequest.fromJson(Map<String, dynamic> json) {
    stockCountingFicheId = json['stockCountingFicheId'];
    ficheNo = json['ficheNo'];
    ficheDate = json['ficheDate'];
    countingStartDate = json['countingStartDate'];
    description = json['description_'];
    stockCountingTeamId = json['stockCountingTeamId'];
    warehouseId = json['warehouseId'];
    isClosed = json['isClosed'];
    if (json['stockcountingficheitems'] != null) {
      stockcountingficheitems = <Stockcountingficheitems>[];
      json['stockcountingficheitems'].forEach((v) {
        stockcountingficheitems!.add(new Stockcountingficheitems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockCountingFicheId'] = this.stockCountingFicheId;
    data['ficheNo'] = this.ficheNo;
    data['ficheDate'] = this.ficheDate;
    data['countingStartDate'] = this.countingStartDate;
    data['description_'] = this.description;
    data['stockCountingTeamId'] = this.stockCountingTeamId;
    data['warehouseId'] = this.warehouseId;
    data['isClosed'] = this.isClosed;
    if (this.stockcountingficheitems != null) {
      data['stockcountingficheitems'] =
          this.stockcountingficheitems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stockcountingficheitems {
  String? stockCountingFicheItemId;
  String? productId;
  int? productItemType;
  String? description;
  int? qty;
  String? warehouseId;
  String? unitId;
  String? unitConversionId;
  String? stockLocationId;
  String? erpId;
  String? erpCode;

  Stockcountingficheitems(
      {this.stockCountingFicheItemId,
      this.productId,
      this.productItemType,
      this.description,
      this.qty,
      this.warehouseId,
      this.unitId,
      this.unitConversionId,
      this.stockLocationId,
      this.erpId,
      this.erpCode});

  Stockcountingficheitems.fromJson(Map<String, dynamic> json) {
    stockCountingFicheItemId = json['stockCountingFicheItemId'];
    productId = json['productId'];
    productItemType = json['productItemType'];
    description = json['description_'];
    qty = json['qty'];
    warehouseId = json['warehouseId'];
    unitId = json['unitId'];
    unitConversionId = json['unitConversionId'];
    stockLocationId = json['stockLocationId'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockCountingFicheItemId'] = this.stockCountingFicheItemId;
    data['productId'] = this.productId;
    data['productItemType'] = this.productItemType;
    data['description_'] = this.description;
    data['qty'] = this.qty;
    data['warehouseId'] = this.warehouseId;
    data['unitId'] = this.unitId;
    data['unitConversionId'] = this.unitConversionId;
    data['stockLocationId'] = this.stockLocationId;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    return data;
  }
}
