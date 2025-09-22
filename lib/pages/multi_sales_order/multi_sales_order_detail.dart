import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:gns_warehouse/constants/user_special_settings.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/database/model/product_barcodes_item.dart';
import 'package:gns_warehouse/database/model/waybills_item_loca.dart';
import 'package:gns_warehouse/database/model/waybills_local.dart';
import 'package:gns_warehouse/database/model/waybills_scanned_item.dart';
import 'package:gns_warehouse/models/new_api/customer_risk_limit_response.dart';
import 'package:gns_warehouse/models/new_api/doc_number_get_fiche_number.dart';
import 'package:gns_warehouse/models/new_api/order_change_qty_item_model.dart';
import 'package:gns_warehouse/models/new_api/order_detail_new_model.dart';
import 'package:gns_warehouse/models/new_api/shipped_qty_request_body.dart';
import 'package:gns_warehouse/models/new_api/waybill_request_body_new.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/multi_sales_order/multi_sales_order_scan_page.dart';
import 'package:gns_warehouse/pages/purchase_order_waybills/waybills_order_scan_page.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_transporter.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:gns_warehouse/widgets/gns_text_field.dart';
import 'package:intl/intl.dart';

class MultiSalesOrderDetail extends StatefulWidget {
  MultiSalesOrderDetail(
      {super.key,
      required this.multiSalesId,
      required this.waybillLocalModel,
      required this.ficheNo});

  String? multiSalesId;
  WaybillLocalModel? waybillLocalModel;
  String ficheNo;

  @override
  State<MultiSalesOrderDetail> createState() => _MultiSalesOrderDetailState();
}

class _MultiSalesOrderDetailState extends State<MultiSalesOrderDetail> {
  final DbHelper _dbHelper = DbHelper.instance;
  late ApiRepository apiRepository;
  late bool isDataFetch;
  List<WaybillItemLocalModel>? waybillItemLocal = [];
  List<ShippedQtyRequestBody> requestBodyList = [];
  String guidEmpty = "00000000-0000-0000-0000-000000000000";
  bool isPriceVisible = false;

  WayybillsRequestBodyNew? waybillRequestBody;
  DateTime currentDate = DateTime.now();

  List<ProductBarcodesItemLocal>? productBarcodesLocalList = [];

  bool isThereWarehouseBoundForUser = false;
  late WorkplaceListResponse? workplaceListResponse;
  List<WorkplaceWarehouse> allWarehouse = [];
  List<String> userSpecialWarehouseList = [];
  bool isLoading = false;
  String warehouseInitName = "Ambar";
  String warehouseName = "Ambar";
  String workplaceId = "";
  String departmentId = "";
  String warehouseId = "";

  String userDefaultWarehouseOut = "";
  String transporterId = "";

  List<OrderDetailResponseNew> salesOrderDetailResponse = [];

  String customerId = "";
  late CustomerRiskLimitResponse riskLimitResponse;
  bool isCustomerInRiskLimit = false;
  double differenceWithRiskLimit = 0;
  String ficheNoThatCreatedByUser = "";

  DocNumberGetFicheNumberResponse? getFicheNumberResponse;
  String salesWaybillFicheNo = "";

  @override
  void initState() {
    super.initState();
    _createApiRepository();
  }

  void _createApiRepository() async {
    isDataFetch = false;
    apiRepository = await ApiRepository.create(context);
    isPriceVisible = await ServiceSharedPreferences.getSharedBool(
            SharedPreferencesKey.isPriceVisible) ??
        false;
    //burası
    _getUserSpecialWarehouseSettings();
    transporterId = widget.waybillLocalModel!.transporterId ?? guidEmpty;
    workplaceId = widget.waybillLocalModel!.workplaceId ?? guidEmpty;
    departmentId = widget.waybillLocalModel!.departmentId ?? guidEmpty;
    warehouseId = widget.waybillLocalModel!.warehouseId ?? guidEmpty;
    workplaceListResponse = await apiRepository.getWorkplaceList();
    allWarehouse = _getAllWarehouseList();
    //burası
    await _getLocalData();
    await _getOrderDetailReponse();
    // check kısmı sorunlu
    //await _checkForAnyChangesFromLogo();
    customerId = widget.waybillLocalModel!.customerId!;
    await checkCustomerRiskLimit();
    setState(() {
      isDataFetch = true;
    });
  }

