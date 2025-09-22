import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/constants/user_special_settings.dart';
import 'package:gns_warehouse/models/new_api/product_list_reponse.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/bottom_sheets/gns_whs_trs_product_bottom.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';

// ignore: must_be_immutable
class SelectTransferFicheProduct extends StatefulWidget {
  SelectTransferFicheProduct({
    super.key,
    // required this.productListReponse,
    required this.workplaceWarehouseList,
    required this.inWarehouse,
    required this.outWarehouse,
    required this.inWarehouseId,
    required this.outWarehouseId,
    required this.onValueChanged,
  });
  // ProductListReponse productListReponse;
  String inWarehouse;
  String outWarehouse;
  String? inWarehouseId;
  String? outWarehouseId;
  List<WorkplaceWarehouse> workplaceWarehouseList;
  final ValueChanged<TransferFicheLocalItems> onValueChanged;
  @override
  State<SelectTransferFicheProduct> createState() =>
      _SelectTransferFicheProductState();
}

class _SelectTransferFicheProductState
    extends State<SelectTransferFicheProduct> {
  late ApiRepository apiRepository;
  late TextEditingController _barcodeController;
  final FocusNode _barcodeFocusNode = FocusNode();
  final FocusNode _numberFocusNode = FocusNode();

  ProductListReponse? responseBasedOrderBarcode;
  bool isLoading = true;
  String productNameInit = "Ürün";
  String inWareouseInit = "Giriş Ambarı";

  int qty = 1;
  ProductItems? productItem;
  String productName = "Ürün";
  String productId = "";
  String inWareouse = "Giriş Ambarı";
  String inWareouseId = "";

  bool isThereWarehouseBoundForUser = false;
  List<String> userSpecialWarehouseListForIn = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _barcodeController = TextEditingController();

    _createApiRepository();
    _getUserSpecialWarehouseSettings();
    inWareouse = widget.inWarehouse == "" ? "Giriş Ambarı" : widget.inWarehouse;

    inWareouseId = widget.inWarehouseId ?? "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _barcodeFocusNode.requestFocus();
    });
  }

  @override
  void didUpdateWidget(covariant SelectTransferFicheProduct oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();

    _numberFocusNode.dispose();
    _barcodeFocusNode.dispose();
    _barcodeController.dispose();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
  }

  _getUserSpecialWarehouseSettings() async {
    String userSpecialSetting = await ServiceSharedPreferences.getSharedString(
            UserSpecialSettingsUtils.userWarehouseAuthIn) ??
        "";

    if (userSpecialSetting.isNotEmpty) {
      List<dynamic> decodedValue = jsonDecode(userSpecialSetting);
      setState(() {
        isLoading = false;
        userSpecialWarehouseListForIn = List<String>.from(decodedValue);
        isThereWarehouseBoundForUser = true;
      });
    }
  }

  Future<void> _searchBasedOnBarcode(String barcode) async {
    responseBasedOrderBarcode =
        await apiRepository.getProductListBasedOnBarcode(barcode);
    if (responseBasedOrderBarcode != null &&
        responseBasedOrderBarcode!.products!.items!.isNotEmpty) {
      _barcodeController.text = barcode;
      productItem = responseBasedOrderBarcode!.products!.items![0];
      productName =
          responseBasedOrderBarcode!.products!.items![0].definition.toString();
    } else {
      productItem = null;
      productName = "Ürün";
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? _loadingScreen(context)
        : Column(
            children: [
              TextField(
                controller: _barcodeController,
                focusNode: _barcodeFocusNode,
                onSubmitted: (value) async {
                  setState(() {
                    isLoading = true;
                  });
                  await _searchBasedOnBarcode(value);

                  setState(() {
                    isLoading = false;
                    if (productItem != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _numberFocusNode.requestFocus();
                      });
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _barcodeController.text = "";
                        _barcodeFocusNode.requestFocus();
                      });
                    }
                  });
                },
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // color: Color(0xff8a9a99),
                    color: Colors.black),
                decoration: InputDecoration(
                    label: Text(
                      "Barkod",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[200]),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(5.0), // BorderRadius 5px
                      borderSide: const BorderSide(
                        color: Colors.black, // Siyah border
                        width: 1.0, // 1px kalınlık
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(5.0), // BorderRadius 5px
                      borderSide: const BorderSide(
                        color: Colors.black, // Siyah border
                        width: 1.0, // 1px kalınlık
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10)),
                cursorColor: const Color(0xff8a9a99),
              ),
              const SizedBox(
                height: 5,
              ),
              _qtyTextField(),
              const SizedBox(
                height: 5,
              ),
              _selectBox(
                context,
                productName,
                productNameInit,
                () {
                  // showModalBottomSheet(
                  //   context: context,
                  //   builder: (context) =>
                  //       _productListBottomSheet(widget.productListReponse),
                  // );

                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) =>
                          GNSWhsTrsProductBottom(onValueChanged: (value) {
                            _barcodeController.text = value.barcode.toString();
                            productItem = value;
                            productName = value.definition.toString();
                            setState(() {});
                          }));
                },
              ),
              const SizedBox(
                height: 5,
              ),
              _selectBox(
                context,
                inWareouse,
                inWareouseInit,
                () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _inWarehouseBottomSheet(
                        isThereWarehouseBoundForUser
                            ? _limitWarehouseBasedOnSetting(
                                widget.workplaceWarehouseList,
                                userSpecialWarehouseListForIn)
                            : widget.workplaceWarehouseList),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: (() {
                        Navigator.of(context).pop();
                      }),
                      child: const Text(
                        "İptal",
                        style: TextStyle(color: Colors.black),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                    onPressed: (() {
                      if (_isThereEmptyValue()) {
                        _showDialogMessage(context, "HATA !",
                            "Boş alanları lütfen doldurunuz.");
                      } else {
                        _createWarehouseTransferItems();
                        Navigator.of(context).pop();
                      }
                    }),
                    child: const Text(
                      "Evet",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          );
  }

  Center _loadingScreen(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 5,
          ),
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              child: const Text(
                "Kapat",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
  }

  TextField _qtyTextField() {
    return TextField(
      onChanged: (value) {
        qty = int.tryParse(value)!;
      },
      focusNode: _numberFocusNode,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.start,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          // color: Color(0xff8a9a99),
          color: Colors.black),
      decoration: InputDecoration(
          label: Text(
            "Adet",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[200]),
          ),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0), // BorderRadius 5px
            borderSide: const BorderSide(
              color: Colors.black, // Siyah border
              width: 1.0, // 1px kalınlık
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0), // BorderRadius 5px
            borderSide: const BorderSide(
              color: Colors.black, // Siyah border
              width: 1.0, // 1px kalınlık
            ),
          ),
          contentPadding: EdgeInsets.all(10)),
      cursorColor: const Color(0xff8a9a99),
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

  Row _selectBox(BuildContext context, String selectedValue,
      String initialValue, Function() onTap) {
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
                selectedValue,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: selectedValue == initialValue
                      ? Colors.blueGrey[200]
                      : Colors.black,
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

  Widget _inWarehouseBottomSheet(List<WorkplaceWarehouse> warehouse) {
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
                    "Ambarlar (Giriş)",
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
                            inWareouse = warehouse[index].code!;
                            inWareouseId = warehouse[index].warehouseId!;
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
    if (productItem!.productId!.isNotEmpty && inWareouseId.isNotEmpty) {
      return false;
    }
    return true;
  }

  void _createWarehouseTransferItems() {
    TransferFicheLocalItems item = TransferFicheLocalItems(
      productId: productItem!.productId,
      description: productItem!.definition,
      inWarehouseId: inWareouseId,
      inWarehouseName: inWareouse,
      unitId: productItem!.unit!.unitId,
      unitConversionId: productItem!.unit!.conversions![0].unitConversionId,
      qty: qty,
      productLocationRelationId: null,
      erpId: productItem?.erpId,
      erpCode: productItem?.erpCode,
    );

    widget.onValueChanged(item);
  }

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
}

