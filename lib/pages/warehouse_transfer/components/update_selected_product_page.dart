import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/constants/user_special_settings.dart';
import 'package:gns_warehouse/models/new_api/product_list_reponse.dart';
import 'package:gns_warehouse/models/new_api/warehouse_transfer_create_body.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/bottom_sheets/gns_whs_trs_product_bottom.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_project.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/gns_select_warehouse.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/select_product_page.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:gns_warehouse/widgets/gns_text_field.dart';

class UpdateSelectedProductPage extends StatefulWidget {
  UpdateSelectedProductPage({
    super.key,
    required this.workplaceWarehouseList,
    required this.oldItem,
    required this.onValueChanged,
  });

  List<WorkplaceWarehouse> workplaceWarehouseList;
  WarehouseTransferLocalItems oldItem;
  final ValueChanged<WarehouseTransferLocalItems> onValueChanged;
  @override
  State<UpdateSelectedProductPage> createState() =>
      _UpdateSelectedProductPageState();
}

class _UpdateSelectedProductPageState extends State<UpdateSelectedProductPage> {
  String productNameInit = "Ürün";
  String inWareouseInit = "Giriş Ambarı";
  String outWarehouseInit = "Çıkış Ambarı";

  int qty = 1;
  ProductItems? productItem;
  String productName = "Ürün";
  String productId = "";
  String inWareouse = "Giriş Ambarı";
  String outWarehouse = "Çıkış Ambarı";
  String inWareouseId = "";
  String outWarehouseId = "";

  List<String> userSpecialWarehouseListForIn = [];
  List<String> userSpecialWarehouseListForOut = [];
  bool isThereWarehouseBoundForUser = false;

  final TextEditingController _qtyController = TextEditingController();

  String projectId = "";
  String projectName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserSpecialWarehouseSettings();
    _getUserSpecialWarehouseSettingsForOut();
    inWareouse = widget.oldItem.inWarehouseName ?? "Giriş Ambarı";
    outWarehouse = widget.oldItem.outWarehouseName ?? "Çıkış Ambarı";
    inWareouseId = widget.oldItem.inWarehouseId.toString();
    outWarehouseId = widget.oldItem.outWarehouseId.toString();
    productId = widget.oldItem.productId.toString();
    projectId = widget.oldItem.projectId.toString();
    projectName = widget.oldItem.projectName.toString();
    qty = widget.oldItem.qty ?? 1;
    _qtyController.text = qty.toString();
    productName = widget.oldItem.description ?? "Ürün";
  }

  _getUserSpecialWarehouseSettings() async {
    String userSpecialSetting = await ServiceSharedPreferences.getSharedString(
            UserSpecialSettingsUtils.userWarehouseAuthIn) ??
        "";

    if (userSpecialSetting.isNotEmpty) {
      List<dynamic> decodedValue = jsonDecode(userSpecialSetting);
      setState(() {
        userSpecialWarehouseListForIn = List<String>.from(decodedValue);
        isThereWarehouseBoundForUser = true;
      });
    }
  }

  _getUserSpecialWarehouseSettingsForOut() async {
    String userSpecialSetting = await ServiceSharedPreferences.getSharedString(
            UserSpecialSettingsUtils.userWarehouseAuthOut) ??
        "";

    if (userSpecialSetting.isNotEmpty) {
      List<dynamic> decodedValue = jsonDecode(userSpecialSetting);
      setState(() {
        userSpecialWarehouseListForOut = List<String>.from(decodedValue);
        isThereWarehouseBoundForUser = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _qtyController,
          onChanged: (value) {
            qty = int.tryParse(value)!;
          },
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
        ),
        const SizedBox(
          height: 5,
        ),
        _selectBox(
          context,
          productName,
          productNameInit,
          () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) =>
                    GNSWhsTrsProductBottom(onValueChanged: (value) {
                      productItem = value;
                      productName = value.definition.toString();
                      productId = value.productId.toString();
                      setState(() {});
                    }));
          },
        ),
        const SizedBox(
          height: 5,
        ),
        _selectBox(
          context,
          outWarehouse,
          outWarehouseInit,
          () {
            showModalBottomSheet(
              context: context,
              builder: (context) => _outWarehouseBottomSheet(
                  isThereWarehouseBoundForUser
                      ? _limitWarehouseBasedOnSetting(
                          widget.workplaceWarehouseList,
                          userSpecialWarehouseListForOut)
                      : widget.workplaceWarehouseList),
            );
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
        const SizedBox(
          height: 5,
        ),
        GNSSelectProject(
          onValueChanged: (value) {
            projectId = value.projectId.toString();
            projectName = value.projectName.toString();
          },
          projectName: projectName,
          isErrorActive: false,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
            const SizedBox(
              width: 10,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              onPressed: (() {
                _createWarehouseTransferItems();
                Navigator.of(context).pop();
              }),
              child: const Text(
                "Güncelle",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        )
      ],
    );
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

  Widget _productListBottomSheet(ProductListReponse response) {
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
                    "Ürünler",
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
                        itemCount: response.products!.items!.length,
                        itemBuilder: (context, index) {
                          return _selectingAreaRowItem(
                              response.products!.items![index].definition!, () {
                            productItem = response.products!.items![index];
                            productName =
                                response.products!.items![index].definition!;
                            productId =
                                response.products!.items![index].productId!;
                            Navigator.pop(context);
                            setState(() {});
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => _outWarehouseBottomSheet(
                                  widget.workplaceWarehouseList),
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

  Widget _inWarehouseBottomSheet(List<WorkplaceWarehouse> warehouse) {
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

  Widget _outWarehouseBottomSheet(List<WorkplaceWarehouse> warehouse) {
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
                    "Ambarlar (Çıkış)",
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
                            outWarehouse = warehouse[index].code!;
                            outWarehouseId = warehouse[index].warehouseId!;
                            Navigator.pop(context);
                            setState(() {});

                            showModalBottomSheet(
                              context: context,
                              builder: (context) => _inWarehouseBottomSheet(
                                  isThereWarehouseBoundForUser
                                      ? _limitWarehouseBasedOnSetting(
                                          widget.workplaceWarehouseList,
                                          userSpecialWarehouseListForIn)
                                      : widget.workplaceWarehouseList),
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

  void _createWarehouseTransferItems() {
    WarehouseTransferLocalItems updatedItem = WarehouseTransferLocalItems(
      productId: productId,
      description: productName,
      outWarehouseId: outWarehouseId,
      outWarehouseName: outWarehouse,
      inWarehouseId: inWareouseId,
      inWarehouseName: inWareouse,
      unitId: productItem == null
          ? widget.oldItem.unitId
          : productItem?.unit?.unitId,
      unitConversionId: productItem == null
          ? widget.oldItem.unitConversionId
          : productItem?.unit?.conversions?[0].unitConversionId,
      qty: qty,
      productLocationRelationId: 'PLR1',
      erpId: productItem == null ? widget.oldItem.erpId : productItem?.erpId,
      erpCode:
          productItem == null ? widget.oldItem.erpCode : productItem?.erpCode,
      projectId: projectId,
      projectName: projectName,
    );

    widget.onValueChanged(updatedItem);
  }
}