  Future<void> checkCustomerRiskLimit() async {
    riskLimitResponse = await apiRepository.getCustomerRiskLimit(customerId);

    if (widget.waybillLocalModel!.grosstotal! >
        riskLimitResponse.customerRiskLimit!.canUseRiskLimit!) {
      isCustomerInRiskLimit = true;
      differenceWithRiskLimit = widget.waybillLocalModel!.grosstotal! -
          riskLimitResponse.customerRiskLimit!.canUseRiskLimit!;
    }
  }

  Future<void> _getOrderDetailReponse() async {
    requestBodyList = [];
    _generateShippedQtyRequestBody();
    var result = birlestir(requestBodyList);

    for (int i = 0; i < result.length; i++) {
      var response = await apiRepository.getOrderDetail(result[i].orderId!);
      salesOrderDetailResponse.add(response);
    }
  }

  Future<void> _checkForAnyChangesFromLogo() async {
    for (int i = 0; i < salesOrderDetailResponse.length; i++) {
      await _checkForRowItemsAddOrDeleteFromLogo(
          salesOrderDetailResponse[i],
          salesOrderDetailResponse[i].order!.orderId!,
          salesOrderDetailResponse[i].order!.orderItems!);
      await _checkForRowItemsQtyChangedFromLogo(
          salesOrderDetailResponse[i].order!.orderItems!);
    }
    // requestBodyList = [];
    // _generateShippedQtyRequestBody();
    // var result = birlestir(requestBodyList);

    // for (int i = 0; i < result.length; i++) {
    //   var response = await apiRepository.getOrderDetail(result[i].orderId!);
    //   await _checkForRowItemsQtyChangedFromLogo(response.order!.orderItems!);
    //   await _checkForRowItemsAddOrDeleteFromLogo(
    //       response.order!.orderId!, response.order!.orderItems!);
    // }
  }

