import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/database/model/order_detail_scanned_item.dart';
import 'package:gns_warehouse/models/order_detail/order_detail_item_db.dart';

class OrderScanSeriPage extends StatefulWidget {
  OrderScanSeriPage({super.key, required this.ficheNo, required this.item});

  String ficheNo;
  OrderDetailItemDB item;
  @override
  State<OrderScanSeriPage> createState() => _OrderScanSeriPageState();
}

class _OrderScanSeriPageState extends State<OrderScanSeriPage> {
  TextEditingController _numberController = TextEditingController(text: '1');
  TextEditingController _barcodeController = TextEditingController();
  String _scannedBarcode = "";
  final FocusNode _barcodeFocusNode = FocusNode();
  final DbHelper _dbHelper = DbHelper.instance;
  List<OrderDetailScannedItemDB>? orderDetailScannedItems = [];
  int deneme = 0;
  bool isSeriBarcodeMatchAnother = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deneme = widget.item.scannedQty!;
    _getScannedItems();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _numberController.dispose();
    _barcodeController.dispose();
    //_barcodeFocusNode.dispose();
    _scannedBarcode = "";
  }

  void _getScannedItems() async {
    orderDetailScannedItems = await _dbHelper.getOrderDetailScannedItem(
      widget.item.ficheNo!,
      widget.item.orderItemId!,
    );
    setState(() {});
  }

  void _seriBarcodeScanned() async {
    isSeriBarcodeMatchAnother = false;
    if (_scannedBarcode != "") {
      orderDetailScannedItems!.forEach((element) {
        if (element.productBarcode == _scannedBarcode) {
          isSeriBarcodeMatchAnother = true;
          return;
        }
      });
      if (!isSeriBarcodeMatchAnother) {
        await _dbHelper.addOrderDetailScannedItem(widget.item.ficheNo!, _scannedBarcode, 1, widget.item.orderItemId!,
            "stockLocationId", "stockLocationName", widget.item.warehouse!);
        orderDetailScannedItems = await _dbHelper.getOrderDetailScannedItem(
          widget.item.ficheNo!,
          widget.item.orderItemId!,
        );
        deneme += 1;
        await _dbHelper.updateOrderDetailItemScannedQty(
            deneme, widget.item.ficheNo!, widget.item.orderItemId!, widget.item.warehouse!);
        setState(() {
          _barcodeFocusNode.requestFocus();
        });
      }
    }
  }

  void _seriBarcodeRemoved(OrderDetailScannedItemDB item) async {
    await _dbHelper.clearOrderDetailScannedItem(item.recid!, item.ficheNo!, item.orderItemId!);
    orderDetailScannedItems = await _dbHelper.getOrderDetailScannedItem(
      widget.item.ficheNo!,
      widget.item.orderItemId!,
    );
    deneme -= item.numberOfPieces!;
    await _dbHelper.updateOrderDetailItemScannedQty(
        deneme, widget.item.ficheNo!, widget.item.orderItemId!, widget.item.warehouse!);
    setState(() {});
  }

/*
  _deneme1() async {
    await _dbHelper.addOrderDetailScannedItem(
        widget.item.ficheNo!, widget.item.productBarcode!, widget.scannedTimes);
    orderDetailScannedItems = await _dbHelper.getOrderDetailScannedItem(
        widget.item.ficheNo!, widget.item.productBarcode!);
    deneme += widget.scannedTimes;
    await _dbHelper.updateOrderDetailItemScannedQty(
        deneme, widget.item.ficheNo!, widget.item.productBarcode!);
    setState(() {});
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: PopScope(
        canPop: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Container(
            color: const Color(0xfffafafa),
            child: Column(
              children: [
                _headerScanner(),
                _fisnoText(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
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
                      ),
                    ]),
                  ),
                ),
                _button("Kaydet", Colors.white, const Color(0xffff9700), () {}),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        "SERİ NUMARA",
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
        _barcodeController.text = _scannedBarcode;
        setState(() {});
      }
    } on PlatformException {
      print("platform uyumsuz");
    }

    if (!mounted) return;
  }

  Padding _fisnoText() {
    return Padding(
      padding: EdgeInsets.only(left: 5, top: 15, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${widget.ficheNo}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff6f6f6f),
            ),
          ),
          Text(
            "$deneme / ${widget.item.qty}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: selectColor(deneme, widget.item.qty!),
            ),
          )
        ],
      ),
    );
  }

  Row _headerScanner() {
    return Row(
      children: [
        //number
        Expanded(
          flex: 1,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xfff1f1f1),
              borderRadius: BorderRadius.circular(100.0), // Köşeleri yuvarlayan kısım
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _numberController.text = "1";
                    },
                    iconSize: 28,
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: Color(0xff8a9a99),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: TextField(
                      controller: _numberController,
                      onSubmitted: (_) {
                        FocusScope.of(context).nextFocus();
                      },
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8a9a99),
                      ),
                      decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
                      cursorColor: const Color(0xff8a9a99),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //space
        SizedBox(
          width: 10,
        ),
        //barcode
        Expanded(
          flex: 2,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xfff1f1f1),
              borderRadius: BorderRadius.circular(100.0), // Köşeleri yuvarlayan kısım
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.barcode_reader,
                      color: Color(0xff8a9a99),
                    )),
                Expanded(
                  child: TextField(
                    focusNode: _barcodeFocusNode,
                    autofocus: true,
                    controller: _barcodeController,
                    onSubmitted: (value) {
                      _scannedBarcode = value;
                      _barcodeController.text = "";
                      if (deneme < widget.item.qty!) {
                        _seriBarcodeScanned();
                      } else {}

                      //FocusScope.of(context).requestFocus(FocusNode());
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    cursorColor: const Color(0xff8a9a99),
                  ),
                ),
                IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 38,
                    onPressed: () {
                      _scannedBarcode = _barcodeController.text;
                      if (deneme < widget.item.qty!) {
                        _seriBarcodeScanned();
                      } else {}
                    },
                    icon: const Icon(Icons.add_circle, color: Colors.black)),
              ],
            ),
          ),
        ),
      ],
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

  Padding _divider() {
    return const Padding(
      padding: EdgeInsets.only(top: 0),
      child: Divider(
        color: Color.fromARGB(255, 201, 201, 201),
        thickness: 0.5,
      ),
    );
  }

  Slidable _column(OrderDetailScannedItemDB item) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            _seriBarcodeRemoved(item);
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
                Text(
                  "${item.productBarcode}",
                  style: const TextStyle(fontSize: 17, color: Color(0xff727272)),
                ),
                Text(
                  "${item.numberOfPieces}",
                  style: const TextStyle(fontSize: 17, color: Color(0xff727272)),
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
}
