import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/database/model/product_barcodes_item.dart';
import 'package:gns_warehouse/database/model/waybills_item_loca.dart';
import 'package:gns_warehouse/models/product_barcode_detail_response.dart';
import 'package:gns_warehouse/pages/multi_sales_order/components/multi_sales_order_scan_product_item_row.dart';
import 'package:gns_warehouse/pages/purchase_order_waybills/component/waybills_scan_area.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';

class MultiSalesOrderScanPage extends StatefulWidget {
  MultiSalesOrderScanPage(
      {super.key, required this.multiSalesItemLocal, required this.ficheNo, required this.productBarcodesLocalList});

  List<WaybillItemLocalModel>? multiSalesItemLocal;
  List<ProductBarcodesItemLocal>? productBarcodesLocalList;

  String ficheNo;

  @override
  State<MultiSalesOrderScanPage> createState() => _MultiSalesOrderScanPageState();
}

class _MultiSalesOrderScanPageState extends State<MultiSalesOrderScanPage> {
  String _scannedBarcode = "";
  String seriOrBarcode = "barcode";
  String productId = "";
  int _scannedTimes = 1;
  late ApiRepository apiRepository;
  final DbHelper _dbHelper = DbHelper.instance;
  String orderItemId = "";
  List<WaybillItemLocalModel> currentLocalData = [];
  late String multiSaledId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.multiSalesItemLocal!.isNotEmpty) {
      multiSaledId = widget.multiSalesItemLocal![0].waybillsId!;
    }
    _createApiRepository();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
  }

  bool _isMatchWithEnteredBarcode(String barcode) {
    if (barcode.isNotEmpty) {
      for (int i = 0; i < widget.multiSalesItemLocal!.length; i++) {
        if (widget.multiSalesItemLocal![i].barcode == barcode) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  int _isMatchWithEnteredBarcode2(String barcode) {
    List<WaybillItemLocalModel> matchedBarcodeItemList = [];
    if (barcode.isNotEmpty) {
      for (int i = 0; i < widget.multiSalesItemLocal!.length; i++) {
        if (widget.multiSalesItemLocal![i].barcode == barcode) {
          matchedBarcodeItemList.add(widget.multiSalesItemLocal![i]);
        }
      }
    }

    if (matchedBarcodeItemList.length == 1) {
      orderItemId = matchedBarcodeItemList[0].orderItemId!;
      return 1;
    } else if (matchedBarcodeItemList.length > 1) {
      _autoSelectBasedOnFicheDateForMainBarcode(matchedBarcodeItemList);
      setState(() {});
      // showModalBottomSheet(
      //   context: context,
      //   // builder: (context) => bottomSheet(matchedBarcodeItemList),
      //   builder: (context) => WaybillsOrderScanItemBottom(
      //     matchedBarcodeItemList: matchedBarcodeItemList,
      //     orderItemIdChanged: (value) {
      //       orderItemId = value;
      //       setState(() {});
      //       print(orderItemId);
      //     },
      //   ),
      // );
      // _showDialogMessage("Birden Çok Barkod Bulundu",
      //     "İlgili yere gidip okutmak istediğiniz ürünün üstüne basılı tutun.");
      return 2;
    } else {
      return -1;
    }
  }

  int _isMatchWithEnteredBarcodeWithProductBarcodeList(String barcode) {
    List<CombineItemAndProductBarcodesItem> matchedBarcodeItemList = [];
    List<ProductBarcodesItemLocal> matchedBarcodeWithProductList = [];
    if (barcode.isNotEmpty) {
      for (int i = 0; i < widget.productBarcodesLocalList!.length; i++) {
        if (widget.productBarcodesLocalList![i].barcode == barcode) {
          matchedBarcodeWithProductList.add(widget.productBarcodesLocalList![i]);
        }
      }
    }

    matchedBarcodeWithProductList.forEach((barcodeElement) {
      widget.multiSalesItemLocal!.forEach((itemElement) {
        if (itemElement.productId! == barcodeElement.productId) {
          matchedBarcodeItemList
              .add(CombineItemAndProductBarcodesItem(waybillItem: itemElement, productBarcodeItem: barcodeElement));
        }
      });
    });

    if (matchedBarcodeItemList.length == 1) {
      orderItemId = matchedBarcodeItemList[0].waybillItem.orderItemId!;
      _scannedTimes = matchedBarcodeItemList[0].productBarcodeItem.convParam2!;

      return 1;
    } else if (matchedBarcodeItemList.length > 1) {
      _autoSelectBasedOnFicheDateForOtherBarcode(matchedBarcodeItemList);
      setState(() {});
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scannedTimes = 1;
        orderItemId = "";
      });
      // showModalBottomSheet(
      //   context: context,
      //   // builder: (context) => bottomSheet(matchedBarcodeItemList),
      //   builder: (context) => SalesPurchaseOrderScanItemBottom(
      //     combineItemList: matchedBarcodeItemList,
      //     combineItemSelected: (value) {
      //       orderItemId = value.waybillItem.orderItemId!;
      //       _scannedTimes = value.productBarcodeItem.convParam2!;
      //       setState(() {});
      //       SchedulerBinding.instance.addPostFrameCallback((_) {
      //         _scannedTimes = 1;
      //         orderItemId = "";
      //       });
      //     },
      //   ),
      // );
      // _showDialogMessage("Birden Çok Barkod Bulundu",
      //     "İlgili yere gidip okutmak istediğiniz ürünün üstüne basılı tutun.");
      return 2;
    } else {
      return -1;
    }
  }

  Future<void> _autoSelectBasedOnFicheDateForMainBarcode(List<WaybillItemLocalModel> filteredList) async {
    currentLocalData = await _dbHelper.getMultiSalesOrderDetailItemList(multiSaledId) ?? [];

    WaybillItemLocalModel? selectedItem;

    filteredList.forEach((filteredItem) {
      currentLocalData.forEach((currentItem) {
        if (currentItem.orderItemId == filteredItem.orderItemId) {
          if ((currentItem.scannedQty! + currentItem.shippedQty! + _scannedTimes) <= currentItem.qty!) {
            if (selectedItem == null || currentItem.ficheDate!.isBefore(selectedItem!.ficheDate!)) {
              selectedItem = currentItem;
            }
          }
        }
      });
    });

    if (selectedItem != null) {
      print(selectedItem!.ficheDate.toString());
      orderItemId = selectedItem!.orderItemId!;
    }
  }

  Future<void> _autoSelectBasedOnFicheDateForOtherBarcode(List<CombineItemAndProductBarcodesItem> filteredList) async {
    currentLocalData = await _dbHelper.getMultiSalesOrderDetailItemList(multiSaledId) ?? [];

    WaybillItemLocalModel? selectedItem;
    int? selectedScannedTimes;

    filteredList.forEach((filteredItem) {
      currentLocalData.forEach((currentItem) {
        if (currentItem.orderItemId == filteredItem.waybillItem.orderItemId) {
          if ((currentItem.scannedQty! + currentItem.shippedQty! + filteredItem.productBarcodeItem.convParam2!) <=
              currentItem.qty!) {
            if (selectedItem == null || currentItem.ficheDate!.isBefore(selectedItem!.ficheDate!)) {
              selectedItem = currentItem;
              selectedScannedTimes = filteredItem.productBarcodeItem.convParam2!;
            }
          }
        }
      });
    });

    if (selectedItem != null) {
      orderItemId = selectedItem!.orderItemId!;
      _scannedTimes = selectedScannedTimes!;
    }
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
          borderRadius: BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      body: PopScope(
        canPop: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Container(
            color: const Color(0xfffafafa),
            child: Column(
              children: [
                WaybillScanArea(
                  onBarcodeChanged: (value) async {
                    if (value.toString().isNotEmpty) {
                      _scannedBarcode = value!;
                    }

                    int caseNumber = _isMatchWithEnteredBarcode2(_scannedBarcode);

                    if (caseNumber == 1) {
                      setState(() {});
                    } else if (caseNumber == 2) {
                    } else {
                      int caseNumber = _isMatchWithEnteredBarcodeWithProductBarcodeList(_scannedBarcode);
                      if (caseNumber == 1) {
                        setState(() {});
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          _scannedTimes = 1;
                          orderItemId = "";
                        });
                      } else if (caseNumber == 2) {
                      } else {
                        print("bulunamadı");
                        //bulunamadı
                      }
                    }
                  },
                  seriOrBarcode: (value) {
                    setState(() {
                      _scannedBarcode = "";
                      seriOrBarcode = value;
                    });
                  },
                  scannedTimes: (value) {
                    _scannedTimes = value ?? 1;
                  },
                ),
                _fisnoText(),
                // Expanded(
                //   child: SingleChildScrollView(
                //     child: Column(children: [
                //       ListView.builder(
                //         primary: false,
                //         shrinkWrap: true,
                //         itemCount: widget.multiSalesItemLocal!.length,
                //         itemBuilder: (context, index) {
                //           return MultiSalesOrderScanProductItemRow(
                //             item: widget.multiSalesItemLocal![index],
                //             index: index,
                //             scannedBarcode: _scannedBarcode,
                //             scannedTimes: _scannedTimes,
                //             seriOrBarcode: seriOrBarcode,
                //             orderItemId: orderItemId,
                //           );
                //         },
                //       ),
                //     ]),
                //   ),
                // ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: widget.multiSalesItemLocal!.map((item) {
                        int index = widget.multiSalesItemLocal!.indexOf(item);
                        return MultiSalesOrderScanProductItemRow(
                          item: item,
                          index: index,
                          scannedBarcode: _scannedBarcode,
                          scannedTimes: _scannedTimes,
                          seriOrBarcode: seriOrBarcode,
                          orderItemId: orderItemId,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _anyBarcodeNoMatch() {
    for (int i = 0; i < widget.multiSalesItemLocal!.length; i++) {
      if (widget.multiSalesItemLocal![i].barcode == _scannedBarcode) {
        return true;
      }
    }

    return false;
  }

  Padding _fisnoText() {
    return Padding(
      padding: EdgeInsets.only(left: 5, top: 5, right: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.ficheNo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff6f6f6f),
              ),
            ),
            /*
            const Text(
              "2 / 5",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffe54827),
              ),
            )
            */
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        "SİPARİŞ TOPLAMA",
        style: TextStyle(color: Colors.deepOrange[700], fontWeight: FontWeight.w600, fontSize: 20),
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
            ))
      ],
      leading: IconButton(
        onPressed: () async {
          scanQRCode();
          /*
          late ApiRepository apiRepository;
          apiRepository = await ApiRepository.create();
          await apiRepository.getProductBasedOnBarcode(
              widget.orderId, _barcodeController.text);
              */
        },
        iconSize: 28,
        icon: const Icon(Icons.camera_alt_rounded),
      ),
    );
  }

  Padding _button(String content, Color textColor, Color backgroundColor, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: const MaterialStatePropertyAll(0),
                backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
              ),
              onPressed: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  content,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showDialogForIsMatchBarcode(BuildContext context, String barcode) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
        ),
        actions: [
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              child: const Text(
                "Tamam",
                style: TextStyle(color: Colors.black),
              )),
        ],
        title: const Text("BARKOD BULUNAMADI !"),
        contentPadding: const EdgeInsets.all(20.0),
        content: Text("$barcode diye bir barkod bulunamadı !"),
      ),
    );
  }

  Future<dynamic> showDialogForIsMatchBarcodeVer2(BuildContext context, String barcode) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: const BorderSide(color: Color.fromARGB(255, 143, 143, 143), width: 2),
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            child: const Text("Ekleme Başarısız"),
          ),
        ],
        title: Container(
          alignment: Alignment.center,
          child: Text(
            "$barcode",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        contentPadding: const EdgeInsets.all(20.0),
        content: SvgPicture.asset(
          "assets/svg/ambar_transfer.svg",
          width: 50,
          height: 50,
        ),
      ),
    );
  }

  Future<void> scanQRCode() async {
    try {
      bool isSuccess = false;

      // await FlutterBarcodeScanner.scanBarcode(
      //         '#ff6666', 'Cancel', true, ScanMode.BARCODE)
      //     .then((value) => {
      //           if (value == "-1")
      //             {}
      //           else if (value.length > 0 || value.trim() != "-1")
      //             {isSuccess = true, _scannedBarcode = value}
      //         });

      if (isSuccess) {
        if (_scannedBarcode.isNotEmpty) {
          setState(() {});
        }
      }
    } on PlatformException {
      print("platform uyumsuz");
    }

    if (!mounted) return;
  }

  // Widget bottomSheet(List<WaybillItemLocalModel> matchedBarcodeItemList) {
  //   double leftPadding = 8.0;
  //   return Container(
  //     width: double.infinity,
  //     height: 400,
  //     decoration: BoxDecoration(
  //       color: Colors.grey[400],
  //       borderRadius: const BorderRadius.only(
  //         topLeft: Radius.circular(20.0),
  //         topRight: Radius.circular(20.0),
  //       ),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(5.0),
  //       child: ListView.builder(
  //           primary: false,
  //           shrinkWrap: true,
  //           itemCount: matchedBarcodeItemList.length,
  //           itemBuilder: (context, index) {
  //             return Card(
  //               elevation: 0,
  //               color: const Color(0xfff1f1f1),
  //               child: InkWell(
  //                 onLongPress: () {},
  //                 highlightColor: const Color.fromARGB(255, 179, 199, 211),
  //                 splashColor: Colors.transparent,
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: ListTile(
  //                   contentPadding: const EdgeInsets.only(right: 15, left: 15),
  //                   trailing: Text(
  //                     "${matchedBarcodeItemList[index].shippedQty! + matchedBarcodeItemList[index].scannedQty!} / ${matchedBarcodeItemList[index].qty}",
  //                     style: TextStyle(
  //                         fontSize: 19,
  //                         fontWeight: FontWeight.bold,
  //                         color: selectColor(
  //                             matchedBarcodeItemList[index].shippedQty! +
  //                                 matchedBarcodeItemList[index].scannedQty!,
  //                             matchedBarcodeItemList[index].qty!)),
  //                   ),
  //                   title: Text(
  //                     "${matchedBarcodeItemList[index].barcode}",
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: const TextStyle(
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.w700,
  //                       color: Color(0xff727272),
  //                     ),
  //                   ),
  //                   subtitle: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           "${matchedBarcodeItemList[index].productName}",
  //                           style: TextStyle(
  //                               fontSize: 14,
  //                               fontWeight: FontWeight.normal,
  //                               color: Colors.grey[700]),
  //                         ),
  //                       ]),
  //                 ),
  //               ),
  //             );
  //           }),
  //     ),
  //   );
  // }
}

class WaybillsOrderScanItemBottom extends StatefulWidget {
  WaybillsOrderScanItemBottom({
    super.key,
    required this.matchedBarcodeItemList,
    required this.orderItemIdChanged,
  });

  List<WaybillItemLocalModel> matchedBarcodeItemList;
  final ValueChanged<String> orderItemIdChanged;
  @override
  State<WaybillsOrderScanItemBottom> createState() => _WaybillsOrderScanItemBottomState();
}

class _WaybillsOrderScanItemBottomState extends State<WaybillsOrderScanItemBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: widget.matchedBarcodeItemList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0,
                color: const Color(0xfff1f1f1),
                child: InkWell(
                  onTap: () {
                    widget.orderItemIdChanged(widget.matchedBarcodeItemList[index].orderItemId!);
                    //scannedqty + shippedqty < qty ise 1 arttırır.
                    // if (widget.matchedBarcodeItemList[index].scannedQty! +
                    //         widget.matchedBarcodeItemList[index].shippedQty! +
                    //         widget.scannedTimes <=
                    //     widget.matchedBarcodeItemList[index].qty!) {
                    //   widget.matchedBarcodeItemList[index].scannedQty =
                    //       widget.matchedBarcodeItemList[index].scannedQty! +
                    //           widget.scannedTimes;
                    //   setState(() {});
                    // }
                  },
                  highlightColor: const Color.fromARGB(255, 179, 199, 211),
                  splashColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(right: 15, left: 15),
                    trailing: Text(
                      "${widget.matchedBarcodeItemList[index].qty}",
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: selectColor(
                              widget.matchedBarcodeItemList[index].shippedQty! +
                                  widget.matchedBarcodeItemList[index].scannedQty!,
                              widget.matchedBarcodeItemList[index].qty!)),
                    ),
                    title: Text(
                      "${widget.matchedBarcodeItemList[index].barcode}",
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
                        "${widget.matchedBarcodeItemList[index].productName}",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[700]),
                      ),
                      Text(
                        "${widget.matchedBarcodeItemList[index].warehouseName}",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[700]),
                      ),
                    ]),
                  ),
                ),
              );
            }),
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
}

