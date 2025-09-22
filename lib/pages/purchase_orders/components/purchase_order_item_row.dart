import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/database/model/order_detail_scanned_item.dart';
import 'package:gns_warehouse/database/model/product_stock_warehouse_location.dart';
import 'package:gns_warehouse/database/model/purchase_order_detail_item_db.dart';
import 'package:gns_warehouse/database/model/purchase_order_detail_scanned_item.dart';
import 'package:gns_warehouse/models/new_api/locations/stock_locations_list_response.dart';
import 'package:gns_warehouse/models/new_api/product_location_list_response.dart';
import 'package:gns_warehouse/models/order_detail/order_detail_item_db.dart';
import 'package:gns_warehouse/pages/order_detail/order_scan_seri_page.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';

class PurchaseOrderProductItemRow extends StatefulWidget {
  PurchaseOrderProductItemRow({
    super.key,
    required this.item,
    required this.index,
    required this.scannedBarcode,
    required this.scannedTimes,
    required this.seriOrBarcode,
    this.productId,
  });

  PurchaseOrderDetailItemDB item;
  int index;
  String scannedBarcode;
  int scannedTimes;
  String seriOrBarcode;
  String? productId;

  @override
  State<PurchaseOrderProductItemRow> createState() =>
      _PurchaseOrderProductItemRowState();
}

class _PurchaseOrderProductItemRowState
    extends State<PurchaseOrderProductItemRow> {
  bool _isVisible = false;
  bool _isAddNewItemRow = false;
  int deneme = 0;
  bool firstLoad = false;
  final DbHelper _dbHelper = DbHelper.instance;
  List<PurchaseOrderDetailScannedItemDB>? orderDetailScannedItems = [];
  late int itemType;
  late int whichTabBarActive;
  bool isGetStockInfo = false;
  bool _showProductStock = false;
  late ApiRepository apiRepository;
  ProductStockWarehouseResponse? response;
  bool isLocationResponseFetched = false;
  late StockLocationsListResponse locationResponse;
  late bool isProductLocatin;
  String stockLocationId = "";
  String stockLocationName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getScannedListFromDB();
    isProductLocatin = widget.item.isProductLocatin!;
    stockLocationName = widget.item.stockLocationName.toString();
    itemType = widget.item.serilotType!;
    deneme3();
    _getStockInfo();
    whichTabBarActive = _whichTabBarActive(widget.seriOrBarcode);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.scannedBarcode = "";
  }

  @override
  void didUpdateWidget(PurchaseOrderProductItemRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    whichTabBarActive = _whichTabBarActive(widget.seriOrBarcode);
    if (widget.scannedTimes == 0) {
      widget.scannedTimes = 1;
    }
    //print("değer: ${widget.scannedTimes}");
    if (widget.productId == widget.item.productId &&
        deneme + widget.scannedTimes <= widget.item.qty!) {
      if (whichTabBarActive == itemType) {
        _deneme1();
      } else {
        print("olmadı");
      }
    } else {
      if (widget.scannedBarcode == widget.item.productBarcode &&
          deneme + widget.scannedTimes <= widget.item.qty!) {
        if (whichTabBarActive == itemType) {
          _deneme1();
        } else {
          print("olmadı");
        }
      } else {}
    }
  }

  int _whichTabBarActive(String seriOrBarcode) {
    if (seriOrBarcode == "barcode") {
      return 1;
    } else if (seriOrBarcode == "seri") {
      return 3;
    } else {
      return -1;
    }
  }

  _deneme1() async {
    await _dbHelper.addPurchaseOrderDetailScannedItem(
        widget.item.ficheNo!,
        //widget.item.productBarcode!,
        widget.scannedBarcode!,
        widget.scannedTimes,
        widget.item.orderItemId!,
        stockLocationId,
        stockLocationName,
        widget.item.warehouse!);
    // orderDetailScannedItems = await _dbHelper.getPurchaseOrderDetailScannedItem(
    //     widget.item.ficheNo!, widget.item.orderItemId!, widget.item.warehouse!);
    orderDetailScannedItems = await _dbHelper.getPurchaseOrderDetailScannedItem(
        widget.item.ficheNo!, widget.item.orderItemId!);
    deneme += widget.scannedTimes;
    await _dbHelper.updatePurchaseOrderDetailItemScannedQty(deneme,
        widget.item.ficheNo!, widget.item.orderItemId!, widget.item.warehouse!);
    setState(() {});
  }

  _deneme2(PurchaseOrderDetailScannedItemDB item) async {
    await _dbHelper.clearPurchaseOrderDetailScannedItem(
        item.recid!, item.ficheNo!, item.orderItemId!);
    orderDetailScannedItems = await _dbHelper.getPurchaseOrderDetailScannedItem(
        widget.item.ficheNo!, widget.item.orderItemId!);
    deneme -= item.numberOfPieces!;
    await _dbHelper.updatePurchaseOrderDetailItemScannedQty(deneme,
        widget.item.ficheNo!, widget.item.orderItemId!, widget.item.warehouse!);
    setState(() {});
  }

  deneme3() async {
    deneme = widget.item.scannedQty!;
    orderDetailScannedItems = await _dbHelper.getPurchaseOrderDetailScannedItem(
      widget.item.ficheNo!,
      widget.item.orderItemId!,
    );
    firstLoad = true;
    setState(() {});
  }

  _getStockInfo() async {
    apiRepository = await ApiRepository.create(context);
    try {
      response =
          await apiRepository.getProductStockWarehouse(widget.item.productId!);
      if (isProductLocatin) {
        locationResponse = await apiRepository.getAllLocationList();
        stockLocationId = locationResponse
            .stockLocations!.items![0].stockLocationId
            .toString();
        stockLocationName =
            locationResponse.stockLocations!.items![0].name.toString();
      }

      setState(() {
        isLocationResponseFetched = true;
        isGetStockInfo = true;
      });
    } catch (e) {
      print(e);
    }
  }

