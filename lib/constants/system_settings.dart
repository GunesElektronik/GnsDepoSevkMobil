// ignore_for_file: non_constant_identifier_names

class GNSSystemSettingsUtils {
  //waybill settings
  static String WaybillTypeSelection = "WaybillTypeSelection";
  static List<WaybillTypeItem> waybillTypeItemList = [
    WaybillTypeItem(0, "Kağıt"),
    WaybillTypeItem(1, "E-İrsaliye"),
  ];

  //warehouse settings
  static String WarehouseTransferTypeSelection =
      "WarehouseTransferTypeSelection";
  static List<TransferTypeItem> transferTypeItemList = [
    TransferTypeItem(0, "Kağıt"),
    TransferTypeItem(1, "E-İrsaliye"),
  ];

  //irsaliye oluşturulduktan sonra sipariş otomatik mi bırakılacak
  static String OrderAssignAutoDrop = "OrderAssignAutoDrop";
}

class WaybillTypeItem {
  final int id;
  final String type;

  WaybillTypeItem(this.id, this.type);
}

class TransferTypeItem {
  final int id;
  final String type;

  TransferTypeItem(this.id, this.type);
}
