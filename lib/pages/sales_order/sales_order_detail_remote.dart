import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/entity_constants.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:gns_warehouse/constants/system_settings.dart';
import 'package:gns_warehouse/constants/user_special_settings.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/database/model/order_detail_scanned_item.dart';
import 'package:gns_warehouse/database/model/product_barcodes_item.dart';
import 'package:gns_warehouse/models/new_api/customer_risk_limit_response.dart';
import 'package:gns_warehouse/models/new_api/doc_number_get_fiche_number.dart';
import 'package:gns_warehouse/models/new_api/order_change_qty_item_model.dart';
import 'package:gns_warehouse/models/new_api/order_detail_new_model.dart';
import 'package:gns_warehouse/models/new_api/order_header_response_new.dart';
import 'package:gns_warehouse/models/new_api/stock_response.dart';
import 'package:gns_warehouse/models/new_api/waybill_request_body_new.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/models/order_detail/order_detail_item_db.dart';
import 'package:gns_warehouse/models/order_summary.dart';
import 'package:gns_warehouse/pages/order_detail/order_scan_page.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_transporter.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:gns_warehouse/widgets/gns_error_field.dart';
import 'package:gns_warehouse/widgets/gns_request_not_found.dart';
import 'package:gns_warehouse/widgets/gns_show_dialog.dart';
import 'package:gns_warehouse/widgets/gns_text_field.dart';
import 'package:intl/intl.dart';

class SalesOrderDetail extends StatefulWidget {
  const SalesOrderDetail({super.key, required this.orderId, required this.item, required this.onValueChanged});

  final String orderId;
  final OrderSummaryItem item;
  final ValueChanged<OrderSummaryItem> onValueChanged;

  @override
  State<SalesOrderDetail> createState() => _SalesOrderDetailState();
}

class _SalesOrderDetailState extends State<SalesOrderDetail> {
  late ApiRepository apiRepository;
  late OrderDetailResponseNew response;
  late bool isDataFetch;
  bool isRequestSuccess = true;
  late bool? isThisInMultiOrder;
  late bool isPartialOrder;
  late bool isAssing;
  late bool isAssingedPersonIsCurrenUser;
  bool isAuthSalesCancelAssign = false;
  bool isAuthChangeOrderStatus = true;
  final DbHelper _dbHelper = DbHelper.instance;
  List<OrderDetailItemDB>? orderDetailItemList = [];
  WayybillsRequestBodyNew? waybillRequestBody;
  DateTime currentDate = DateTime.now();

  String guidEmpty = "00000000-0000-0000-0000-000000000000";
  bool isPriceVisible = false;

//burası
  bool isThereWarehouseBoundForUser = false;
  bool isOrderAssignAutoDrop = false;
  late WorkplaceListResponse? workplaceListResponse;
  List<WorkplaceWarehouse> allWarehouse = [];
  List<WorkplaceWarehouse> commonWarehousesForProducts = [];
  StockResponse? stockResponse;
  List<String> userSpecialWarehouseList = [];
  bool isLoading = false;
  String warehouseInitName = "Ambar";
  String warehouseName = "Ambar";
  String workplaceId = "";
  String departmentId = "";
  String warehouseId = "";
  String userDefaultWarehouseOut = "";
  String projectId = "";
  String projectName = "";
  String transporterId = "";

  String customerId = "";
  late CustomerRiskLimitResponse riskLimitResponse;
  bool isCustomerInRiskLimit = false;
  double differenceWithRiskLimit = 0;

  DocNumberGetFicheNumberResponse? getFicheNumberResponse;
  String salesWaybillFicheNo = "";
  String ficheNoThatCreatedByUser = "";

  String waybillTypeName = "";
  bool isWaybillTypeSelectable = false;
  int waybillTypeId = 0;
  List<WaybillTypeItem> waybillTypeItem = GNSSystemSettingsUtils.waybillTypeItemList;

  int orderStatusId = -1;
  String orderStatusName = "";
  //burası
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

