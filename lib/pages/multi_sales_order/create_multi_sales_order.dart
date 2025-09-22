import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/user_special_settings.dart';
import 'package:gns_warehouse/database/dbhelper_for_waybills.dart';
import 'package:gns_warehouse/database/model/waybills_local.dart';
import 'package:gns_warehouse/models/new_api/new_customer_list_response.dart';
import 'package:gns_warehouse/models/new_api/order_header_response_new.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_detail.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_summary_list_response.dart';
import 'package:gns_warehouse/models/new_api/shipping_type_list_response.dart';
import 'package:gns_warehouse/models/new_api/transporter_list_response.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/multi_sales_order/check_list_multi_sales_order.dart';
import 'package:gns_warehouse/pages/multi_sales_order/components/multi_sales_order_control_card.dart';
import 'package:gns_warehouse/pages/purchase_orders/order_control_card.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order_list.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/bottom_sheets/gns_whs_trs_customer_bottom.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/bottom_sheets/gns_whs_trs_transporter_bottom.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:gns_warehouse/widgets/gns_text_field_search.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CreateMultiSalesOrder extends StatefulWidget {
  const CreateMultiSalesOrder({super.key});

  @override
  State<CreateMultiSalesOrder> createState() => _CreateMultiSalesOrderState();
}

class _CreateMultiSalesOrderState extends State<CreateMultiSalesOrder> {
  late ApiRepository apiRepository;
  //final DbHelperForWaybills _dbHelperForWaybills = DbHelperForWaybills.instance;
  bool deneme = false;
  bool isItValidForNextPage = false;
  bool isCreateApiRepo = false;
  bool isSelectedItemEmpty = true;
  late bool isGetOrderBasedOnCustomer;
  DateTime? ficheDate = DateTime.now();
  DateTime? shipDate = DateTime.now();
  String customerName = "";
  String workplaceName = "";
  String departmentName = "";
  String warehouseName = "";
  String transporterName = "";
  String shippingType = "";
  String errorMessage = "Müşteri Seçmediniz";
  NewCustomerListResponse? response;
  TransporterListResponse? transporterResponse;
  WorkplaceListResponse? workplaceResponse;
  ShippingTypeListResponse? shippingTypeListResponse;

  List<OrderSummaryItem>? salesOrderResponse;
  PurchaseOrderDetailResponse? detailResponse;
  List<IsSelectedclassSalesOrderSummaryItem>
      selectedSalesOrdersBasedOnCustomer = [];
  List<IsSelectedclassSalesOrderSummaryItem> selectedOrders = [];
  List<Departments> departments = [];
  List<WorkplaceWarehouse> allWarehouse = [];
  List<String> userSpecialWarehouseList = [];
  String userDefaultWarehouseOut = "";
  bool isThereWarehouseBoundForUser = false;

  String customerId = "";
  String workplaceId = "";
  String departmentId = "";
  String warehouseId = "";
  String transporterId = "";
  String shippingTypeId = "";

  bool isReverseFetched = false;
  String searchBasedOnFicheNo = "";
  List<IsSelectedclassSalesOrderSummaryItem> denemeselected = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isGetOrderBasedOnCustomer = false;

