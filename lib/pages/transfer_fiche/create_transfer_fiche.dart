import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gns_warehouse/models/new_api/doc_number_get_fiche_number.dart';
import 'package:gns_warehouse/models/new_api/request_body/transfer_fiche_request_body.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/stock_counting_fiche/components/count_fiche_scan_area.dart';
import 'package:gns_warehouse/pages/minus_count_fiche/components/minus_count_product_update.dart';
import 'package:gns_warehouse/pages/minus_count_fiche/create_minus_count_fiche.dart';
import 'package:gns_warehouse/pages/transfer_fiche/components/select_transfer_fiche_product.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_project.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_transporter.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_warehouse.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/widgets/gns_error_field.dart';
import 'package:gns_warehouse/widgets/gns_text_field.dart';
import 'package:gns_warehouse/widgets/gns_text_form_field.dart';
import 'package:intl/intl.dart';

class CreateTransferFichePage extends StatefulWidget {
  const CreateTransferFichePage({super.key});

  @override
  State<CreateTransferFichePage> createState() =>
      _CreateTransferFichePageState();
}

class _CreateTransferFichePageState extends State<CreateTransferFichePage> {
  String ficheNo = "";
  late ApiRepository apiRepository;
  late WorkplaceListResponse? workplaceResponse;
  bool isFetched = false;
  bool isTransferFicheCreated = false;
  DateTime ficheDate = DateTime.now();
  String description = "";
  String transporterId = "";
  String projectId = "";
  String projectName = "";
  double spaceBetweenInputs = 7;
  DocNumberGetFicheNumberResponse? getFicheNumberResponse;

  bool isProjectIdEmpty = false;
  bool isTransporterIdEmpty = false;
  bool isWorkplaceIdEmpty = false;
  bool isDepartmentIdEmpty = false;
  bool isWarehouseIdEmpty = false;

  bool isFormAreaVisible = true;

  void _updateUIForEmptyAreas() {
    isTransporterIdEmpty = transporterId.isEmpty;
    isProjectIdEmpty = projectId.isEmpty;
    isWorkplaceIdEmpty = inTransferInfo.workplaceId.isEmpty;
    isDepartmentIdEmpty = inTransferInfo.departmentId.isEmpty;
    isWarehouseIdEmpty = inTransferInfo.warehouseId.isEmpty;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createApiRepository();
  }

