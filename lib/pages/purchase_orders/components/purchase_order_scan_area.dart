import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PurchaseOrderScanArea extends StatefulWidget {
  const PurchaseOrderScanArea(
      {super.key,
      required this.onBarcodeChanged,
      required this.seriOrBarcode,
      required this.scannedTimes});
  final ValueChanged<String?> onBarcodeChanged;
  final ValueChanged<int?> scannedTimes;
  final ValueChanged<String> seriOrBarcode;

  @override
  State<PurchaseOrderScanArea> createState() => _PurchaseOrderScanAreaState();
}

class _PurchaseOrderScanAreaState extends State<PurchaseOrderScanArea>
    with TickerProviderStateMixin {
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _numberController =
      TextEditingController(text: '1');
  final TextEditingController _seriController = TextEditingController();
  late TabController _tabController;
  final FocusNode _barcodeFocusNode = FocusNode();
  final FocusNode _seriFocusNode = FocusNode();
  String barcode = "barcode";
  String seri = "seri";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 0) {
        widget.seriOrBarcode(barcode);
      } else {
        widget.seriOrBarcode(seri);
      }
    }
  }

  void _handlePageSelection() {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
    _barcodeController.dispose();
    _seriController.dispose();
    _seriFocusNode.dispose();
    _barcodeFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
          height: 120,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                padding: const EdgeInsets.only(bottom: 0),
                tabAlignment: TabAlignment.fill,
                indicatorPadding: const EdgeInsets.symmetric(vertical: 2),
                indicatorColor: Colors.deepOrange,
                labelColor: Colors.deepOrange,
                unselectedLabelColor: const Color(0xff959b9b),
                indicator: BoxDecoration(
                    color: const Color(0xfffef8ec),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.deepOrange, width: 1)),
                //isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerHeight: 3,
                dividerColor: Colors.deepOrange,
                tabs: const [
                  Tab(
                    child: Text(
                      "BARKOD OKU",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "SERİ / LOT OKU",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    _barcodeScanner(),
                    _seriAndLotScanner(),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Row _barcodeScanner() {
    return Row(
      children: [
        //number
        Expanded(
          flex: 1,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xfff1f1f1),
              borderRadius:
                  BorderRadius.circular(100.0), // Köşeleri yuvarlayan kısım
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (_numberController.text != "1") {
                            _numberController.text = (int.parse(
                                        _numberController.text == ""
                                            ? "1"
                                            : _numberController.text) -
                                    1)
                                .toString();
                          }
                        },
                        iconSize: 30,
                        icon: const Icon(
                          Icons.remove,
                          color: Color(0xff8a9a99),
                        )),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _numberController,
                    onSubmitted: (_) {
                      FocusScope.of(context).nextFocus();
                    },
                    textInputAction: TextInputAction.next,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff8a9a99),
                    ),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero),
                    cursorColor: const Color(0xff8a9a99),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          _numberController.text = (int.parse(
                                      _numberController.text == ""
                                          ? "1"
                                          : _numberController.text) +
                                  1)
                              .toString();
                        },
                        iconSize: 30,
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xff8a9a99),
                        )),
                  ),
                ),
                // IconButton(
                //     padding: EdgeInsets.zero,
                //     onPressed: () {},
                //     iconSize: 28,
                //     icon: const Icon(
                //       Icons.clear_rounded,
                //       color: Color(0xff8a9a99),
                //     )),
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.only(right: 15),
                //     child: TextField(
                //       controller: _numberController,
                //       onSubmitted: (_) {
                //         FocusScope.of(context).nextFocus();
                //       },
                //       textInputAction: TextInputAction.next,
                //       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //       keyboardType: TextInputType.number,
                //       textAlign: TextAlign.end,
                //       style: const TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //         color: Color(0xff8a9a99),
                //       ),
                //       decoration: const InputDecoration(
                //           border: InputBorder.none,
                //           contentPadding: EdgeInsets.zero),
                //       cursorColor: const Color(0xff8a9a99),
                //     ),
                //   ),
                // ),
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
              borderRadius:
                  BorderRadius.circular(100.0), // Köşeleri yuvarlayan kısım
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
                    //autofocus: true,
                    controller: _barcodeController,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _barcodeHasChanged(value);

                        _barcodeController.text = "";
                        _barcodeFocusNode.requestFocus();
                      }
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
                      _barcodeHasChanged(_barcodeController.text);
                      //_barcodeController.text = "";
                      _barcodeFocusNode.requestFocus();
                    },
                    icon: const Icon(Icons.add_circle, color: Colors.black)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _barcodeHasChanged(value) {
    if (value.isNotEmpty) {
      widget.scannedTimes(
        int.parse(_numberController.text == "" ? "1" : _numberController.text),
      );
      widget.onBarcodeChanged(value);
    }
  }

  Row _seriAndLotScanner() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xfff1f1f1),
              borderRadius:
                  BorderRadius.circular(100.0), // Köşeleri yuvarlayan kısım
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
                    focusNode: _seriFocusNode,
                    //autofocus: true,
                    controller: _seriController,
                    onSubmitted: (value) {
                      _barcodeHasChanged(value);
                      _seriController.text = "";
                      _seriFocusNode.requestFocus();
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
                      _barcodeHasChanged(_seriController.text);
                      //_seriController.text = "";
                      _seriFocusNode.requestFocus();
                    },
                    icon: const Icon(Icons.add_circle, color: Colors.black)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
