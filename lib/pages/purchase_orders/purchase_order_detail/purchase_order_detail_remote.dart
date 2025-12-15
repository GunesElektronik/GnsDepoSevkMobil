import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/entity_constants.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:gns_warehouse/constants/system_settings.dart';
import 'package:gns_warehouse/constants/user_special_settings.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/database/model/product_barcodes_item.dart';
import 'package:gns_warehouse/database/model/purchase_order_detail_item_db.dart';
import 'package:gns_warehouse/database/model/purchase_order_detail_scanned_item.dart';
import 'package:gns_warehouse/models/new_api/customer_risk_limit_response.dart';
import 'package:gns_warehouse/models/new_api/doc_number_get_fiche_number.dart';
import 'package:gns_warehouse/models/new_api/order_change_qty_item_model.dart';
import 'package:gns_warehouse/models/new_api/product_detail_barcode_response.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_detail.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_summary_list_response.dart';
import 'package:gns_warehouse/models/new_api/waybill_request_body_new.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/models/order_detail/order_detail_item_db.dart';
import 'package:gns_warehouse/models/purchase_order_summary_local.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order_scan_page.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_transporter.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:gns_warehouse/widgets/gns_error_field.dart';
import 'package:gns_warehouse/widgets/gns_request_not_found.dart';
import 'package:gns_warehouse/widgets/gns_text_field.dart';
import 'package:intl/intl.dart';

class PurchaseOrderDetailRemote extends StatefulWidget {
  const PurchaseOrderDetailRemote(
      {super.key, required this.purchaseOrderId, required this.item, required this.onValueChanged});

  final String purchaseOrderId;
  final PurchaseOrderSummaryItem item;
  final ValueChanged<PurchaseOrderSummaryItem> onValueChanged;

  @override
  State<PurchaseOrderDetailRemote> createState() => _PurchaseOrderDetailRemoteState();
}

class _PurchaseOrderDetailRemoteState extends State<PurchaseOrderDetailRemote> {
  late ApiRepository apiRepository;
  late PurchaseOrderDetailResponse response;
  late bool isDataFetch;
  bool isRequestSuccess = true;
  late bool? isThisInMultiOrder;
  late bool isPartialOrder;
  late bool isAssing;
  bool isAuthPurchaseCancelAssign = false;
  bool isAuthChangeOrderStatus = true;
  late bool isAssingedPersonIsCurrenUser;
  final DbHelper _dbHelper = DbHelper.instance;
  List<PurchaseOrderDetailItemDB>? orderDetailItemList = [];
  WayybillsRequestBodyNew? waybillRequestBody;
  DateTime currentDate = DateTime.now();
  bool isPriceVisible = false;

  bool isThereWarehouseBoundForUser = false;
  bool isOrderAssignAutoDrop = false;
  late WorkplaceListResponse? workplaceListResponse;
  List<WorkplaceWarehouse> allWarehouse = [];
  List<String> userSpecialWarehouseList = [];
  bool isLoading = false;
  String warehouseInitName = "Ambar";
  String warehouseName = "Ambar";
  String workplaceId = "";
  String departmentId = "";
  String warehouseId = "";
  String userDefaultWarehouseIn = "";
  String projectId = "";
  String projectName = "";
  String transporterId = "";

  String guidEmpty = "00000000-0000-0000-0000-000000000000";

  String customerId = "";
  late CustomerRiskLimitResponse riskLimitResponse;
  bool isCustomerInRiskLimit = false;
  double differenceWithRiskLimit = 0;
  String ficheNoThatCreatedByUser = "";

  DocNumberGetFicheNumberResponse? getFicheNumberResponse;
  String salesWaybillFicheNo = "";

  String waybillTypeName = "";
  bool isWaybillTypeSelectable = false;
  int waybillTypeId = 1;
  List<WaybillTypeItem> waybillTypeItem = GNSSystemSettingsUtils.waybillTypeItemList;

  int orderStatusId = -1;
  String orderStatusName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createApiRepository();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _createApiRepository() async {
    isDataFetch = false;
    isThisInMultiOrder = false;
    apiRepository = await ApiRepository.create(context);
    try {
      isAuthPurchaseCancelAssign =
          await ServiceSharedPreferences.getSharedBool(UserSpecialSettingsUtils.isAuthPurchaseCancelAssign) ?? false;
      isAuthChangeOrderStatus =
          await ServiceSharedPreferences.getSharedBool(UserSpecialSettingsUtils.isAuthPurchaseChangeOrderStatus) ??
              false;
      isPriceVisible = await ServiceSharedPreferences.getSharedBool(SharedPreferencesKey.isPriceVisible) ?? false;
      isOrderAssignAutoDrop =
          await ServiceSharedPreferences.getSharedBool(GNSSystemSettingsUtils.OrderAssignAutoDrop) ?? false;
    } catch (e) {}
    await _getWaybillTypeSelection();
    isThisInMultiOrder = await _dbHelper.isThereAnyItemBasedOrderIdInMultiPurchaseOrder(widget.purchaseOrderId);
    _getUserSpecialWarehouseSettings();
    try {
      response = await apiRepository.getPurchaseOrderDetail(widget.purchaseOrderId);
    } catch (e) {
      isRequestSuccess = false;
    }
    orderStatusId = response.order?.orderStatusId ?? -1;
    orderStatusName = response.order?.orderStatusName ?? "";
    transporterId = response.order?.transporter?.transporterId ?? "";
    workplaceId = response.order?.workplace?.workplaceId ?? "";
    departmentId = response.order?.department?.departmentId ?? "";
    warehouseId = response.order?.warehouse?.warehouseId ?? "";
    projectId = response.order?.project?.projectId ?? guidEmpty;
    projectName = response.order?.project?.code ?? "";
    workplaceListResponse = await apiRepository.getWorkplaceList();
    allWarehouse = _getAllWarehouseList();
    isPartialOrder = response.order?.isPartialOrder ?? false;
    customerId = response.order?.customer?.customerId ?? "";
    await checkCustomerRiskLimit();
    response.order!.orderItems!.forEach((element) {
      orderDetailItemList!.add(
        PurchaseOrderDetailItemDB(
            purchaseOrderId: widget.purchaseOrderId,
            orderItemId: element.orderItemId,
            productId: element.product!.productId,
            warehouseId: element.warehouseId,
            ficheNo: response.order!.ficheNo,
            productName: element.product!.definition,
            productBarcode: element.product!.barcode,
            warehouse: element.warehouseName,
            serilotType: _transformToIntForProductTracking(element.product!.productTrackingMethod!),
            scannedQty: element.shippedQty!.toInt()!,
            shippedQty: 0,
            qty: element.qty!.toInt()),
      );
    });

    if (response.order!.isAssing!) {
      if (response.order!.assingmentEmail == apiRepository.employeeEmail) {
        isAssingedPersonIsCurrenUser = true;
        _getLocalOrderDetailItemList();
        if (!isThisInMultiOrder!) {
          _savePurchaseOrderSummaryOnLocal();
        }
      } else {
        isAssingedPersonIsCurrenUser = false;
      }
    } else {
      isAssingedPersonIsCurrenUser = false;
    }
    setState(() {
      isDataFetch = true;
      if (response.order != null) {
        isAssing = response.order!.isAssing as bool;
        //print("adet: ${widget.orderId}");
      }
    });
    //print("response: ${response.data!.isAssing}");
  }

  Future<void> _getWaybillTypeSelection() async {
    String waybillType =
        await ServiceSharedPreferences.getSharedString(GNSSystemSettingsUtils.WaybillTypeSelection) ?? "";

    switch (waybillType) {
      case "0":
        waybillTypeName = "Kağıt";
        waybillTypeId = 0;
        isWaybillTypeSelectable = false;
        break;
      case "1":
        waybillTypeName = "E-İrsaliye";
        waybillTypeId = 1;
        isWaybillTypeSelectable = false;
        break;
      case "2":
        waybillTypeName = "Kağıt";
        waybillTypeId = 0;
        isWaybillTypeSelectable = true;
        setState(() {});
        break;
      case "3":
        waybillTypeName = "E-İrsaliye";
        waybillTypeId = 1;
        isWaybillTypeSelectable = true;
        break;
      default:
    }
  }