  bool _isThereEmptyValue() {
    if (transporterId.isNotEmpty &&
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
          var newItem = TransferFicheLocalItems(
            productId: response.products!.items![0].productId,
            description: response.products?.items?[0].definition ?? "",
            inWarehouseId: inTransferInfo.warehouseId,
            inWarehouseName: inTransferInfo.warehouseName,
            unitId: response.products?.items?[0].unit?.unitId ?? guidEmpty,
            unitConversionId: response.products?.items?[0].unit?.conversions?[0]
                    .unitConversionId ??
                guidEmpty,
            qty: 1,
            productLocationRelationId: null,
            erpId: response.products?.items?[0].erpId ?? "0",
            erpCode: response.products?.items?[0].erpCode ?? "0",
            projectId: projectId,
            projectName: projectName,
          );
          transferProductList.add(ProductDetailAndScannedNumber(
              response: response, bodyItem: newItem, scannedNumber: 1));
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        // resizeToAvoidBottomInset: false,
        body: isFetched
            ? Container(
                child: Column(
                  children: [
                    CountFicheScanArea(
                      onBarcodeChanged: (val) async {
                        bool isMatchAnyBarcode = false;
                        transferProductList.forEach((element) {
                          if (element.response.products?.items?[0].barcode
                                  .toString() ==
                              val) {
                            isMatchAnyBarcode = true;
                            element.bodyItem.qty =
                                (element.bodyItem.qty ?? 0) + scannedTimes;
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
                                  return _card2(
                                      transferProductList[index].bodyItem,
                                      index);
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
                    // Expanded(
                    //   flex: 3,
                    //   child: _formArea(),
                    // ),
                    _showFormAreaButton(),
                    Expanded(
                      flex: isFormAreaVisible ? 3 : 0,
                      child: AnimatedContainer(
                        height: isFormAreaVisible ? null : 0,
                        duration: const Duration(milliseconds: 200),
                        child: _formArea(),
                      ),
                    ),
                    //transfer ürünü oluşturma butonu
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5, left: 5, right: 5, bottom: 5),
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            color: Colors.orangeAccent,
                            elevation: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              splashColor:
                                  const Color.fromARGB(255, 255, 223, 187),
                              onTap: () async {
                                _updateUIForEmptyAreas();
                                if (_isThereEmptyValue()) {
                                  _showDialogMessage(context, "HATA !",
                                      "Boş alanları lütfen doldurunuz.");
                                } else {
                                  _showLoadingScreen(true, "Yükleniyor...");
                                  try {
                                    bool isTransferCreated =
                                        await apiRepository.createTransferFiche(
                                            await _createTransferBody());
                                    if (isTransferCreated) {
                                      isTransferFicheCreated = true;
                                      _showLoadingScreen(
                                          false, "Yükleniyor...");
                                      // ignore: use_build_context_synchronously
                                      _showDialogMessage(context, "Başarılı",
                                          "Transfer fişi oluşturuldu");
                                    } else {
                                      _showLoadingScreen(
                                          false, "Yükleniyor...");
                                      // ignore: use_build_context_synchronously
                                      _showDialogMessage(context, "Başarısız",
                                          "Transfer fişi oluşturulamadı !");
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
                                        "Devir Fişi Oluştur",
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
                    ),
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
            style: const TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 73, 88, 90)),
            children: <TextSpan>[
              TextSpan(
                text: isFormAreaVisible ? "Gizle" : "Göster",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
            // ElevatedButton(
            //     onPressed: () {
            //       _updateUIForEmptyAreas();
            //       setState(() {});
            //     },
            //     child: Text("asdad")),
            GNSTextField(
              label: "Fiş No",
              onValueChanged: (value) {
                ficheNo = value.toString();
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
                      isErrorActiveForWorkplace: isWorkplaceIdEmpty,
                      isErrorActiveForDepartment: isDepartmentIdEmpty,
                      isErrorActiveForWarehouse: isWarehouseIdEmpty,
                      onValueChanged: (value) {
                        inTransferInfo = value;
                        transferProductList.forEach((element) {
                          element.bodyItem.inWarehouseId =
                              inTransferInfo.warehouseId;
                          element.bodyItem.inWarehouseName =
                              inTransferInfo.warehouseName;
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
    );
  }

  Future<dynamic> _showDialogForUpdateProduct(BuildContext context,
      String content, TransferFicheLocalItems oldItem, int index) {
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
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[700]),
            ),
            trailing: Text(
              item.qty.toString(),
              style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
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
            subtitle:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Giriş Ambarı: ${item.inWarehouseName.toString()}",
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
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[700]),
            ),
            trailing: Text(
              item.qty.toString(),
              style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
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
            subtitle:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Giriş Ambarı: ${item.inWarehouseName.toString()}",
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

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(
          color: Colors.deepOrange[700], size: 32 //change your color here
          ),
      title: Text(
        "Devir Fişi Oluştur",
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

  Future<dynamic> showDialogForAddNewProduct(
      BuildContext context, String content) {
    return showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
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
    getFicheNumberResponse = await apiRepository.getDocNumberFicheNumber(
        apiRepository.employeeUid, "7");

    return getFicheNumberResponse?.docnumber?.lastNum ?? "";
  }

  Future<TransferFicheRequestBody> _createTransferBody() async {
    return TransferFicheRequestBody(
      ficheNo: ficheNo.isEmpty ? await _getDocNumberFicheNumber() : ficheNo,
      ficheDate:
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(ficheDate.toUtc()),
      ficheTime: DateFormat('HH:mm').format(ficheDate),
      docNo: "",
      inWorkplaceId: inTransferInfo.workplaceId,
      inDepartmentId: inTransferInfo.departmentId,
      inWarehouseId: inTransferInfo.warehouseId,
      description: description,
      transporterId: transporterId,
      erpId: "",
      erpCode: "",
      projectId: projectId,
      transferFicheItems: _createWarehouseTransferItems(),
    );
  }

  List<TransferFicheItems> _createWarehouseTransferItems() {
    List<TransferFicheItems> list = [];
    transferProductList.forEach((element) {
      TransferFicheItems item = TransferFicheItems(
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
