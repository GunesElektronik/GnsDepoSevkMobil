import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/models/new_api/order_detail_new_model.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';

class MultiSalesOrderListItemRow extends StatefulWidget {
  MultiSalesOrderListItemRow(
      {super.key,
      required this.item,
      required this.departments,
      required this.newWarehouseName,
      required this.newWarehouseId});
  OrderItems item;
  List<Departments> departments;
  final ValueChanged<String?> newWarehouseName;
  final ValueChanged<String?> newWarehouseId;
  @override
  State<MultiSalesOrderListItemRow> createState() =>
      _MultiSalesOrderListItemRowState();
}

class _MultiSalesOrderListItemRowState
    extends State<MultiSalesOrderListItemRow> {
  bool isProductLocation = false;
  late String workplaceName;
  String warehouseName = "";
  String warehouseId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isProductLocation = widget.item.product!.isProductLocatin!;
    workplaceName = widget.item.warehouseName!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10.0), // Köşeleri yuvarlatılmış bir kart
            ),
            color: const Color(0xfff1f1f1),
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                contentPadding: const EdgeInsets.only(right: 10, left: 10),
                leading: Text(
                  serilotType(widget.item.product!.productTrackingMethod!),
                  style: _textStyle(
                      17, FontWeight.normal, const Color(0xff707070)),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   width: 55,
                    //   height: 25,
                    //   child: TextField(
                    //     textAlign: TextAlign.center,
                    //     textAlignVertical: TextAlignVertical.center,
                    //     style: const TextStyle(
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.w900,
                    //       color: Colors.black,
                    //     ),
                    //     inputFormatters: [
                    //       FilteringTextInputFormatter.digitsOnly
                    //     ],
                    //     keyboardType: TextInputType.number,
                    //     decoration: const InputDecoration(
                    //         border: InputBorder.none,
                    //         contentPadding:
                    //             EdgeInsets.only(left: 5, right: 5, top: -36),
                    //         filled: true,
                    //         fillColor: Colors.white),
                    //     cursorColor: const Color(0xff8a9a99),
                    //   ),
                    // ),
                    Text(
                      "${widget.item.shippedQty!.toInt()} / ${widget.item.qty!.toInt()}",
                      style: _textStyle(
                          18, FontWeight.bold, const Color(0xff8e9d9a)),
                    ),
                  ],
                ),
                title: Text(
                  widget.item.product!.code!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      _textStyle(13, FontWeight.w700, const Color(0xff717171)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // isProductLocation
                    //     ? ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //           elevation: 0,
                    //           backgroundColor: Colors.orange[500],
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(
                    //                 3), // Kenar yarıçapını belirler
                    //           ),
                    //           padding:
                    //               const EdgeInsets.symmetric(horizontal: 10),
                    //         ),
                    //         onPressed: _selectWarehouse,
                    //         child: const Text(
                    //           "Depo Seç",
                    //           style: TextStyle(
                    //               color: Colors.black,
                    //               fontWeight: FontWeight.bold),
                    //         ))
                    //     :
                    Text(
                      "$workplaceName - $warehouseName",
                      overflow: TextOverflow.ellipsis,
                      style: _textStyle(
                          14, FontWeight.w600, const Color(0xff8e9796)),
                    ),
                    Text(
                      widget.item.product!.definition!,
                      overflow: TextOverflow.ellipsis,
                      style: _textStyle(
                          12, FontWeight.normal, const Color(0xff707070)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _selectWarehouse() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _departmentsBottomSheet(widget.departments),
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
                    "Departmanlar",
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
                            workplaceName = departments[index].code!;
                            Navigator.pop(context);
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => _warehouseBottomSheet(
                                  departments[index].warehouse!),
                            ).then((value) {
                              setState(() {
                                isProductLocation = false;
                              });
                            });
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
                    "Ambarlar",
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
                            widget.newWarehouseName(warehouseName);
                            widget.newWarehouseId(warehouseId);
                            Navigator.pop(context);
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

  TextStyle _textStyle(double fontSize, FontWeight fontWeight, Color color) {
    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  String serilotType(String type) {
    if (type == "Normal") {
      return "N";
    } else if (type == "seri") {
      return "S";
    } else if (type == "lot") {
      return "L";
    } else {
      return "Z";
    }
  }
}
