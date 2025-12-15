import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gns_warehouse/constants/customer_address_type.dart';
import 'package:gns_warehouse/models/new_api/doc_number_get_fiche_number.dart';
import 'package:gns_warehouse/models/new_api/minus_count_fiche/minus_count_fiche_request_body.dart';
import 'package:gns_warehouse/models/new_api/new_customer_list_response.dart';
import 'package:gns_warehouse/models/new_api/product_list_reponse.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/stock_counting_fiche/components/count_fiche_scan_area.dart';
import 'package:gns_warehouse/pages/minus_count_fiche/components/minus_count_product_update.dart';
import 'package:gns_warehouse/pages/transfer_fiche/components/select_transfer_fiche_product.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_customer.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_project.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_warehouse.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/widgets/gns_error_field.dart';
import 'package:gns_warehouse/widgets/gns_text_field.dart';
import 'package:gns_warehouse/widgets/gns_text_form_field.dart';
import 'package:intl/intl.dart';

class CreateMinusCountFichePage extends StatefulWidget {
  const CreateMinusCountFichePage({super.key});

  @override
  State<CreateMinusCountFichePage> createState() => _CreateMinusCountFichePageState();
}

class _CreateMinusCountFichePageState extends State<CreateMinusCountFichePage> {
  final Color contentColor = const Color.fromARGB(255, 134, 200, 255);
  final Color contentDarkColor = const Color.fromARGB(255, 0, 108, 196);
  String ficheNo = "";
  late ApiRepository apiRepository;
  late WorkplaceListResponse? workplaceResponse;
  bool isFetched = false;
  bool isTransferFicheCreated = false;
  DateTime ficheDate = DateTime.now();
  String description = "";
  double spaceBetweenInputs = 7;
  DocNumberGetFicheNumberResponse? getFicheNumberResponse;
  late NewCustomerListResponse? customerResponse;
  String projectId = "";
  String projectName = "";

  bool isProjectIdEmpty = false;
  bool isWorkplaceIdEmpty = false;
  bool isDepartmentIdEmpty = false;
  bool isWarehouseIdEmpty = false;
  bool isCustomerIdEmpty = false;
  bool isCustomerAddressIdEmpty = false;
  bool isFormAreaVisible = true;

  void _updateUIForEmptyAreas() {
    isProjectIdEmpty = projectId.isEmpty;
    isWorkplaceIdEmpty = inTransferInfo.workplaceId.isEmpty;
    isDepartmentIdEmpty = inTransferInfo.departmentId.isEmpty;
    isWarehouseIdEmpty = inTransferInfo.warehouseId.isEmpty;
    isCustomerIdEmpty = customerInfo.customerId.isEmpty;
    isCustomerAddressIdEmpty = customerInfo.customerAddressId.isEmpty;
  }

  List<TransferFicheLocalItems> transferListItems = [];

  List<ProductDetailAndScannedNumber> transferProductList = [];
  int scannedTimes = 1;
  String guidEmpty = "00000000-0000-0000-0000-000000000000";

  WorkplaceDepartmentWarehouse inTransferInfo = WorkplaceDepartmentWarehouse(
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createApiRepository();
  }