class TransferFicheLocalItems {
  String? productId;
  String? description;
  String? inWarehouseId;
  String? inWarehouseName;
  String? unitId;
  String? unitConversionId;
  int? qty;
  String? productLocationRelationId;
  String? erpId;
  String? erpCode;
  String? projectId;
  String? projectName;

  TransferFicheLocalItems({
    this.productId,
    this.description,
    this.inWarehouseId,
    this.inWarehouseName,
    this.unitId,
    this.unitConversionId,
    this.qty,
    this.productLocationRelationId,
    this.erpId,
    this.erpCode,
    this.projectId,
    this.projectName,
  });

  TransferFicheLocalItems.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    description = json['description'];
    inWarehouseId = json['inWarehouseId'];
    inWarehouseName = json['inWarehouseName'];
    unitId = json['unitId'];
    unitConversionId = json['unitConversionId'];
    qty = json['qty'];
    productLocationRelationId = json['productLocationRelationId'];
    erpId = json['erpId'];
    erpCode = json['erpCode'];
    projectId = json['projectId'];
    projectName = json['projectName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['description'] = this.description;
    data['inWarehouseId'] = this.inWarehouseId;
    data['inWarehouseName'] = this.inWarehouseName;
    data['unitId'] = this.unitId;
    data['unitConversionId'] = this.unitConversionId;
    data['qty'] = this.qty;
    data['productLocationRelationId'] = this.productLocationRelationId;
    data['erpId'] = this.erpId;
    data['erpCode'] = this.erpCode;
    data['projectId'] = this.projectId;
    data['projectName'] = this.projectName;
    return data;
  }
}
