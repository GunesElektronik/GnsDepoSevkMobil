import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:gns_warehouse/models/new_api/purchase_sales_waybills_response.dart';
import 'package:gns_warehouse/models/new_api/sales_waybills_response.dart';

import 'package:gns_warehouse/pages/order_detail/components/order_scan_area.dart';
import 'package:gns_warehouse/pages/waybills/components/waybills_select_area.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';

class WaybillsList extends StatefulWidget {
  WaybillsList({
    super.key,
  });

  @override
  State<WaybillsList> createState() => _WaybillsListState();
}

class _WaybillsListState extends State<WaybillsList> {
  String seriOrBarcode = "barcode";
  String productId = "";
  String tabType = "order";
  bool isLoading = false;
  late ApiRepository apiRepository;
  late SalesWaybillsResponse? salesResponse;
  late PurchaseSalesWaybillsResponse? purchaseSalesResponse;

  bool isFetched = false;
  List<SalesWaybillsItems> salesWaybillsItems = [];
  List<PruchaseSalesWaybillsItems> purchaseSalesWaybillsItems = [];

  int waybillOrderPage = 1;
  int waybillPurchaseOrderPage = 1;
  String query = "";
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
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    salesResponse =
        await apiRepository.getOrderWaybillSummaryList(waybillOrderPage, "");
    salesWaybillsItems = salesResponse!.waybills!.items!;
    purchaseSalesResponse = await apiRepository
        .getPurchaseOrderWaybillSummaryList(waybillPurchaseOrderPage, "");
    purchaseSalesWaybillsItems = purchaseSalesResponse!.waybills!.items!;
    setState(() {
      isFetched = true;
    });
  }

  void _filterOrderUsingService(String query) async {
    waybillOrderPage++;
    setState(() {
      isLoading = true;
    });
    var newResponse =
        await apiRepository.getOrderWaybillSummaryList(waybillOrderPage, query);
    salesWaybillsItems = salesWaybillsItems + newResponse!.waybills!.items!;

    setState(() {
      isLoading = false;
    });
  }

  void _filterPurchaseOrderUsingService(String query) async {
    waybillPurchaseOrderPage++;
    setState(() {
      isLoading = true;
    });
    var newResponse = await apiRepository.getPurchaseOrderWaybillSummaryList(
        waybillPurchaseOrderPage, query);
    purchaseSalesWaybillsItems =
        purchaseSalesWaybillsItems + newResponse!.waybills!.items!;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.only(left: 0, top: 10, right: 0),
          child: Container(
            color: const Color(0xfffafafa),
            child: isFetched
                ? Column(
                    children: [
                      Expanded(
                        child: WaybillSelectArea(
                          onSelectChange: (value) {
                            tabType = value!;
                          },
                          query: (value) {
                            query = value;
                            if (tabType == "order") {
                              waybillOrderPage = 0;
                              salesWaybillsItems = [];
                              _filterOrderUsingService(value);
                            } else {
                              waybillPurchaseOrderPage = 0;
                              purchaseSalesWaybillsItems = [];
                              _filterPurchaseOrderUsingService(value);
                            }
                          },
                          salesResponse: salesWaybillsItems,
                          purchaseSalesResponse: purchaseSalesWaybillsItems,
                          addMoreButtonClickedForSales: () {
                            _filterOrderUsingService(query);
                          },
                          addMoreButtonClickedForPurchase: () {
                            _filterPurchaseOrderUsingService(query);
                          },
                        ),
                      ),

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
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
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
        isLoading ? "Yükleniyor ..." : "İrsaliye Listesi",
        style: TextStyle(
            color: isLoading ? Colors.amber : Colors.deepOrange[700],
            fontWeight: FontWeight.bold,
            fontSize: 20),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    );
  }
}
