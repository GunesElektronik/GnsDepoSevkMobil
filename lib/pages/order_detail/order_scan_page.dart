import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/database/model/product_barcodes_item.dart';
import 'package:gns_warehouse/models/new_api/order_change_qty_item_model.dart';
import 'package:gns_warehouse/models/order_detail/order_detail_item_db.dart';
import 'package:gns_warehouse/models/order_detail_response.dart';
import 'package:gns_warehouse/models/order_fast_service_item_body.dart';
import 'package:gns_warehouse/models/product_barcode_detail_response.dart';
import 'package:gns_warehouse/pages/order_detail/components/order_row_product_item.dart';
import 'package:gns_warehouse/pages/order_detail/components/order_scan_area.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/widgets/bottom_widget.dart';
import 'package:gns_warehouse/widgets/gns_error_field.dart';

class OrderScan extends StatefulWidget {
  OrderScan({super.key, required this.orderDetailItemList, required this.orderId});
  final List<OrderDetailItemDB>? orderDetailItemList;
  String orderId;
  @override
  State<OrderScan> createState() => _OrderScanState();
}

class _OrderScanState extends State<OrderScan> {
  TextEditingController _numberController = TextEditingController(text: '1');
  TextEditingController _barcodeController = TextEditingController();
  late ProductBarcodeDetailResponse response;
  String _scannedBarcode = "";
  String seriOrBarcode = "barcode";
  String productId = "";
  int _scannedTimes = 1;
  final FocusNode _barcodeFocusNode = FocusNode();
  late ApiRepository apiRepository;
  final DbHelper _dbHelper = DbHelper.instance;
  final player = AudioPlayer();

  String errorPath = "sounds/error_sound.mp3";
  String completePath = "sounds/complete_sound.mp3";
  List<ProductBarcodesItemLocal>? productBarcodesLocalList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createApiRepository();
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

