import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gns_warehouse/constants/system_settings.dart';
import 'package:gns_warehouse/models/new_api/doc_number_get_fiche_number.dart';
import 'package:gns_warehouse/models/new_api/new_customer_list_response.dart';
import 'package:gns_warehouse/models/new_api/order_detail_new_model.dart';
import 'package:gns_warehouse/models/new_api/product_list_reponse.dart';
import 'package:gns_warehouse/models/new_api/sales_order/create_sales_order_request.dart';
import 'package:gns_warehouse/models/new_api/waybill_request_body_new.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/stock_counting_fiche/components/count_fiche_scan_area.dart';
import 'package:gns_warehouse/pages/create_order/create_sales_order/create_order_product_update.dart';
import 'package:gns_warehouse/pages/create_order/common_components/gns_select_salesman/gns_select_salesman.dart';
import 'package:gns_warehouse/pages/create_order/common_components/gns_shipping_type/gns_select_shipping_type.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_customer.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_project.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_transporter.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_warehouse.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:gns_warehouse/widgets/gns_app_bar.dart';
import 'package:gns_warehouse/widgets/gns_error_field.dart';
import 'package:gns_warehouse/widgets/gns_show_dialog.dart';
import 'package:gns_warehouse/widgets/gns_text_field.dart';
import 'package:gns_warehouse/widgets/gns_text_form_field.dart';
import 'package:intl/intl.dart';

class CreateSalesOrder extends StatefulWidget {
  const CreateSalesOrder({super.key});

  @override
  State<CreateSalesOrder> createState() => _CreateSalesOrderState();
}

class _CreateSalesOrderState extends State<CreateSalesOrder> {
  late ApiRepository apiRepository;
  late WorkplaceListResponse? workplaceResponse;
  late NewCustomerListResponse? customerResponse;
  double spaceBetweenInputs = 6.0;
  bool isFetched = false;
  bool isTransferFicheCreated = false;
  DateTime ficheDate = DateTime.now();
  String description = "";
  String transporterId = "";
  String salesmenId = "";
  String shippingTypeId = "";
  String projectId = "";
  String projectName = "";
  String ficheNo = "";

  bool isSalesmanIdEmpty = false;
  bool isCustomerIdEmpty = false;
  bool isCustomerAddressIdEmpty = false;
  bool isTransporterIdEmpty = false;
  bool isShippingTypeIdEmpty = false;
  bool isProjectIdEmpty = false;
  bool isWorkplaceIdEmpty = false;
  bool isDepartmentIdEmpty = false;
  bool isWarehouseIdEmpty = false;

  void _updateUIForEmptyAreas() {
    isSalesmanIdEmpty = salesmenId.isEmpty;
    isCustomerIdEmpty = customerInfo.customerId.isEmpty;
    isCustomerAddressIdEmpty = customerInfo.customerAddressId.isEmpty;
    isTransporterIdEmpty = transporterId.isEmpty;
    isShippingTypeIdEmpty = shippingTypeId.isEmpty;
    isProjectIdEmpty = projectId.isEmpty;
    isWorkplaceIdEmpty = warehouseInfo.workplaceId.isEmpty;
    isDepartmentIdEmpty = warehouseInfo.departmentId.isEmpty;
    isWarehouseIdEmpty = warehouseInfo.warehouseId.isEmpty;
  }

  DateTime currentDate = DateTime.now();
  int waybillTypeId = 0;
  DocNumberGetFicheNumberResponse? getFicheNumberResponse;

  List<ProductDetailAndScannedNumberForSalesOrderCreate> salesProductList = [];
  int scannedTimes = 1;
  String guidEmpty = "00000000-0000-0000-0000-000000000000";

  bool isWaybillAutoCreated = true;

  WorkplaceDepartmentWarehouse warehouseInfo = WorkplaceDepartmentWarehouse(
    workplaceName: "",
    departmentName: "",
    warehouseName: "Giriş Ambarı",
    workplaceId: "",
    departmentId: "",
    warehouseId: "",
  );

  CustomerAndAddress customerInfo = CustomerAndAddress(
    customerId: "",
    customerAddressId: "",
  );