  Future<void> _getLocalData() async {
    isDataFetch = false;
    var results =
        await _dbHelper.getMultiSalesOrderDetailItemList(widget.multiSalesId!);
    waybillItemLocal = results;

    requestBodyList = [];
    _generateShippedQtyRequestBody();
    var result = birlestir(requestBodyList);

    for (int i = 0; i < result.length; i++) {
      var barcodesResult =
          await _dbHelper.getProductBarcodes(result[i].orderId!);
      barcodesResult!.forEach((element) {
        productBarcodesLocalList!.add(element);
      });

      productBarcodesLocalList?.forEach((element) {
        print("${element.productId} : ${element.barcode}");
      });
    }

    // bool isThereChange1 = await _checkForRowItemsAddOrDeleteFromLogo();
    // bool isThereChange2 = await _checkForRowItemsQtyChangedFromLogo();

    // if (isThereChange1 == true || isThereChange2 == true) {
    //   var results = await _dbHelper.getMultiSalesOrderDetailItemList(widget.multiSalesId!);
    //   waybillItemLocal = results;
    // }

    //print(waybillItemLocal![0].stockLocationName);

    setState(() {});
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

  Future<bool> _checkForRowItemsQtyChangedFromLogo(
      List<OrderItems> newList) async {
    bool isThereAnyChange = false;
    for (int i = 0; i < newList.length; i++) {
      var remoteElement = newList[i];
      for (int j = 0; j < waybillItemLocal!.length; j++) {
        var localElement = waybillItemLocal![j];
        if (localElement.qty! != remoteElement.qty!.toInt() &&
            localElement.orderItemId == remoteElement.orderItemId) {
          isThereAnyChange = true;
          await _dbHelper.updateMultiSalesDetailItemQty(
              widget.multiSalesId!,
              localElement.orderId!,
              localElement.orderItemId!,
              localElement.warehouseId!,
              remoteElement.qty!.toInt());
        }
      }
    }

    return isThereAnyChange;
  }

  Future<bool> _checkForRowItemsAddOrDeleteFromLogo(
      OrderDetailResponseNew response,
      String orderId,
      List<OrderItems> newList) async {
    List<OrderItems> addedItems =
        findAddedItems(waybillItemLocal!, newList, orderId);
    List<WaybillItemLocalModel> deletedItems =
        findDeletedItems(waybillItemLocal!, newList, orderId);

    for (OrderItems item in addedItems) {
      await _dbHelper.addMultiSalesOrderDetailItem(WaybillItemLocalModel(
        waybillsId: widget.multiSalesId,
        orderId: orderId,
        orderItemId: item.orderItemId,
        productId: item.product?.productId,
        description: item.description,
        warehouseId: item.warehouseId,
        warehouseName: item.warehouseName,
        stockLocationId: "",
        stockLocationName: "coklusiparis",
        isProductLocatin: item.product?.isProductLocatin,
        productPrice: item.productPrice,
        shippedQty: item.shippedQty!.toInt(),
        scannedQty: 0,
        qty: item.qty!.toInt(),
        total: item.total,
        discount: item.discount,
        tax: item.tax,
        nettotal: item.nettotal,
        unitId: item.unitId,
        unitConversionId: item.unitConversionId,
        currencyId: 1,
        barcode: item.product?.barcode,
        productName: item.product?.definition2,
        ficheDate: DateTime.parse(response.order!.ficheDate!),
        erpId: item.erpId,
        erpCode: item.erpCode,
      ));
    }

    for (WaybillItemLocalModel item in deletedItems) {
      await _dbHelper.deleteMultiSalesDetailItem(widget.multiSalesId!,
          item.orderId!, item.orderItemId!, item.warehouseId!);
    }

    if (addedItems.length > 0 || deletedItems.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  List<WaybillItemLocalModel> findDeletedItems(
      List<WaybillItemLocalModel> oldList,
      List<OrderItems> newList,
      String orderId) {
    List<WaybillItemLocalModel> deletedItems = [];
    for (WaybillItemLocalModel item in oldList) {
      if (item.orderId! == orderId) {
        if (!newList
            .any((newItem) => newItem.orderItemId == item.orderItemId)) {
          deletedItems.add(item);
        }
      }
    }
    return deletedItems;
  }

  List<OrderItems> findAddedItems(List<WaybillItemLocalModel> oldList,
      List<OrderItems> newList, String orderId) {
    List<OrderItems> addedItems = [];
    for (OrderItems item in newList) {
      if (!oldList.any((oldItem) => oldItem.orderItemId == item.orderItemId)) {
        addedItems.add(item);
      }
    }
    return addedItems;
  }

  _showDialogMessage(String title, String content) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
        ),
        actions: [
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              onPressed: (() {
                Navigator.of(context).pop();
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
          borderRadius:
              BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
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
        title: const Text("HATA !"),
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

  Future<dynamic> showDialogForAssingOrder(
      BuildContext context, bool isAssing, String content) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
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

                //_completeTheOrder();
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
        child: isDataFetch ? _body() : _loadingScreen(),
      ),
    );
  }

  Padding _body() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.ficheNo,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //toplamaya devam et
                      IconButton(
                        onPressed: () {
                          /*
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PurchaseOrderScanPage(
                                              purchaseOrderDetailItemList:
                                                  orderDetailItemList,
                                              purchaseOrderId:
                                                  widget.purchaseOrderId,
                                              customerId: response
                                                  .order!.customer!.customerId!,
                                            ))).then((value) async {
                                  var results = await _dbHelper
                                      .getPurchaseOrderDetailItemList(
                                          widget.purchaseOrderId);
                                  orderDetailItemList = results;
                                  setState(() {});
                                });
                                */
                        },
                        icon: const Icon(
                          Icons.access_time,
                          size: 30,
                          color: Color(0xffff9700),
                        ),
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      //toplamayı tamamla
                      IconButton(
                        onPressed: () {
                          //_complateOrder();
                        },
                        icon: const Icon(
                          Icons.inbox,
                          size: 30,
                          color: Color(0xff8a9c9c),
                        ),
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      //sevk et
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.fire_truck,
                          size: 30,
                          color: Color(0xffe64a19),
                        ),
                      ),
                    ],
                  ),
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
            _infoRow(
                "Tarih",
                DateFormat('dd-MM-yyyy').format(DateTime.parse(
                    widget.waybillLocalModel!.ficheDate.toString()))),
            _divider(),
            _infoRow(
                "Müşteri", widget.waybillLocalModel!.customerName.toString()),
            _divider(),
            _infoRow(
                "Depolar",
                warehouseName == "Ambar"
                    ? widget.waybillLocalModel!.warehouseName.toString()
                    : warehouseName),
            _divider(),
            _infoRow(
                "Tutar",
                isPriceVisible
                    ? widget.waybillLocalModel!.grosstotal.toString()
                    : "***"),
            _divider(),
            //burası
            Column(
              children: [
                GNSTextField(
                  label: "Fiş Numarası",
                  onValueChanged: (value) {
                    ficheNoThatCreatedByUser = value!;
                  },
                ),
                _divider(),
                _openBottomSheetAndSelectFromTile(warehouseInitName,
                    warehouseName, selectWarehouseReverseForAllItems),
                _divider(),
                GNSSelectTransporter(
                  onValueChanged: (value) {
                    transporterId = value;
                  },
                  isErrorActive: false,
                ),
              ],
            ),
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
                itemCount: waybillItemLocal!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    color: const Color(0xfff1f1f1),
                    child: InkWell(
                      //burası
                      onLongPress: () {
                        selectWarehouseReverseForOnlyOneItem(
                            waybillItemLocal![index].orderItemId!);
                      },
                      //burası
                      highlightColor: const Color.fromARGB(255, 179, 199, 211),
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.only(right: 15, left: 15),
                        leading: Text(
                          (index + 1 < 10)
                              ? "0${index + 1} ${serilotType(1)}"
                              : "${index + 1} ${serilotType(1)}",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[700]),
                        ),
                        // trailing: Text(
                        //   "${waybillItemLocal![index].shippedQty! + waybillItemLocal![index].scannedQty!} / ${waybillItemLocal![index].qty}",
                        //   style: TextStyle(
                        //       fontSize: 19,
                        //       fontWeight: FontWeight.bold,
                        //       color: selectColor(
                        //           waybillItemLocal![index].shippedQty! +
                        //               waybillItemLocal![index].scannedQty!,
                        //           waybillItemLocal![index].qty!)),
                        // ),
                        // title: Text(
                        //   "${waybillItemLocal![index].barcode}",
                        //   maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        //   style: const TextStyle(
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w700,
                        //     color: Color(0xff727272),
                        //   ),
                        // ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${waybillItemLocal![index].barcode}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff727272),
                                    ),
                                  ),
                                  Text(
                                    "${waybillItemLocal![index].productName}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[700]),
                                  ),
                                  Text(
                                    "${waybillItemLocal![index].warehouseName}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[700]),
                                  ),
                                ]),
                            Column(
                              children: [
                                Text(
                                  "${waybillItemLocal![index].scannedQty!}",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 39, 150, 43)),
                                ),
                                Text(
                                  "${waybillItemLocal![index].shippedQty! + waybillItemLocal![index].scannedQty!} / ${waybillItemLocal![index].qty}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                    // color: selectColor(
                                    //     waybillItemLocal![index].shippedQty! +
                                    //         waybillItemLocal![index]
                                    //             .scannedQty!,
                                    //     waybillItemLocal![index].qty!),
                                  ),
                                ),
                                Text(
                                  "${waybillItemLocal![index].qty! - (waybillItemLocal![index].shippedQty! + waybillItemLocal![index].scannedQty!)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            _listTileButton(
              "Toplamaya Devam Et",
              Icons.access_time,
              const Color.fromARGB(255, 228, 228, 228),
              const Color(0xffff9700),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiSalesOrderScanPage(
                      multiSalesItemLocal: waybillItemLocal,
                      productBarcodesLocalList: productBarcodesLocalList,
                      ficheNo: widget.ficheNo,
                    ),
                  ),
                ).then((value) async {
                  var results = await _dbHelper
                      .getMultiSalesOrderDetailItemList(widget.multiSalesId!);
                  waybillItemLocal = results;
                  setState(() {});
                });
              },
            ),
            _listTileButton("Toplamayı Tamamla", Icons.inbox, Colors.black,
                const Color(0xff8a9c9c), () async {
              requestBodyList = [];
              _generateShippedQtyRequestBody();
              var result = birlestir(requestBodyList);
              /*
              _showLoadingScreen(true, "Siparişler Üzerinizden Bırakılıyor");
              result.forEach((element) async {
                await apiRepository.setPurchaseOrderAssingStatus(
                    false, apiRepository.employeeUid, element.orderId!);
              });
              _showLoadingScreen(false, "Siparişler Üzerinizden Bırakılıyor");

              _showLoadingScreen(true, "Değerler Güncelleniyor");
              result.forEach((element) async {
                await apiRepository.updatePurchaseOrderItems(
                    element.orderId!, "", element.shippedQty!);
              });
              await apiRepository.getPurchaseOrderSummaryList();
              _showLoadingScreen(false, "Değerler Güncelleniyor");

              _showLoadingScreen(true, "Veritabanından Değerler Siliniyor");
              _dbHelper.removeMultiOrder(widget.waybillsId!);
              _dbHelper.removeWaybillOrderScannedItems(widget.waybillsId!);
              _dbHelper.clearAllWaybillOrderDetailItems(widget.waybillsId!);
              _showLoadingScreen(false, "Veritabanından Değerler Siliniyor");
              */
              _showLoadingScreen(true, "Siparişler Üzerinizden Bırakılıyor");
              await _servicePart(result);
              await _localPart();
              _showLoadingScreen(false, "Siparişler Üzerinizden Bırakılıyor");
              _showDialogMessage(
                  "İşlem Başarılı", "Siparişleri üzerinizden bırktınız.");
              //_complateOrder();
            }),
            _listTileButton("Sevk Et", Icons.fire_truck, Colors.black,
                const Color(0xffe64a19), () async {
              requestBodyList = [];
              _generateShippedQtyRequestBody();
              var result = birlestir(requestBodyList);
              _showLoadingScreen(true, "Siparişler Üzerinizden Bırakılıyor");
              waybillRequestBody = await _createWaybillBodyNew();
              bool isWaybillCreated =
                  await apiRepository.createWaybill(waybillRequestBody!);
              if (isWaybillCreated) {
                await _servicePart(result);
                await _localPart();
                _showLoadingScreen(false, "Siparişler Üzerinizden Bırakılıyor");
                _showDialogMessage(
                    "İşlem Başarılı", "Siparişleri üzerinizden bırktınız.");
              } else {
                _showDialogMessage(
                    "İşlem Başarısız", "İrsaliye Oluşturulamadı.");
              }
            }),
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