/*
  _getScannedListFromDB() async {
    orderDetailScannedItems = await _dbHelper.getOrderDetailScannedItem(
        widget.item.ficheNo!,
        widget.item.productBarcode!,
        widget.item.warehouse!);
    orderDetailScannedItems!.forEach(
      (element) {
        deneme += element.numberOfPieces!;
      },
    );
    //print("${widget.item.productBarcode}: ${orderDetailScannedItems!.length}");
    firstLoad = true;

    //await _dbHelper.clearAllOrderDetailScannedItems(
    //    widget.item.ficheNo!, widget.item.productBarcode!);
    setState(() {});
  }

  _getScannedListFromDB2() async {
    if (!_isAddNewItemRow) {
      await _dbHelper.addOrderDetailScannedItem(
          widget.item.ficheNo!,
          widget.item.productBarcode!,
          widget.scannedTimes,
          widget.item.orderItemId!,
          widget.item.warehouse!);
      orderDetailScannedItems = await _dbHelper.getOrderDetailScannedItem(
          widget.item.ficheNo!,
          widget.item.productBarcode!,
          widget.item.warehouse!);
      _isAddNewItemRow = true;
      deneme += widget.scannedTimes;
      await _dbHelper.updateOrderDetailItemScannedQty(
          deneme,
          widget.item.ficheNo!,
          widget.item.productBarcode!,
          widget.item.warehouse!);
      setState(() {});
    } else {
      _isAddNewItemRow = false;
    }
  }

  _deleteRow(OrderDetailScannedItemDB item) async {
    if (!_isAddNewItemRow) {
      await _dbHelper.clearOrderDetailScannedItem(
          item.recid!, item.ficheNo!, item.productBarcode!);
      orderDetailScannedItems = await _dbHelper.getOrderDetailScannedItem(
          widget.item.ficheNo!,
          widget.item.productBarcode!,
          widget.item.warehouse!);
      _isAddNewItemRow = true;
      deneme -= item.numberOfPieces!;
      await _dbHelper.updateOrderDetailItemScannedQty(
          deneme,
          widget.item.ficheNo!,
          widget.item.productBarcode!,
          widget.item.warehouse!);
      setState(() {});
      _isAddNewItemRow = false;
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    print("${widget.item.productBarcode} build çalıştı");

    return firstLoad
        ? itemType == 1
            ? _rowItem(context)
            : _rowItem(context)
        : const Center(child: CircularProgressIndicator());
  }

  int _numberOfScannedItems() {
    int number = 0;
    orderDetailScannedItems!.forEach((element) {
      number += element.numberOfPieces!.toInt();
    });
    return number;
  }

  Padding _rowItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        children: [
          Slidable(
            endActionPane: ActionPane(motion: const StretchMotion(), children: [
              SlidableAction(
                onPressed: (context) {
                  setState(() {
                    _showProductStock = !_showProductStock;
                  });
                },
                backgroundColor: const Color.fromARGB(255, 154, 194, 201),
                icon: Icons.warehouse_rounded,
                borderRadius: BorderRadius.circular(10.0),
                label: "Stok Durumu Göster",
              ),
            ]),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    10.0), // Köşeleri yuvarlatılmış bir kart
              ),
              color: const Color(0xfff1f1f1),
              elevation: 0,
              child: InkWell(
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _productLogBottomSheet(),
                  );
                },
                onTap: () {
                  setState(() {
                    _isVisible = !_isVisible;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                  ),
                  leading: Text(
                    (widget.index + 1 < 10)
                        ? "0${widget.index + 1} ${serilotType(itemType)}"
                        : "${widget.index + 1} ${serilotType(itemType)}",
                    style: _textStyle(
                        17, FontWeight.normal, const Color(0xff707070)),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.item.productBarcode}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _textStyle(
                                15, FontWeight.w700, const Color(0xff727272)),
                          ),
                          Text(
                            "${widget.item.productName}",
                            style: _textStyle(
                                14, FontWeight.normal, const Color(0xff707070)),
                          ),
                          isProductLocatin
                              ? IconButton(
                                  icon: const Icon(Icons.warehouse_outlined),
                                  color: Colors.deepOrange,
                                  onPressed: isLocationResponseFetched
                                      ? () async {
                                          // await _dbHelper.updateLocationArea(
                                          //     "13131",
                                          //     "5615615",
                                          //     widget.item.orderId!,
                                          //     widget.item.orderItemId!,
                                          //     widget.item.warehouse!);
                                          // print(
                                          //     "location: ${widget.item.stockLocationId} ${widget.item.stockLocationName}");
                                          _selectLocation();
                                        }
                                      : null,
                                  iconSize:
                                      25.0, // İkonun boyutunu buradan küçültebilirsin
                                )
                              : const SizedBox(),
                          // isProductLocatin
                          //     ? ElevatedButton(
                          //         onPressed: isLocationResponseFetched
                          //             ? () async {
                          //                 // await _dbHelper.updateLocationArea(
                          //                 //     "13131",
                          //                 //     "5615615",
                          //                 //     widget.item.orderId!,
                          //                 //     widget.item.orderItemId!,
                          //                 //     widget.item.warehouse!);
                          //                 // print(
                          //                 //     "location: ${widget.item.stockLocationId} ${widget.item.stockLocationName}");
                          //                 _selectLocation();
                          //               }
                          //             : null,
                          //         child: isLocationResponseFetched
                          //             ? const Text("Lokasyon Seç")
                          //             : const CupertinoActivityIndicator(
                          //                 color: Colors.deepOrange,
                          //               ),
                          //       )
                          //     : const SizedBox(),
                          isProductLocatin
                              ? Text(
                                  stockLocationName,
                                  style: _textStyle(14, FontWeight.normal,
                                      const Color(0xff707070)),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "${_numberOfScannedItems()}",
                            style:
                                _textStyle(20, FontWeight.bold, Colors.green),
                          ),
                          Text(
                            "$deneme / ${widget.item.qty}",
                            style: _textStyle(
                              15,
                              FontWeight.bold,
                              // selectColor(deneme, widget.item.qty!),
                              Colors.blueGrey,
                            ),
                          ),
                          Text(
                            "${widget.item.qty! - deneme}",
                            style: _textStyle(20, FontWeight.bold, Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                  // trailing: Text(
                  //   "$deneme / ${widget.item.qty}",
                  //   style: _textStyle(20, FontWeight.bold,
                  //       selectColor(deneme, widget.item.qty!)),
                  // ),
                  // title: Text(
                  //   "${widget.item.productBarcode}",
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: _textStyle(
                  //       15, FontWeight.w700, const Color(0xff727272)),
                  // ),
                  // subtitle: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       "${widget.item.productName}",
                  //       style: _textStyle(
                  //           14, FontWeight.normal, const Color(0xff707070)),
                  //     ),
                  //     isProductLocatin
                  //         ? IconButton(
                  //             icon: const Icon(Icons.warehouse_outlined),
                  //             color: Colors.deepOrange,
                  //             onPressed: isLocationResponseFetched
                  //                 ? () async {
                  //                     // await _dbHelper.updateLocationArea(
                  //                     //     "13131",
                  //                     //     "5615615",
                  //                     //     widget.item.orderId!,
                  //                     //     widget.item.orderItemId!,
                  //                     //     widget.item.warehouse!);
                  //                     // print(
                  //                     //     "location: ${widget.item.stockLocationId} ${widget.item.stockLocationName}");
                  //                     _selectLocation();
                  //                   }
                  //                 : null,
                  //             iconSize:
                  //                 25.0, // İkonun boyutunu buradan küçültebilirsin
                  //           )
                  //         : const SizedBox(),
                  //     isProductLocatin
                  //         ? Text(
                  //             stockLocationName,
                  //             style: _textStyle(14, FontWeight.normal,
                  //                 const Color(0xff707070)),
                  //           )
                  //         : const SizedBox(),
                  //   ],
                  // ),
                ),
              ),
            ),
          ),
          // Card(
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(
          //         10.0), // Köşeleri yuvarlatılmış bir kart
          //   ),
          //   color: const Color(0xfff1f1f1),
          //   elevation: 0,
          //   child: InkWell(
          //     onLongPress: () {
          //       showModalBottomSheet(
          //         context: context,
          //         builder: (context) => _productLogBottomSheet(),
          //       );
          //     },
          //     onTap: () {
          //       setState(() {
          //         _isVisible = !_isVisible;
          //       });
          //     },
          //     borderRadius: BorderRadius.circular(10),
          //     child: ListTile(
          //       contentPadding: const EdgeInsets.only(right: 10, left: 10),
          //       leading: Text(
          //         (widget.index + 1 < 10)
          //             ? "0${widget.index + 1} ${serilotType(itemType)}"
          //             : "${widget.index + 1} ${serilotType(itemType)}",
          //         style: _textStyle(
          //             17, FontWeight.normal, const Color(0xff707070)),
          //       ),
          //       trailing: Text(
          //         "$deneme / ${widget.item.qty}",
          //         style: _textStyle(20, FontWeight.bold,
          //             selectColor(deneme, widget.item.qty!)),
          //       ),
          //       title: Text(
          //         "${widget.item.productBarcode}",
          //         maxLines: 1,
          //         overflow: TextOverflow.ellipsis,
          //         style:
          //             _textStyle(15, FontWeight.w700, const Color(0xff727272)),
          //       ),
          //       subtitle: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "${widget.item.productName}",
          //             style: _textStyle(
          //                 14, FontWeight.normal, const Color(0xff707070)),
          //           ),
          //           SizedBox(
          //             height: 40,
          //             width: 100,
          //             child: TextButton(
          //               onPressed: () {
          //                 setState(() {
          //                   _showProductStock = !_showProductStock;
          //                 });
          //               },
          //               child: const Text(
          //                 "Stok Göster",
          //                 style: TextStyle(color: Colors.blueAccent),
          //                 textAlign: TextAlign.start,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 235, 252, 255),
            ),
            duration: const Duration(milliseconds: 100),
            height: _showProductStock ? 120 : 0,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isGetStockInfo
                      ? ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: response!.stockWarehouse!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                _column2(response!.stockWarehouse![index]),
                                _divider(),
                              ],
                            );
                          },
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xfffafafa),
            ),
            duration: const Duration(milliseconds: 100),
            height: _isVisible ? 200 : 0,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // _barcodeTypingArea(),
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: orderDetailScannedItems!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          _column(orderDetailScannedItems![index]),
                          _divider(),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _barcodeTypingArea() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 2),
      child: Container(
        color: const Color(0xfffafafa),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromARGB(255, 255, 232, 217),
                  ),
                  child: TextField(
                    //textAlignVertical: TextAlignVertical.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff8a9a99),
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(right: 7, left: 7),
                      border: InputBorder.none,
                      filled: false,
                      fillColor: Color.fromARGB(255, 255, 232, 217),
                    ),
                    cursorColor: const Color(0xff8a9a99),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.clear_rounded,
                  color: Color(0xff8a9a99),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromARGB(255, 255, 232, 217),
                  ),
                  child: const TextField(
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff8a9a99),
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 7, right: 7),
                        filled: false,
                        fillColor: Color.fromARGB(255, 255, 232, 217),
                        suffixIcon: Icon(
                          Icons.library_add_outlined,
                          color: Colors.black,
                        ),
                        border: InputBorder.none),
                    cursorColor: Color(0xff8a9a99),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _textStyle(double fontSize, FontWeight fontWeight, Color color) {
    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  Padding _divider() {
    return const Padding(
      padding: EdgeInsets.only(top: 0),
      child: Divider(
        color: Color.fromARGB(255, 201, 201, 201),
        thickness: 0.5,
      ),
    );
  }

  Column _column2(PStockWarehouse item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        "${item.warehouseName}",
                        style: const TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 44, 71, 87),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "${item.quantity}",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 44, 71, 87),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Slidable _column(PurchaseOrderDetailScannedItemDB item) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            //print("$index");
            //_deleteRow(item);
            _deneme2(item);
          },
          backgroundColor: Colors.red,
          icon: Icons.delete,
        )
      ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "${item.productBarcode}",
                      style: const TextStyle(
                          fontSize: 17, color: Color(0xff727272)),
                    ),
                    widget.item.isProductLocatin!
                        ? Text(
                            "${item.stockLocationName}",
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xff727272)),
                          )
                        : const SizedBox(),
                  ],
                ),
                Text(
                  "${item.numberOfPieces}",
                  style:
                      const TextStyle(fontSize: 17, color: Color(0xff727272)),
                ),
              ],
            ),
          ),
        ],
      ),
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

  Padding seriItem(BuildContext context) {
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
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _productLogBottomSheet(),
                );
              },
              onTap: () {
                /*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderScanSeriPage(
                              ficheNo: widget.item.ficheNo!,
                              item: widget.item,
                            ))).then((value) async {
                  var results = await _dbHelper.getOrderDetailItem(
                      widget.item.ficheNo!,
                      widget.item.orderItemId!,
                      widget.item.warehouse!);
                  widget.item = results!;
                  deneme = widget.item.scannedQty!;
                  setState(() {});
                });
                */
              },
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                contentPadding: const EdgeInsets.only(right: 10, left: 10),
                leading: Text(
                  (widget.index + 1 < 10)
                      ? "0${widget.index + 1} ${serilotType(itemType)}"
                      : "${widget.index + 1} ${serilotType(itemType)}",
                  style: _textStyle(
                      17, FontWeight.normal, const Color(0xff707070)),
                ),
                trailing: Text(
                  "$deneme / ${widget.item.qty}",
                  style: _textStyle(20, FontWeight.bold,
                      selectColor(deneme, widget.item.qty!)),
                ),
                title: Text(
                  "${widget.item.productBarcode}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      _textStyle(15, FontWeight.w700, const Color(0xff727272)),
                ),
                subtitle: Text(
                  "${widget.item.productName}",
                  style: _textStyle(
                      14, FontWeight.normal, const Color(0xff707070)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productLogBottomSheet() {
    Map<String, int> groupedItems = {};

    for (var item in orderDetailScannedItems!) {
      if (groupedItems.containsKey(item.stockLocationName)) {
        groupedItems[item.stockLocationName!] =
            groupedItems[item.stockLocationName]! + (item.numberOfPieces ?? 0);
      } else {
        groupedItems[item.stockLocationName!] = item.numberOfPieces ?? 0;
      }
    }

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
                    "Geçmiş İşlemler",
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
                        itemCount: groupedItems.length,
                        itemBuilder: (context, index) {
                          String stockLocationName =
                              groupedItems.keys.elementAt(index);
                          int totalPieces = groupedItems[stockLocationName]!;
                          return Column(
                            children: [
                              // _column(orderDetailScannedItems![index]),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(stockLocationName),
                                  Text(totalPieces.toString()),
                                ],
                              ),
                              _divider(),
                            ],
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

  _selectLocation() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _locationBottomSheet(),
    );
  }

  Widget _locationBottomSheet() {
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
                    "Lokasyon Seçin",
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
                        itemCount:
                            locationResponse.stockLocations!.items!.length,
                        itemBuilder: (context, index) {
                          return _selectingAreaRowItem(
                              locationResponse.stockLocations!.items![index]
                                  .name!, () async {
                            stockLocationName = locationResponse
                                .stockLocations!.items![index].name!;

                            stockLocationId = locationResponse
                                .stockLocations!.items![index].stockLocationId!;

                            await _dbHelper.updatePurchaseOrderLocationArea(
                                stockLocationId,
                                stockLocationName,
                                widget.item.purchaseOrderId!,
                                widget.item.orderItemId!,
                                widget.item.warehouse!);
                            Navigator.pop(context);
                            setState(() {});
/*
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
                            */
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
}
