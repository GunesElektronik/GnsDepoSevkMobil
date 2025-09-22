class OrderDetailCountModel {
  String name;
  String barcode;
  int qty;
  int scannedQty;
  bool isDone;

  OrderDetailCountModel(
      this.name, this.barcode, this.qty, this.isDone, this.scannedQty);
}