  List<OrderDetailItemDB> sortOrderDetailItems(List<OrderDetailItemDB> items) {
    // Yeni bir kopya oluşturup sıralıyoruz
    List<OrderDetailItemDB> sortedList = List.from(items);
    sortedList.sort((a, b) => (a.lineNr ?? 0).compareTo(b.lineNr ?? 0));
    return sortedList;
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

  void _createApiRepository() async {
    isDataFetch = false;
    isThisInMultiOrder = false;
    apiRepository = await ApiRepository.create(context);
    try {
      isAuthSalesCancelAssign =
          await ServiceSharedPreferences.getSharedBool(UserSpecialSettingsUtils.isAuthSalesCancelAssign) ?? false;
      isAuthChangeOrderStatus =
          await ServiceSharedPreferences.getSharedBool(UserSpecialSettingsUtils.isAuthSalesChangeOrderStatus) ?? false;
      isPriceVisible = await ServiceSharedPreferences.getSharedBool(SharedPreferencesKey.isPriceVisible) ?? false;
      isOrderAssignAutoDrop =
          await ServiceSharedPreferences.getSharedBool(GNSSystemSettingsUtils.OrderAssignAutoDrop) ?? false;
    } catch (e) {}
    await _getWaybillTypeSelection();
    isThisInMultiOrder = await _dbHelper.isThereAnyItemBasedOrderIdInMultiSalesOrder(widget.orderId);
    //burası
    _getUserSpecialWarehouseSettings();
    try {
      response = await apiRepository.getOrderDetail(widget.orderId);
    } catch (e) {
      isRequestSuccess = false;
      setState(() {});
    }
    orderStatusId = response.order?.orderStatusId ?? -1;
    orderStatusName = response.order?.orderStatusName ?? "";
    transporterId = response.order?.transporter?.transporterId ?? guidEmpty;
    workplaceId = response.order?.workplace?.workplaceId ?? guidEmpty;
    departmentId = response.order?.department?.departmentId ?? guidEmpty;
    warehouseId = response.order?.warehouse?.warehouseId ?? guidEmpty;
    projectId = response.order?.project?.projectId ?? guidEmpty;
    projectName = response.order?.project?.code ?? "";
    workplaceListResponse = await apiRepository.getWorkplaceList();
    allWarehouse = _getAllWarehouseList();
    //burası
    isPartialOrder = response.order!.isPartialOrder ?? false;
    customerId = response.order?.customer?.customerId ?? "";
    await checkCustomerRiskLimit();
    response.order!.orderItems!.forEach((element) {
      orderDetailItemList!.add(
        OrderDetailItemDB(
          productName: element.product!.definition,
          productBarcode: element.product!.barcode,
          warehouse: element.warehouseName,
          isExceededStockCount: false,
          serilotType: _transformToIntForProductTracking(element.product!.productTrackingMethod!),
          scannedQty: element.shippedQty!.toInt()!,
          shippedQty: 0,
          qty: element.qty!.toInt(),
          lineNr: element.lineNr!.toInt(),
        ),
      );
    });
    if (response.order!.isAssing!) {
      if (response.order!.assingmentEmail == apiRepository.employeeEmail) {
        isAssingedPersonIsCurrenUser = true;
        _getLocalOrderDetailItemList();
        if (!isThisInMultiOrder!) {
          _saveOrderSummaryOnLocal();
        }
        //_saveOrderSummaryOnLocal();
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
        print("adet: ${widget.orderId}");
      }
    });
    //print("response: ${response.data!.isAssing}");

    orderDetailItemList = sortOrderDetailItems(orderDetailItemList!);
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

//burası
  Future<void> _getUserSpecialWarehouseSettings() async {
    String userSpecialSetting =
        await ServiceSharedPreferences.getSharedString(UserSpecialSettingsUtils.userWarehouseAuthOut) ?? "";

    userDefaultWarehouseOut =
        await ServiceSharedPreferences.getSharedString(UserSpecialSettingsUtils.userDefaultWarehouseOut) ?? "";

    print(userDefaultWarehouseOut);

    if (userSpecialSetting.isNotEmpty) {
      List<dynamic> decodedValue = jsonDecode(userSpecialSetting);
      setState(() {
        userSpecialWarehouseList = List<String>.from(decodedValue);
        isThereWarehouseBoundForUser = true;
      });
    } else {}
  }

//burası
  Future<void> _getProductBarcodes(String productId) async {
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
      orderId: widget.orderId,
      productId: productId,
      barcode: barcode,
      code: code,
      convParam1: convParam1,
      convParam2: convParam2,
    );
  }

  void _saveOrderSummaryOnLocal() async {
    OrderSummary? item = await _dbHelper.getOrderHeaderById(widget.orderId);

    if (item == null) {
      await _dbHelper.addOrderHeader(_updateCurrentOrderSummaryItem());
    }
  }

  void _deleteOrderSummaryOnLocal() async {
    OrderSummary? item = await _dbHelper.getOrderHeaderById(widget.orderId);

    if (item != null) {
      await _dbHelper.removeOrderHeader(widget.orderId);
    }
  }

  void _getLocalOrderDetailItemList() async {
    var results = await _dbHelper.getOrderDetailItemList(widget.orderId);
    orderDetailItemList = results;

    if (orderDetailItemList!.isEmpty) {
      await _saveProductAndOrderItems();

      var results = await _dbHelper.getOrderDetailItemList(widget.orderId);
      orderDetailItemList = results;
    } else {
      bool isThereChange1 = await _checkForRowItemsAddOrDeleteFromLogo();
      bool isThereChange2 = await _checkForRowItemsQtyChangedFromLogo();

      if (isThereChange1 == true || isThereChange2 == true) {
        var results = await _dbHelper.getOrderDetailItemList(widget.orderId);
        orderDetailItemList = results;
      }
    }

    //stok kontrol burada otomatik olacak
    await _checkStockForEachRow();
    await _createWarehouseListForItemsBasedOnStock();
    commonWarehousesForProducts = await _filterWarehouseListForAllProduct();
    orderDetailItemList = sortOrderDetailItems(orderDetailItemList!);
    setState(() {});
  }

  _checkStockForEachRow() async {
    var list = await _checkStock();

    if (list.isNotEmpty) {
      var results = await _dbHelper.getOrderDetailItemList(widget.orderId);
      orderDetailItemList = results;
      setState(() {});
      _showInsufficientStockProducts(list);
    } else {
      var results = await _dbHelper.getOrderDetailItemList(widget.orderId);
      orderDetailItemList = results;
      setState(() {});
    }

    orderDetailItemList = sortOrderDetailItems(orderDetailItemList!);
  }

  bool _checkForWaybillItemsNotEmpty() {
    for (int i = 0; i < orderDetailItemList!.length; i++) {
      if (orderDetailItemList![i].scannedQty! > orderDetailItemList![i].shippedQty!) {
        return true;
      }
    }

    return false;
  }