  Future<void> playSound(String path) async {
    await player.play(AssetSource(path));
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    productBarcodesLocalList = await _dbHelper.getProductBarcodes(widget.orderId);
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

  bool _isMatchWithEnteredBarcode(String barcode) {
    if (barcode.isNotEmpty) {
      for (int i = 0; i < widget.orderDetailItemList!.length; i++) {
        if (widget.orderDetailItemList![i].productBarcode == barcode) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      /*
      bottomNavigationBar: bottomWidget(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //Navigator.of(context).popUntil((route) => route.isFirst);
        },
        backgroundColor: Colors.orange,
        highlightElevation: 10,
        child: const Icon(
          Icons.qr_code_2_outlined,
          color: Color(0XFFFFFFFF),
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      */
      body: PopScope(
        canPop: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Container(
            color: const Color(0xfffafafa),
            child: Column(
              children: [
                //_headerScanner(),
                OrderScanArea(
                  onBarcodeChanged: (value) async {
                    if (value.toString().isNotEmpty) {
                      _scannedBarcode = value!;
                    }
                    if (_isMatchWithEnteredBarcode(_scannedBarcode)) {
                      // playSound(completePath);
                      setState(() {});
                    } else {
                      if (productBarcodesLocalList!.isNotEmpty) {
                        productBarcodesLocalList!.forEach((element) async {
                          if (element.barcode! == _scannedBarcode) {
                            productId = element.productId!;
                            _scannedBarcode = element.barcode!;
                            _scannedTimes = element.convParam2!;
                            // playSound(completePath);
                            setState(() {});
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              _scannedTimes = 1;
                              productId = "";
                            });
                            return;
                          }
                        });
                      }
                      // try {
                      //   _showLoadingScreen(true, "Servis Kontrol Ediliyor...");
                      //   response = await apiRepository
                      //       .getProductBasedOnBarcode(_scannedBarcode);
                      //   productId = response.data!.product!.productId!;
                      //   _scannedBarcode =
                      //       response.data!.barcode!.toString() + "1551";
                      //   _scannedTimes =
                      //       response.data!.unitConversion!.convParam2!.toInt() +
                      //           2;
                      //   _showLoadingScreen(false, "Servis Kontrol Ediliyor...");
                      //   playSound(completePath);
                      //   setState(() {});
                      //   SchedulerBinding.instance.addPostFrameCallback((_) {
                      //     _scannedTimes = 1;
                      //     productId = "";
                      //   });
                      // } catch (e) {
                      //   _showLoadingScreen(false, "Servis Kontrol Ediliyor...");
                      //   playSound(errorPath);
                      //   _showDialogMessage("Barkod Bulunamadı", "hata");
                      // }
                    }
                    /*
                    if (value.toString().isNotEmpty) {
                      _scannedBarcode = value!;
                    }
                    if (_isMatchWithEnteredBarcode(_scannedBarcode)) {
                      setState(() {});
                    } else {
                      try {
                        await apiRepository
                            .getProductBasedOnBarcode(_scannedBarcode);
                      } catch (e) {
                        _showDialogMessage("Barkod Bulunamadı", e.toString());
                      }
                    }
                    */
                  },
                  seriOrBarcode: (value) {
                    setState(() {
                      _scannedBarcode = "";
                      productId = "";
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
                //         itemCount: widget.orderDetailItemList!.length,
                //         itemBuilder: (context, index) {
                //           return OrderProductItemRow(
                //             item: widget.orderDetailItemList![index],
                //             index: index,
                //             scannedBarcode: _scannedBarcode,
                //             scannedTimes: _scannedTimes,
                //             seriOrBarcode: seriOrBarcode,
                //             productId: productId,
                //           );
                //         },
                //       ),
                //     ]),
                //   ),
                // ),
                Expanded(
                  child: ListView(
                    children: widget.orderDetailItemList!.map((item) {
                      int index = widget.orderDetailItemList!.indexOf(item);
                      return OrderProductItemRow(
                        item: item,
                        index: index,
                        scannedBarcode: _scannedBarcode,
                        scannedTimes: _scannedTimes,
                        seriOrBarcode: seriOrBarcode,
                        productId: productId,
                        errorHandler: (value) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _showDialogMessage("Uyarı", value.toString());
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                /*
                _button(
                  "Kaydet",
                  Colors.white,
                  const Color(0xffff9700),
                  () async {
                    _showLoadingScreen(true, "Veriler Sunucuyua İletiliyor...");
                    var orderItemList =
                        await _dbHelper.getOrderDetailItemList(widget.orderId);

                    //print("productId: ${orderItemList![0].productId}");

                    if (orderItemList!.isNotEmpty) {
                      var orderItemsList = orderItemList
                          .map((orderItemDB) => OrderUpdateQtyItem(
                                orderItemId: orderItemDB.orderItemId,
                                productId: orderItemDB.productId,
                                shippedQty: orderItemDB.scannedQty,
                              ))
                          .toList();

                      bool isSuccess = await apiRepository.updateOrderItems(
                          widget.orderId, widget.customerId, orderItemsList);

                      _showLoadingScreen(
                          false, "Veriler Sunucuyua İletiliyor...");
                      if (isSuccess) {
                        _showDialogMessage(
                            "Başarılı !", "Veriler Serviste Güncellendi.");
                      } else {
                        _showDialogMessage(
                            "HATA !", "Veriler Serviste Güncellenemedi.");
                      }
                    }

                    /*
                    try {
                      final response =
                          await apiRepository.getProductBasedOnBarcode(
                              widget.orderId, _barcodeController.text);
                      print("product detail: ${response.data!.product!.code!}");
                    } catch (e) {
                      print("Barcode hatası: $e");
                    }
                    */
                  },
                ),
                */
                //_button("Toplamayı Tamamla", Colors.black,
                //    const Color(0xff8a9c9c), () {}),
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

  Padding _fisnoText() {
    return Padding(
      padding: EdgeInsets.only(left: 5, top: 15, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${widget.orderDetailItemList![0].ficheNo}",
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
                      if (value.isNotEmpty) {
                        _scannedBarcode = value;
                        _barcodeController.text = "";
                        if (_isMatchWithEnteredBarcode(value)) {
                        } else {
                          //showDialogForIsMatchBarcode(context, value);
                          showDialogForIsMatchBarcodeVer2(context, value);
                        }

                        setState(() {
                          _barcodeFocusNode.requestFocus();
                        });
                      }
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
                      if (_scannedBarcode.isNotEmpty) {
                        if (_isMatchWithEnteredBarcode(_scannedBarcode)) {
                        } else {
                          showDialogForIsMatchBarcode(context, _scannedBarcode);
                        }
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.add_circle, color: Colors.black)),
              ],
            ),
          ),
        ),
      ],
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
          print("orderId: ${widget.orderId}");
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
        _barcodeController.text = _scannedBarcode;
        if (_scannedBarcode.isNotEmpty) {
          setState(() {});
          if (_isMatchWithEnteredBarcode(_scannedBarcode)) {
          } else {
            showDialogForIsMatchBarcode(context, _scannedBarcode);
          }
        }
      }
    } on PlatformException {
      print("platform uyumsuz");
    }

    if (!mounted) return;
  }
}
