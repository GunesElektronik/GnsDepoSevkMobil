import 'package:flutter/material.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/database/model/purchase_order_detail_item_db.dart';
import 'package:gns_warehouse/models/new_api/order_change_qty_item_model.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_detail.dart';
import 'package:gns_warehouse/models/new_api/waybill_request_body_new.dart';
import 'package:gns_warehouse/models/order_detail/order_detail_item_db.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order_scan_page.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:intl/intl.dart';

class PurchaseOrderDetailPage extends StatefulWidget {
  const PurchaseOrderDetailPage({super.key, required this.purchaseOrderId});

  final String purchaseOrderId;

  @override
  State<PurchaseOrderDetailPage> createState() =>
      _PurchaseOrderDetailPageState();
}

class _PurchaseOrderDetailPageState extends State<PurchaseOrderDetailPage> {
  late ApiRepository apiRepository;
  late PurchaseOrderDetailResponse response;
  late bool isDataFetch;
  late bool? isThisInMultiOrder;
  late bool isPartialOrder;
  late bool isAssing;
  late bool isAssingedPersonIsCurrenUser;
  final DbHelper _dbHelper = DbHelper.instance;
  List<PurchaseOrderDetailItemDB>? orderDetailItemList = [];
  String customerId = "";
  WayybillsRequestBodyNew? waybillRequestBody;
  DateTime currentDate = DateTime.now();

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

  Future<void> _denemelocalkayit() async {
    orderDetailItemList!.forEach((element) async {
      await _dbHelper.addPurchaseOrderDetailItem(element);
    });
  }