  Future<bool> _checkForRowItemsQtyChangedFromLogo() async {
    bool isThereAnyChange = false;
    for (int i = 0; i < response.order!.orderItems!.length; i++) {
      var remoteElement = response.order!.orderItems![i];
      for (int j = 0; j < orderDetailItemList!.length; j++) {
        var localElement = orderDetailItemList![j];
        if (localElement.qty! != remoteElement.qty!.toInt() && localElement.orderItemId == remoteElement.orderItemId) {
          isThereAnyChange = true;
          await _dbHelper.updateOrderDetailItemQty(
              widget.orderId, localElement.orderItemId!, localElement.warehouseId!, remoteElement.qty!.toInt());
        }
      }
    }

    return isThereAnyChange;
  }

  Future<bool> _checkForRowItemsAddOrDeleteFromLogo() async {
    List<OrderItems> addedItems = findAddedItems(orderDetailItemList!, response.order!.orderItems!);
    List<OrderDetailItemDB> deletedItems = findDeletedItems(orderDetailItemList!, response.order!.orderItems!);

    for (OrderItems item in addedItems) {
      await _dbHelper.addOrderDetailItem(OrderDetailItemDB(
        orderId: widget.orderId,
        orderItemId: item.orderItemId,
        productId: item.product!.productId!,
        warehouseId: item.warehouseId,
        stockLocationId: "",
        ficheNo: response.order!.ficheNo,
        productName: item.product!.definition ?? "",
        productBarcode: item.product!.barcode,
        warehouse: item.warehouseName,
        isProductLocatin: item.product!.isProductLocatin ?? false,
        isExceededStockCount: false,
        stockLocationName: "",
        serilotType: _transformToIntForProductTracking(item.product!.productTrackingMethod!),
        scannedQty: item.shippedQty!.toInt(),
        qty: item.qty!.toInt(),
        shippedQty: item.shippedQty!.toInt(),
        lineNr: item.lineNr!.toInt(),
      ));
    }

    for (OrderDetailItemDB item in deletedItems) {
      await _dbHelper.deleteOrderDetailItem(item.orderId!, item.orderItemId!, item.warehouseId!);
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

  List<OrderDetailItemDB> findDeletedItems(List<OrderDetailItemDB> oldList, List<OrderItems> newList) {
    List<OrderDetailItemDB> deletedItems = [];
    for (OrderDetailItemDB item in oldList) {
      if (!newList.any((newItem) => newItem.orderItemId == item.orderItemId)) {
        deletedItems.add(item);
      }
    }
    return deletedItems;
  }

  List<OrderItems> findAddedItems(List<OrderDetailItemDB> oldList, List<OrderItems> newList) {
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
      await _dbHelper.addOrderDetailItem(OrderDetailItemDB(
        orderId: widget.orderId,
        orderItemId: response.order!.orderItems![i].orderItemId,
        productId: response.order!.orderItems![i].product!.productId!,
        warehouseId: response.order!.orderItems![i].warehouseId,
        stockLocationId: "",
        ficheNo: response.order!.ficheNo,
        productName: response.order!.orderItems![i].product!.definition ?? "",
        productBarcode: response.order!.orderItems![i].product!.barcode,
        warehouse: response.order!.orderItems![i].warehouseName,
        isProductLocatin: response.order!.orderItems![i].product!.isProductLocatin ?? false,
        isExceededStockCount: false,
        stockLocationName: "",
        serilotType: _transformToIntForProductTracking(response.order!.orderItems![i].product!.productTrackingMethod!),
        scannedQty: response.order!.orderItems![i].shippedQty!.toInt(),
        qty: response.order!.orderItems![i].qty!.toInt(),
        shippedQty: response.order!.orderItems![i].shippedQty!.toInt(),
        lineNr: response.order!.orderItems![i].lineNr!.toInt(),
      ));
    }
    // response.order!.orderItems!.forEach((element) async {
    //   await _getProductBarcodes(element.product!.productId!);
    //   await _dbHelper.addOrderDetailItem(OrderDetailItemDB(
    //     orderId: widget.orderId,
    //     orderItemId: element.orderItemId,
    //     productId: element.product!.productId!,
    //     warehouseId: element.warehouseId,
    //     stockLocationId: "emiralclocation",
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
  }

  Future<void> _setOrderAssingStatus(bool isAssingRemote) async {
    if (isAssingRemote) {
      await _takeTheOrder();
    } else {
      await _completeTheOrder();
    }
  }

  Future<bool> _completeTheOrder() async {
    //checkResultList.isEmpty böyle olmalı
    //var checkResultList = await _checkStock();
    if (true) {
      // bool isUpdate = false;
      bool isSuccess = false;
      _showLoadingScreen(true, "Yükleniyor ...");
      var orderItemList = await _dbHelper.getOrderDetailItemList(widget.orderId);

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
      //     isUpdate = await apiRepository.updateOrderItems(
      //         widget.orderId, customerId, orderItemsList);
      //   } catch (e) {
      //     print("İşlem hatası: $e");
      //     _showLoadingScreen(false, "Yükleniyor ...");
      //     return false;
      //   }
      // }

//       if (isUpdate) {
// //await Future.delayed(Duration(seconds: 3));
//         isSuccess = await apiRepository.setOrderAssingStatus(
//             false, apiRepository.employeeUid, widget.orderId);
//         _showLoadingScreen(false, "Yükleniyor ...");
//       }

      isSuccess = await apiRepository.setOrderAssingStatus(false, apiRepository.employeeUid, widget.orderId);
      _showLoadingScreen(false, "Yükleniyor ...");
      // && isUpdate yorum aldım
      if (isSuccess) {
        _showLoadingScreen(true, "Veriler Güncelleniyor ...");
        _deleteOrderSummaryOnLocal();

        response = await apiRepository.getOrderDetail(widget.orderId);
        await _dbHelper.clearAllOrderDetailItems(widget.orderId);

        await _dbHelper.removeOrderDetailScannedItems(response.order!.ficheNo!);
        await _dbHelper.clearAllProductBarcodes(widget.orderId);
        _showLoadingScreen(false, "Veriler Güncelleniyor ...");
        setState(() {
          isAssing = false;
          isAssingedPersonIsCurrenUser = true;
          widget.onValueChanged(_updateCurrentOrderSummaryItem());
        });
        _showDialogMessage("BAŞARILI", "İşlem başarılı");
        return true;
      } else {
        _showDialogMessage("HATA !", "Siparişi üzerinize alamadınız !");
        return false;
        //error ver
      }
    } else {
      _showDialogMessage("YETERSİZ STOK", "Stok sayıları okutulan ürünleri karşılamıyor.");
      return false;
    }
  }

  Future<List<WorkplaceWarehouse>> _createWarehouseListForItemsBasedOnStock() async {
    List<WorkplaceWarehouse> list = [];
    stockResponse = await apiRepository.getStockByProductIdList(_createStockByProductList());

    if (stockResponse != null) {
      for (int i = 0; i < (stockResponse!.stocks?.length ?? 0); i++) {
        var element = stockResponse!.stocks![i];

        list.add(
          WorkplaceWarehouse(
            warehouseId: element.warehouse?.warehouseId,
            code: element.warehouse?.code,
            definition: element.warehouse?.definition,
          ),
        );
      }
    }

    return list;
  }

  List<WorkplaceWarehouseOnHandStock> _filterWarehouseListForPorduct(String productId) {
    List<WorkplaceWarehouseOnHandStock> list = [];

    if (stockResponse != null) {
      for (int i = 0; i < stockResponse!.stocks!.length; i++) {
        var element = stockResponse!.stocks![i];
        if (element.productId.toString() == productId.toString()) {
          var item = WorkplaceWarehouseOnHandStock(
              warehouse: WorkplaceWarehouse(
                warehouseId: element.warehouse!.warehouseId!.toLowerCase(),
                code: element.warehouse!.code,
                definition: element.warehouse!.definition,
              ),
              onHandStock: element.onHandStock!);

          list.add(item);
        }
      }
    }

    return list;
  }

  //siparişteki itemların stoklarının ortak tutuldugu warehouseları dönüyor
  Future<List<WorkplaceWarehouse>> _filterWarehouseListForAllProduct() async {
    List<String> productIdList = _createStockByProductList();
    List<WorkplaceWarehouse> list = [];

    // Öncelikle her warehouse'ı, her bir productId ile ilişkilendirecek bir harita oluştur
    Map<String, Set<String>> warehouseProductMapping = {};

    // stockResponse'daki her bir öğe üzerinden dön
    stockResponse!.stocks!.forEach((remoteElement) {
      var warehouse = remoteElement.warehouse;
      var productId = remoteElement.productId;

      // Eğer warehouse ve productId mevcutsa, mapping'e ekle
      if (warehouse != null && productId != null) {
        var warehouseId = warehouse.warehouseId;

        // Warehouse için productId ekle
        if (!warehouseProductMapping.containsKey(warehouseId)) {
          warehouseProductMapping[warehouseId!] = {};
        }
        warehouseProductMapping[warehouseId]!.add(productId);
      }
    });

    // Şimdi, her bir warehouse'ı kontrol et ve sadece tüm productId'leri kapsayanları ekle
    warehouseProductMapping.forEach((warehouseId, productIds) {
      if (productIds.containsAll(productIdList)) {
        // Warehouse, tüm productId'leri kapsıyorsa, listeye ekle
        stockResponse!.stocks!.forEach((remoteElement) {
          var warehouse = remoteElement.warehouse;
          if (warehouse != null && warehouse.warehouseId == warehouseId) {
            list.add(WorkplaceWarehouse(
              warehouseId: warehouse.warehouseId!.toLowerCase(),
              code: warehouse.code,
              definition: warehouse.definition,
            ));
          }
        });
      }
    });

    // Benzersiz öğeleri almak için 'where' kullan
    var uniqueList = <WorkplaceWarehouse>[];
    list.forEach((item) {
      if (!uniqueList.any((e) => e.warehouseId == item.warehouseId)) {
        uniqueList.add(item);
      }
    });

    return uniqueList;
  }

  Future<List<StockInfoBasedOnProduct>> _checkStock() async {
    List<StockInfoBasedOnProduct> insufficientStockProducts = [];
    var result = await apiRepository.getStockByProductIdList(_createStockByProductList());
    //stockResponse'u bir kere en başta çektik, tekrar butona basarsa stockResponse değerini günceller
    // bu da her bir item'ın ambarını değiştirirken güncel gözükmesini sağlar
    stockResponse = result;

    // result!.stocks!.forEach((remoteElement) {
    //   orderDetailItemList!.forEach((localElement) async {
    //     if (remoteElement.productId == localElement.productId &&
    //         remoteElement.warehouse!.warehouseId == localElement.warehouseId) {
    //       if (remoteElement.onHandStock! <
    //           localElement.scannedQty! - localElement.shippedQty!) {
    //         var item = StockInfoBasedOnProduct(
    //             productName: localElement.productName!,
    //             barcode: localElement.productBarcode!,
    //             onHandStock: remoteElement.onHandStock!.toInt(),
    //             scannedQty: localElement.scannedQty! - localElement.shippedQty!,
    //             differenceBetween:
    //                 (localElement.scannedQty! - localElement.shippedQty!) -
    //                     remoteElement.onHandStock!.toInt());
    //         await _dbHelper.updateOrderDetailItemExceededStockCount(
    //             widget.orderId, localElement.orderItemId!, true);
    //         insufficientStockProducts.add(item);
    //       }
    //     }
    //   });
    // });

    for (int i = 0; i < result!.stocks!.length; i++) {
      var remoteElement = result!.stocks![i];

      for (int j = 0; j < orderDetailItemList!.length; j++) {
        var localElement = orderDetailItemList![j];

        if (remoteElement.productId == localElement.productId &&
            remoteElement.warehouse!.warehouseId == localElement.warehouseId) {
          if (remoteElement.onHandStock! < localElement.scannedQty! - localElement.shippedQty!) {
            var item = StockInfoBasedOnProduct(
              productName: localElement.productName!,
              barcode: localElement.productBarcode!,
              onHandStock: remoteElement.onHandStock!.toInt(),
              scannedQty: localElement.scannedQty! - localElement.shippedQty!,
              differenceBetween:
                  (localElement.scannedQty! - localElement.shippedQty!) - remoteElement.onHandStock!.toInt(),
            );
            await _dbHelper.updateOrderDetailItemExceededStockCount(widget.orderId, localElement.orderItemId!, true);
            insufficientStockProducts.add(item);
          } else {
            if (localElement.isExceededStockCount!) {
              await _dbHelper.updateOrderDetailItemExceededStockCount(widget.orderId, localElement.orderItemId!, false);
            }
          }
        }
      }
    }

    return insufficientStockProducts;
  }

  List<String> _createStockByProductList() {
    List<String> idList = [];
    orderDetailItemList!.forEach((element) {
      idList.add(element.productId!);
    });
    return idList;
  }

  bool _checkAllItemsCollectedCompletely() {
    for (int i = 0; i < orderDetailItemList!.length; i++) {
      if (orderDetailItemList![i].scannedQty != orderDetailItemList![i].qty) {
        return false;
      }
    }

    return true;
  }

  Future<void> _changeOrderStatusRequest() async {
    _showLoadingScreen(true, "Yükleniyor");
    try {
      await apiRepository.setSalesOrderStatus(widget.orderId, orderStatusId);
      _showLoadingScreen(false, "Yükleniyor");
      await _dbHelper.updateOrderStatusForOrderHeader(orderStatusName, widget.orderId);
    } catch (e) {
      _showLoadingScreen(false, "Yükleniyor");
      _showDialogMessage("HATA !", "Sipariş durumu değiştilirken hata oluştu. \n ${e.toString()}");
    }
  }

  Future<bool> _completeTheOrder2() async {
    bool isUpdate = false;
    bool isSuccess = false;
    var orderItemList = await _dbHelper.getOrderDetailItemList(widget.orderId);

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
        isUpdate = await apiRepository.updateOrderItems(widget.orderId, customerId, orderItemsList);
      } catch (e) {
        print("İşlem hatası: $e");
        return false;
      }
    }

