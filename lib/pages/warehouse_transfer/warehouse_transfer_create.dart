import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gns_warehouse/constants/customer_address_type.dart';
import 'package:gns_warehouse/constants/system_settings.dart';
import 'package:gns_warehouse/models/new_api/customer_addresses_response.dart';
import 'package:gns_warehouse/models/new_api/doc_number_get_fiche_number.dart';
import 'package:gns_warehouse/models/new_api/new_customer_list_response.dart';
import 'package:gns_warehouse/models/new_api/product_list_reponse.dart';
import 'package:gns_warehouse/models/new_api/transporter_list_response.dart';
import 'package:gns_warehouse/models/new_api/warehouse_transfer_create_body.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/stock_counting_fiche/components/count_fiche_scan_area.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_customer.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_project.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_transporter.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_warehouse.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/select_product_page.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/update_selected_product_page.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:gns_warehouse/widgets/gns_error_field.dart';
import 'package:gns_warehouse/widgets/gns_field_with_bottom_page.dart';
import 'package:gns_warehouse/widgets/gns_text_field.dart';
import 'package:gns_warehouse/widgets/gns_text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class WarehouseTransferCreatePage extends StatefulWidget {
  const WarehouseTransferCreatePage({super.key});

  @override
  State<WarehouseTransferCreatePage> createState() => _WarehouseTransferCreatePageState();
}

class _WarehouseTransferCreatePageState extends State<WarehouseTransferCreatePage> {
  String ficheNo = "";
  late ApiRepository apiRepository;
  late NewCustomerListResponse? customerResponse;
  late TransporterListResponse? transporterResponse;
  late WorkplaceListResponse? workplaceResponse;
  late ProductListReponse? productListReponse;
  bool isFetched = false;
  DateTime ficheDate = DateTime.now();
  String customerId = "";
  String description = "";
  String transporterId = "";
  String customerAddressId = "";
  String projectId = "";
  String projectName = "";
  double spaceBetweenInputs = 7;
  DocNumberGetFicheNumberResponse? getFicheNumberResponse;

  List<WarehouseTransferLocalItems> transferListItems = [];

  List<WarehouseTransferProductDetailAndScannedNumber> transferProductList = [];
  int scannedTimes = 1;
  String guidEmpty = "00000000-0000-0000-0000-000000000000";

  bool isFicheCreated = false;

  CustomerAndAddress customerInfo = CustomerAndAddress(
    customerId: "",
    customerAddressId: "",
  );
  WorkplaceDepartmentWarehouse inTransferInfo = WorkplaceDepartmentWarehouse(
    workplaceName: "",
    departmentName: "",
    warehouseName: "Giriş Ambarı",
    workplaceId: "",
    departmentId: "",
    warehouseId: "",
  );
  WorkplaceDepartmentWarehouse outTransferInfo = WorkplaceDepartmentWarehouse(
    workplaceName: "",
    departmentName: "",
    warehouseName: "Çıkış Ambarı",
    workplaceId: "",
    departmentId: "",
    warehouseId: "",
  );

  String transferTypeName = "";
  bool isTransferTypeSelectable = false;
  int transferTypeId = 0;
  List<TransferTypeItem> transferTypeItem = GNSSystemSettingsUtils.transferTypeItemList;

  bool isCustomerIdEmpty = false;
  bool isCustomerAddressIdEmpty = false;
  bool isProjectIdEmpty = false;
  bool isTransporterIdEmpty = false;
  //çıkış
  bool isWorkplaceIdEmptyForOut = false;
  bool isDepartmentIdEmptyForOut = false;
  bool isWarehouseIdEmptyForOut = false;
  //giriş
  bool isWorkplaceIdEmptyForIn = false;
  bool isDepartmentIdEmptyForIn = false;
  bool isWarehouseIdEmptyForIn = false;

