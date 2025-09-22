import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/models/new_api/purchase_sales_waybills_response.dart';
import 'package:gns_warehouse/models/new_api/sales_waybills_response.dart';
import 'package:gns_warehouse/pages/waybills/waybills_order_list.dart';
import 'package:gns_warehouse/pages/waybills/waybills_purchase_order_list.dart';

class WaybillSelectArea extends StatefulWidget {
  WaybillSelectArea({
    super.key,
    required this.onSelectChange,
    required this.query,
    required this.salesResponse,
    required this.purchaseSalesResponse,
    required this.addMoreButtonClickedForSales,
    required this.addMoreButtonClickedForPurchase,
  });
  final ValueChanged<String?> onSelectChange;
  final ValueChanged<String> query;
  List<SalesWaybillsItems> salesResponse;
  List<PruchaseSalesWaybillsItems> purchaseSalesResponse;
  void Function()? addMoreButtonClickedForSales;
  void Function()? addMoreButtonClickedForPurchase;

  @override
  State<WaybillSelectArea> createState() => _WaybillSelectAreaState();
}

class _WaybillSelectAreaState extends State<WaybillSelectArea>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;

  String order = "order";
  String purchaseOrder = "purchaseOrder";

  @override
  void didUpdateWidget(covariant WaybillSelectArea oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.salesResponse != widget.salesResponse) {
      setState(() {});
    }

    if (oldWidget.purchaseSalesResponse != widget.purchaseSalesResponse) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 0) {
        widget.onSelectChange(order);
      } else {
        widget.onSelectChange(purchaseOrder);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
    _searchController.dispose();
  }

  // Container(
  //                     color: const Color.fromARGB(255, 168, 213, 235),
  //                     child: Stack(
  //                       alignment: Alignment.centerRight,
  //                       children: [
  //                         TextField(
  //                           controller: _searchController,
  //                           onSubmitted: (value) {
  //                             query = value;
  //                             customerPage = 0;
  //                             filteredItems = [];
  //                             _filterUsingService(query);
  //                           },
  //                           textAlign: TextAlign.start,
  //                           style: const TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.black,
  //                           ),
  //                           decoration: const InputDecoration(
  //                             prefixIcon:
  //                                 Icon(Icons.search, color: Colors.black),
  //                             border: InputBorder.none,
  //                           ),
  //                           cursorColor: Colors.black,
  //                         ),
  //                         Positioned(
  //                           right: 0,
  //                           child: SizedBox(
  //                             height: 50,
  //                             width: 50,
  //                             child: Material(
  //                               color: Colors.transparent,
  //                               child: InkWell(
  //                                 borderRadius: const BorderRadius.only(
  //                                   topRight: Radius.circular(5),
  //                                   bottomRight: Radius.circular(5),
  //                                 ),
  //                                 splashColor:
  //                                     const Color.fromARGB(255, 255, 223, 187),
  //                                 onTap: () {
  //                                   query = _searchController.text;
  //                                   customerPage = 0;
  //                                   filteredItems = [];
  //                                   _filterUsingService(query);
  //                                 },
  //                                 child: Container(
  //                                   child: const Center(
  //                                       child: Text(
  //                                     "ARA",
  //                                     style: TextStyle(
  //                                         color: Colors.black,
  //                                         fontWeight: FontWeight.bold),
  //                                   )),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     )),

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
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
                      "SATIŞ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "SATIN ALMA",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Container(
                  color: Color.fromARGB(255, 255, 240, 152),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        controller: _searchController,
                        onSubmitted: (value) {
                          widget.query(value);
                          // query = value;
                          // customerPage = 0;
                          // filteredItems = [];
                          // _filterUsingService(query);
                        },
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.black),
                          border: InputBorder.none,
                        ),
                        cursorColor: Colors.black,
                      ),
                      Positioned(
                        right: 0,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              splashColor:
                                  const Color.fromARGB(255, 255, 223, 187),
                              onTap: () {
                                widget.query(_searchController.text);
                                // query = _searchController.text;
                                // customerPage = 0;
                                // filteredItems = [];
                                // _filterUsingService(query);
                              },
                              child: Container(
                                child: const Center(
                                    child: Text(
                                  "ARA",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    WaybillsOrderList(
                      response: widget.salesResponse,
                      addMoreButtonClicked: widget.addMoreButtonClickedForSales,
                    ),
                    WaybillsPurchaseOrderList(
                      response: widget.purchaseSalesResponse,
                      addMoreButtonClicked:
                          widget.addMoreButtonClickedForPurchase,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
