import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/database/dbhelper_for_waybills.dart';
import 'package:gns_warehouse/database/model/product_barcodes_item.dart';
import 'package:gns_warehouse/database/model/waybills_item_loca.dart';
import 'package:gns_warehouse/database/model/waybills_local.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_detail.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/models/waybills_request_body.dart';
import 'package:gns_warehouse/pages/purchase_orders/components/purchase_order_list_item.dart';
import 'package:gns_warehouse/pages/purchase_orders/order_control_card.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order_scan.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class PurchaseOrderList extends StatefulWidget {
  PurchaseOrderList({
    super.key,
    required this.selectedItems,
    required this.customerName,
    required this.departments,
    required this.customerId,
    required this.workplaceId,
    required this.departmentId,
    required this.warehouseId,
    required this.warehouseName,
    required this.transporterId,
    required this.shippingTypeId,
    required this.ficheDate,
    required this.shipDate,
  });
  List<IsSelectedclassPurchaseOrderSummaryItem> selectedItems;
  List<Departments> departments;
  String customerName;
  String customerId;
  String workplaceId;
  String departmentId;
  String warehouseId;
  String warehouseName;
  String transporterId;
  String shippingTypeId;
  DateTime ficheDate;
  DateTime shipDate;

  @override
  State<PurchaseOrderList> createState() => _PurchaseOrderListState();
}