  void _updateUIForEmptyAreas() {
    isCustomerIdEmpty = customerInfo.customerId.isEmpty;
    isCustomerAddressIdEmpty = customerInfo.customerAddressId.isEmpty;
    isTransporterIdEmpty = transporterId.isEmpty;
    isProjectIdEmpty = projectId.isEmpty;
    //giris
    isWorkplaceIdEmptyForIn = inTransferInfo.workplaceId.isEmpty;
    isDepartmentIdEmptyForIn = inTransferInfo.departmentId.isEmpty;
    isWarehouseIdEmptyForIn = inTransferInfo.warehouseId.isEmpty;
    //cikis
    isWorkplaceIdEmptyForOut = outTransferInfo.workplaceId.isEmpty;
    isDepartmentIdEmptyForOut = outTransferInfo.departmentId.isEmpty;
    isWarehouseIdEmptyForOut = outTransferInfo.warehouseId.isEmpty;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createApiRepository();
  }

  bool _isThereEmptyValue() {
    if (customerInfo.customerId.isNotEmpty &&
        transporterId.isNotEmpty &&
        customerInfo.customerAddressId.isNotEmpty &&
        outTransferInfo.workplaceId.isNotEmpty &&
        outTransferInfo.departmentId.isNotEmpty &&
        outTransferInfo.warehouseId.isNotEmpty &&
        inTransferInfo.workplaceId.isNotEmpty &&
        inTransferInfo.departmentId.isNotEmpty &&
        inTransferInfo.warehouseId.isNotEmpty) {
      return false;
    }
    return true;
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);