  Future<void> _denemelocalgetir() async {
    var result =
        await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);
    print("data oldu ${result![0].productName}");
  }

  void _createApiRepository() async {
    isDataFetch = false;
    isThisInMultiOrder = false;
    apiRepository = await ApiRepository.create(context);
    isThisInMultiOrder = await _dbHelper
        .isThereAnyItemBasedOrderIdInMultiPurchaseOrder(widget.purchaseOrderId);
    response =
        await apiRepository.getPurchaseOrderDetail(widget.purchaseOrderId);
    isPartialOrder = response.order!.isPartialOrder ?? false;
    customerId = response.order!.customer!.customerId!;
    response.order!.orderItems!.forEach((element) {
      orderDetailItemList!.add(
        PurchaseOrderDetailItemDB(
            purchaseOrderId: widget.purchaseOrderId,
            orderItemId: element.orderItemId,
            productId: element.product!.productId,
            warehouseId: element.warehouseId,
            ficheNo: response.order!.ficheNo,
            productName: element.product!.code,
            productBarcode: element.product!.barcode,
            warehouse: element.warehouseName,
            serilotType: _transformToIntForProductTracking(
                element.product!.productTrackingMethod!),
            scannedQty: element.shippedQty!.toInt()!,
            qty: element.qty!.toInt()),
      );
    });

    //await _denemelocalkayit();

    if (response.order!.isAssing!) {
      if (response.order!.assingmentEmail == apiRepository.employeeEmail) {
        isAssingedPersonIsCurrenUser = true;
        _getLocalOrderDetailItemList();
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

  void _getLocalOrderDetailItemList() async {
    var results =
        await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);
    orderDetailItemList = results;

    if (orderDetailItemList!.isEmpty) {
      response.order!.orderItems!.forEach((element) async {
        await _dbHelper.addPurchaseOrderDetailItem(PurchaseOrderDetailItemDB(
          purchaseOrderId: widget.purchaseOrderId,
          orderItemId: element.orderItemId,
          productId: element.product!.productId!,
          warehouseId: element.warehouseId,
          stockLocationId: "",
          ficheNo: response.order!.ficheNo,
          productName: element.product!.code,
          productBarcode: element.product!.barcode,
          warehouse: element.warehouseName,
          isProductLocatin: element.product!.isProductLocatin!,
          stockLocationName: "",
          serilotType: _transformToIntForProductTracking(
              element.product!.productTrackingMethod!),
          scannedQty: element.shippedQty!.toInt(),
          qty: element.qty!.toInt(),
          shippedQty: element.shippedQty!.toInt(),
        ));
      });

      var results = await _dbHelper
          .getPurchaseOrderDetailItemList(widget.purchaseOrderId);
      orderDetailItemList = results;
    }

    setState(() {
      print(
          "localdeki order itemlarıns sayııs: ${orderDetailItemList!.length}");
    });
  }

  Future<void> _setOrderAssingStatus(bool isAssingRemote) async {
    if (isAssingRemote) {
      await _takeTheOrder();
    } else {
      await _completeTheOrder();
    }
  }

  Future<bool> _completeTheOrder() async {
    bool isUpdate = false;
    bool isSuccess = false;
    _showLoadingScreen(true, "Yükleniyor ...");

    var orderItemList =
        await _dbHelper.getPurchaseOrderDetailItemList(widget.purchaseOrderId);

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
        isUpdate = await apiRepository.updatePurchaseOrderItems(
            widget.purchaseOrderId, customerId, orderItemsList);
      } catch (e) {
        print("İşlem hatası: $e");
        _showLoadingScreen(false, "Yükleniyor ...");
        return false;
      }
    } else {
      isUpdate = true;
    }
    //isUpdate = true;

    if (isUpdate) {
      isSuccess = await apiRepository.setPurchaseOrderAssingStatus(
          false, apiRepository.employeeUid, widget.purchaseOrderId);
      _showLoadingScreen(false, "Yükleniyor ...");
    }

    if (isSuccess && isUpdate) {
      print("işlem başarılı");
      _showLoadingScreen(true, "Veriler Güncelleniyor ...");
      await apiRepository.getPurchaseOrderSummaryList();
      response =
          await apiRepository.getPurchaseOrderDetail(widget.purchaseOrderId);
      await _dbHelper.clearAllPurchaseOrderDetailItems(widget.purchaseOrderId);

      await _dbHelper
          .removePurchaseOrderDetailScannedItems(response.order!.ficheNo!);

      _showLoadingScreen(false, "Veriler Güncelleniyor ...");
      setState(() {
        isAssing = false;
        isAssingedPersonIsCurrenUser = true;
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

  _takeTheOrder() async {
    _showLoadingScreen(true, "Yükleniyor ...");
    //await Future.delayed(Duration(seconds: 3));
    //bool isSuccess = true;

    bool isSuccess = await apiRepository.setPurchaseOrderAssingStatus(
        true, apiRepository.employeeUid, widget.purchaseOrderId);
    _showLoadingScreen(false, "Yükleniyor ...");

    //bool deneme = false;
    if (isSuccess) {
      print("işlem başarılı");
      _showLoadingScreen(true, "Veriler Güncelleniyor ...");

      await apiRepository.getPurchaseOrderSummaryList();
      response =
          await apiRepository.getPurchaseOrderDetail(widget.purchaseOrderId);
      await _dbHelper.clearAllPurchaseOrderDetailItems(widget.purchaseOrderId);

      response.order!.orderItems!.forEach((element) async {
        await _dbHelper.addPurchaseOrderDetailItem(PurchaseOrderDetailItemDB(
          purchaseOrderId: widget.purchaseOrderId,
          orderItemId: element.orderItemId,
          productId: element.product!.productId!,
          warehouseId: element.warehouseId,
          stockLocationId: "",
          ficheNo: response.order!.ficheNo,
          productName: element.product!.code,
          productBarcode: element.product!.barcode,
          warehouse: element.warehouseName,
          isProductLocatin: element.product!.isProductLocatin!,
          stockLocationName: "",
          serilotType: _transformToIntForProductTracking(
              element.product!.productTrackingMethod!),
          scannedQty: element.shippedQty!.toInt(),
          qty: element.qty!.toInt(),
          shippedQty: element.shippedQty!.toInt(),
        ));
      });
      var results = await _dbHelper
          .getPurchaseOrderDetailItemList(widget.purchaseOrderId);
      orderDetailItemList = results;

      _showLoadingScreen(false, "Veriler Güncelleniyor ...");
      setState(() {
        isAssing = true;
        isAssingedPersonIsCurrenUser = true;
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
            isThisInMultiOrder!
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "BU SİPARİŞ ÇOKLU SİPARİŞLERDE",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 152, 35)),
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
                              showDialogForAssingOrder(context, true,
                                  "Siparişi görevlenmeye emin misiniz ?");
                            },
                            icon: const Icon(
                              Icons.download_rounded,
                              size: 30,
                              color: Color(0xffff9700),
                            ),
                          ),
                    isAssing &&
                            isAssingedPersonIsCurrenUser &&
                            !isThisInMultiOrder!
                        ? const SizedBox(
                            width: 5,
                          )
                        : const SizedBox(),
                    //toplamaya devam et
                    isAssing &&
                            isAssingedPersonIsCurrenUser &&
                            !isThisInMultiOrder!
                        ? IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PurchaseOrderScanPage(
                                            purchaseOrderDetailItemList:
                                                orderDetailItemList,
                                            purchaseOrderId:
                                                widget.purchaseOrderId,
                                            // customerId: response
                                            //     .order!.customer!.customerId!,
                                          ))).then((value) async {
                                var results = await _dbHelper
                                    .getPurchaseOrderDetailItemList(
                                        widget.purchaseOrderId);
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
                    isAssing &&
                            isAssingedPersonIsCurrenUser &&
                            !isThisInMultiOrder!
                        ? const SizedBox(
                            width: 5,
                          )
                        : const SizedBox(),
                    //toplamayı tamamla
                    isAssing &&
                            isAssingedPersonIsCurrenUser &&
                            !isThisInMultiOrder!
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
                    isAssing &&
                            isAssingedPersonIsCurrenUser &&
                            !isThisInMultiOrder!
                        ? const SizedBox(
                            width: 5,
                          )
                        : const SizedBox(),
                    //sevk et
                    isAssing &&
                            isAssingedPersonIsCurrenUser &&
                            !isThisInMultiOrder!
                        ? IconButton(
                            onPressed: () async {
                              _showLoadingScreen(
                                  true, "İrsaliye Oluşturuluyor");
                              waybillRequestBody = _createWaybillBodyNew();
                              bool isDone = await _completeTheOrder();
                              if (isDone) {
                                if (isDone) {
                                  bool isCreated = await apiRepository
                                      .createWaybillPurchaseOrder(
                                          waybillRequestBody!);
                                  if (isCreated) {
                                    _showLoadingScreen(
                                        false, "İrsaliye Oluşturuluyor");
                                    _showLoadingScreen(
                                        false, "İrsaliye Oluşturuluyor");
                                    _showDialogMessage(
                                        "Başarılı", "İrsaliye Oluşturuldu.");
                                  } else {
                                    _showLoadingScreen(
                                        false, "İrsaliye Oluşturuluyor");
                                    _showLoadingScreen(
                                        false, "İrsaliye Oluşturuluyor");
                                    _showErrorMessage(
                                        "İrsaliye Oluşturulamadı !");
                                  }
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
            _infoRow("Parçalı Sipariş",
                response.order!.isPartialOrder! ? "Evet" : "Hayır"),
            _divider(),
            _infoRow(
                "Tarih",
                DateFormat('dd-MM-yyyy').format(
                    DateTime.parse(response.order!.ficheDate ?? "01-01-2000"))),
            _divider(),
            _infoRow("Müşteri", response.order!.customer!.name.toString()),
            _divider(),
            _infoRow(
                "Depolar", response.order!.warehouse!.definition.toString()),
            _divider(),
            _infoRow("Adet", response.order!.orderItems!.length.toString()),
            _divider(),
            _infoRow("Tutar", response.order!.grossTotal.toString()),
            _divider(),
            _infoRow("Durum", response.order!.orderStatusName!.toString()),
            _divider(),
            _infoRow("Operatör",
                isAssing ? response.order!.assingmetFullname.toString() : ""),
            _divider(),
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
                      onLongPress: () {},
                      highlightColor: const Color.fromARGB(255, 179, 199, 211),
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.only(right: 15, left: 15),
                        leading: Text(
                          (index + 1 < 10)
                              ? "0${index + 1} ${serilotType(orderDetailItemList![index].serilotType!)}"
                              : "${index + 1} ${serilotType(orderDetailItemList![index].serilotType!)}",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[700]),
                        ),
                        trailing: Text(
                          "${orderDetailItemList![index].scannedQty!} / ${orderDetailItemList![index].qty}",
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: selectColor(
                                  orderDetailItemList![index].scannedQty!,
                                  orderDetailItemList![index].qty!)),
                        ),
                        title: Text(
                          "${orderDetailItemList![index].productBarcode}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff727272),
                          ),
                        ),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${orderDetailItemList![index].productName}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[700]),
                              ),
                              Text(
                                "${orderDetailItemList![index].warehouse}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[700]),
                              )
                            ]),
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            isAssing
                ? const SizedBox()
                : _listTileButton("Toplamaya Başla", Icons.download_rounded,
                    Colors.white, const Color(0xffff9700), () {
                    showDialogForAssingOrder(
                        context, true, "Siparişi görevlenmeye emin misiniz ?");
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
                                    purchaseOrderDetailItemList:
                                        orderDetailItemList,
                                    purchaseOrderId: widget.purchaseOrderId,
                                    // customerId:
                                    //     response.order!.customer!.customerId!,
                                  ))).then((value) async {
                        var results =
                            await _dbHelper.getPurchaseOrderDetailItemList(
                                widget.purchaseOrderId);
                        orderDetailItemList = results;
                        setState(() {});
                      });
                    },
                  )
                : const SizedBox(),
            isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                ? _listTileButton("Toplamayı Tamamla", Icons.inbox,
                    Colors.black, const Color(0xff8a9c9c), () {
                    _complateOrder();
                  })
                : const SizedBox(),
            isAssing && isAssingedPersonIsCurrenUser && !isThisInMultiOrder!
                ? _listTileButton("Sevk Et", Icons.fire_truck, Colors.black,
                    const Color(0xffe64a19), () async {
                    _showLoadingScreen(true, "İrsaliye Oluşturuluyor");
                    waybillRequestBody = _createWaybillBodyNew();
                    bool isDone = await _completeTheOrder();

                    if (isDone) {
                      bool isCreated = await apiRepository
                          .createWaybillPurchaseOrder(waybillRequestBody!);
                      if (isCreated) {
                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        _showDialogMessage("Başarılı", "İrsaliye Oluşturuldu.");
                      } else {
                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        _showLoadingScreen(false, "İrsaliye Oluşturuluyor");
                        _showErrorMessage("İrsaliye Oluşturulamadı !");
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

  void changeLocalIsAssing() {
    if (!isAssing) {
      setState(() {
        isAssing = true;
        print("buraya girdi");
      });
    }
  }

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

  bool _isScannedQtyEqualQty() {
    for (int i = 0; i < orderDetailItemList!.length; i++) {
      if (orderDetailItemList![i].scannedQty != orderDetailItemList![i].qty) {
        return false;
      }
    }

    return true;
  }

  WayybillsRequestBodyNew _createWaybillBodyNew() {
    return WayybillsRequestBodyNew(
      customerId: response.order!.customer!.customerId!,
      ficheNo: response.order!.ficheNo,
      ficheDate: DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(response.order!.ficheDate!)),
      shipDate: DateFormat('yyyy-MM-dd').format(currentDate),
      ficheTime: response.order!.ficheTime,
      docNo: response.order!.docNo,
      erpInvoiceRef: "deneme",
      workPlaceId: response.order!.workplace!.workplaceId,
      department: response.order!.department!.departmentId,
      warehouse: response.order!.warehouse!.warehouseId!,
      currencyId: response.order!.currencyId,
      totaldiscounted: response.order!.totaldiscounted,
      totalvat: response.order!.totalvat,
      grossTotal: response.order!.grossTotal,
      transporterId: response.order!.transporter!.transporterId,
      shippingAccountId: response.order!.shippingAccount!.customerId,
      shippingAddressId: response.order!.shippingAddress!.shippingAddressId,
      description: "deneme",
      shippingTypeId: response.order!.orderShippingType!.shippingTypeId,
      salesmanId: response.order!.shippingAccount!.salesman!.salesmanId,
      waybillStatusId: 1,
      erpId: "",
      erpCode: "",
      waybillItems: _createWaybillItemListNew(),
    );
  }

  List<WaybillItemsNew> _createWaybillItemListNew() {
    // var uuid = Uuid();
    List<WaybillItemsNew> waybillItemsList = [];
    orderDetailItemList!.forEach((localElement) {
      response.order!.orderItems!.forEach((element) {
        if (localElement.productId == element.product!.productId) {
          waybillItemsList.add(
            WaybillItemsNew(
              productId: element.product!.productId,
              description: element.description,
              warehouseId: element.warehouseId,
              productPrice: element.productPrice,
              qty: (localElement.scannedQty!.toInt() -
                  element.shippedQty!.toInt()),
              total: element.total,
              discount: element.discount,
              tax: element.tax,
              nettotal: element.nettotal,
              unitId: element.unitId,
              unitConversionId: element.unitConversionId,
              stockLocationRelations: [],
              currencyId: 1,
              erpId: "",
              erpCode: "",
            ),
          );
        }
      });
    });

    return waybillItemsList;
  }
}