class _PurchaseOrderListState extends State<PurchaseOrderList> {
  List<PurchaseOrderDetailResponse> purchaseOrderDetailResponse = [];
  final DbHelper _dbHelper = DbHelper.instance;
  bool isCreatedWaybill = false;
  late ApiRepository apiRepository;
  var uuid = Uuid();
  late String waybillId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waybillId = uuid.v4();
    _createApiRepository();
  }

  void _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBar(context),
        body: PopScope(
          canPop: false,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10,
            ),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  _headerTextStage(),
                  const SizedBox(
                    height: 20,
                  ),
                  // _listTile(
                  //   "IRS00000123",
                  //   "12.03.2024",
                  // ),
                  // _divider(),
                  _listTile("Müşteri", widget.customerName),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: widget.selectedItems.length,
                            itemBuilder: (context, index) {
                              return PurchaseOrderListItem(
                                item: widget.selectedItems[index],
                                departments: widget.departments,
                                response: (value) {
                                  purchaseOrderDetailResponse.add(value);
                                },
                                changedItem: (value) {
                                  for (int i = 0;
                                      i < purchaseOrderDetailResponse.length;
                                      i++) {
                                    if (purchaseOrderDetailResponse[i]
                                            .order!
                                            .ficheNo ==
                                        value.order!.ficheNo) {
                                      purchaseOrderDetailResponse[i] = value;
                                    }
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: _button("Toplama Listesini Kaydet", Colors.white,
                        const Color(0xffff9700), () {}),
                  ),
                  */
                  isCreatedWaybill
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: _button("Toplama Listesini Topla",
                              Colors.white, const Color(0xffff9700), () {
                            Navigator.of(context)
                                .push<String>(MaterialPageRoute(
                              builder: (context) => const PurchaseOrderScan(),
                            ));
                          }),
                        )
                      : const SizedBox(),
                  !isCreatedWaybill
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: _button("Siparişleri Birleştir", Colors.white,
                              const Color(0xffe64a19), () async {
                            /*
                            _showLoadingScreen(
                                true, "Siparişler Üstünüze Alınıyor");
                            widget.selectedItems.forEach((element) async {
                              await apiRepository.setPurchaseOrderAssingStatus(
                                  true,
                                  apiRepository.employeeUid,
                                  element.item.orderId!);
                            });
                            await apiRepository.getPurchaseOrderSummaryList();
                            _showLoadingScreen(
                                false, "Siparişler Üstünüze Alınıyor");

                            _showLoadingScreen(
                                true, "Siparişler Oluşturuluyor");
                            await _dbHelper
                                .addMultiOrder(_createWaybillLocal());

                            _createWaybillItemList().forEach((element) async {
                              await _dbHelper.addWaybillOrderDetailItem(
                                  WaybillItemLocalModel(
                                waybillsId: waybillId,
                                orderId: element.orderId,
                                orderItemId: element.orderItemId,
                                productId: element.productId,
                                description: element.description,
                                warehouseId: element.warehouseId,
                                productPrice: element.productPrice,
                                shippedQty: element.shippedQty,
                                scannedQty: 0,
                                qty: element.qty,
                                total: element.total,
                                discount: element.discount,
                                tax: element.tax,
                                nettotal: element.nettotal,
                                unitId: element.unitId,
                                unitConversionId: element.unitConversionId,
                                currencyId: element.currencyId,
                                barcode: (element.barcode) == ""
                                    ? "12121212"
                                    : element.barcode,
                                productName: element.productName,
                              ));
                            });
                            _showLoadingScreen(
                                false, "Siparişler Oluşturuluyor");
                            _showDialogMessage("İşlem Başarılı",
                                "Siparişleri birleştirme başarılı.");
                                */
                            _showLoadingScreen(true, "Yükleniyor...");
                            await _setAssingStatus();
                            await _localSave();
                            _showLoadingScreen(false, "Yükleniyor...");
                            _showDialogMessage(
                                "İşlem Başarılı", "Çoklu sipariş oluşturuldu");

/*
                            
                            setState(() {
                              isCreatedWaybill = true;
                            });
*/
                          }),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        "SATIN ALMA SİPARİŞİ",
        style: TextStyle(
            color: Colors.deepOrange[700],
            fontWeight: FontWeight.w600,
            fontSize: 20),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 35,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  ListTile _listTile(String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0, left: 0),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xff6a6a6a),
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange),
      ),
    );
  }

  Padding _headerTextStage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _headerText("Kontrol", const Color(0xff919b9a)),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 25,
            color: Color(0xffd5d5d5),
          ),
          _headerText("Liste", Colors.deepOrange),
          // const Icon(
          //   Icons.arrow_forward_rounded,
          //   size: 25,
          //   color: Color(0xffd5d5d5),
          // ),
          // _headerText("Okutma", const Color(0xff919b9a)),
        ],
      ),
    );
  }

  Text _headerText(String content, Color color) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }

  Divider _divider() {
    return const Divider(
      color: Color.fromARGB(255, 228, 228, 228),
      thickness: 1,
    );
  }

  Row _button(String content, Color textColor, Color backgroundColor,
      VoidCallback? onPressed) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: const MaterialStatePropertyAll(0),
              backgroundColor:
                  MaterialStateProperty.all<Color>(backgroundColor),
            ),
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                content,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  WayybillsRequestBody _createWaybillBody() {
    return WayybillsRequestBody(
      customerId: widget.customerId,
      ficheNo: "",
      ficheDate: widget.ficheDate.toString(),
      shipDate: widget.shipDate.toString(),
      ficheTime: "",
      docNo: "",
      erpInvoiceRef: "",
      workPlaceId: widget.workplaceId,
      department: widget.departmentId,
      warehouse: widget.warehouseId,
      currencyId: 0,
      totaldiscounted: 0,
      totalvat: 0,
      grossTotal: 0,
      transporterId: widget.transporterId,
      shippingAccountId: widget.customerId,
      shippingAddressId: "",
      description: "",
      shippingTypeId: widget.shippingTypeId,
      salesmanId: purchaseOrderDetailResponse[0].order!.salesman!.salesmanId!,
      waybillStatusId: 1,
      erpId: "",
      erpCode: "",
      waybillItems: _createWaybillItemList(),
    );
  }

  List<WaybillItems> _createWaybillItemList() {
    List<WaybillItems> waybillItemsList = [];
    purchaseOrderDetailResponse.forEach((orderElement) {
      orderElement.order!.orderItems!.forEach((itemElement) {
        waybillItemsList.add(
          WaybillItems(
            orderId: orderElement.order!.orderId,
            orderItemId: itemElement.orderItemId,
            productId: itemElement.product!.productId,
            description: itemElement.description,
            warehouseId: itemElement.warehouseId,
            warehouseName: itemElement.warehouseName,
            stockLocationId: "",
            stockLocationName: "coklusiparislocname",
            isProductLocatin: itemElement.product?.isProductLocatin,
            productPrice: itemElement.productPrice,
            qty: itemElement.qty!.toInt(),
            total: itemElement.total,
            discount: itemElement.discount,
            tax: itemElement.tax,
            nettotal: itemElement.nettotal,
            unitId: itemElement.unitId,
            unitConversionId: itemElement.unitConversionId,
            currencyId: 1,
            ficheDate: DateTime.parse(orderElement.order!.ficheDate!),
            erpId: itemElement.erpId,
            erpCode: itemElement.erpCode,
            shippedQty: itemElement.shippedQty!.toInt(),
            barcode: itemElement.product!.barcode,
            productName: itemElement.product!.code,
          ),
        );
      });
    });

    return waybillItemsList;
  }

  WaybillLocalModel _createWaybillLocal() {
    return WaybillLocalModel(
      waybillId,
      "",
      _createFicheNo(),
      widget.customerId,
      widget.customerName,
      purchaseOrderDetailResponse[0].order?.salesman?.salesmanId,
      widget.ficheDate,
      widget.shipDate,
      widget.workplaceId,
      widget.departmentId,
      widget.warehouseId,
      widget.warehouseName,
      widget.transporterId,
      widget.shippingTypeId,
      1,
      purchaseOrderDetailResponse[0].order!.currencyId,
      _sumOfTotalDiscounted(),
      _sumOfTotalVat(),
      _sumOfTotalGrossTotal(),
      purchaseOrderDetailResponse[0].order!.shippingAccount?.customerId,
      purchaseOrderDetailResponse[0].order!.shippingAddress?.shippingAddressId,
      purchaseOrderDetailResponse[0].order!.description,
    );
  }

  double _sumOfTotalDiscounted() {
    double total = 0;
    purchaseOrderDetailResponse.forEach((element) {
      total += element.order!.totaldiscounted!;
    });

    return total;
  }

  double _sumOfTotalVat() {
    double total = 0;
    purchaseOrderDetailResponse.forEach((element) {
      total += element.order!.totalvat!;
    });

    return total;
  }

  double _sumOfTotalGrossTotal() {
    double total = 0;
    purchaseOrderDetailResponse.forEach((element) {
      total += element.order!.grossTotal!;
    });

    return total;
  }

  String _createFicheNo() {
    String ficheNo = "";
    purchaseOrderDetailResponse.forEach((element) {
      ficheNo += element.order!.ficheNo! + " ";
    });

    return ficheNo;
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

  Future<void> _setAssingStatus() async {
    for (int i = 0; i < widget.selectedItems.length; i++) {
      await apiRepository.setPurchaseOrderAssingStatus(true,
          apiRepository.employeeUid, widget.selectedItems[i].item.orderId!);
    }
    // await apiRepository.getPurchaseOrderSummaryList();
  }

  Future<void> _localSave() async {
    await _dbHelper.addMultiPurchaseOrder(_createWaybillLocal());

    var list = _createWaybillItemList();

    for (int i = 0; i < list.length; i++) {
      await _getProductBarcodes(list[i].orderId!, list[i].productId!);
    }

    for (int i = 0; i < list.length; i++) {
      await _dbHelper.addWaybillOrderDetailItem(WaybillItemLocalModel(
        waybillsId: waybillId,
        orderId: list[i].orderId,
        orderItemId: list[i].orderItemId,
        productId: list[i].productId,
        description: list[i].description,
        warehouseId: list[i].warehouseId,
        warehouseName: list[i].warehouseName,
        stockLocationId: list[i].stockLocationId,
        stockLocationName: list[i].stockLocationName,
        isProductLocatin: list[i].isProductLocatin,
        productPrice: list[i].productPrice,
        shippedQty: list[i].shippedQty,
        scannedQty: 0,
        qty: list[i].qty,
        total: list[i].total,
        discount: list[i].discount,
        tax: list[i].tax,
        nettotal: list[i].nettotal,
        unitId: list[i].unitId,
        unitConversionId: list[i].unitConversionId,
        currencyId: list[i].currencyId,
        // barcode: (list[i].barcode) == "" ? "111" : list[i].barcode,
        barcode: list[i].barcode,
        productName: list[i].productName,
        ficheDate: list[i].ficheDate,
        erpId: list[i].erpId,
        erpCode: list[i].erpCode,
      ));
    }
  }

  _getProductBarcodes(String purchaseOrderId, String productId) async {
    var result = await apiRepository.getProductDetailBarcodes(productId);
    result.products!.unit!.conversions!.forEach((element) async {
      element.barcodes!.forEach((barcode) async {
        await _dbHelper.addProductBarcode(_createProductBarcodeItem(
            purchaseOrderId,
            productId,
            barcode.barcode!,
            element.code!,
            element.convParam1!,
            element.convParam2!));
      });
    });
  }

  ProductBarcodesItemLocal _createProductBarcodeItem(
      String purchaseOrderId,
      String productId,
      String barcode,
      String code,
      int convParam1,
      int convParam2) {
    return ProductBarcodesItemLocal(
      recid: 0,
      orderId: purchaseOrderId,
      productId: productId,
      barcode: barcode,
      code: code,
      convParam1: convParam1,
      convParam2: convParam2,
    );
  }
}