    await _getWaybillTypeSelection();
    customerResponse = await apiRepository.getCustomer();
    transporterResponse = await apiRepository.getTransporterList();
    workplaceResponse = await apiRepository.getWorkplaceList();
    productListReponse = await apiRepository.getProductList();
    setState(() {
      isFetched = true;
    });
  }

  Future<void> _getProductBasedOnBarcode(String barcode) async {
    try {
      _showLoadingScreen(true, "Barkodla İlgili Ürün Aranıyor");
      var response = await apiRepository.getProductListBasedOnBarcode(barcode);
      if (response != null) {
        if (response.products!.items!.isNotEmpty) {
          var newItem = WarehouseTransferLocalItems(
            productId: response.products!.items![0].productId,
            description: response.products?.items?[0].definition ?? "",
            outWarehouseId: outTransferInfo.warehouseId,
            outWarehouseName: outTransferInfo.warehouseName,
            inWarehouseId: inTransferInfo.warehouseId,
            inWarehouseName: inTransferInfo.warehouseName,
            unitId: response.products?.items?[0].unit?.unitId ?? guidEmpty,
            unitConversionId: response.products?.items?[0].unit?.conversions?[0].unitConversionId ?? guidEmpty,
            qty: 1,
            productLocationRelationId: null,
            erpId: response.products?.items?[0].erpId ?? "0",
            erpCode: response.products?.items?[0].erpCode ?? "0",
            projectId: projectId,
            projectName: projectName,
          );
          transferProductList.add(
              WarehouseTransferProductDetailAndScannedNumber(response: response, bodyItem: newItem, scannedNumber: 1));
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

  Future<void> _getWaybillTypeSelection() async {
    String waybillType =
        await ServiceSharedPreferences.getSharedString(GNSSystemSettingsUtils.WaybillTypeSelection) ?? "";

    switch (waybillType) {
      case "0":
        transferTypeName = "Kağıt";
        transferTypeId = 0;
        isTransferTypeSelectable = false;
        break;
      case "1":
        transferTypeName = "E-İrsaliye";
        transferTypeId = 1;
        isTransferTypeSelectable = false;
        break;
      case "2":
        transferTypeName = "Kağıt";
        transferTypeId = 0;
        isTransferTypeSelectable = true;
        setState(() {});
        break;
      case "3":
        transferTypeName = "E-İrsaliye";
        transferTypeId = 1;
        isTransferTypeSelectable = true;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        // resizeToAvoidBottomInset: false,
        body: isFetched
            ? Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: spaceBetweenInputs,
                              ),
                              // GNSTextField(
                              //   label: "Fiş No",
                              //   onValueChanged: (value) {
                              //     ficheNo = value.toString();
                              //   },
                              // ),
                              // SizedBox(
                              //   height: spaceBetweenInputs,
                              // ),
                              // ElevatedButton(
                              //     onPressed: () {
                              //       _updateUIForEmptyAreas();
                              //       setState(() {});
                              //     },
                              //     child: Text("asdad")),
                              GNSSelectCustomerAndAddress(
                                addressType: CustomerAddressType.shippingAddress,
                                response: customerResponse!,
                                isErrorActiveForCustomer: isCustomerIdEmpty,
                                isErrorActiveForCustomerAddress: isCustomerAddressIdEmpty,
                                onValueChanged: (value) {
                                  customerInfo = value;
                                },
                              ),
                              SizedBox(
                                height: spaceBetweenInputs,
                              ),
                              GNSTextFormField(
                                label: "Açık Adres",
                                maxLengthEnforcement: MaxLengthEnforcement.none,
                                onValueChanged: (value) {},
                              ),
                              SizedBox(
                                height: spaceBetweenInputs,
                              ),
                              _selectWaybillType(transferTypeName, selectWaybillTypeFromBottom),
                              SizedBox(
                                height: spaceBetweenInputs,
                              ),
                              // GNSFieldWithBottomPage(
                              //   label: "Taşıyıcı",
                              //   response: transporterResponse,
                              //   whichResponse: "transporter",
                              //   onValueChanged: (value) {
                              //     transporterId = value.toString();
                              //   },
                              // ),
                              GNSSelectTransporter(
                                onValueChanged: (value) {
                                  transporterId = value.toString();
                                  print(transporterId);
                                },
                                isErrorActive: isTransporterIdEmpty,
                              ),
                              SizedBox(
                                height: spaceBetweenInputs,
                              ),
                              GNSSelectProject(
                                onValueChanged: (value) {
                                  projectId = value.projectId.toString();
                                  projectName = value.projectName.toString();

                                  transferProductList.forEach((element) {
                                    element.bodyItem.projectId = projectId;
                                    element.bodyItem.projectName = projectName;
                                  });
                                  setState(() {});
                                },
                                isErrorActive: isProjectIdEmpty,
                                projectName: "",
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    //cikis
                                    Expanded(
                                      child: GNSSelectWarehouseList(
                                        title: "Çıkış",
                                        response: workplaceResponse!,
                                        isErrorActiveForWorkplace: isWorkplaceIdEmptyForOut,
                                        isErrorActiveForDepartment: isDepartmentIdEmptyForOut,
                                        isErrorActiveForWarehouse: isWarehouseIdEmptyForOut,
                                        onValueChanged: (value) {
                                          outTransferInfo = value;
                                          transferProductList.forEach((element) {
                                            element.bodyItem.outWarehouseId = outTransferInfo.warehouseId;
                                            element.bodyItem.outWarehouseName = outTransferInfo.warehouseName;
                                          });
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    const VerticalDivider(
                                      color: Color.fromARGB(70, 39, 14, 14),
                                      thickness: 1.5,
                                      width: 20,
                                      indent: 55,
                                      endIndent: 20,
                                    ),
                                    //giris
                                    Expanded(
                                      child: GNSSelectWarehouseList(
                                        title: "Giriş",
                                        response: workplaceResponse!,
                                        isErrorActiveForWorkplace: isWorkplaceIdEmptyForIn,
                                        isErrorActiveForDepartment: isDepartmentIdEmptyForIn,
                                        isErrorActiveForWarehouse: isWarehouseIdEmptyForIn,
                                        onValueChanged: (value) {
                                          inTransferInfo = value;
                                          transferProductList.forEach((element) {
                                            element.bodyItem.inWarehouseId = inTransferInfo.warehouseId;
                                            element.bodyItem.inWarehouseName = inTransferInfo.warehouseName;
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
                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                    CountFicheScanArea(
                      onBarcodeChanged: (val) async {
                        bool isMatchAnyBarcode = false;
                        transferProductList.forEach((element) {
                          if (element.response.products?.items?[0].barcode.toString() == val) {
                            isMatchAnyBarcode = true;
                            element.bodyItem.qty = (element.bodyItem.qty ?? 0) + scannedTimes;
                            setState(() {});
                          }
                        });

                        if (isMatchAnyBarcode == false) {
                          await _getProductBasedOnBarcode(val.toString());
                        }
                      },
                      seriOrBarcode: (val) {},
                      scannedTimes: (val) {
                        scannedTimes = val!;
                      },
                    ),
                    //transfer ürünü oluşturma butonu
                    // Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 10),
                    //     child: _addProductButton(80, 35)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        thickness: 1,
                        color: Color.fromARGB(255, 161, 161, 161),
                        indent: 20,
                        endIndent: 20,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: transferProductList.length,
                                itemBuilder: (context, index) {
                                  return _card(transferProductList[index].bodyItem, index);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
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
                                if (_isThereEmptyValue()) {
                                  _showDialogMessage(context, "HATA !", "Boş alanları lütfen doldurunuz.");
                                } else {
                                  _showLoadingScreen(true, "Yükleniyor...");
                                  try {
                                    bool isTransferCreated =
                                        await apiRepository.createWarehouseTransfer(await _createTransferBody());
                                    if (isTransferCreated) {
                                      _showLoadingScreen(false, "Yükleniyor...");
                                      isFicheCreated = true;
                                      // ignore: use_build_context_synchronously
                                      _showDialogMessage(context, "Başarılı", "Transfer fişi oluşturuldu");
                                    } else {
                                      _showLoadingScreen(false, "Yükleniyor...");
                                      // ignore: use_build_context_synchronously
                                      _showDialogMessage(context, "Başarısız", "Transfer fişi oluşturulamadı !");
                                    }
                                  } catch (e) {
                                    _showLoadingScreen(false, "Yükleniyor...");

                                    GNSShowErrorMessage(context, e.toString());
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
                                        "Ambar Transfer Oluştur",
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //     onPressed: () async {
                    //       // if (_isThereEmptyValue()) {
                    //       //   _showDialogMessage(context, "HATA !",
                    //       //       "Boş alanları lütfen doldurunuz.");
                    //       // } else {
                    //       //   _showLoadingScreen(true, "Yükleniyor...");
                    //       //   await apiRepository
                    //       //       .createWarehouseTransfer(_createTransferBody());
                    //       //   _showLoadingScreen(false, "Yükleniyor...");
                    //       // }
                    //       _showLoadingScreen(true, "Yükleniyor...");
                    //       await apiRepository
                    //           .createWarehouseTransfer(_createTransferBody());
                    //       _showLoadingScreen(false, "Yükleniyor...");
                    //     },
                    //     child: Text("asdas")),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Padding _addProductButton(double width, double height) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: height,
        width: width,
        child: Material(
          color: Colors.orange,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            splashColor: const Color.fromARGB(255, 255, 223, 187),
            onTap: () {
              showDialogForAddNewProduct(context, "Ürün Ekle");
            },
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 1.0,
                  // ),
                ),
                child: const Center(
                    child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ))),
          ),
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
        isTransferTypeSelectable
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
                    itemCount: transferTypeItem.length,
                    itemBuilder: (context, index) {
                      return _selectingAreaRowItem(transferTypeItem[index].type, () {
                        transferTypeName = transferTypeItem[index].type;
                        transferTypeId = transferTypeItem[index].id;

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

  Slidable _card(WarehouseTransferLocalItems item, int index) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            // transferListItems.removeAt(index);
            transferProductList.removeAt(index);
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
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Colors.grey[700]),
            ),
            trailing: Text(
              item.qty.toString(),
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            title: Text(
              item.description.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xff727272),
              ),
            ),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Çıkış Ambarı: ${item.outWarehouseName.toString()}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[700]),
              ),
              Text(
                "Giriş Ambarı: ${item.inWarehouseName.toString()}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[700]),
              )
            ]),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.deepOrange[700], size: 32 //change your color here
          ),
      title: Text(
        "Ambar Transfer Fişi Oluştur",
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

  Future<dynamic> showDialogForAddNewProduct(BuildContext context, String content) {
    return showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
            ),
            title: const Text("Ürün Ekle"),
            contentPadding: const EdgeInsets.all(10.0),
            content: SingleChildScrollView(
              child: SelectProductPage(
                // productListReponse: productListReponse!,
                workplaceWarehouseList: getAllWarehouses(workplaceResponse!),
                inWarehouse: inTransferInfo.warehouseName,
                outWarehouse: outTransferInfo.warehouseName,
                inWarehouseId: inTransferInfo.warehouseId,
                outWarehouseId: outTransferInfo.warehouseId,
                onValueChanged: (value) {
                  transferListItems.add(value);
                  setState(() {});
                },
              ),
            )),
      ),
    );
  }

//asdasd
  Future<dynamic> _showDialogForUpdateProduct(
      BuildContext context, String content, WarehouseTransferLocalItems oldItem, int index) {
    return showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: true,
        child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
            ),
            title: const Text("Ürün Güncelle"),
            contentPadding: const EdgeInsets.all(10.0),
            content: SingleChildScrollView(
              child: UpdateSelectedProductPage(
                workplaceWarehouseList: getAllWarehouses(workplaceResponse!),
                oldItem: oldItem,
                onValueChanged: (value) {
                  // transferListItems[index] = value;
                  transferProductList[index].bodyItem = value;
                  setState(() {});
                },
              ),
            )),
      ),
    );
  }

  _showDialogMessage(BuildContext buildContext, String title, String content) {
    return showDialog(
      context: buildContext,
      builder: (buildContext) => AlertDialog(
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
                if (isFicheCreated) {
                  Navigator.of(context).pop();
                }
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
    // for (var workplace in data['workplaces']['items']) {
    //   for (var department in workplace['departments']) {
    //     if (department['warehouse'].isNotEmpty) {
    //       warehouses.addAll(department['warehouse']);
    //     }
    //   }
    // }
    return warehouses;
  }

  Future<String> _getDocNumberFicheNumber() async {
    getFicheNumberResponse = await apiRepository.getDocNumberFicheNumber(apiRepository.employeeUid, "11");

    return getFicheNumberResponse?.docnumber?.lastNum ?? "";
  }

  Future<WarehouseTransferCreateBody> _createTransferBody() async {
    return WarehouseTransferCreateBody(
      customerId: customerInfo.customerId,
      ficheNo: ficheNo.isEmpty ? await _getDocNumberFicheNumber() : ficheNo,
      ficheDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(ficheDate.toUtc()),
      ficheTime: DateFormat('HH:mm').format(ficheDate),
      docNo: "",
      outWorkplaceId: outTransferInfo.workplaceId,
      outDepartmentId: outTransferInfo.departmentId,
      outWarehouseId: outTransferInfo.warehouseId,
      inWorkplaceId: inTransferInfo.workplaceId,
      inDepartmentId: inTransferInfo.departmentId,
      inWarehouseId: inTransferInfo.warehouseId,
      description: description,
      transporterId: transporterId,
      customerAddressId: customerInfo.customerAddressId,
      erpId: "",
      erpCode: "",
      waybillTypeId: transferTypeId,
      projectId: projectId,
      warehouseTransferItems: _createWarehouseTransferItems(),
    );
  }

  List<WarehouseTransferItems> _createWarehouseTransferItems() {
    List<WarehouseTransferItems> list = [];
    transferProductList.forEach((element) {
      WarehouseTransferItems item = WarehouseTransferItems(
        productId: element.bodyItem.productId,
        description: element.bodyItem.description,
        outWarehouseId: element.bodyItem.outWarehouseId,
        inWarehouseId: element.bodyItem.inWarehouseId,
        unitId: element.bodyItem.unitId,
        unitConversionId: element.bodyItem.unitConversionId,
        qty: element.bodyItem.qty,
        productLocationRelationId: "00000000-0000-0000-0000-000000000000",
        erpId: element.bodyItem.erpId,
        erpCode: element.bodyItem.erpCode,
        projectId: element.bodyItem.projectId,
      );
      list.add(item);
    });

    return list;
  }
}

class WarehouseTransferProductDetailAndScannedNumber {
  ProductListReponse response;
  WarehouseTransferLocalItems bodyItem;
  int scannedNumber;

  WarehouseTransferProductDetailAndScannedNumber({
    required this.response,
    required this.bodyItem,
    required this.scannedNumber,
  });
}