  Future<void> _getProductBasedOnBarcode(String barcode) async {
    try {
      _showLoadingScreen(true, "Barkodla İlgili Ürün Aranıyor");
      var response = await apiRepository.getProductListBasedOnBarcode(barcode);
      if (response != null) {
        if (response.products!.items!.isNotEmpty) {
          var newItem = TransferFicheLocalItems(
            productId: response.products!.items![0].productId,
            description: response.products?.items?[0].definition ?? "",
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
          transferProductList
              .add(ProductDetailAndScannedNumber(response: response, bodyItem: newItem, scannedNumber: 1));
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

  bool _isThereEmptyValue() {
    if (customerInfo.customerId.isNotEmpty &&
        customerInfo.customerAddressId.isNotEmpty &&
        inTransferInfo.workplaceId.isNotEmpty &&
        inTransferInfo.departmentId.isNotEmpty &&
        inTransferInfo.warehouseId.isNotEmpty) {
      return false;
    }
    return true;
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    workplaceResponse = await apiRepository.getWorkplaceList();
    customerResponse = await apiRepository.getCustomer();
    setState(() {
      isFetched = true;
    });
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
                                  return _card2(transferProductList[index].bodyItem, index);
                                  // return Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(transferProductList[index]
                                  //         .response
                                  //         .data!
                                  //         .barcode
                                  //         .toString()),
                                  //     Text(transferProductList[index]
                                  //         .scannedNumber
                                  //         .toString()),
                                  //   ],
                                  // );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //transfer ürünü oluşturma butonu
                    // Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 10),
                    //     child: _addProductButton(80, 35)),
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   child: Divider(
                    //     thickness: 1,
                    //     color: Color.fromARGB(255, 161, 161, 161),
                    //     indent: 20,
                    //     endIndent: 20,
                    //   ),
                    // ),
                    // Expanded(
                    //   flex: 3,
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 10),
                    //     child: SingleChildScrollView(
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           ListView.builder(
                    //             primary: false,
                    //             shrinkWrap: true,
                    //             itemCount: transferListItems.length,
                    //             itemBuilder: (context, index) {
                    //               return _card(transferListItems[index], index);
                    //             },
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    _showFormAreaButton(),
                    Expanded(
                      flex: isFormAreaVisible ? 3 : 0,
                      child: SizedBox(
                        height: isFormAreaVisible ? null : 0,
                        child: _formArea(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            color: contentColor,
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
                                        await apiRepository.createMinusCountFiche(await _createTransferBody());
                                    if (isTransferCreated) {
                                      isTransferFicheCreated = true;
                                      _showLoadingScreen(false, "Yükleniyor...");
                                      // ignore: use_build_context_synchronously
                                      _showDialogMessage(context, "Başarılı", "Sayım eksiği fişi oluşturuldu");
                                    } else {
                                      _showLoadingScreen(false, "Yükleniyor...");
                                      // ignore: use_build_context_synchronously
                                      _showDialogMessage(context, "Başarısız", "Sayım eksiği fişi oluşturulamadı !");
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
                                        "Fişi Oluştur",
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

  InkWell _showFormAreaButton() {
    return InkWell(
      onTap: () {
        isFormAreaVisible = !isFormAreaVisible;
        setState(() {});
      },
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      splashColor: const Color.fromARGB(255, 255, 230, 223),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 73, 88, 90)),
            children: <TextSpan>[
              TextSpan(
                text: isFormAreaVisible ? "Gizle" : "Göster",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _formArea() {
    return Padding(
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
            SizedBox(
              height: spaceBetweenInputs,
            ),
            GNSSelectCustomerAndAddress(
              addressType: CustomerAddressType.shippingAddress,
              isErrorActiveForCustomer: isCustomerIdEmpty,
              isErrorActiveForCustomerAddress: isCustomerAddressIdEmpty,
              response: customerResponse!,
              onValueChanged: (value) {
                customerInfo = value;
              },
            ),
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

            IntrinsicHeight(
              child: Row(
                children: [
                  //giris
                  Expanded(
                    child: GNSSelectWarehouseList(
                      title: "Giriş",
                      response: workplaceResponse!,
                      isErrorActiveForWorkplace: isWorkplaceIdEmpty,
                      isErrorActiveForDepartment: isDepartmentIdEmpty,
                      isErrorActiveForWarehouse: isWarehouseIdEmpty,
                      onValueChanged: (value) {
                        inTransferInfo = value;
                        transferProductList.forEach((element) {
                          element.bodyItem.inWarehouseId = inTransferInfo.warehouseId;
                          element.bodyItem.inWarehouseName = inTransferInfo.warehouseName;
                        });
                        setState(() {});
                      },
                      titleTextColor: contentDarkColor,
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
    );
  }

  Padding _addProductButton(double width, double height) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: height,
        width: width,
        child: Material(
          color: contentColor,
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

  Future<dynamic> _showDialogForUpdateProduct(
      BuildContext context, String content, TransferFicheLocalItems oldItem, int index) {
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
              child: MinusCountProductUpdate(
                workplaceWarehouseList: getAllWarehouses(workplaceResponse!),
                oldItem: oldItem,
                onValueChanged: (value) {
                  transferProductList[index].bodyItem = value;
                  setState(() {});
                },
              ),
            )),
      ),
    );
  }

  Slidable _card2(TransferFicheLocalItems item, int index) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        SlidableAction(
          onPressed: (context) {
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
                "Giriş Ambarı: ${item.inWarehouseName.toString()}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[700]),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Slidable _card(TransferFicheLocalItems item, int index) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            transferListItems.removeAt(index);
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
            // _showDialogForUpdateProduct(context, "Ürünü Güncelle", item, index);
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
      iconTheme: IconThemeData(color: contentDarkColor, size: 32 //change your color here
          ),
      title: Text(
        "Sayım Eksiği Fişi Oluştur",
        style: TextStyle(color: contentDarkColor, fontWeight: FontWeight.bold, fontSize: 20),
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
              child: SelectTransferFicheProduct(
                // productListReponse: productListReponse!,
                workplaceWarehouseList: getAllWarehouses(workplaceResponse!),
                inWarehouse: inTransferInfo.warehouseName,
                outWarehouse: "",
                inWarehouseId: inTransferInfo.warehouseId,
                outWarehouseId: "",
                onValueChanged: (value) {
                  transferListItems.add(value);
                  setState(() {});
                },
              ),
            )),
      ),
    );
  }

  // Future<dynamic> _showDialogForUpdateProduct(BuildContext context,
  //     String content, TransferFicheLocalItems oldItem, int index) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => PopScope(
  //       canPop: true,
  //       child: AlertDialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius:
  //                 BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
  //           ),
  //           title: const Text("Ürün Güncelle"),
  //           contentPadding: const EdgeInsets.all(10.0),
  //           content: SingleChildScrollView(
  //             child: UpdateSelectedProductPage(
  //               productListReponse: productListReponse!,
  //               workplaceWarehouseList: getAllWarehouses(workplaceResponse!),
  //               oldItem: oldItem,
  //               onValueChanged: (value) {
  //                 transferListItems[index] = value;
  //                 setState(() {});
  //               },
  //             ),
  //           )),
  //     ),
  //   );
  // }

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
                if (isTransferFicheCreated) {
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
    getFicheNumberResponse = await apiRepository.getDocNumberFicheNumber(apiRepository.employeeUid, "13");

    return getFicheNumberResponse?.docnumber?.lastNum ?? "";
  }

  Future<MinusCountFicheRequestBody> _createTransferBody() async {
    return MinusCountFicheRequestBody(
      ficheNo: ficheNo.isEmpty ? await _getDocNumberFicheNumber() : ficheNo,
      ficheDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(ficheDate.toUtc()),
      ficheTime: DateFormat('HH:mm').format(ficheDate),
      docNo: "",
      inWorkplaceId: inTransferInfo.workplaceId,
      inDepartmentId: inTransferInfo.departmentId,
      inWarehouseId: inTransferInfo.warehouseId,
      description: description,
      customerId: customerInfo.customerId,
      customerAddressId: customerInfo.customerAddressId,
      erpId: "",
      erpCode: "",
      projectId: projectId,
      minusCountFicheItem: _createWarehouseTransferItems(),
    );
  }

  List<MinusCountFicheItem> _createWarehouseTransferItems() {
    List<MinusCountFicheItem> list = [];
    transferProductList.forEach((element) {
      MinusCountFicheItem item = MinusCountFicheItem(
        productId: element.bodyItem.productId,
        description: element.bodyItem.description,
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

class ProductDetailAndScannedNumber {
  ProductListReponse response;
  TransferFicheLocalItems bodyItem;
  int scannedNumber;

  ProductDetailAndScannedNumber({required this.response, required this.bodyItem, required this.scannedNumber});
}