class SalesPurchaseOrderScanItemBottom extends StatefulWidget {
  SalesPurchaseOrderScanItemBottom({
    super.key,
    required this.combineItemList,
    required this.combineItemSelected,
  });

  List<CombineItemAndProductBarcodesItem> combineItemList;
  final ValueChanged<CombineItemAndProductBarcodesItem> combineItemSelected;
  @override
  State<SalesPurchaseOrderScanItemBottom> createState() => _SalesPurchaseOrderScanItemBottomState();
}

class _SalesPurchaseOrderScanItemBottomState extends State<SalesPurchaseOrderScanItemBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: widget.combineItemList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0,
                color: const Color(0xfff1f1f1),
                child: InkWell(
                  onTap: () {
                    widget.combineItemSelected(widget.combineItemList[index]);
                    //scannedqty + shippedqty < qty ise 1 arttırır.
                    // if (widget.matchedBarcodeItemList[index].scannedQty! +
                    //         widget.matchedBarcodeItemList[index].shippedQty! +
                    //         widget.scannedTimes <=
                    //     widget.matchedBarcodeItemList[index].qty!) {
                    //   widget.matchedBarcodeItemList[index].scannedQty =
                    //       widget.matchedBarcodeItemList[index].scannedQty! +
                    //           widget.scannedTimes;
                    //   setState(() {});
                    // }
                  },
                  highlightColor: const Color.fromARGB(255, 179, 199, 211),
                  splashColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(right: 15, left: 15),
                    trailing: Text(
                      "${widget.combineItemList[index].waybillItem.qty}",
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: selectColor(
                              widget.combineItemList[index].waybillItem.shippedQty! +
                                  widget.combineItemList[index].waybillItem.scannedQty!,
                              widget.combineItemList[index].waybillItem.qty!)),
                    ),
                    title: Text(
                      "${widget.combineItemList[index].productBarcodeItem.barcode}",
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
                        "${widget.combineItemList[index].waybillItem.productName}",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[700]),
                      ),
                      Text(
                        "${widget.combineItemList[index].waybillItem.warehouseName}",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[700]),
                      ),
                    ]),
                  ),
                ),
              );
            }),
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
}

class CombineItemAndProductBarcodesItem {
  final WaybillItemLocalModel waybillItem;
  final ProductBarcodesItemLocal productBarcodeItem;

  CombineItemAndProductBarcodesItem({required this.waybillItem, required this.productBarcodeItem});
}