  Future<void> checkCustomerRiskLimit() async {
    riskLimitResponse = await apiRepository.getCustomerRiskLimit(customerId);

    if (riskLimitResponse.customerRiskLimit != null) {
      if (response.order!.grossTotal! > riskLimitResponse.customerRiskLimit!.canUseRiskLimit!) {
        isCustomerInRiskLimit = true;
        differenceWithRiskLimit = response.order!.grossTotal! - riskLimitResponse.customerRiskLimit!.canUseRiskLimit!;
      }
    }
  }

  Future<void> _getUserSpecialWarehouseSettings() async {
    String userSpecialSetting =
        await ServiceSharedPreferences.getSharedString(UserSpecialSettingsUtils.userWarehouseAuthIn) ?? "";

    userDefaultWarehouseIn =
        await ServiceSharedPreferences.getSharedString(UserSpecialSettingsUtils.userDefaultWarehouseIn) ?? "";

    if (userSpecialSetting.isNotEmpty) {
      List<dynamic> decodedValue = jsonDecode(userSpecialSetting);
      setState(() {
        userSpecialWarehouseList = List<String>.from(decodedValue);
        isThereWarehouseBoundForUser = true;
      });
    } else {}
  }

  int _transformToIntForProductTracking(String trackingMethod) {
    if (trackingMethod == "Normal") {
      return 1;
    } else if (trackingMethod == "Seri") {
      return 2;
    } else if (trackingMethod == "Lot") {
      return 3;
    } else {
      return -1;
    }
  }

  void _savePurchaseOrderSummaryOnLocal() async {
    PurchaseOrderSummaryLocal? item = await _dbHelper.getPurchaseOrderHeaderById(widget.purchaseOrderId);

    if (item == null) {
      await _dbHelper.addPurchaseOrderSummary(_updateCurrentPurchaseOrderSummaryItem());
    }
  }

  void _deletePurchaseOrderSummaryOnLocal() async {
    PurchaseOrderSummaryLocal? item = await _dbHelper.getPurchaseOrderHeaderById(widget.purchaseOrderId);

    if (item != null) {
      await _dbHelper.removePurchaseOrderSummary(widget.purchaseOrderId);
    }
  }

  void _getLocalOrderDetailItemList() async {
    var results = await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);
    orderDetailItemList = results;