/*
  _complateOrder() {
    if (!isPartialOrder) {
      if (_isScannedQtyEqualQty()) {
        print("bütün itemlar eşit");
        showDialogForAssingOrder(
            context, false, "Siparişi bırakmak istediğinize emin misiniz ?");
      } else {
        print("bütün itemlar eşit değil");
        _showErrorMessage("Bütün siparişleri tamamlamadınız.");
      }
    } else {
      showDialogForAssingOrder(
          context, false, "Siparişi bırakmak istediğinize emin misiniz ?");
    }
  }

*/
  Column _orderLog() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Son Yapılan İşlemler",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500]),
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
    if (waybillItemLocal!.length == 1) {
      if (warehouseId.toLowerCase() !=
          waybillItemLocal![0].warehouseId!.toLowerCase()) {
        warehouseId = waybillItemLocal![0].warehouseId!;
        var result = await apiRepository.getWarehouseReverse(warehouseId);
        departmentId = result.warehouse?.departments?.departmentId ?? "";
        workplaceId =
            result.warehouse?.departments?.workplace?.workplaceId ?? "";
      }
    } else if (waybillItemLocal!.length > 1) {
      int maxScannedQty = -1;
      for (var item in waybillItemLocal!) {
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

/*
  void changeLocalIsAssing() {
    if (!isAssing) {
      setState(() {
        isAssing = true;
        print("buraya girdi");
      });
    }
  }
*/
  Padding _listTileButton(String content, IconData icon, Color textColor,
      Color backgroundColor, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              30), // Kenar yuvarlaklığını burada ayarlayabilirsiniz
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
            waybillItemLocal!.length.toString(),
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
      iconTheme: IconThemeData(
          color: Colors.deepOrange[700], size: 32 //change your color here
          ),
      title: Text(
        "Sipariş Detayı",
        style: TextStyle(
            color: Colors.deepOrange[700],
            fontWeight: FontWeight.bold,
            fontSize: 20),
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

  void _generateShippedQtyRequestBody() {
    for (int i = 0; i < waybillItemLocal!.length; i++) {
      requestBodyList.add(_createBody(waybillItemLocal![i]));
    }
  }

  ShippedQtyRequestBody _createBody(WaybillItemLocalModel model) {
    return ShippedQtyRequestBody(
        orderId: model.orderId,
        shippedQty: _createShippedQty(model.orderItemId!, model.productId!,
            (model.shippedQty! + model.scannedQty!)));
  }

  List<OrderUpdateQtyItem> _createShippedQty(
      String orderItemId, String productId, int shippedQty) {
    return List.generate(
        1,
        (index) => OrderUpdateQtyItem(
              orderItemId: orderItemId,
              productId: productId,
              shippedQty: shippedQty,
            ));
  }

  void _filteredBody() {
    for (int i = 0; i < requestBodyList.length - 1; i++) {}
  }

  List<ShippedQtyRequestBody> birlestir(
      List<ShippedQtyRequestBody> requestBodyList) {
    Map<String, List<OrderUpdateQtyItem>> groupedByOrderId = {};

    // orderId'ye göre ShippedQtyRequestBody nesnelerini grupla
    requestBodyList.forEach((requestBody) {
      if (groupedByOrderId.containsKey(requestBody.orderId)) {
        groupedByOrderId[requestBody.orderId]!.addAll(requestBody.shippedQty!);
      } else {
        groupedByOrderId[requestBody.orderId!] =
            List.from(requestBody.shippedQty!);
      }
    });

    // Birleştirilmiş ShippedQtyRequestBody nesnelerini oluştur
    List<ShippedQtyRequestBody> combinedRequestBodyList = [];
    groupedByOrderId.forEach((orderId, shippedQtyList) {
      combinedRequestBodyList.add(ShippedQtyRequestBody(
        orderId: orderId,
        shippedQty: shippedQtyList,
      ));
    });

    return combinedRequestBodyList;
  }

  Future<List<String>> _checkStock() async {
    List<String> insufficientStockProducts = [];
    var result = await apiRepository
        .getStockByProductIdList(_createStockByProductList());
    result!.stocks!.forEach((remoteElement) {
      waybillItemLocal!.forEach((localElement) {
        if (remoteElement.productId == localElement.productId &&
            remoteElement.warehouse!.warehouseId == localElement.warehouseId) {
          if (remoteElement.onHandStock! <
              localElement.scannedQty! - localElement.shippedQty!) {
            insufficientStockProducts.add(localElement.productName!);
          }
        }
      });
    });

    return insufficientStockProducts;
  }

  List<String> _createStockByProductList() {
    List<String> idList = [];
    waybillItemLocal!.forEach((element) {
      idList.add(element.productId!);
    });
    return idList;
  }

  Future<void> _servicePart(List<ShippedQtyRequestBody> result) async {
    for (int i = 0; i < result.length; i++) {
      await apiRepository.setOrderAssingStatus(
          false, apiRepository.employeeUid, result[i].orderId!);
    }

    for (int i = 0; i < result.length; i++) {
      await apiRepository.updateOrderItems(
          result[i].orderId!, customerId, result[i].shippedQty!);
    }

    // await apiRepository.getPurchaseOrderSummaryList();
  }

  Future<void> _localPart() async {
    _dbHelper.removeMultiSalesOrder(widget.multiSalesId!);
    _dbHelper.removeMultiSalesOrderScannedItems(widget.multiSalesId!);
    _dbHelper.clearAllMultiSalesOrderDetailItems(widget.multiSalesId!);
  }

  //burası
  Future<void> _getUserSpecialWarehouseSettings() async {
    String userSpecialSetting = await ServiceSharedPreferences.getSharedString(
            UserSpecialSettingsUtils.userWarehouseAuthOut) ??
        "";
    userDefaultWarehouseOut = await ServiceSharedPreferences.getSharedString(
            UserSpecialSettingsUtils.userDefaultWarehouseOut) ??
        "";
    if (userSpecialSetting.isNotEmpty) {
      List<dynamic> decodedValue = jsonDecode(userSpecialSetting);
      setState(() {
        userSpecialWarehouseList = List<String>.from(decodedValue);
        isThereWarehouseBoundForUser = true;
      });
    } else {}
  }

//burası

  //burası
  Row _openBottomSheetAndSelectFromTile(
      String initTitle, String title, Function()? onTap) {
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
                  color:
                      title == initTitle ? Colors.blueGrey[200] : Colors.black,
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

  //burası
  void selectWarehouseReverseForAllItems() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _selectWarehouseByAllWarehousBottomSheet(
          isThereWarehouseBoundForUser
              ? _limitWarehouseBasedOnSetting(
                  allWarehouse, userSpecialWarehouseList)
              : allWarehouse),
    );
  }

  void selectWarehouseReverseForOnlyOneItem(String orderItemId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _selectWarehouseForOnlyOneBottomSheet(
          isThereWarehouseBoundForUser
              ? _limitWarehouseBasedOnSetting(
                  allWarehouse, userSpecialWarehouseList)
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

  Widget _selectWarehouseByAllWarehousBottomSheet(
      List<WorkplaceWarehouse> warehouse) {
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: warehouse.length,
                        itemBuilder: (context, index) {
                          return _selectingAreaRowItem(warehouse[index].code!,
                              () async {
                            warehouseName = warehouse[index].code!;
                            warehouseId = warehouse[index].warehouseId!;
                            setState(() {
                              isLoading = true;
                            });
                            var response = await apiRepository
                                .getWarehouseReverse(warehouseId);
                            for (int i = 0; i < waybillItemLocal!.length; i++) {
                              await _dbHelper
                                  .updateMultiSalesDetailItemWarehouse(
                                      widget.multiSalesId!,
                                      waybillItemLocal![i].orderItemId!,
                                      warehouseId,
                                      warehouseName);
                            }
                            waybillItemLocal = await _dbHelper
                                .getMultiSalesOrderDetailItemList(
                                    widget.multiSalesId!);
                            setState(() {
                              isLoading = false;
                            });
                            workplaceId = response.warehouse!.departments!
                                .workplace!.workplaceId!;

                            departmentId =
                                response.warehouse!.departments!.departmentId!;

                            await _dbHelper.updateMultiSalesOrderWarehouse(
                                widget.multiSalesId!,
                                workplaceId,
                                departmentId,
                                warehouseId,
                                warehouseName);

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

  Widget _selectWarehouseForOnlyOneBottomSheet(
      List<WorkplaceWarehouse> warehouse, String orderItemId) {
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: warehouse.length,
                        itemBuilder: (context, index) {
                          return _selectingAreaRowItem(warehouse[index].code!,
                              () async {
                            var newWarehouseName = warehouse[index].code!;
                            var newWarehouseId = warehouse[index].warehouseId!;

                            //tam olmadı, create'de ve modelde güncelleme lazım
                            await _dbHelper.updateMultiSalesDetailItemWarehouse(
                                widget.multiSalesId!,
                                orderItemId,
                                newWarehouseId,
                                newWarehouseName);

                            waybillItemLocal = await _dbHelper
                                .getMultiSalesOrderDetailItemList(
                                    widget.multiSalesId!);

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

  List<WorkplaceWarehouse> _limitWarehouseBasedOnSetting(
      List<WorkplaceWarehouse> mainList, List<String> limitedList) {
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

//burası

  String _createUniqueFicheNo() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HHmmssSS').format(now);
    String uniqueFicheNo = widget.waybillLocalModel!.ficheNo! + formattedTime;

    return "AUTO_$formattedTime";
  }

  Future<String> _getDocNumberFicheNumber() async {
    getFicheNumberResponse = await apiRepository.getDocNumberFicheNumber(
        apiRepository.employeeUid, "5");

    return getFicheNumberResponse?.docnumber?.lastNum ?? "";
  }

  Future<WayybillsRequestBodyNew> _createWaybillBodyNew() async {
    return WayybillsRequestBodyNew(
      customerId: widget.waybillLocalModel?.customerId ?? guidEmpty,
      // ficheNo: widget.waybillLocalModel!.ficheNo!,
      ficheNo: ficheNoThatCreatedByUser.isEmpty
          ? await _getDocNumberFicheNumber()
          : ficheNoThatCreatedByUser,
      ficheDate: DateFormat('yyyy-MM-dd')
          .format(widget.waybillLocalModel!.ficheDate!)
          .toString(),
      shipDate: DateFormat('yyyy-MM-dd')
          .format(widget.waybillLocalModel!.shipDate!)
          .toString(),
      ficheTime: DateFormat('HH:mm')
          .format(widget.waybillLocalModel!.ficheDate!)
          .toString(),
      // ficheTime: "321529407",
      docNo: widget.waybillLocalModel!.docNo,
      erpInvoiceRef: "deneme",
      workPlaceId: workplaceId,
      department: departmentId,
      warehouse: warehouseId,
      currencyId: widget.waybillLocalModel!.currencyId!,
      totaldiscounted: widget.waybillLocalModel!.totaldiscounted!,
      totalvat: widget.waybillLocalModel!.totalvat!,
      grossTotal: widget.waybillLocalModel!.grosstotal!,
      transporterId: transporterId ?? guidEmpty,
      shippingAccountId: widget.waybillLocalModel?.customerId ?? guidEmpty,
      shippingAddressId:
          widget.waybillLocalModel?.shippingAddressId ?? guidEmpty,
      description: "deneme",
      shippingTypeId: widget.waybillLocalModel?.shippingTypeId ?? guidEmpty,
      salesmanId: widget.waybillLocalModel?.salesmanId ?? guidEmpty,
      waybillStatusId: 1,
      erpId: "",
      erpCode: "",
      waybillTypeId: 0,
      waybillItems: await _createWaybillItemListNew(),
      globalWaybillItemDetails: _createGlobalWaybillItemDetails(),
    );
  }

  Future<List<WaybillItemsNew>> _createWaybillItemListNew() async {
    // var uuid = Uuid();
    List<WaybillItemsNew> waybillItemsList = [];

    for (int i = 0; i < waybillItemLocal!.length; i++) {
      var element = waybillItemLocal![i];

      if (element.scannedQty! > 0) {
        List<WaybillScannedItemDB>? scannedList = [];
        bool isProductLocation = element.isProductLocatin!;

        // Eğer ürün lokasyonu varsa scannedList'i doldur
        if (isProductLocation) {
          scannedList = await _dbHelper.getMultiSalesOrderScannedItem(
              element.recid!, widget.multiSalesId!, element.productId!);
        }

        waybillItemsList.add(
          WaybillItemsNew(
            productId: element.productId,
            description: element.description,
            warehouseId: element.warehouseId,
            productPrice: element.productPrice,
            qty: (element.scannedQty),
            total: element.total,
            discount: element.discount,
            tax: element.tax,
            nettotal: element.nettotal,
            unitId: element.unitId,
            unitConversionId: element.unitConversionId,
            stockLocationRelations: isProductLocation
                ? _createStockLocationRelationList(scannedList!)
                : [],
            currencyId: 1,
            erpId: element.erpId,
            erpCode: element.erpCode,
            orderReferance: element.orderItemId,
            erpOrderReferance: 1,
            waybillItemTypeId: 0,
            waybillItemDetails: _createWaybillItemDetails(
                element.orderId!, element.orderItemId!),
          ),
        );
      }
    }

    return waybillItemsList;
  }

  List<StockLocationRelations> _createStockLocationRelationList(
      List<WaybillScannedItemDB> scannedList) {
    // Map oluşturup stockLocationId'yi key olarak kullanacağız ve numberOfPieces'ları toplayacağız
    Map<String, int> locationMap = {};

    for (var item in scannedList) {
      if (item.stockLocationId != null && item.numberOfPieces != null) {
        if (locationMap.containsKey(item.stockLocationId)) {
          // Eğer stockLocationId map'te varsa, qty'ye numberOfPieces'ı ekle
          locationMap[item.stockLocationId!] =
              locationMap[item.stockLocationId!]! + item.numberOfPieces!;
        } else {
          // Eğer stockLocationId map'te yoksa, yeni bir giriş oluştur
          locationMap[item.stockLocationId!] = item.numberOfPieces!;
        }
      }
    }

    // Map'teki verileri StockLocationRelations nesnelerine dönüştür
    List<StockLocationRelations> stockLocationRelationsList = [];
    locationMap.forEach((stockLocationId, qty) {
      stockLocationRelationsList.add(
          StockLocationRelations(stockLocationId: stockLocationId, qty: qty));
    });

    return stockLocationRelationsList;
  }

  // List<WaybillItemsNew> _createWaybillItemListNew() {
  //   // var uuid = Uuid();
  //   List<WaybillItemsNew> waybillItemsList = [];
  //   waybillItemLocal!.forEach((element) async{
  //     if (element.scannedQty! > 0) {
  //       List<WaybillScannedItemDB>? scannedList = [];
  //           bool isProductLocation = element.isProductLocatin!;

  //           // Eğer ürün lokasyonu varsa scannedList'i doldur
  //           if (isProductLocation) {
  //             scannedList = await _dbHelper.getMultiSalesOrderScannedItem(
  //                 element.recid!,widget.multiSalesId! ,element.productId!);
  //           }
  //       waybillItemsList.add(
  //         WaybillItemsNew(
  //           productId: element.productId,
  //           description: element.description,
  //           warehouseId: element.warehouseId,
  //           productPrice: element.productPrice,
  //           qty: (element.scannedQty),
  //           total: element.total,
  //           discount: element.discount,
  //           tax: element.tax,
  //           nettotal: element.nettotal,
  //           unitId: element.unitId,
  //           unitConversionId: element.unitConversionId,
  //           stockLocationRelations: [],
  //           currencyId: 1,
  //           erpId: element.erpId,
  //           erpCode: element.erpCode,
  //           orderReferance: element.orderItemId,
  //           erpOrderReferance: 1,
  //           waybillItemDetails: _createWaybillItemDetails(
  //               element.orderId!, element.orderItemId!),
  //         ),
  //       );
  //     }
  //   });
  //   return waybillItemsList;
  // }

  List<WaybillItemDetails> _createWaybillItemDetails(
      String orderId, String orderItemId) {
    // var uuid = Uuid();
    List<WaybillItemDetails> waybillItemDetails = [];
    salesOrderDetailResponse.forEach((salesResponse) {
      if (salesResponse.order?.orderId == orderId) {
        salesResponse.order!.orderItems!.forEach((element) {
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
      }
    });

    return waybillItemDetails;
  }

  List<GlobalWaybillItemDetails> _createGlobalWaybillItemDetails() {
    // var uuid = Uuid();
    List<GlobalWaybillItemDetails> globalWaybillItemDetails = [];
    salesOrderDetailResponse.forEach((salesResponse) {
      salesResponse.order!.globalOrderItemDetails!.forEach((element) {
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
    });

    return globalWaybillItemDetails;
  }
}