  late OrderDetailResponseNew response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createApiRepository();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    customerResponse = await apiRepository.getCustomer();
    workplaceResponse = await apiRepository.getWorkplaceList();
    setState(() {
      isFetched = true;
    });
  }

  Future<void> _getWaybillTypeSelection() async {
    String waybillType = await ServiceSharedPreferences.getSharedString(
            GNSSystemSettingsUtils.WaybillTypeSelection) ??
        "";

    switch (waybillType) {
      case "0":
        // waybillTypeName = "Kağıt";
        waybillTypeId = 0;
        // isWaybillTypeSelectable = false;
        break;
      case "1":
        // waybillTypeName = "E-İrsaliye";
        waybillTypeId = 1;
        // isWaybillTypeSelectable = false;
        break;
      case "2":
        // waybillTypeName = "Kağıt";
        waybillTypeId = 0;
        // isWaybillTypeSelectable = true;
        setState(() {});
        break;
      case "3":
        // waybillTypeName = "E-İrsaliye";
        waybillTypeId = 1;
        // isWaybillTypeSelectable = true;
        break;
      default:
    }
  }

  Future<void> _getProductBasedOnBarcode(String barcode) async {
    try {
      _showLoadingScreen(true, "Barkodla İlgili Ürün Aranıyor");
      var response = await apiRepository.getProductListBasedOnBarcode(barcode);
      if (response != null) {
        if (response.products!.items!.isNotEmpty) {
          var newItem = SalesOrderItems(
            productId: response.products!.items![0].productId,
            description: response.products?.items?[0].definition ?? "",
            warehouseId: warehouseInfo.warehouseId,
            productPrice: 100,
            qty: 1,
            shippedQty: 1,
            total: 0,
            discount: 0,
            tax: 20,
            nettotal: 80,
            unitId: response.products?.items?[0].unit?.unitId ?? guidEmpty,
            unitConversionId: response.products?.items?[0].unit?.conversions?[0]
                    .unitConversionId ??
                guidEmpty,
            erpId: response.products?.items?[0].erpId ?? "0",
            erpCode: response.products?.items?[0].erpCode ?? "0",
            currencyId: 1,
            orderitemtype: 0,
            projectId: projectId,
          );

          ProductDetailInfoForUI infoForUI = ProductDetailInfoForUI(
            warehouseName: warehouseInfo.warehouseName,
            unitConversionName: response
                    .products?.items?[0].unit?.conversions?[0].description ??
                "",
          );
          salesProductList.add(
            ProductDetailAndScannedNumberForSalesOrderCreate(
                response: response,
                bodyItem: newItem,
                scannedNumber: 1,
                infoForUI: infoForUI),
          );
          _showLoadingScreen(false, "Barkodla İlgili Ürün Aranıyor");
          setState(() {});
        } else {
          _showLoadingScreen(false, "Barkodla İlgili Ürün Aranıyor");
          GNSShowErrorMessage(context, "Barkod İle Eşleşen Ürün Bulunamadı");
        }
      }
    } catch (e) {
      _showLoadingScreen(false, "Barkodla İlgili Ürün Aranıyor");
      GNSShowErrorMessage(context, e.toString());
    }
  }

  _showLoadingScreen(bool isLoading, String content) {
    if (isLoading) {
      return showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            );
          });
    } else {
      Navigator.pop(context); // Loading ekranını kapat
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: GnsAppBar("Satış Siparişi Oluştur", context),
          body: isFetched
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                CountFicheScanArea(
                                  onBarcodeChanged: (val) async {
                                    if (_isThereEmptyValueForAddNewItem()) {
                                      GNSShowDialog(
                                          context,
                                          "HATA !",
                                          "Ürün eklemek için Proje ve Ambar ayarları dolu olmalı.",
                                          "Kapat",
                                          "Tamam",
                                          () => Navigator.of(context).pop());
                                    } else {
                                      bool isMatchAnyBarcode = false;
                                      salesProductList.forEach((element) {
                                        if (element.response.products?.items?[0]
                                                .barcode
                                                .toString() ==
                                            val) {
                                          isMatchAnyBarcode = true;
                                          element.bodyItem.qty =
                                              (element.bodyItem.qty ?? 0) +
                                                  scannedTimes;
                                          setState(() {});
                                        }
                                      });

                                      if (isMatchAnyBarcode == false) {
                                        await _getProductBasedOnBarcode(
                                            val.toString());
                                      }
                                    }
                                  },
                                  seriOrBarcode: (val) {},
                                  scannedTimes: (val) {
                                    scannedTimes = val!;
                                  },
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ListView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: salesProductList.length,
                                          itemBuilder: (context, index) {
                                            return _card2(
                                                salesProductList[index],
                                                index,
                                                salesProductList[index]
                                                    .infoForUI
                                                    .warehouseName);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: spaceBetweenInputs,
                                  ),
                                  GNSTextField(
                                    label: "Fiş No",
                                    onValueChanged: (value) {
                                      ficheNo = value.toString();
                                    },
                                  ),
                                  SizedBox(
                                    height: spaceBetweenInputs,
                                  ),
                                  GNSSelectCustomerAndAddress(
                                    response: customerResponse!,
                                    isErrorActiveForCustomer: isCustomerIdEmpty,
                                    isErrorActiveForCustomerAddress:
                                        isCustomerAddressIdEmpty,
                                    onValueChanged: (value) {
                                      customerInfo = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: spaceBetweenInputs,
                                  ),
                                  GNSSelectSalesmen(
                                    onValueChanged: (value) {
                                      salesmenId = value.toString();
                                    },
                                    isErrorActive: isSalesmanIdEmpty,
                                  ),
                                  // ElevatedButton(
                                  //     onPressed: () {
                                  //       _updateUIForEmptyAreas();
                                  //       setState(() {});
                                  //     },
                                  //     child: Text("asdad")),
                                  SizedBox(
                                    height: spaceBetweenInputs,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GNSSelectTransporter(
                                          onValueChanged: (value) {
                                            transporterId = value.toString();
                                          },
                                          isErrorActive: isTransporterIdEmpty,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: GNSSelectShippingType(
                                          isErrorActive: isShippingTypeIdEmpty,
                                          onValueChanged: (value) {
                                            shippingTypeId = value.toString();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: spaceBetweenInputs,
                                  ),
                                  GNSSelectProject(
                                    onValueChanged: (value) {
                                      projectId = value.projectId.toString();
                                      projectName =
                                          value.projectName.toString();

                                      salesProductList.forEach((element) {
                                        element.bodyItem.projectId = projectId;
                                      });
                                      setState(() {});
                                    },
                                    isErrorActive: isProjectIdEmpty,
                                    projectName: "",
                                  ),
                                  SizedBox(
                                    height: spaceBetweenInputs,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        //giris
                                        Expanded(
                                          child: GNSSelectWarehouseList(
                                            title: "Giriş",
                                            response: workplaceResponse!,
                                            isErrorActiveForWorkplace:
                                                isWorkplaceIdEmpty,
                                            isErrorActiveForDepartment:
                                                isDepartmentIdEmpty,
                                            isErrorActiveForWarehouse:
                                                isWarehouseIdEmpty,
                                            onValueChanged: (value) {
                                              warehouseInfo = value;
                                              salesProductList
                                                  .forEach((element) {
                                                element.bodyItem.warehouseId =
                                                    warehouseInfo.warehouseId;
                                                element.infoForUI
                                                        .warehouseName =
                                                    warehouseInfo.warehouseName;
                                              });
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: spaceBetweenInputs,
                                  ),
                                  GNSTextFormField(
                                    label: "Not",
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    maxLength: 200,
                                    onValueChanged: (value) {
                                      description = value!;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        _createSalesOrderButton(),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  Padding _createSalesOrderButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Card(
            color: Colors.orangeAccent,
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: const Color.fromARGB(255, 255, 223, 187),
              onTap: () async {
                _updateUIForEmptyAreas();
                if (_isThereEmptyValueForCreateOrder()) {
                  GNSShowDialog(
                      context,
                      "HATA !",
                      "Sipariş oluşturmak için alanlar dolu olmalıdır.",
                      "Kapat",
                      "Tamam",
                      () => Navigator.of(context).pop());
                } else {
                  try {
                    _showLoadingScreen(true, "İşlem Yapılıyor");
                    var createResponse = await apiRepository
                        .createSalesOrder(await _createSalesOrderBody());
                    _showLoadingScreen(false, "İşlem Yapılıyor");
                    if (isWaybillAutoCreated) {
                      _showLoadingScreen(true, "İşlem Yapılıyor");
                      response = await apiRepository
                          .getOrderDetail(createResponse!.orderId!);
                      var isWaybillCreated = await apiRepository
                          .createWaybill(await _createWaybillBodyNew());
                      _showLoadingScreen(false, "İşlem Yapılıyor");
                    }
                    if (createResponse != null) {
                      // ignore: use_build_context_synchronously
                      GNSShowDialog(
                          context,
                          "İşlem Başarılı",
                          "Sipariş başarılı bir şekilde oluşturuldu",
                          "Kapat",
                          "Tamam",
                          () => Navigator.of(context).pop());
                    }
                  } catch (e) {
                    _showLoadingScreen(false, "İşlem Yapılıyor");
                  }
                }

                setState(() {});
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Siparişi Oluştur",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Slidable _card2(ProductDetailAndScannedNumberForSalesOrderCreate item,
      int index, String warehouseName) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            salesProductList.removeAt(index);
            setState(() {});
          },
          backgroundColor: Colors.red,
          icon: Icons.delete,
          borderRadius: BorderRadius.circular(10),
        )
      ]),
      child: Card(
        elevation: 0,
        color: const Color(0xfff1f1f1),
        child: InkWell(
          onLongPress: () {
            _showDialogForUpdateProduct(context, "Ürünü Güncelle", item, index);
          },
          highlightColor: const Color.fromARGB(255, 179, 199, 211),
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: ListTile(
            contentPadding: const EdgeInsets.only(right: 15, left: 15),
            leading: Text(
              (index + 1 < 10) ? "0${index + 1}" : "${index + 1}",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[700]),
            ),
            trailing: Text(
              item.bodyItem.qty.toString(),
              style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            title: Text(
              item.bodyItem.description.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xff727272),
              ),
            ),
            subtitle:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                //${item.inWarehouseName.toString()}
                "Giriş Ambarı: $warehouseName",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[700]),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showDialogForUpdateProduct(
      BuildContext context,
      String content,
      ProductDetailAndScannedNumberForSalesOrderCreate oldItem,
      int index) {
    return showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: true,
        child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
            ),
            title: const Text("Ürün Güncelle"),
            contentPadding: const EdgeInsets.all(10.0),
            content: SingleChildScrollView(
              child: CreateSalesOrderProductUpdate(
                workplaceWarehouseList: getAllWarehouses(workplaceResponse!),
                oldItem: oldItem,
                onValueChanged: (value) {
                  salesProductList[index] = value;
                  setState(() {});
                },
              ),
            )),
      ),
    );
  }

  String _convertDateTimeHoursToTimestamp(DateTime dateTime) {
    // var millis = dateTime.millisecondsSinceEpoch;
    // var dt = DateTime.fromMillisecondsSinceEpoch(millis);

// 24 Hour format:
    // var d24 = DateFormat('HH:mm').format(dt); // 31/12/2000, 22:00
    // print(d24);

    // Mevcut tarih ve saati al

    // Sadece saat, dakika ve saniye kısmını al
    int hoursInSeconds = dateTime.hour * 3600;
    int minutesInSeconds = dateTime.minute * 60;
    int seconds = dateTime.second;

    // Toplam saniyeye dönüştür
    int timestamp = hoursInSeconds + minutesInSeconds + seconds;

    return timestamp.toString();
  }

  // _convertTimestampToDateTimeHours(int timestamp) {
  //   // Saat, dakika ve saniyeyi geri hesapla
  //   int hours = timestamp ~/ 3600; // Saat
  //   int remainingSeconds = timestamp % 3600;
  //   int minutes = remainingSeconds ~/ 60; // Dakika
  //   int seconds = remainingSeconds % 60; // Saniye
  //   DateTime currentDate = DateTime.now();
  //   DateTime result = DateTime(
  //     currentDate.year,
  //     currentDate.month,
  //     currentDate.day,
  //     hours,
  //     minutes,
  //     seconds,
  //   );
  //   print("Geri dönüştürülen DateTime: $result");
  // }

  List<WorkplaceWarehouse> getAllWarehouses(WorkplaceListResponse response) {
    List<WorkplaceWarehouse> warehouses = [];

    for (int i = 0; i < response.workplaces!.items!.length; i++) {}
    for (var workplace in response.workplaces!.items!) {
      for (var department in workplace.departments!) {
        for (var warehouse in department.warehouse!) {
          warehouses.add(warehouse);
        }
      }
    }

    return warehouses;
  }

  Future<String> _getDocNumberFicheNumber() async {
    //3 satış siparişi
    //4 satın alma siparişi
    getFicheNumberResponse = await apiRepository.getDocNumberFicheNumber(
        apiRepository.employeeUid, "3");

    return getFicheNumberResponse?.docnumber?.lastNum ?? "";
  }

  Future<CreateSalesOrderRequest> _createSalesOrderBody() async {
    return CreateSalesOrderRequest(
      customerId: customerInfo.customerId,
      ficheNo: ficheNo.isEmpty ? await _getDocNumberFicheNumber() : ficheNo,
      ficheDate: DateFormat('yyyy-MM-ddTHH:mm:ss').format(currentDate),
      // ficheTime: DateFormat('HH:mm').format(currentDate),
      ficheTime: _convertDateTimeHoursToTimestamp(currentDate),
      docNo: "",
      workPlaceId: warehouseInfo.workplaceId,
      departmentId: warehouseInfo.departmentId,
      warehouseId: warehouseInfo.warehouseId,
      currencyId: 1,
      totaldiscounted: 1,
      totalvat: 1,
      grossTotal: 100,
      transporterId: transporterId,
      shippingAccountId: customerInfo.customerId,
      shippingAddressId: customerInfo.customerAddressId,
      description: "",
      shippingTypeId: shippingTypeId,
      isAssing: false,
      assingmentEmail: "",
      assingCode: "",
      assingmetFullname: "",
      salesmanId: salesmenId,
      orderStatusId: 1,
      isPartialOrder: true,
      payPlan: "",
      specode: "",
      erpId: "",
      erpCode: "",
      projectId: projectId,
      orderItems: _createSalesOrderItemList(),
    );
  }

  bool _isThereEmptyValueForCreateOrder() {
    if (salesmenId.isEmpty ||
        shippingTypeId.isEmpty ||
        customerInfo.customerId.isEmpty ||
        customerInfo.customerAddressId.isEmpty ||
        transporterId.isEmpty ||
        projectId.isEmpty ||
        warehouseInfo.workplaceId.isEmpty ||
        warehouseInfo.departmentId.isEmpty ||
        warehouseInfo.warehouseId.isEmpty) {
      return true;
    }

    return false;
  }

  bool _isThereEmptyValueForAddNewItem() {
    if (projectId.isEmpty ||
        warehouseInfo.workplaceId.isEmpty ||
        warehouseInfo.departmentId.isEmpty ||
        warehouseInfo.warehouseId.isEmpty) {
      return true;
    }

    return false;
  }

  List<SalesOrderItems> _createSalesOrderItemList() {
    List<SalesOrderItems> salesOrderItemsList = [];

    // Geleneksel for döngüsü ile response.order!.orderItems üzerinden geçiyoruz
    for (int j = 0; j < salesProductList.length; j++) {
      var element = salesProductList[j];

      salesOrderItemsList.add(
        SalesOrderItems(
          productId: element.bodyItem.productId,
          description: element.bodyItem.description,
          warehouseId: element.bodyItem.warehouseId,
          productPrice: 0,
          qty: element.bodyItem.qty,
          shippedQty: element.bodyItem.qty,
          total: 0,
          discount: 0,
          tax: 0,
          nettotal: 0,
          unitId: element.bodyItem.unitId,
          unitConversionId: element.bodyItem.unitConversionId,
          erpId: element.bodyItem.erpId,
          erpCode: element.bodyItem.erpCode,
          currencyId: element.bodyItem.currencyId,
          orderitemtype: element.bodyItem.orderitemtype,
          projectId: projectId,
        ),
      );
    }

    return salesOrderItemsList;
  }

  Future<WayybillsRequestBodyNew> _createWaybillBodyNew() async {
    return WayybillsRequestBodyNew(
      customerId: response.order?.customer?.customerId ?? guidEmpty,
      ficheNo: ficheNo.isEmpty ? await _getDocNumberFicheNumber() : ficheNo,
      ficheDate: DateFormat('yyyy-MM-ddTHH:mm:ss').format(currentDate),
      shipDate: DateFormat('yyyy-MM-ddTHH:mm:ss').format(currentDate),
      ficheTime: DateFormat('HH:mm').format(currentDate),
      docNo: response.order?.docNo,
      erpInvoiceRef: "",
      workPlaceId: response.order?.workplace?.workplaceId ?? guidEmpty,
      department: response.order?.department?.departmentId ?? guidEmpty,
      warehouse: response.order?.warehouse?.warehouseId ?? guidEmpty,
      currencyId: response.order?.currencyId,
      totaldiscounted: response.order?.totaldiscounted,
      totalvat: response.order?.totalvat,
      grossTotal: response.order?.grossTotal,
      transporterId: transporterId,
      shippingAccountId:
          response.order?.shippingAccount?.customerId ?? guidEmpty,
      shippingAddressId:
          response.order?.shippingAddress?.shippingAddressId ?? guidEmpty,
      description: "",
      shippingTypeId:
          response.order?.orderShippingType?.shippingTypeId ?? guidEmpty,
      salesmanId:
          response.order?.shippingAccount?.salesman?.salesmanId ?? guidEmpty,
      waybillStatusId: 1,
      erpId: "",
      erpCode: "",
      waybillTypeId: waybillTypeId,
      waybillItems: await _createWaybillItemListNew(),
      globalWaybillItemDetails: _createGlobalWaybillItemDetails(),
    );
  }

  Future<List<WaybillItemsNew>> _createWaybillItemListNew() async {
    List<WaybillItemsNew> waybillItemsList = [];

    // Geleneksel for döngüsü ile response.order!.orderItems üzerinden geçiyoruz
    for (int j = 0; j < response.order!.orderItems!.length; j++) {
      var element = response.order!.orderItems![j];

      waybillItemsList.add(
        WaybillItemsNew(
          productId: element.product?.productId,
          description: element.description,
          warehouseId: element.warehouseId,
          productPrice: element.productPrice,
          qty: element.qty!.toInt(),
          total: element.total,
          discount: element.discount,
          tax: element.tax,
          nettotal: element.nettotal,
          unitId: element.unitId,
          unitConversionId: element.unitConversionId,
          // stockLocationRelations: isProductLocation
          //     ? _createStockLocationRelationList(scannedList!)
          //     : [],
          stockLocationRelations: [],
          currencyId: element.currencyId,
          erpId: element.erpId,
          erpCode: element.erpCode,
          orderReferance: element.orderItemId,
          erpOrderReferance: 2,
          waybillItemTypeId: 0,
          waybillItemDetails: _createWaybillItemDetails(element.orderItemId!),
        ),
      );
    }

    return waybillItemsList;
  }

  /*

  List<StockLocationRelations> _createStockLocationRelationList(
      List<OrderDetailScannedItemDB> scannedList) {
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

  */

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
}

class ProductDetailAndScannedNumberForSalesOrderCreate {
  ProductListReponse response;
  SalesOrderItems bodyItem;
  int scannedNumber;
  ProductDetailInfoForUI infoForUI;

  ProductDetailAndScannedNumberForSalesOrderCreate({
    required this.response,
    required this.bodyItem,
    required this.scannedNumber,
    required this.infoForUI,
  });
}

class ProductDetailInfoForUI {
  String warehouseName;
  String unitConversionName;

  ProductDetailInfoForUI({
    required this.warehouseName,
    required this.unitConversionName,
  });
}