    if (orderDetailItemList!.isEmpty) {
      await _saveProductAndOrderItems();
      // response.order!.orderItems!.forEach((element) async {
      //   _getProductBarcodes(element.product!.productId!);
      //   await _dbHelper.addPurchaseOrderDetailItem(PurchaseOrderDetailItemDB(
      //     purchaseOrderId: widget.purchaseOrderId,
      //     orderItemId: element.orderItemId,
      //     productId: element.product!.productId!,
      //     warehouseId: element.warehouseId,
      //     stockLocationId: "",
      //     ficheNo: response.order!.ficheNo,
      //     productName: element.product!.definition,
      //     productBarcode: element.product!.barcode,
      //     warehouse: element.warehouseName,
      //     isProductLocatin: element.product!.isProductLocatin!,
      //     stockLocationName: "",
      //     serilotType: _transformToIntForProductTracking(
      //         element.product!.productTrackingMethod!),
      //     scannedQty: element.shippedQty!.toInt(),
      //     qty: element.qty!.toInt(),
      //     shippedQty: element.shippedQty!.toInt(),
      //   ));
      // });

      var results = await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);
      orderDetailItemList = results;
    } else {
      bool isThereChange1 = await _checkForRowItemsAddOrDeleteFromLogo();
      bool isThereChange2 = await _checkForRowItemsQtyChangedFromLogo();

      if (isThereChange1 == true || isThereChange2 == true) {
        var results = await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);
        orderDetailItemList = results;
      }
    }

    setState(() {});
  }

  Future<bool> _checkForRowItemsQtyChangedFromLogo() async {
    bool isThereAnyChange = false;
    for (int i = 0; i < response.order!.orderItems!.length; i++) {
      var remoteElement = response.order!.orderItems![i];
      for (int j = 0; j < orderDetailItemList!.length; j++) {
        var localElement = orderDetailItemList![j];
        if (localElement.qty! != remoteElement.qty!.toInt() && localElement.orderItemId == remoteElement.orderItemId) {
          isThereAnyChange = true;
          await _dbHelper.updatePurchaseOrderDetailItemQty(
              widget.purchaseOrderId, localElement.orderItemId!, localElement.warehouseId!, remoteElement.qty!.toInt());
        }
      }
    }

    return isThereAnyChange;
  }

  Future<bool> _checkForRowItemsAddOrDeleteFromLogo() async {
    List<OrderItems> addedItems = findAddedItems(orderDetailItemList!, response.order!.orderItems!);
    List<PurchaseOrderDetailItemDB> deletedItems = findDeletedItems(orderDetailItemList!, response.order!.orderItems!);

    for (OrderItems item in addedItems) {
      await _dbHelper.addPurchaseOrderDetailItem(PurchaseOrderDetailItemDB(
        purchaseOrderId: widget.purchaseOrderId,
        orderItemId: item.orderItemId,
        productId: item.product!.productId!,
        warehouseId: item.warehouseId,
        stockLocationId: "",
        ficheNo: response.order!.ficheNo,
        productName: item.product!.definition ?? "",
        productBarcode: item.product!.barcode,
        warehouse: item.warehouseName,
        isProductLocatin: item.product!.isProductLocatin ?? false,
        stockLocationName: "",
        serilotType: _transformToIntForProductTracking(item.product!.productTrackingMethod!),
        scannedQty: item.shippedQty!.toInt(),
        qty: item.qty!.toInt(),
        shippedQty: item.shippedQty!.toInt(),
        lineNr: item.lineNr!.toInt(),
      ));
    }

    for (PurchaseOrderDetailItemDB item in deletedItems) {
      await _dbHelper.deletePurchaseOrderDetailItem(item.purchaseOrderId!, item.orderItemId!, item.warehouseId!);
    }

    if (addedItems.length > 0 || deletedItems.length > 0) {
      return true;
    } else {
      return false;
    }

    // if (response.order!.orderItems!.length > orderDetailItemList!.length) {
    //   //logoya yeni satır eklenmiş
    // } else if (response.order!.orderItems!.length <
    //     orderDetailItemList!.length) {
    //   //logodan satır silinmiş
    // } else {
    //   //eşit
    // }
  }

  bool _checkForWaybillItemsNotEmpty() {
    for (int i = 0; i < orderDetailItemList!.length; i++) {
      if (orderDetailItemList![i].scannedQty! > orderDetailItemList![i].shippedQty!) {
        return true;
      }
    }

    return false;
  }

  List<PurchaseOrderDetailItemDB> findDeletedItems(List<PurchaseOrderDetailItemDB> oldList, List<OrderItems> newList) {
    List<PurchaseOrderDetailItemDB> deletedItems = [];
    for (PurchaseOrderDetailItemDB item in oldList) {
      if (!newList.any((newItem) => newItem.orderItemId == item.orderItemId)) {
        deletedItems.add(item);
      }
    }
    return deletedItems;
  }

  List<OrderItems> findAddedItems(List<PurchaseOrderDetailItemDB> oldList, List<OrderItems> newList) {
    List<OrderItems> addedItems = [];
    for (OrderItems item in newList) {
      if (!oldList.any((oldItem) => oldItem.orderItemId == item.orderItemId)) {
        addedItems.add(item);
      }
    }
    return addedItems;
  }

  Future<void> _saveProductAndOrderItems() async {
    for (int i = 0; i < response.order!.orderItems!.length; i++) {
      await _getProductBarcodes(response.order!.orderItems![i].product!.productId!);
      await _dbHelper.addPurchaseOrderDetailItem(PurchaseOrderDetailItemDB(
        purchaseOrderId: widget.purchaseOrderId,
        orderItemId: response.order!.orderItems![i].orderItemId,
        productId: response.order!.orderItems![i].product!.productId!,
        warehouseId: response.order!.orderItems![i].warehouseId,
        stockLocationId: "",
        ficheNo: response.order!.ficheNo,
        productName: response.order!.orderItems![i].product?.definition ?? "",
        productBarcode: response.order!.orderItems![i].product!.barcode,
        warehouse: response.order!.orderItems![i].warehouseName,
        isProductLocatin: response.order!.orderItems![i].product!.isProductLocatin ?? false,
        stockLocationName: "",
        serilotType: _transformToIntForProductTracking(response.order!.orderItems![i].product!.productTrackingMethod!),
        scannedQty: response.order!.orderItems![i].shippedQty!.toInt(),
        qty: response.order!.orderItems![i].qty!.toInt(),
        shippedQty: response.order!.orderItems![i].shippedQty!.toInt(),
        lineNr: response.order!.orderItems![i].lineNr!.toInt(),
      ));
    }
  }

  Future<List<String>> _checkStock() async {
    List<String> insufficientStockProducts = [];
    var result = await apiRepository.getStockByProductIdList(_createStockByProductList());
    result!.stocks!.forEach((remoteElement) {
      orderDetailItemList!.forEach((localElement) {
        if (remoteElement.productId == localElement.productId &&
            remoteElement.warehouse!.warehouseId == localElement.warehouseId) {
          if (remoteElement.onHandStock! < localElement.scannedQty! - localElement.shippedQty!) {
            insufficientStockProducts.add(localElement.productName!);
          }
        }
      });
    });

    return insufficientStockProducts;
  }

  List<String> _createStockByProductList() {
    List<String> idList = [];
    orderDetailItemList!.forEach((element) {
      idList.add(element.productId!);
    });
    return idList;
  }

  Future<void> _setOrderAssingStatus(bool isAssingRemote) async {
    if (isAssingRemote) {
      await _takeTheOrder();
    } else {
      await _completeTheOrder();
    }
  }

  Future<bool> _completeTheOrder() async {
    // bool isUpdate = false;
    bool isSuccess = false;
    _showLoadingScreen(true, "Yükleniyor ...");

    var orderItemList = await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);

    //print("productId: ${orderItemList![0].productId}");

    // butonu tamamlaya bastıktan sonra servisteki verileri güncelliyor

    // if (orderItemList!.isNotEmpty) {
    //   var orderItemsList = orderItemList
    //       .map((orderItemDB) => OrderUpdateQtyItem(
    //             orderItemId: orderItemDB.orderItemId,
    //             productId: orderItemDB.productId,
    //             shippedQty: orderItemDB.scannedQty,
    //           ))
    //       .toList();
    //   try {
    //     isUpdate = await apiRepository.updatePurchaseOrderItems(
    //         widget.purchaseOrderId, customerId, orderItemsList);
    //   } catch (e) {
    //     print("İşlem hatası: $e");
    //     _showLoadingScreen(false, "Yükleniyor ...");
    //     return false;
    //   }
    // } else {
    //   isUpdate = true;
    // }
    //isUpdate = true;

    // if (isUpdate) {
    //   isSuccess = await apiRepository.setPurchaseOrderAssingStatus(
    //       false, apiRepository.employeeUid, widget.purchaseOrderId);
    //   _showLoadingScreen(false, "Yükleniyor ...");
    // }

    isSuccess =
        await apiRepository.setPurchaseOrderAssingStatus(false, apiRepository.employeeUid, widget.purchaseOrderId);
    _showLoadingScreen(false, "Yükleniyor ...");

    //&& isUpdate yorum aldım

    if (isSuccess) {
      print("işlem başarılı");
      _showLoadingScreen(true, "Veriler Güncelleniyor ...");
      _deletePurchaseOrderSummaryOnLocal();
      response = await apiRepository.getPurchaseOrderDetail(widget.purchaseOrderId);
      await _dbHelper.clearAllPurchaseOrderDetailItems(widget.purchaseOrderId);

      await _dbHelper.removePurchaseOrderDetailScannedItems(response.order!.ficheNo!);
      await _dbHelper.clearAllProductBarcodes(widget.purchaseOrderId);

      _showLoadingScreen(false, "Veriler Güncelleniyor ...");
      setState(() {
        isAssing = false;
        isAssingedPersonIsCurrenUser = true;
        widget.onValueChanged(_updateCurrentPurchaseOrderSummaryItem());
      });
      _showDialogMessage("BAŞARILI", "İşlem başarılı");
      return true;

      //db kaydet işlemleri
    } else {
      print("işlem başarısız");
      _showDialogMessage("HATA !", "Siparişi üzerinize alamadınız !");
      return false;

      //error ver
    }
  }

  bool _checkAllItemsCollectedCompletely() {
    for (int i = 0; i < orderDetailItemList!.length; i++) {
      if (orderDetailItemList![i].scannedQty != orderDetailItemList![i].qty) {
        return false;
      }
    }

    return true;
  }

  Future<void> _changePurchaseOrderStatusRequest() async {
    _showLoadingScreen(true, "Yükleniyor");
    try {
      await apiRepository.setPurchaseOrderStatus(widget.purchaseOrderId, orderStatusId);
      await _dbHelper.updateOrderStatusForPurchaseOrderHeader(orderStatusName, widget.purchaseOrderId);
      _showLoadingScreen(false, "Yükleniyor");
    } catch (e) {
      _showLoadingScreen(false, "Yükleniyor");
      _showDialogMessage("HATA !", "Sipariş durumu değiştilirken hata oluştu. \n ${e.toString()}");
    }
  }

  Future<bool> _completeTheOrder2() async {
    bool isUpdate = false;
    bool isSuccess = false;

    var orderItemList = await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);

    //print("productId: ${orderItemList![0].productId}");

    // butonu tamamlaya bastıktan sonra servisteki verileri güncelliyor

    if (orderItemList!.isNotEmpty) {
      var orderItemsList = orderItemList
          .map((orderItemDB) => OrderUpdateQtyItem(
                orderItemId: orderItemDB.orderItemId,
                productId: orderItemDB.productId,
                shippedQty: orderItemDB.scannedQty,
              ))
          .toList();
      try {
        isUpdate = await apiRepository.updatePurchaseOrderItems(widget.purchaseOrderId, customerId, orderItemsList);
      } catch (e) {
        print("İşlem hatası: $e");
        // _showLoadingScreen(false, "Yükleniyor ...");
        return false;
      }
    } else {
      isUpdate = true;
    }
    //isUpdate = true;

    if (isOrderAssignAutoDrop) {
      if (isUpdate) {
        isSuccess =
            await apiRepository.setPurchaseOrderAssingStatus(false, apiRepository.employeeUid, widget.purchaseOrderId);
        // _showLoadingScreen(false, "Yükleniyor ...");
      }
    }

    if (isSuccess && isUpdate) {
      print("işlem başarılı");
      // _showLoadingScreen(true, "Veriler Güncelleniyor ...");
      _deletePurchaseOrderSummaryOnLocal();
      response = await apiRepository.getPurchaseOrderDetail(widget.purchaseOrderId);
      await _dbHelper.clearAllPurchaseOrderDetailItems(widget.purchaseOrderId);

      await _dbHelper.removePurchaseOrderDetailScannedItems(response.order!.ficheNo!);
      await _dbHelper.clearAllProductBarcodes(widget.purchaseOrderId);

      // _showLoadingScreen(false, "Veriler Güncelleniyor ...");
      setState(() {
        isAssing = false;
        isAssingedPersonIsCurrenUser = true;
        widget.onValueChanged(_updateCurrentPurchaseOrderSummaryItem());
      });
      // _showDialogMessage("BAŞARILI", "İşlem başarılı");
      return true;

      //db kaydet işlemleri
    } else if (isUpdate && !isSuccess) {
      print("işlem başarılı");
      response = await apiRepository.getPurchaseOrderDetail(widget.purchaseOrderId);

      for (int j = 0; j < orderDetailItemList!.length; j++) {
        var localElement = orderDetailItemList![j];

        await _dbHelper.updatePurchaseOrderDetailItemShippedQty(
          widget.purchaseOrderId,
          localElement.orderItemId!,
          localElement.warehouseId!,
          localElement.scannedQty!,
        );
      }

      await _dbHelper.removePurchaseOrderDetailScannedItems(response.order!.ficheNo!);
      var results = await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);
      orderDetailItemList = results;
      // _showLoadingScreen(false, "Veriler Güncelleniyor ...");

      setState(() {});
      // _showDialogMessage("BAŞARILI", "İşlem başarılı");
      return false;
    } else {
      print("işlem başarısız");
      // _showDialogMessage("HATA !", "Siparişi üzerinize alamadınız !");
      return false;

      //error ver
    }
  }

  _getProductBarcodes(String productId) async {
    var result = await apiRepository.getProductDetailBarcodes(productId);
    result.products!.unit!.conversions!.forEach((element) async {
      element.barcodes!.forEach((barcode) async {
        await _dbHelper.addProductBarcode(_createProductBarcodeItem(
            productId, barcode.barcode!, element.code!, element.convParam1!, element.convParam2!));
      });
    });
  }

  ProductBarcodesItemLocal _createProductBarcodeItem(
      String productId, String barcode, String code, int convParam1, int convParam2) {
    return ProductBarcodesItemLocal(
      recid: 0,
      orderId: widget.purchaseOrderId,
      productId: productId,
      barcode: barcode,
      code: code,
      convParam1: convParam1,
      convParam2: convParam2,
    );
  }

  _takeTheOrder() async {
    _showLoadingScreen(true, "Yükleniyor ...");
    //await Future.delayed(Duration(seconds: 3));
    //bool isSuccess = true;

    bool isSuccess =
        await apiRepository.setPurchaseOrderAssingStatus(true, apiRepository.employeeUid, widget.purchaseOrderId);
    _showLoadingScreen(false, "Yükleniyor ...");

    //bool deneme = false;
    if (isSuccess) {
      print("işlem başarılı");
      _showLoadingScreen(true, "Veriler Güncelleniyor ...");

      response = await apiRepository.getPurchaseOrderDetail(widget.purchaseOrderId);
      await _dbHelper.clearAllPurchaseOrderDetailItems(widget.purchaseOrderId);

      await _saveProductAndOrderItems();
      // response.order!.orderItems!.forEach((element) async {
      //   _getProductBarcodes(element.product!.productId!);
      //   await _dbHelper.addPurchaseOrderDetailItem(PurchaseOrderDetailItemDB(
      //     purchaseOrderId: widget.purchaseOrderId,
      //     orderItemId: element.orderItemId,
      //     productId: element.product!.productId!,
      //     warehouseId: element.warehouseId,
      //     stockLocationId: "",
      //     ficheNo: response.order!.ficheNo,
      //     productName: element.product!.definition,
      //     productBarcode: element.product!.barcode,
      //     warehouse: element.warehouseName,
      //     isProductLocatin: element.product!.isProductLocatin!,
      //     stockLocationName: "",
      //     serilotType: _transformToIntForProductTracking(
      //         element.product!.productTrackingMethod!),
      //     scannedQty: element.shippedQty!.toInt(),
      //     qty: element.qty!.toInt(),
      //     shippedQty: element.shippedQty!.toInt(),
      //   ));
      // });
      var results = await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);
      orderDetailItemList = results;

      _showLoadingScreen(false, "Veriler Güncelleniyor ...");
      setState(() {
        isAssing = true;
        isAssingedPersonIsCurrenUser = true;
        _savePurchaseOrderSummaryOnLocal();
        widget.onValueChanged(_updateCurrentPurchaseOrderSummaryItem());
      });
      _showDialogMessage("BAŞARILI", "İşlem başarılı");
    } else {
      print("işlem başarısız");
      _showDialogMessage("HATA !", "Siparişi üzerinize alamadınız !");
    }
  }

  _showDialogMessage(String title, String content) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
        ),
        actions: [
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              child: const Text(
                "Kapat",
                style: TextStyle(color: Colors.black),
              )),
        ],
        title: Text(title),
        contentPadding: const EdgeInsets.all(20.0),
        content: Text(content),
      ),
    );
  }

  _showErrorMessage(String content) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
        ),
        actions: [
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              child: const Text(
                "Kapat",
                style: TextStyle(color: Colors.black),
              )),
        ],
        title: const Text("DİKKAT !"),
        contentPadding: const EdgeInsets.all(20.0),
        content: Text(content),
      ),
    );
  }

  _showLoadingScreen(bool isLoading, String content) {
    if (isLoading) {
      return showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: content,
              ),
            );
          });
    } else {
      Navigator.pop(context); // Loading screen'i kapat
    }
  }

  Future<dynamic> showDialogForAssingOrder(BuildContext context, bool isAssing, String content) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
        ),
        actions: [
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              child: const Text(
                "İptal",
                style: TextStyle(color: Colors.black),
              )),
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              onPressed: (() {
                Navigator.of(context).pop();

                _setOrderAssingStatus(isAssing);
              }),
              child: const Text(
                "Evet",
                style: TextStyle(color: Colors.black),
              )),
        ],
        title: const Text("Emin Misiniz ?"),
        contentPadding: const EdgeInsets.all(20.0),
        content: Text(content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      /*
      bottomNavigationBar: bottomWidget(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //Navigator.of(context).popUntil((route) => route.isFirst);
        },
        backgroundColor: Colors.orange,
        highlightElevation: 10,
        child: const Icon(
          Icons.qr_code_2_outlined,
          color: Color(0XFFFFFFFF),
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      */
      body: Container(
        width: double.infinity,
        color: Color(0xfffafafa),
        child: isDataFetch
            ? _body()
            : isRequestSuccess
                ? _loadingScreen()
                : requestNotFound("Sipariş"),
      ),
    );
  }

  Padding _body() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            isThisInMultiOrder!
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "BU SİPARİŞ ÇOKLU SİPARİŞLERDE",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 152, 35)),
                    ),
                  )
                : const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  response.order!.ficheNo ?? "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    //toplamaya başla
                    isAssing
                        ? const SizedBox()
                        : IconButton(
                            onPressed: () {
                              showDialogForAssingOrder(context, true, "Siparişi görevlenmeye emin misiniz ?");
                            },
                            icon: const Icon(
                              Icons.download_rounded,
                              size: 30,
                              color: Color(0xffff9700),
                            ),
                          ),
                    isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                        ? const SizedBox(
                            width: 5,
                          )
                        : const SizedBox(),
                    //toplamaya devam et
                    isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                        ? IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PurchaseOrderScanPage(
                                            purchaseOrderDetailItemList: orderDetailItemList,
                                            purchaseOrderId: widget.purchaseOrderId,
                                            // customerId:
                                            //     response.order!.customer!.customerId!,
                                          ))).then((value) async {
                                var results = await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);
                                orderDetailItemList = results;
                                setState(() {});
                              });
                            },
                            icon: const Icon(
                              Icons.access_time,
                              size: 30,
                              color: Color(0xffff9700),
                            ),
                          )
                        : const SizedBox(),
                    isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                        ? const SizedBox(
                            width: 5,
                          )
                        : const SizedBox(),
                    //toplamayı tamamla
                    isAuthPurchaseCancelAssign && isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                        ? IconButton(
                            onPressed: () {
                              _complateOrder();
                            },
                            icon: const Icon(
                              Icons.inbox,
                              size: 30,
                              color: Color(0xff8a9c9c),
                            ),
                          )
                        : const SizedBox(),
                    isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                        ? const SizedBox(
                            width: 5,
                          )
                        : const SizedBox(),
                    //sevk et
                    isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                        ? IconButton(
                            onPressed: () async {
                              _showLoadingScreen(true, "İrsaliye Oluşturuluyor");

                              if (isCustomerInRiskLimit) {
                                _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                _showDialogMessage("Müşteri Risk Limitine Takıldı",
                                    "İrsaliye oluşturulmadı, sipariş ücreti risk limitinin arasındaki fark: \n $differenceWithRiskLimit");
                              } else {
                                // await _changeWarehouseBasedOnItems();
                                bool isWaybillItemNotEmpty = _checkForWaybillItemsNotEmpty();
                                if (isWaybillItemNotEmpty) {
                                  waybillRequestBody = await _createWaybillBodyNew();
                                  try {
                                    bool isDone = await apiRepository.createWaybillPurchaseOrder(waybillRequestBody!);

                                    bool isAllItemCollected = _checkAllItemsCollectedCompletely();
                                    if (isAllItemCollected) {
                                      orderStatusId = EntityConstants.OrderStatusKapandi;
                                      orderStatusName = EntityConstants.getStatusDescription(orderStatusId);
                                      await _changePurchaseOrderStatusRequest();
                                    }

                                    if (isDone) {
                                      bool isCreated = await _completeTheOrder2();
                                      if (isCreated) {
                                        _deletePurchaseOrderSummaryOnLocal();
                                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                        // _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                        _showDialogMessage("Başarılı", "İşlem Başarılı");
                                      } else {
                                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                        _showErrorMessage("İrsaliye oluşturuldu, Sipariş bırakılamadı !");
                                      }
                                    } else {
                                      _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                      _showErrorMessage("İrsaliye Oluşturulamadı !");
                                    }
                                  } catch (e) {
                                    _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                    GNSShowErrorMessage(context, e.toString());
                                  }
                                } else {
                                  _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                  _showDialogMessage("İrsaliye Oluşturulamadı",
                                      "Okutulmuş ürün tespit edilemediği için irsaliye oluşturulamadı.");
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.fire_truck,
                              size: 30,
                              color: Color(0xffe64a19),
                            ),
                          )
                        : const SizedBox(),
                  ],
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Divider(
                color: Color.fromARGB(255, 235, 235, 235),
                thickness: 1.5,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            _infoRow("Parçalı Sipariş", response.order!.isPartialOrder! ? "Evet" : "Hayır"),
            _divider(),
            _infoRow(
                "Tarih", DateFormat('dd-MM-yyyy').format(DateTime.parse(response.order!.ficheDate ?? "01-01-2000"))),
            _divider(),
            _infoRow("Müşteri", response.order!.customer!.name ?? ""),
            _divider(),
            _infoRow("Depolar", response.order!.warehouse!.definition ?? ""),
            _divider(),
            _infoRow("Proje", projectName),
            _divider(),
            _infoRow("Adet", response.order!.orderItems!.length.toString()),
            _divider(),
            _infoRow("Tutar", isPriceVisible ? response.order!.grossTotal.toString() : "***"),
            _divider(),
            _infoRow("Durum", response.order!.orderStatusName ?? ""),
            _divider(),
            _infoRow("Operatör", isAssing ? response.order!.assingmetFullname.toString() : ""),
            _divider(),

            isAssingedPersonIsCurrenUser
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GNSTextField(
                              label: "Fiş Numarası",
                              onValueChanged: (value) {
                                ficheNoThatCreatedByUser = value!;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(flex: 1, child: _selectWaybillType(waybillTypeName, selectWaybillTypeFromBottom)),
                        ],
                      ),
                      _divider(),
                      Row(
                        children: [
                          Expanded(
                            child: _openBottomSheetAndSelectFromTile(
                                warehouseInitName, warehouseName, selectWarehouseReverseForAllItems),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: isAuthChangeOrderStatus
                                ? _selectOrderStatusFromList("OrderStatus", orderStatusName, showOrderStatusBottomSheet)
                                : const SizedBox(),
                          ),
                        ],
                      ),
                      _divider(),
                      GNSSelectTransporter(
                        onValueChanged: (value) {
                          transporterId = value;
                        },
                        isErrorActive: false,
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(
              height: 25,
            ),
            _orderLineRow(),
            const SizedBox(
              height: 25,
            ),
            ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: orderDetailItemList!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    color: const Color(0xfff1f1f1),
                    child: InkWell(
                      onLongPress: () {
                        selectWarehouseReverseForOnlyOneItem(orderDetailItemList![index].orderItemId!);
                      },
                      highlightColor: const Color.fromARGB(255, 179, 199, 211),
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(right: 15, left: 15),
                        leading: Text(
                          (index + 1 < 10)
                              ? "0${index + 1} ${serilotType(orderDetailItemList![index].serilotType!)}"
                              : "${index + 1} ${serilotType(orderDetailItemList![index].serilotType!)}",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Colors.grey[700]),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  "${orderDetailItemList![index].productBarcode}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff727272),
                                  ),
                                ),
                                Text(
                                  "${orderDetailItemList![index].productName}",
                                  maxLines: 1,
                                  style:
                                      TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[700]),
                                ),
                                Text(
                                  "${orderDetailItemList![index].warehouse}",
                                  style:
                                      TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[700]),
                                ),
                              ]),
                            ),
                            Column(
                              children: [
                                isAssing && isAssingedPersonIsCurrenUser
                                    ? Text(
                                        "${orderDetailItemList![index].scannedQty! - orderDetailItemList![index].shippedQty!}",
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 39, 150, 43)),
                                      )
                                    : const SizedBox(),
                                Text(
                                  "${orderDetailItemList![index].scannedQty!} / ${orderDetailItemList![index].qty}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      // color: selectColor(
                                      //     orderDetailItemList![index].scannedQty!,
                                      //     orderDetailItemList![index].qty!),
                                      color: Colors.blueGrey),
                                ),
                                isAssing && isAssingedPersonIsCurrenUser
                                    ? Text(
                                        "${orderDetailItemList![index].qty! - orderDetailItemList![index].scannedQty!}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                        // trailing: Text(
                        //   "${orderDetailItemList![index].scannedQty!} / ${orderDetailItemList![index].qty}",
                        //   style: TextStyle(
                        //       fontSize: 19,
                        //       fontWeight: FontWeight.bold,
                        //       color: selectColor(
                        //           orderDetailItemList![index].scannedQty!,
                        //           orderDetailItemList![index].qty!)),
                        // ),
                        // title: Text(
                        //   "${orderDetailItemList![index].productBarcode}",
                        //   maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        //   style: const TextStyle(
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w700,
                        //     color: Color(0xff727272),
                        //   ),
                        // ),
                        // subtitle: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         "${orderDetailItemList![index].productName}",
                        //         style: TextStyle(
                        //             fontSize: 14,
                        //             fontWeight: FontWeight.normal,
                        //             color: Colors.grey[700]),
                        //       ),
                        //       Text(
                        //         "${orderDetailItemList![index].warehouse}",
                        //         style: TextStyle(
                        //             fontSize: 14,
                        //             fontWeight: FontWeight.normal,
                        //             color: Colors.grey[700]),
                        //       )
                        //     ]),
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            isAssing
                ? const SizedBox()
                : _listTileButton("Toplamaya Başla", Icons.download_rounded, Colors.white, const Color(0xffff9700), () {
                    showDialogForAssingOrder(context, true, "Siparişi görevlenmeye emin misiniz ?");
                  }),
            isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                ? _listTileButton(
                    "Toplamaya Devam Et",
                    Icons.access_time,
                    const Color.fromARGB(255, 228, 228, 228),
                    const Color(0xffff9700),
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PurchaseOrderScanPage(
                                    purchaseOrderDetailItemList: orderDetailItemList,
                                    purchaseOrderId: widget.purchaseOrderId,
                                    // customerId:
                                    //     response.order!.customer!.customerId!,
                                  ))).then((value) async {
                        var results = await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);
                        orderDetailItemList = results;
                        setState(() {});
                      });
                    },
                  )
                : const SizedBox(),
            isAuthPurchaseCancelAssign && isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                ? _listTileButton("Atamayı Kaldır", Icons.inbox, Colors.black, const Color(0xff8a9c9c), () {
                    _complateOrder();
                  })
                : const SizedBox(),
            isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                ? _listTileButton("Sevk Et", Icons.fire_truck, Colors.black, const Color(0xffe64a19), () async {
                    /*
                    _showLoadingScreen(true, "İrsaliye Oluşturuluyor");
                    waybillRequestBody = _createWaybillBodyNew();
                    bool isDone = await _completeTheOrder();

                    if (isDone) {
                      bool isCreated = await apiRepository
                          .createWaybillPurchaseOrder(waybillRequestBody!);
                      if (isCreated) {
                        _deletePurchaseOrderSummaryOnLocal();
                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        _showDialogMessage("Başarılı", "İrsaliye Oluşturuldu.");
                      } else {
                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        _showErrorMessage("İrsaliye Oluşturulamadı !");
                      }
                    }
                    */

                    _showLoadingScreen(true, "İrsaliye Oluşturuluyor");

                    if (!isCustomerInRiskLimit) {
                      _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                      _showDialogMessage("Müşteri Risk Limitine Takıldı",
                          "İrsaliye oluşturulmadı, sipariş ücreti risk limitinin arasındaki fark: \n $differenceWithRiskLimit");
                    } else {
                      // await _changeWarehouseBasedOnItems();
                      bool isWaybillItemNotEmpty = _checkForWaybillItemsNotEmpty();
                      if (isWaybillItemNotEmpty) {
                        waybillRequestBody = await _createWaybillBodyNew();
                        try {
                          bool isDone = await apiRepository.createWaybillPurchaseOrder(waybillRequestBody!);

                          bool isAllItemCollected = _checkAllItemsCollectedCompletely();
                          if (isAllItemCollected) {
                            orderStatusId = EntityConstants.OrderStatusKapandi;
                            orderStatusName = EntityConstants.getStatusDescription(orderStatusId);
                            await _changePurchaseOrderStatusRequest();
                          }

                          if (isDone) {
                            bool isCreated = await _completeTheOrder2();
                            if (isCreated) {
                              _deletePurchaseOrderSummaryOnLocal();
                              _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                              // _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                              _showDialogMessage("Başarılı", "İşlem Başarılı");
                            } else {
                              _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                              _showErrorMessage("İrsaliye oluşturuldu, Sipariş bırakılamadı !");
                            }
                          } else {
                            _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                            _showErrorMessage("İrsaliye Oluşturulamadı !");
                          }
                        } catch (e) {
                          _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                          GNSShowErrorMessage(context, e.toString());
                        }
                      } else {
                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        _showDialogMessage("İrsaliye Oluşturulamadı",
                            "Okutulmuş ürün tespit edilemediği için irsaliye oluşturulamadı.");
                      }
                    }
                  })
                : const SizedBox(),
            const SizedBox(
              height: 35,
            ),
            // _orderLog(),
            // SizedBox(
            //   height: 40,
            // ),
          ],
        ),
      ),
    );
  }

  _complateOrder() {
    if (!isPartialOrder) {
      if (_isScannedQtyEqualQty()) {
        print("bütün itemlar eşit");
        showDialogForAssingOrder(context, false, "Siparişi bırakmak istediğinize emin misiniz ?");
      } else {
        print("bütün itemlar eşit değil");
        _showErrorMessage("Bütün siparişleri tamamlamadınız.");
      }
    } else {
      showDialogForAssingOrder(context, false, "Siparişi bırakmak istediğinize emin misiniz ?");
    }
  }

  Row _selectWaybillType(String title, Function()? onTap) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        // const SizedBox(
        //   width: 10,
        // ),
        isWaybillTypeSelectable
            ? SizedBox(
                height: 50,
                width: 50,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    splashColor: Color.fromARGB(255, 255, 223, 187),
                    onTap: onTap,
                    child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          // border: Border.all(
                          //   color: Colors.black,
                          //   width: 1.0,
                          // ),
                          border: Border(
                            top: BorderSide(
                              width: 1,
                            ),
                            bottom: BorderSide(
                              width: 1,
                            ),
                            right: BorderSide(
                              width: 1,
                            ),
                          ),
                        ),
                        child: Center(
                            child: Icon(
                          Icons.view_list_rounded,
                          color: Colors.blueGrey[300],
                          size: 30,
                        ))),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  void selectWaybillTypeFromBottom() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _selectWaybillTypeShowBottomPage(),
    );
  }

  Widget _selectWaybillTypeShowBottomPage() {
    double leftPadding = 8.0;
    return Container(
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            //Geçmiş İşlemler Text
            Container(
              decoration: BoxDecoration(
                color: Colors.deepOrange[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "İrsaliye Tipi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: waybillTypeItem.length,
                    itemBuilder: (context, index) {
                      return _selectingAreaRowItem(waybillTypeItem[index].type, () {
                        waybillTypeName = waybillTypeItem[index].type;
                        waybillTypeId = waybillTypeItem[index].id;

                        print("$waybillTypeName  $waybillTypeId");
                        Navigator.pop(context);
                        setState(() {});
                      });
                    },
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _selectOrderStatusFromList(String initTitle, String title, Function()? onTap) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: title == initTitle ? Colors.blueGrey[200] : Colors.black,
                ),
              ),
            ),
          ),
        ),
        // const SizedBox(
        //   width: 10,
        // ),
        SizedBox(
          height: 50,
          width: 50,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              splashColor: Color.fromARGB(255, 255, 223, 187),
              onTap: onTap,
              child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    // border: Border.all(
                    //   color: Colors.black,
                    //   width: 1.0,
                    // ),
                    border: Border(
                      top: BorderSide(
                        width: 1,
                      ),
                      bottom: BorderSide(
                        width: 1,
                      ),
                      right: BorderSide(
                        width: 1,
                      ),
                    ),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.view_list_rounded,
                    color: Colors.blueGrey[300],
                    size: 30,
                  ))),
            ),
          ),
        ),
      ],
    );
  }

  void showOrderStatusBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _selectOrderStatusBottomSheet(EntityConstants.OrderStatusList),
    );
  }

  Widget _selectOrderStatusBottomSheet(List<String> orderStasuses) {
    double leftPadding = 8.0;
    return Container(
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            //Geçmiş İşlemler Text
            Container(
              decoration: BoxDecoration(
                color: Colors.deepOrange[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Sipariş Durumları",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: orderStasuses.length,
                    itemBuilder: (context, index) {
                      return _selectingAreaRowItem(orderStasuses[index], () async {
                        orderStatusName = orderStasuses[index];
                        orderStatusId = EntityConstants.getStatusId(orderStasuses[index]);

                        await _changePurchaseOrderStatusRequest();
                        setState(() {});
                        Navigator.pop(context);
                      });
                    },
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _openBottomSheetAndSelectFromTile(String initTitle, String title, Function()? onTap) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: title == initTitle ? Colors.blueGrey[200] : Colors.black,
                ),
              ),
            ),
          ),
        ),
        // const SizedBox(
        //   width: 10,
        // ),
        SizedBox(
          height: 50,
          width: 50,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              splashColor: Color.fromARGB(255, 255, 223, 187),
              onTap: onTap,
              child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    // border: Border.all(
                    //   color: Colors.black,
                    //   width: 1.0,
                    // ),
                    border: Border(
                      top: BorderSide(
                        width: 1,
                      ),
                      bottom: BorderSide(
                        width: 1,
                      ),
                      right: BorderSide(
                        width: 1,
                      ),
                    ),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.view_list_rounded,
                    color: Colors.blueGrey[300],
                    size: 30,
                  ))),
            ),
          ),
        ),
      ],
    );
  }

  Column _orderLog() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Son Yapılan İşlemler",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[500]),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              "Emir Alacacı",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 12),
            )),
            Expanded(
                child: Text(
              "Sipariş Toplama",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            )),
            Expanded(
                child: Text(
              "17.01.2024 10:24:35",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            )),
          ],
        ),
        _divider(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              "Hayrettin Bebek",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 12),
            )),
            Expanded(
                child: Text(
              "Sipariş Toplama",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            )),
            Expanded(
                child: Text(
              "17.01.2024 09:45:10",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            )),
          ],
        ),
      ],
    );
  }

  Color selectColor(int scannedQty, int qty) {
    if (scannedQty == 0) {
      return const Color(0xff939d9c);
    }
    if (scannedQty == qty) {
      return const Color(0xff20c0d8);
    } else {
      return const Color(0xffd0552b);
    }
  }

  Future<void> _changeWarehouseBasedOnItems() async {
    if (orderDetailItemList!.length == 1) {
      if (warehouseId.toLowerCase() != orderDetailItemList![0].warehouseId!.toLowerCase()) {
        warehouseId = orderDetailItemList![0].warehouseId!;
        var result = await apiRepository.getWarehouseReverse(warehouseId);
        departmentId = result.warehouse?.departments?.departmentId ?? "";
        workplaceId = result.warehouse?.departments?.workplace?.workplaceId ?? "";
      }
    } else if (orderDetailItemList!.length > 1) {
      int maxScannedQty = -1;
      for (var item in orderDetailItemList!) {
        if ((item.scannedQty! - item.shippedQty!) > maxScannedQty) {
          maxScannedQty = (item.scannedQty! - item.shippedQty!);
          warehouseId = item.warehouseId!;
        }
      }
      var result = await apiRepository.getWarehouseReverse(warehouseId);
      departmentId = result.warehouse?.departments?.departmentId ?? "";
      workplaceId = result.warehouse?.departments?.workplace?.workplaceId ?? "";
    }
  }

  void changeLocalIsAssing() {
    if (!isAssing) {
      setState(() {
        isAssing = true;
        print("buraya girdi");
      });
    }
  }

  Padding _listTileButton(String content, IconData icon, Color textColor, Color backgroundColor, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Kenar yuvarlaklığını burada ayarlayabilirsiniz
        ),
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: ListTile(
            leading: Icon(
              icon,
              color: textColor,
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                content,
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          ),
        ),
      ),
    );
  }

  Row _orderLineRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Sipariş Satırları",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xffe44817),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            response.order!.orderItems!.length.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xffe44817),
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Padding _divider() {
    return const Padding(
      padding: EdgeInsets.only(top: 5),
      child: Divider(
        color: Color.fromARGB(255, 235, 235, 235),
        thickness: 0.5,
      ),
    );
  }

  Padding _infoRow(String infoTitle, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              infoTitle,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 73, 73, 73),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              info,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color.fromARGB(255, 92, 92, 92),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.deepOrange[700], size: 32 //change your color here
          ),
      title: Text(
        "Satın Alma Sipariş Detayı",
        style: TextStyle(color: Colors.deepOrange[700], fontWeight: FontWeight.bold, fontSize: 20),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Center _loadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  String serilotType(int type) {
    if (type == 1) {
      return "N";
    } else if (type == 2) {
      return "S";
    } else if (type == 3) {
      return "L";
    } else {
      return "Z";
    }
  }

  bool _isScannedQtyEqualQty() {
    for (int i = 0; i < orderDetailItemList!.length; i++) {
      if (orderDetailItemList![i].scannedQty != orderDetailItemList![i].qty) {
        return false;
      }
    }

    return true;
  }

  String _createUniqueFicheNo() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HHmmssSS').format(now);
    String uniqueFicheNo = response.order!.ficheNo! + formattedTime;

    return "AUTO_$formattedTime";
  }

  Future<String> _getDocNumberFicheNumber() async {
    getFicheNumberResponse = await apiRepository.getDocNumberFicheNumber(apiRepository.employeeUid, "6");

    return getFicheNumberResponse?.docnumber?.lastNum ?? "";
  }

  Future<WayybillsRequestBodyNew> _createWaybillBodyNew() async {
    return WayybillsRequestBodyNew(
      customerId: response.order?.customer?.customerId,
      orderId: response.order?.orderId ?? guidEmpty,
      ficheNo: ficheNoThatCreatedByUser.isEmpty ? await _getDocNumberFicheNumber() : ficheNoThatCreatedByUser,
      // ficheDate: DateFormat('yyyy-MM-dd')
      //     .format(DateTime.parse(response.order!.ficheDate!)),
      // ficheDate: DateFormat('yyyy-MM-dd').format(currentDate),
      ficheDate: DateFormat('yyyy-MM-ddTHH:mm:ss').format(currentDate),
      // shipDate: DateFormat('yyyy-MM-dd').format(currentDate),
      shipDate: DateFormat('yyyy-MM-ddTHH:mm:ss').format(currentDate),

      // ficheTime: response.order?.ficheTime,
      ficheTime: DateFormat('HH:mm').format(currentDate),

      docNo: response.order?.docNo,
      erpInvoiceRef: "",
      workPlaceId: workplaceId,
      department: departmentId,
      warehouse: warehouseId,
      currencyId: 1,
      totaldiscounted: response.order?.totaldiscounted,
      totalvat: response.order?.totalvat,
      grossTotal: response.order?.grossTotal,
      transporterId: response.order?.transporter?.transporterId ?? guidEmpty,
      shippingAccountId: response.order?.shippingAccount?.customerId ?? guidEmpty,
      shippingAddressId: response.order?.shippingAddress?.shippingAddressId ?? guidEmpty,
      description: "deneme",
      shippingTypeId: response.order?.orderShippingType?.shippingTypeId ?? guidEmpty,
      salesmanId: response.order?.shippingAccount?.salesman?.salesmanId ?? guidEmpty,
      waybillStatusId: 2,
      erpId: "",
      erpCode: "",
      waybillTypeId: waybillTypeId,
      waybillItems: await _createWaybillItemListNew(),
      globalWaybillItemDetails: _createGlobalWaybillItemDetails(),
    );
  }

  // List<WaybillItemsNew> _createWaybillItemListNew() {
  //   // var uuid = Uuid();
  //   List<WaybillItemsNew> waybillItemsList = [];
  //   orderDetailItemList!.forEach((localElement) {
  //     response.order!.orderItems!.forEach((element) async {
  //       if (localElement.productId == element.product!.productId) {
  //         if (localElement.scannedQty!.toInt() - element.shippedQty!.toInt() !=
  //             0) {
  //           List<PurchaseOrderDetailScannedItemDB>? scannedList = [];
  //           bool isProductLocation = localElement.isProductLocatin!;
  //           if (isProductLocation) {
  //             scannedList = await _dbHelper.getPurchaseOrderDetailScannedItem(
  //                 widget.item.ficheNo!, localElement.orderItemId!);
  //           }
  //           waybillItemsList.add(
  //             WaybillItemsNew(
  //               productId: element.product?.productId,
  //               description: element.description,
  //               warehouseId: localElement.warehouseId,
  //               productPrice: element.productPrice,
  //               qty: (localElement.scannedQty!.toInt() -
  //                   element.shippedQty!.toInt()),
  //               total: element.total,
  //               discount: element.discount,
  //               tax: element.tax,
  //               nettotal: element.nettotal,
  //               unitId: element.unitId,
  //               unitConversionId: element.unitConversionId,
  //               stockLocationRelations: isProductLocation
  //                   ? _createStockLocationRelationList(scannedList!)
  //                   : [],
  //               currencyId: 1,
  //               erpId: element.erpId,
  //               erpCode: element.erpCode,
  //               orderReferance: element.orderItemId,
  //               erpOrderReferance: 0,
  //               waybillItemTypeId: waybillTypeId,
  //               waybillItemDetails:
  //                   _createWaybillItemDetails(element.orderItemId!),
  //             ),
  //           );
  //         }
  //       }
  //     });
  //   });

  //   return waybillItemsList;
  // }

  Future<List<WaybillItemsNew>> _createWaybillItemListNew() async {
    List<WaybillItemsNew> waybillItemsList = [];

    // İlk liste olan orderDetailItemList üzerinde gezin
    for (int i = 0; i < orderDetailItemList!.length; i++) {
      var localElement = orderDetailItemList![i];

      // İkinci liste olan response.order!.orderItems! üzerinde gezin
      for (int j = 0; j < response.order!.orderItems!.length; j++) {
        var element = response.order!.orderItems![j];

        if (localElement.productId == element.product!.productId) {
          if (localElement.scannedQty!.toInt() - element.shippedQty!.toInt() != 0) {
            List<PurchaseOrderDetailScannedItemDB>? scannedList = [];
            bool isProductLocation = localElement.isProductLocatin!;

            // Eğer ürün lokasyonu varsa scannedList'i doldur
            if (isProductLocation) {
              scannedList =
                  await _dbHelper.getPurchaseOrderDetailScannedItem(widget.item.ficheNo!, localElement.orderItemId!);
            }

            // WaybillItemsNew listesine yeni bir öğe ekle
            waybillItemsList.add(
              WaybillItemsNew(
                productId: element.product?.productId,
                orderLineId: element.orderItemId,
                description: element.description,
                warehouseId: localElement.warehouseId,
                productPrice: element.productPrice,
                qty: (localElement.scannedQty!.toInt() - element.shippedQty!.toInt()),
                total: element.total,
                discount: element.discount,
                tax: element.tax,
                nettotal: element.nettotal,
                unitId: element.unitId,
                unitConversionId: element.unitConversionId,
                stockLocationRelations: isProductLocation ? _createStockLocationRelationList(scannedList!) : [],
                currencyId: 1,
                erpId: element.erpId,
                erpCode: element.erpCode,
                orderReferance: element.orderItemId,
                erpOrderReferance: int.parse(element.erpId.toString()),
                waybillItemTypeId: 0,
                waybillItemDetails: _createWaybillItemDetails(element.orderItemId!),
              ),
            );
          }
        }
      }
    }

    return waybillItemsList;
  }

  List<StockLocationRelations> _createStockLocationRelationList(List<PurchaseOrderDetailScannedItemDB> scannedList) {
    // Map oluşturup stockLocationId'yi key olarak kullanacağız ve numberOfPieces'ları toplayacağız
    Map<String, int> locationMap = {};

    for (var item in scannedList) {
      if (item.stockLocationId != null && item.numberOfPieces != null) {
        if (locationMap.containsKey(item.stockLocationId)) {
          // Eğer stockLocationId map'te varsa, qty'ye numberOfPieces'ı ekle
          locationMap[item.stockLocationId!] = locationMap[item.stockLocationId!]! + item.numberOfPieces!;
        } else {
          // Eğer stockLocationId map'te yoksa, yeni bir giriş oluştur
          locationMap[item.stockLocationId!] = item.numberOfPieces!;
        }
      }
    }

    // Map'teki verileri StockLocationRelations nesnelerine dönüştür
    List<StockLocationRelations> stockLocationRelationsList = [];
    locationMap.forEach((stockLocationId, qty) {
      stockLocationRelationsList.add(StockLocationRelations(stockLocationId: stockLocationId, qty: qty));
    });

    return stockLocationRelationsList;
  }

  List<WaybillItemDetails> _createWaybillItemDetails(String orderItemId) {
    // var uuid = Uuid();
    List<WaybillItemDetails> waybillItemDetails = [];

    response.order!.orderItems!.forEach((element) {
      if (orderItemId == element.orderItemId) {
        element.orderItemDetails?.forEach((orderItemDetailElement) {
          waybillItemDetails.add(WaybillItemDetails(
            waybillItemTypeId: orderItemDetailElement.orderItemTypeId,
            lineNr: orderItemDetailElement.lineNr,
            isGlobal: orderItemDetailElement.isGlobal,
            calcType: orderItemDetailElement.calcType,
            qty: orderItemDetailElement.qty,
            total: orderItemDetailElement.total,
            discountPercent: orderItemDetailElement.discountPercent,
            erpId: orderItemDetailElement.erpId,
            erpCode: orderItemDetailElement.erpCode,
          ));
        });
      }
    });

    return waybillItemDetails;
  }

  List<GlobalWaybillItemDetails> _createGlobalWaybillItemDetails() {
    // var uuid = Uuid();
    List<GlobalWaybillItemDetails> globalWaybillItemDetails = [];
    response.order!.globalOrderItemDetails?.forEach((element) {
      globalWaybillItemDetails.add(GlobalWaybillItemDetails(
        waybillItemTypeId: element.orderItemTypeId,
        lineNr: element.lineNr,
        isGlobal: element.isGlobal,
        calcType: element.calcType,
        qty: element.qty,
        total: element.total,
        discountPercent: element.discountPercent,
        erpId: element.erpId,
        erpCode: element.erpCode,
      ));
    });

    return globalWaybillItemDetails;
  }

  PurchaseOrderSummaryItem _updateCurrentPurchaseOrderSummaryItem() {
    return PurchaseOrderSummaryItem(
      orderId: widget.item.orderId,
      ficheNo: widget.item.ficheNo,
      ficheDate: widget.item.ficheDate,
      customer: widget.item.customer,
      shippingMethod: widget.item.shippingMethod,
      warehouse: widget.item.warehouse,
      lineCount: widget.item.lineCount,
      orderStatus: widget.item.orderStatus,
      totalQty: widget.item.totalQty,
      total: widget.item.total,
      isAssing: isAssing,
      assingmentEmail: widget.item.assingmentEmail,
      assingCode: widget.item.assingCode,
      assingmetFullname: widget.item.assingmetFullname,
      isPartialOrder: widget.item.isPartialOrder,
    );
  }

  void selectWarehouseReverseForAllItems() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _selectWarehouseByAllWarehousBottomSheet(isThereWarehouseBoundForUser
          ? _limitWarehouseBasedOnSetting(allWarehouse, userSpecialWarehouseList)
          : allWarehouse),
    );
  }

  void selectWarehouseReverseForOnlyOneItem(String orderItemId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _selectWarehouseForOnlyOneBottomSheet(
          isThereWarehouseBoundForUser
              ? _limitWarehouseBasedOnSetting(allWarehouse, userSpecialWarehouseList)
              : allWarehouse,
          orderItemId),
    );
  }

  List<WorkplaceWarehouse> _getAllWarehouseList() {
    List<WorkplaceWarehouse> list = [];
    workplaceListResponse!.workplaces!.items!.forEach((workplace) {
      workplace.departments!.forEach((department) {
        department.warehouse!.forEach((warehouse) {
          list.add(warehouse);
        });
      });
    });

    return list;
  }

  Widget _selectWarehouseByAllWarehousBottomSheet(List<WorkplaceWarehouse> warehouse) {
    double leftPadding = 8.0;
    return Container(
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            //Geçmiş İşlemler Text
            Container(
              decoration: BoxDecoration(
                color: Colors.deepOrange[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Warehouse",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: warehouse.length,
                    itemBuilder: (context, index) {
                      return _selectingAreaRowItem(warehouse[index].code!, () async {
                        warehouseName = warehouse[index].code!;
                        warehouseId = warehouse[index].warehouseId!;
                        setState(() {
                          isLoading = true;
                        });
                        var response = await apiRepository.getWarehouseReverse(warehouseId);
                        for (int i = 0; i < orderDetailItemList!.length; i++) {
                          await _dbHelper.updatePurchaseOrderDetailItemWarehouse(
                              widget.purchaseOrderId, orderDetailItemList![i].orderItemId!, warehouseId, warehouseName);
                        }
                        orderDetailItemList = await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);
                        setState(() {
                          isLoading = false;
                        });
                        workplaceId = response.warehouse!.departments!.workplace!.workplaceId!;

                        departmentId = response.warehouse!.departments!.departmentId!;

                        Navigator.pop(context);
                        setState(() {});
                      });
                    },
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectWarehouseForOnlyOneBottomSheet(List<WorkplaceWarehouse> warehouse, String orderItemId) {
    double leftPadding = 8.0;
    return Container(
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            //Geçmiş İşlemler Text
            Container(
              decoration: BoxDecoration(
                color: Colors.deepOrange[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Warehouse",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: warehouse.length,
                    itemBuilder: (context, index) {
                      return _selectingAreaRowItem(warehouse[index].code!, () async {
                        var newWarehouseName = warehouse[index].code!;
                        var newWarehouseId = warehouse[index].warehouseId!;

                        await _dbHelper.updatePurchaseOrderDetailItemWarehouse(
                            widget.purchaseOrderId, orderItemId, newWarehouseId, newWarehouseName);

                        orderDetailItemList = await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);

                        Navigator.pop(context);
                        setState(() {});
                      });
                    },
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _selectingAreaRowItem(String title, Function()? onTap) {
    return Card(
      elevation: 0,
      child: InkWell(
        splashColor: Colors.deepOrangeAccent,
        onTap: onTap,
        child: ListTile(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  List<WorkplaceWarehouse> _limitWarehouseBasedOnSetting(List<WorkplaceWarehouse> mainList, List<String> limitedList) {
    List<WorkplaceWarehouse> newList = [];
    mainList.forEach((element) {
      limitedList.forEach((warehouseId) {
        if (element.warehouseId!.toLowerCase() == warehouseId.toLowerCase()) {
          newList.add(element);
        }
      });
    });

    return newList;
  }
}