    createApiRepository();
  }

  Future<void> createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    await _getUserSpecialWarehouseSettings();
    if (userDefaultWarehouseOut.isNotEmpty) {
      await _reverseWarehouse(userDefaultWarehouseOut.toLowerCase());
    }
    await getListFromService();
    setState(() {
      isCreateApiRepo = true;
    });
  }

  Future<void> _reverseWarehouse(String defaultWarehouseId) async {
    var response = await apiRepository.getWarehouseReverse(defaultWarehouseId);

    warehouseId = response.warehouse!.warehouseId.toString();
    warehouseName = response.warehouse!.code.toString();

    workplaceId = response.warehouse!.departments!.workplace!.workplaceId!;
    workplaceName = response.warehouse!.departments!.workplace!.code!;

    departmentId = response.warehouse!.departments!.departmentId!;
    departmentName = response.warehouse!.departments!.code!;

    isReverseFetched = true;
  }

  Future<void> _getUserSpecialWarehouseSettings() async {
    String userSpecialSetting = await ServiceSharedPreferences.getSharedString(
            UserSpecialSettingsUtils.userWarehouseAuthOut) ??
        "";
    var sharedDefaultWarehouse = await ServiceSharedPreferences.getSharedString(
            UserSpecialSettingsUtils.userDefaultWarehouseOut) ??
        "";
    if (sharedDefaultWarehouse.isNotEmpty) {
      userDefaultWarehouseOut = jsonDecode(sharedDefaultWarehouse);
    }
    if (userSpecialSetting.isNotEmpty) {
      List<dynamic> decodedValue = jsonDecode(userSpecialSetting);
      setState(() {
        userSpecialWarehouseList = List<String>.from(decodedValue);
        isThereWarehouseBoundForUser = true;
      });
    } else {}
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

  Future<void> getListFromService() async {
    //response = await apiRepository.getCustomer();
    //transporterResponse = await apiRepository.getTransporterList();
    workplaceResponse = await apiRepository.getWorkplaceList();
    allWarehouse = _getAllWarehouseList();
    shippingTypeListResponse = await apiRepository.getShippingTypeList();
    // purchaseResponse = await apiRepository.getPurchaseOrderSummaryList();
    // detailResponse = await apiRepository
    //    .getPurchaseOrderDetail("4b1495cc-5daa-45f5-b6cd-7b976b41dbf2");
  }

  void _getOrderBasedOnCustomer() async {
    setState(() {
      isGetOrderBasedOnCustomer = false;
    });
    _showLoadingScreen(true, "Siparişler Yükleniyor ");
    salesOrderResponse =
        await apiRepository.getSalesOrderSummaryListBasedOnCustomer(
            customerName, searchBasedOnFicheNo);
    selectedSalesOrdersBasedOnCustomer = [];
    salesOrderResponse!.forEach(
      (element) {
        selectedSalesOrdersBasedOnCustomer
            .add(IsSelectedclassSalesOrderSummaryItem(element, false));
      },
    );
    _showLoadingScreen(false, "Siparişler Yükleniyor ");
    setState(() {
      isGetOrderBasedOnCustomer = true;
    });
    // if (customerName.isNotEmpty) {
    //   _showLoadingScreen(true, "Siparişler Yükleniyor ");
    //   salesOrderResponse =
    //       await apiRepository.getSalesOrderSummaryListBasedOnCustomer(
    //           customerName, searchBasedOnFicheNo);
    //   selectedSalesOrdersBasedOnCustomer = [];
    //   salesOrderResponse!.forEach(
    //     (element) {
    //       selectedSalesOrdersBasedOnCustomer
    //           .add(IsSelectedclassSalesOrderSummaryItem(element, false));
    //     },
    //   );
    //   _showLoadingScreen(false, "Siparişler Yükleniyor ");
    //   setState(() {
    //     isGetOrderBasedOnCustomer = true;
    //   });
    // } else {
    //   _showErrorMessage("Müşteri Seçmediniz !");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      body: isCreateApiRepo
          ? PopScope(
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
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              _headerTextStage(),
                              const SizedBox(
                                height: 20,
                              ),
                              GNSTextFieldSearch(
                                  onSearchTextChange: (searchValue) {
                                searchBasedOnFicheNo = searchValue;
                                _getOrderBasedOnCustomer();
                                setState(() {});
                              }),

                              _listTile(
                                "Müşteri Seç",
                                customerName,
                                Icons.store_outlined,
                                () {
                                  // showModalBottomSheet(
                                  //   context: context,
                                  //   builder: (context) =>
                                  //       _productLogBottomSheet(response!),
                                  // );
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) =>
                                        GNSWhsTrsCustomerBottomSheet(
                                      onValueChanged: (value) async {
                                        if (customerName !=
                                            value.customerName) {
                                          denemeselected = [];
                                        }
                                        customerName =
                                            "${value.customerCode} ${value.customerName}";
                                        customerId = value.customerId;
                                        _getOrderBasedOnCustomer();
                                        setState(() {});
                                      },
                                    ),
                                  );
                                },
                              ),
                              /*
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: _button(
                                    "Satın Alma Siparişlerini Bul",
                                    Colors.white,
                                    const Color(0xff8a9c9c),
                                    _getOrderBasedOnCustomer),
                              ),
                              */

                              isGetOrderBasedOnCustomer
                                  ? Container(
                                      height: 200,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            ListView.builder(
                                              primary: false,
                                              shrinkWrap: true,
                                              itemCount:
                                                  salesOrderResponse!.length,
                                              itemBuilder: (context, index) {
                                                //daha önceden eklenmiş mi onu kontrol ediyor
                                                bool isSelected = denemeselected
                                                    .where((element) =>
                                                        element.item.orderId ==
                                                        selectedSalesOrdersBasedOnCustomer[
                                                                index]
                                                            .item
                                                            .orderId)
                                                    .isNotEmpty;

                                                if (isSelected) {
                                                  selectedSalesOrdersBasedOnCustomer[
                                                          index]
                                                      .isSelected = true;
                                                }
                                                return MultiSalesOrderControlCard(
                                                  item:
                                                      selectedSalesOrdersBasedOnCustomer[
                                                          index],
                                                  isSelected: (value) async {
                                                    selectedSalesOrdersBasedOnCustomer[
                                                            index]
                                                        .isSelected = value!;

                                                    if (value) {
                                                      if (customerName ==
                                                              selectedSalesOrdersBasedOnCustomer[
                                                                      index]
                                                                  .item
                                                                  .customer
                                                                  .toString() ||
                                                          customerName == "") {
                                                        denemeselected.add(
                                                            selectedSalesOrdersBasedOnCustomer[
                                                                index]);
                                                      } else {
                                                        _showErrorMessage(
                                                            "Cariler aynı olmadığı için eklenemiyor.");
                                                      }

                                                      if (denemeselected
                                                              .length ==
                                                          1) {
                                                        customerName =
                                                            denemeselected[0]
                                                                .item
                                                                .customer
                                                                .toString();
                                                        _showLoadingScreen(true,
                                                            "Siparişler Yükleniyor ");
                                                        var response =
                                                            await apiRepository
                                                                .getOrderDetail(
                                                                    denemeselected[
                                                                            0]
                                                                        .item
                                                                        .orderId!);
                                                        _showLoadingScreen(
                                                            false,
                                                            "Siparişler Yükleniyor ");
                                                        customerId = response
                                                                .order
                                                                ?.customer
                                                                ?.customerId ??
                                                            "";
                                                      }
                                                    } else {
                                                      denemeselected.removeWhere(
                                                          (element) =>
                                                              element.item
                                                                  .orderId ==
                                                              selectedSalesOrdersBasedOnCustomer[
                                                                      index]
                                                                  .item
                                                                  .orderId);

                                                      if (denemeselected
                                                          .isEmpty) {
                                                        customerName = "";
                                                        customerId = "";
                                                      }
                                                    }
                                                    setState(() {});
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              _divider(),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: denemeselected.length,
                                itemBuilder: (context, index) {
                                  return Text(
                                      denemeselected[index].item.ficheNo!);
                                },
                              ),
                              _listTileYeni(
                                  "Ship Date",
                                  DateFormat('dd.MM.yyyy').format(shipDate!),
                                  Icons.date_range_rounded, () {
                                _showDate(context);
                              }),
                              _divider(),
                              // _listTileYeni("Workplace", workplaceName,
                              //     Icons.date_range_rounded, () {
                              //   showModalBottomSheet(
                              //     context: context,
                              //     builder: (context) =>
                              //         _workplaceBottomSheet(workplaceResponse!),
                              //   );
                              // }),
                              isReverseFetched
                                  ? _listTileYeni("Workplace", workplaceName,
                                      Icons.date_range_rounded, null)
                                  : const SizedBox(),
                              isReverseFetched ? _divider() : const SizedBox(),
                              isReverseFetched
                                  ? _listTileYeni("Department", departmentName,
                                      Icons.date_range_rounded, null)
                                  : const SizedBox(),
                              isReverseFetched ? _divider() : const SizedBox(),
                              _listTileYeni("Warehouse", warehouseName,
                                  Icons.date_range_rounded, () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => _warehouseBottomSheet2(
                                      isThereWarehouseBoundForUser
                                          ? _limitWarehouseBasedOnSetting(
                                              allWarehouse,
                                              userSpecialWarehouseList)
                                          : allWarehouse),
                                );
                              }),

                              _divider(),
                              _listTileYeni("Transporter", transporterName,
                                  Icons.date_range_rounded, () {
                                // showModalBottomSheet(
                                //   context: context,
                                //   builder: (context) =>
                                //       _transportersBottomSheet(
                                //           transporterResponse!),
                                // );
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) =>
                                      GNSWhsTrsTransporterBottom(
                                    onValueChanged: (value) async {
                                      transporterName = value.transporterName;
                                      transporterId = value.transporterId;
                                      setState(() {});
                                    },
                                  ),
                                );
                              }),
                              _divider(),
                              _listTileYeni("Shipping Type", shippingType,
                                  Icons.date_range_rounded, () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      _shippingTypeBottomSheet(
                                          shippingTypeListResponse!),
                                );
                              }),
                              _divider(),

                              /*
                              isGetOrderBasedOnCustomer
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: _button("Toplama Listesini Kaydet",
                                          Colors.white, const Color(0xffff9700), () {}),
                                    )
                                  : const SizedBox(),
                                  */

                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                      isGetOrderBasedOnCustomer
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: _button("Toplama Listesini Görüntüle",
                                  Colors.white, const Color(0xffff9700), () {
                                if (!_isThereEmptyValue()) {
                                  selectedSalesOrdersBasedOnCustomer
                                      .forEach((element) {
                                    if (element.isSelected) {
                                      selectedOrders.add(element);
                                    }
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CheckListMultiSalesOrder(
                                              selectedItems: denemeselected,
                                              customerName: customerName,
                                              departments: departments,
                                              customerId: customerId,
                                              workplaceId: workplaceId,
                                              departmentId: departmentId,
                                              warehouseId: warehouseId,
                                              warehouseName: warehouseName,
                                              transporterId: transporterId,
                                              shippingTypeId: shippingTypeId,
                                              ficheDate: ficheDate!,
                                              shipDate: shipDate!,
                                            )),
                                  ).then((value) async {
                                    selectedOrders = [];
                                  });
                                } else {
                                  _showErrorMessage(
                                      "Lütfen Bütün Satırları Doldurun");
                                }
                              }),
                            )
                          : const SizedBox(),
                      /*
                      isItValidForNextPage
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: _button(
                                "Toplama Listesine Git",
                                Colors.white,
                                const Color(0xffff9700),
                                () {
                                  if (!_isThereEmptyValue()) {
                                    selectedPurchaseOrders.forEach((element) {
                                      if (element.isSelected) {
                                        selectedOrders.add(element);
                                      }
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PurchaseOrderList(
                                                selectedItems: selectedOrders,
                                                customerName: customerName,
                                                departments: departments,
                                                customerId: customerId,
                                                workplaceId: workplaceId,
                                                departmentId: departmentId,
                                                warehouseId: warehouseId,
                                                warehouseName: warehouseName,
                                                transporterId: transporterId,
                                                shippingTypeId: shippingTypeId,
                                                ficheDate: ficheDate!,
                                                shipDate: shipDate!,
                                              )),
                                    ).then((value) async {
                                      selectedOrders = [];
                                    });
                                  } else {
                                    _showErrorMessage(
                                        "Lütfen Bütün Satırları Doldurun");
                                  }
                                },
                              ),
                            )
                          : const SizedBox(),
                          */
                    ],
                  ),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<DateTime?> _showDate(BuildContext context) async {
    shipDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101),
        ) ??
        DateTime.now();

    setState(() {});
  }

  ListTile _listTile(
      String title, String subtitle, IconData iconData, Function()? onPressed) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0, left: 0),
      trailing: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            iconData,
            size: 30,
            color: Colors.deepOrange,
          ),
        ),
      ),
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

  ListTile _listTileYeni(
      String title, String subtitle, IconData iconData, Function()? onPressed) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0, left: 0),
      trailing: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            iconData,
            size: 30,
            color: Colors.deepOrange,
          ),
        ),
      ),
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
          _headerText("Kontrol", Colors.deepOrange),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 25,
            color: Color(0xffd5d5d5),
          ),
          _headerText("Liste", const Color(0xff919b9a)),
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

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        "SATIŞ SİPARİŞİ",
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

  Divider _divider() {
    return const Divider(
      color: Color.fromARGB(255, 228, 228, 228),
      thickness: 1,
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

  Widget _productLogBottomSheet(NewCustomerListResponse response) {
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
                    "Müşteriler",
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
                        itemCount: response.customers!.items!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0,
                            child: InkWell(
                              splashColor: Colors.deepOrangeAccent,
                              onTap: () {
                                customerName = response
                                    .customers!.items![index].name
                                    .toString();
                                customerId = response
                                    .customers!.items![index].customerId
                                    .toString();
                                print("customerid: $customerId");
                                _getOrderBasedOnCustomer();
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: ListTile(
                                title: Text(
                                  response.customers!.items![index].name
                                      .toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
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

  Widget _workplaceBottomSheet(WorkplaceListResponse response) {
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
                    "Workplace",
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
                        itemCount: response.workplaces!.items!.length,
                        itemBuilder: (context, index) {
                          return _selectingAreaRowItem(
                              response.workplaces!.items![index].code!, () {
                            workplaceId =
                                response.workplaces!.items![index].workplaceId!;
                            workplaceName =
                                response.workplaces!.items![index].code!;
                            departments =
                                response.workplaces!.items![index].departments!;

                            departmentName = "";
                            departmentId = "";
                            warehouseName = "";
                            warehouseId = "";

                            Navigator.pop(context);
                            setState(() {});
                            showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  _departmentsBottomSheet(departments),
                            );
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

  Widget _departmentsBottomSheet(List<Departments> departments) {
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
                    "Department",
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
                        itemCount: departments.length,
                        itemBuilder: (context, index) {
                          return _selectingAreaRowItem(departments[index].code!,
                              () {
                            departmentName = departments[index].code!;
                            departmentId = departments[index].departmentId!;
                            Navigator.pop(context);
                            setState(() {});
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => _warehouseBottomSheet(
                                  departments[index].warehouse!),
                            );
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

  Widget _warehouseBottomSheet(List<WorkplaceWarehouse> warehouse) {
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
                              () {
                            warehouseName = warehouse[index].code!;
                            warehouseId = warehouse[index].warehouseId!;
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

  List<WorkplaceWarehouse> _getAllWarehouseList() {
    List<WorkplaceWarehouse> list = [];
    workplaceResponse!.workplaces!.items!.forEach((workplace) {
      workplace.departments!.forEach((department) {
        department.warehouse!.forEach((warehouse) {
          list.add(warehouse);
        });
      });
    });

    return list;
  }

  Widget _warehouseBottomSheet2(List<WorkplaceWarehouse> warehouse) {
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

                            var response = await apiRepository
                                .getWarehouseReverse(warehouseId);
                            workplaceName = response
                                .warehouse!.departments!.workplace!.code
                                .toString();
                            workplaceId = workplaceName = response
                                .warehouse!.departments!.workplace!.workplaceId
                                .toString();
                            departmentName = workplaceName = response
                                .warehouse!.departments!.code
                                .toString();
                            departmentId = response
                                .warehouse!.departments!.departmentId
                                .toString();
                            isReverseFetched = true;
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

  Widget _shippingTypeBottomSheet(ShippingTypeListResponse response) {
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
                    "Shipping Type",
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
                        itemCount: response.shippingType!.items!.length,
                        itemBuilder: (context, index) {
                          return _selectingAreaRowItem(
                              response.shippingType!.items![index].code!, () {
                            shippingTypeId = response
                                .shippingType!.items![index].shippingTypeId!;
                            shippingType =
                                response.shippingType!.items![index].code!;
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

  Widget _transportersBottomSheet(TransporterListResponse response) {
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
                    "Transporter",
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
                        itemCount: response.transporters!.items!.length,
                        itemBuilder: (context, index) {
                          return _selectingAreaRowItem(
                              response.transporters!.items![index].code!, () {
                            transporterId = response
                                .transporters!.items![index].transporterId!;
                            transporterName =
                                response.transporters!.items![index].code!;
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

  bool _isThereEmptyValue() {
    if (customerId.isEmpty ||
        workplaceId.isEmpty ||
        departmentId.isEmpty ||
        warehouseId.isEmpty ||
        transporterId.isEmpty ||
        shippingTypeId.isEmpty) {
      return true;
    }

    return false;
  }

  Row _row(String title, String initTitle, Function()? onTap) {
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
}