    if (isOrderAssignAutoDrop) {
      if (isUpdate) {
        isSuccess = await apiRepository.setOrderAssingStatus(false, apiRepository.employeeUid, widget.orderId);
      }
    }

    if (isSuccess && isUpdate) {
      print("işlem başarılı");
      _deleteOrderSummaryOnLocal();
      response = await apiRepository.getOrderDetail(widget.orderId);
      await _dbHelper.clearAllOrderDetailItems(widget.orderId);

      await _dbHelper.removeOrderDetailScannedItems(response.order!.ficheNo!);
      await _dbHelper.clearAllProductBarcodes(widget.orderId);
      setState(() {
        isAssing = false;
        isAssingedPersonIsCurrenUser = true;
        widget.onValueChanged(_updateCurrentOrderSummaryItem());
      });
      //db kaydet işlemleri
      return true;
    } else if (isUpdate && !isSuccess) {
      print("işlem başarılı");
      response = await apiRepository.getOrderDetail(widget.orderId);

      for (int j = 0; j < orderDetailItemList!.length; j++) {
        var localElement = orderDetailItemList![j];

        await _dbHelper.updateOrderDetailItemShippedQty(
          widget.orderId,
          localElement.orderItemId!,
          localElement.warehouseId!,
          localElement.scannedQty!,
        );
      }
      await _dbHelper.removeOrderDetailScannedItems(response.order!.ficheNo!);
      var results = await _dbHelper.getOrderDetailItemList(widget.orderId);
      orderDetailItemList = results;
      orderDetailItemList = sortOrderDetailItems(orderDetailItemList!);

      setState(() {});

      return false;
    } else {
      print("işlem başarısız");
      return false;
      //error ver
    }
  }

  Future<bool> _completeTheOrder3() async {
    bool isUpdate = false;
    bool isSuccess = false;
    var orderItemList = await _dbHelper.getOrderDetailItemList(widget.orderId);

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
        isUpdate = await apiRepository.updateOrderItems(widget.orderId, customerId, orderItemsList);
      } catch (e) {
        print("İşlem hatası: $e");
        return false;
      }
    }

    if (isUpdate) {
      // ignore: use_build_context_synchronously
      await GNSShowDialog(context, "Emin Misiniz ?", "Siparişi üzerinizden bırakmak ister misiniz ?", "Hayır", "Evet",
          () async {
        isSuccess = await apiRepository.setOrderAssingStatus(false, apiRepository.employeeUid, widget.orderId);

        if (isSuccess) {
          _clearFromLocal();
        }
        Navigator.of(context).pop();
      });
    }

    return isSuccess;
  }

  _clearFromLocal() async {
    _deleteOrderSummaryOnLocal();
    response = await apiRepository.getOrderDetail(widget.orderId);
    await _dbHelper.clearAllOrderDetailItems(widget.orderId);

    await _dbHelper.removeOrderDetailScannedItems(response.order!.ficheNo!);
    await _dbHelper.clearAllProductBarcodes(widget.orderId);
    setState(() {
      isAssing = false;
      isAssingedPersonIsCurrenUser = true;
      widget.onValueChanged(_updateCurrentOrderSummaryItem());
    });
  }

  _takeTheOrder() async {
    _showLoadingScreen(true, "Yükleniyor ...");
    //await Future.delayed(Duration(seconds: 3));
    bool isSuccess = await apiRepository.setOrderAssingStatus(true, apiRepository.employeeUid, widget.orderId);
    _showLoadingScreen(false, "Yükleniyor ...");
    //bool deneme = false;
    if (isSuccess) {
      print("işlem başarılı");
      _showLoadingScreen(true, "Veriler Güncelleniyor ...");
      response = await apiRepository.getOrderDetail(widget.orderId);

      await _dbHelper.clearAllOrderDetailItems(widget.orderId);

      await _saveProductAndOrderItems();
      // response.order!.orderItems!.forEach((element) async {
      //   await _getProductBarcodes(element.product!.productId!);
      //   await _dbHelper.addOrderDetailItem(OrderDetailItemDB(
      //     orderId: widget.orderId,
      //     orderItemId: element.orderItemId,
      //     productId: element.product!.productId!,
      //     warehouseId: element.warehouseId,
      //     stockLocationId: "emiralclocation",
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
      var results = await _dbHelper.getOrderDetailItemList(widget.orderId);
      orderDetailItemList = results;
      orderDetailItemList = sortOrderDetailItems(orderDetailItemList!);
      _checkStockForEachRow();

      _showLoadingScreen(false, "Veriler Güncelleniyor ...");
      setState(() {
        isAssing = true;
        isAssingedPersonIsCurrenUser = true;
        _saveOrderSummaryOnLocal();
        widget.onValueChanged(_updateCurrentOrderSummaryItem());
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

  _showInsufficientStockProducts(List<StockInfoBasedOnProduct> list) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Kapat",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
        title: const Text("Yetersiz Stok"),
        contentPadding: const EdgeInsets.all(20.0),
        content: Container(
          height: 200,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list.map((product) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      product.productName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      product.barcode,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      "${product.scannedQty.toString()} / ${product.onHandStock.toString()}",
                                      style: const TextStyle(
                                        fontSize: 11.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      product.differenceBetween.toString(),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ));
              }).toList(),
            ),
          ),
        ),
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
                                      builder: (context) => OrderScan(
                                            orderDetailItemList: orderDetailItemList,
                                            orderId: widget.orderId,
                                            // customerId:
                                            //     response.order!.customer!.customerId!,
                                          ))).then((value) async {
                                var results = await _dbHelper.getOrderDetailItemList(widget.orderId);
                                orderDetailItemList = results;
                                orderDetailItemList = sortOrderDetailItems(orderDetailItemList!);
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
                    isAuthSalesCancelAssign && isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
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
                                    bool isDone = await apiRepository.createWaybill(waybillRequestBody!);
                                    bool isAllItemCollected = _checkAllItemsCollectedCompletely();
                                    if (isAllItemCollected) {
                                      orderStatusId = EntityConstants.OrderStatusKapandi;
                                      orderStatusName = EntityConstants.getStatusDescription(orderStatusId);
                                      await _changeOrderStatusRequest();
                                    }
                                    if (isDone) {
                                      // try {
                                      //   await apiRepository.createWaybill(waybillRequestBody!);
                                      //   _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                      //   _showDialogMessage("Başarılı", "İrsaliye Oluşturuldu.");
                                      // } catch (e) {
                                      //   print("asdasdasd : ${e.toString()}");
                                      //   _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                      //   _showErrorMessage(e.toString());
                                      // }
                                      bool isCreated = await _completeTheOrder2();
                                      if (isCreated) {
                                        _deleteOrderSummaryOnLocal();
                                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                        _showDialogMessage("Başarılı", "İşlem Başarılı.");
                                      } else {
                                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                        _showErrorMessage("İrsaliye oluşturuldu, Sipariş bırakılamadı !");
                                      }
                                    } else {
                                      // _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                      // _showErrorMessage("İrsaliye Oluşturulamadı !");
                                    }
                                  } catch (e) {
                                    _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                    GNSShowErrorMessage(context, e.toString());
                                  }
                                  // } else {
                                  //   _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                                  //   _showDialogMessage("YETERSİZ STOK",
                                  //       "Stok sayıları okutulan ürünleri karşılamıyor.");
                                  // }
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
            _infoRow("Tarih",
                DateFormat('dd-MM-yyyy / HH:mm').format(DateTime.parse(response.order!.ficheDate ?? "01-01-2000"))),
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
            //burası
            isAssing && isAssingedPersonIsCurrenUser
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
                          //ambar
                          Expanded(
                            child: _openBottomSheetAndSelectFromTile(
                                warehouseInitName, warehouseName, selectWarehouseReverseForAllItems),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          //order status
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
            //burası
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
                    color: orderDetailItemList![index].isExceededStockCount!
                        ? const Color.fromARGB(255, 255, 173, 173)
                        : const Color.fromRGBO(241, 241, 241, 1),
                    child: InkWell(
                      //burası
                      onLongPress: () {
                        selectWarehouseReverseForOnlyOneItem(
                            orderDetailItemList![index].orderItemId!, orderDetailItemList![index].productId!);
                      },
                      //burası
                      highlightColor: const Color.fromARGB(255, 179, 199, 211),
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(
                          right: 15,
                          left: 15,
                        ),
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
                ? _listTileButton("Toplamaya Devam Et", Icons.access_time, const Color.fromARGB(255, 228, 228, 228),
                    const Color(0xffff9700), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderScan(
                                  orderDetailItemList: orderDetailItemList,
                                  orderId: widget.orderId,
                                  // customerId:
                                  //     response.order!.customer!.customerId!,
                                ))).then((value) async {
                      var results = await _dbHelper.getOrderDetailItemList(widget.orderId);
                      orderDetailItemList = results;
                      orderDetailItemList = sortOrderDetailItems(orderDetailItemList!);
                      setState(() {});
                    });
                  })
                : const SizedBox(),
            isAuthSalesCancelAssign && isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                ? _listTileButton("Atamayı Kaldır", Icons.inbox, Colors.black, const Color(0xff8a9c9c), () {
                    _complateOrder();
                  })
                : const SizedBox(),
            isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                ? _listTileButton("Sevk Et", Icons.fire_truck, Colors.black, const Color(0xffe64a19), () async {
                    /*
                    _showLoadingScreen(true, "İrsaliye Oluşturuluyor");
                    waybillRequestBody = _createWaybillBodyNew();
                    bool isDone = await _completeTheOrder2();

                    if (isDone) {
                      // try {
                      //   await apiRepository.createWaybill(waybillRequestBody!);
                      //   _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                      //   _showDialogMessage("Başarılı", "İrsaliye Oluşturuldu.");
                      // } catch (e) {
                      //   print("asdasdasd : ${e.toString()}");
                      //   _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                      //   _showErrorMessage(e.toString());
                      // }
                      bool isCreated = await apiRepository
                          .createWaybill(waybillRequestBody!);
                      if (isCreated) {
                        _deleteOrderSummaryOnLocal();
                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        _showDialogMessage("Başarılı", "İrsaliye Oluşturuldu.");
                      } else {
                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        _showErrorMessage("İrsaliye Oluşturulamadı !");
                      }
                    }
                    */
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
                          bool isDone = await apiRepository.createWaybill(waybillRequestBody!);
                          bool isAllItemCollected = _checkAllItemsCollectedCompletely();
                          if (isAllItemCollected) {
                            orderStatusId = EntityConstants.OrderStatusKapandi;
                            orderStatusName = EntityConstants.getStatusDescription(orderStatusId);
                            await _changeOrderStatusRequest();
                          }
                          if (isDone) {
                            // try {
                            //   await apiRepository.createWaybill(waybillRequestBody!);
                            //   _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                            //   _showDialogMessage("Başarılı", "İrsaliye Oluşturuldu.");
                            // } catch (e) {
                            //   print("asdasdasd : ${e.toString()}");
                            //   _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                            //   _showErrorMessage(e.toString());
                            // }
                            bool isCreated = await _completeTheOrder2();
                            if (isCreated) {
                              _deleteOrderSummaryOnLocal();
                              _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                              _showDialogMessage("Başarılı", "İşlem Başarılı.");
                            } else {
                              _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                              _showErrorMessage("İrsaliye oluşturuldu, Sipariş bırakılamadı !");
                            }
                          } else {
                            // _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                            // _showErrorMessage("İrsaliye Oluşturulamadı !");
                          }
                        } catch (e) {
                          _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                          GNSShowErrorMessage(context, e.toString());
                        }
                        // } else {
                        //   _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        //   _showDialogMessage("YETERSİZ STOK",
                        //       "Stok sayıları okutulan ürünleri karşılamıyor.");
                        // }
                      } else {
                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        _showDialogMessage("İrsaliye Oluşturulamadı",
                            "Okutulmuş ürün tespit edilemediği için irsaliye oluşturulamadı.");
                      }
                    }
                  })
                : const SizedBox(),
            isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                ? _listTileButton("Stok Kontrolü Yap", Icons.inventory_2_rounded, const Color.fromARGB(255, 75, 75, 75),
                    const Color.fromARGB(255, 255, 228, 176), () async {
                    await _checkStockForEachRow();
                  })
                : const SizedBox(),
            const SizedBox(
              height: 35,
            ),
            // _orderLog(),
            // SizedBox(
            //   height: 20,
            // ),
          ],
        ),
      ),
    );
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

                        await _changeOrderStatusRequest();
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

