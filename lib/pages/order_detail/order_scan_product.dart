import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/models/order_detail_count_mode.dart';
import 'package:gns_warehouse/models/order_detail_response.dart';
import 'package:gns_warehouse/pages/order_detail/components/order_detail_count.dart';
import 'package:gns_warehouse/pages/order_detail/components/order_detail_widget.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/widgets/bottom_widget.dart';
/*
class OrderScanProduct extends StatefulWidget {
  const OrderScanProduct({super.key, required final this.orderId});
  final String orderId;
  @override
  State<OrderScanProduct> createState() => _OrderScanProductState();
}

class _OrderScanProductState extends State<OrderScanProduct> {
  late ApiRepository apiRepository;
  late Future<bool> _setOrderAssingStatus;
  OrderDetailResponse? response;
  bool isCreateApiRepo = false;
  bool isFetched = false;
  bool isAssing = false;
  String _bottomTakeOrderText = "";

  late Future<OrderDetailData> orderDetailFuture;
  OrderDetailData orderDetails = OrderDetailData();
  List<OrderDetailCountModel> orderDetailCountList = [];
  TextEditingController barcodeController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  String _barccode = "";
  String okunanDeger = "+";

  static const platform = OptionalMethodChannel('com.example.datawedge');

  Future<void> startBarcodeScanning() async {
    try {
      await platform.invokeMethod('startBarcodeScanning');
      FlutterClipboard.paste().then((value) {
        print("değerimiz: $value");
      });
    } on PlatformException catch (e) {
      print("Failed to start barcode scanning: '${e.message}'.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(_onFocusChange);
    createApiRepository();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      _barccode = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: const Color.fromARGB(255, 241, 241, 241),
          child: isCreateApiRepo == true
              ? FutureBuilder(
                  future: orderDetailFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("hasdata");

                      return _showOrderItems(snapshot, orderDetailCountList);
                    } else if (snapshot.hasError) {
                      print("haserror");
                      return _snapshotErrorPage(snapshot);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }

  Future<void> createApiRepository() async {
    print("id: ${widget.orderId}");
    apiRepository = await ApiRepository.create();
    setState(() {
      isCreateApiRepo = true;
    });

    orderDetailFuture = _callOrderDetail();
    print("userId: ${apiRepository.employeeUid}");
  }

  Future<OrderDetailData> _callOrderDetail() async {
    final orderDetailResponse =
        await apiRepository.getOrderDetail(widget.orderId);
    setState(() {
      isFetched = true;
      isAssing = orderDetailResponse.data!.isAssing ?? false;
      changeBottomTakeOrderText(isAssing);
    });
    if (orderDetailResponse.data != null) {
      orderDetails = orderDetailResponse.data!;
      orderDetails.orderItems!.forEach((element) {
        OrderDetailCountModel model = OrderDetailCountModel(
            element.product!.code!,
            element.product!.barcode!,
            element.qty!.value!,
            false,
            0);
        orderDetailCountList.add(model);
        print(
            "Barcode: ${element.product!.barcode} | Qty: ${element.qty!.value}");
      });
    }

    return orderDetails;
  }

  void changeBottomTakeOrderText(bool isAssing) {
    if (isAssing) {
      _bottomTakeOrderText = "BU SİPARİŞ ALINMIŞ !";
    } else {
      _bottomTakeOrderText = "SİPARİŞİ AL !";
    }
  }

  void _setBarcode() {
    _barccode = barcodeController.text;
    setState(() {});
  }

  Future<bool> setOrderAssingStatus() async {
    return await apiRepository.setOrderAssingStatus(
        true, apiRepository.employeeUid, widget.orderId);
  }

  SizedBox _bottomTakeOrder() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isAssing == true
            ? null
            : () {
                _setOrderAssingStatus = setOrderAssingStatus();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          shadowColor: const Color.fromARGB(255, 255, 251, 0),
          elevation: 5,
        ),
        child: Text(
          _bottomTakeOrderText,
          style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Column _showOrderItems(AsyncSnapshot<OrderDetailData> snapshot,
      List<OrderDetailCountModel> orderDetailCountList) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: TextField(
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _isFocused
                                          ? Colors.amber
                                          : Colors.grey),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: const EdgeInsets.all(5),
                                hintText: 'BARCODE',
                              ),
                              textAlign: TextAlign.center,
                              controller: barcodeController,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              onPressed: _setBarcode, child: Text("+")),
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              onPressed: () {
                                //FlutterClipboard.paste().then((value) {
                                // print("değerimiz: $value");
                                // });
                              },
                              child: Text("d")),
                        )
                      ]),
                ),
              )),
        ),
        Expanded(
            flex: 4,
            child: OrderDetailCount(
              orderDetailCountList: orderDetailCountList,
              scannedBarcode: _barccode,
            )),
      ],
    );
  }

  Column _snapshotErrorPage(AsyncSnapshot<OrderDetailData> snapshot) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Bir sorun oluştu lütfen tekrar deneyiniz",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Hata: ${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                        child: const Icon(Icons.refresh),
                        onPressed: () {
                          orderDetailFuture = _callOrderDetail();
                          setState(() {});
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
*/