//burası
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

//burası
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

    // if (isPartialOrder) {
    //   showDialogForAssingOrder(
    //       context, false, "Siparişi bırakmak istediğinize emin misiniz ?");
    // } else {
    //   if (_isScannedQtyEqualQty()) {
    //     print("bütün itemlar eşit");
    //     showDialogForAssingOrder(
    //         context, false, "Siparişi bırakmak istediğinize emin misiniz ?");
    //   } else {
    //     print("bütün itemlar eşit değil");
    //     _showErrorMessage("Bütün siparişleri tamamlamadınız.");
    //   }
    // }
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
        "Satış Sipariş Detayı",
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
    getFicheNumberResponse = await apiRepository.getDocNumberFicheNumber(apiRepository.employeeUid, "5");

    return getFicheNumberResponse?.docnumber?.lastNum ?? "";
  }

  Future<WayybillsRequestBodyNew> _createWaybillBodyNew() async {
    return WayybillsRequestBodyNew(
      customerId: response.order?.customer?.customerId ?? guidEmpty,
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
      transporterId: transporterId ?? guidEmpty,
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
  //           List<OrderDetailScannedItemDB>? scannedList = [];
  //           bool isProductLocation = localElement.isProductLocatin!;
  //           // Eğer ürün lokasyonu varsa scannedList'i doldur
  //           if (isProductLocation) {
  //             scannedList = await _dbHelper.getOrderDetailScannedItem(
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
  //               currencyId: element.currencyId,
  //               erpId: element.erpId,
  //               erpCode: element.erpCode,
  //               orderReferance: element.orderItemId,
  //               erpOrderReferance: 2,
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
    // var uuid = Uuid();
    List<WaybillItemsNew> waybillItemsList = [];

    // Geleneksel for döngüsü ile orderDetailItemList üzerinden geçiyoruz
    for (int i = 0; i < orderDetailItemList!.length; i++) {
      var localElement = orderDetailItemList![i];

      // Geleneksel for döngüsü ile response.order!.orderItems üzerinden geçiyoruz
      for (int j = 0; j < response.order!.orderItems!.length; j++) {
        var element = response.order!.orderItems![j];

        if (localElement.productId == element.product!.productId) {
          if (localElement.scannedQty!.toInt() - element.shippedQty!.toInt() != 0) {
            List<OrderDetailScannedItemDB>? scannedList = [];
            bool isProductLocation = localElement.isProductLocatin!;

            // Eğer ürün lokasyonu varsa scannedList'i doldur
            if (isProductLocation) {
              scannedList = await _dbHelper.getOrderDetailScannedItem(widget.item.ficheNo!, localElement.orderItemId!);
            }

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
                currencyId: element.currencyId,
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

  List<StockLocationRelations> _createStockLocationRelationList(List<OrderDetailScannedItemDB> scannedList) {
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
    response.order!.globalOrderItemDetails!.forEach((element) {
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

//burası
  void selectWarehouseReverseForAllItems() {
    //allWarehouse yerine commonWarehousesForProducts yazdım
    showModalBottomSheet(
      context: context,
      builder: (context) => _selectWarehouseByAllWarehousBottomSheet(isThereWarehouseBoundForUser
          ? _limitWarehouseBasedOnSetting(commonWarehousesForProducts, userSpecialWarehouseList)
          : commonWarehousesForProducts),
    );
  }

  void selectWarehouseReverseForOnlyOneItem(String orderItemId, String productId) {
    //_filterWarehouseListForPorduct(productId) yerine allWarehouse gelecek sorun çıkarsa

    var item = _filterWarehouseListForPorduct(productId);

    showModalBottomSheet(
      context: context,
      builder: (context) => _selectWarehouseForOnlyOneBottomSheet(
          isThereWarehouseBoundForUser
              ? _limitWarehouseBasedOnSettingOnlyOneItem(
                  _filterWarehouseListForPorduct(productId), userSpecialWarehouseList)
              : _filterWarehouseListForPorduct(productId),
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
                          await _dbHelper.updateOrderDetailItemWarehouse(
                              widget.orderId, orderDetailItemList![i].orderItemId!, warehouseId, warehouseName);
                        }
                        orderDetailItemList = await _dbHelper.getOrderDetailItemList(widget.orderId);
                        orderDetailItemList = sortOrderDetailItems(orderDetailItemList!);
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

  Widget _selectWarehouseForOnlyOneBottomSheet(List<WorkplaceWarehouseOnHandStock> warehouse, String orderItemId) {
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
                      String title = "${warehouse[index].warehouse.code!} (${warehouse[index].onHandStock.toString()})";
                      return _selectingAreaRowItem(title, () async {
                        var newWarehouseName = warehouse[index].warehouse.code!;
                        var newWarehouseId = warehouse[index].warehouse.warehouseId!;

                        await _dbHelper.updateOrderDetailItemWarehouse(
                            widget.orderId, orderItemId, newWarehouseId, newWarehouseName);

                        orderDetailItemList = await _dbHelper.getOrderDetailItemList(widget.orderId);
                        orderDetailItemList = sortOrderDetailItems(orderDetailItemList!);
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

  List<WorkplaceWarehouseOnHandStock> _limitWarehouseBasedOnSettingOnlyOneItem(
      List<WorkplaceWarehouseOnHandStock> mainList, List<String> limitedList) {
    List<WorkplaceWarehouseOnHandStock> newList = [];
    mainList.forEach((element) {
      limitedList.forEach((warehouseId) {
        if (element.warehouse.warehouseId!.toLowerCase() == warehouseId.toLowerCase()) {
          newList.add(element);
        }
      });
    });

    return newList;
  }

//burası

  OrderSummaryItem _updateCurrentOrderSummaryItem() {
    return OrderSummaryItem(
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
}

class StockInfoBasedOnProduct {
  String productName;
  String barcode;
  int onHandStock;
  int scannedQty;
  int differenceBetween;

  StockInfoBasedOnProduct({
    required this.productName,
    required this.barcode,
    required this.onHandStock,
    required this.scannedQty,
    required this.differenceBetween,
  });
}

class WorkplaceWarehouseOnHandStock {
  WorkplaceWarehouse warehouse;
  double onHandStock;

  WorkplaceWarehouseOnHandStock({
    required this.warehouse,
    required this.onHandStock,
  });
}
