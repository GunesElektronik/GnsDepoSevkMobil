import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/entity_constants.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_summary_list_response.dart';
import 'package:gns_warehouse/models/purchase_order_summary_local.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order_detail/purchase_order_detail_local.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order_detail/purchase_order_detail_remote.dart';

import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:intl/intl.dart';

class PurchaseOrderItemLocalList extends StatefulWidget {
  const PurchaseOrderItemLocalList({super.key});

  @override
  State<PurchaseOrderItemLocalList> createState() =>
      _PurchaseOrderItemLocalListState();
}

class _PurchaseOrderItemLocalListState
    extends State<PurchaseOrderItemLocalList> {
  TextEditingController editingController = TextEditingController();
  final DbHelper _dbHelper = DbHelper.instance;
  List<PurchaseOrderSummaryLocal>? orderHeaderList = [];
  String searchQuery = "";
  late ApiRepository apiRepository;
  PurchaseOrderSummaryListResponse? summaryListResponse;
  bool isConnected = true;
  bool isFetched = false;
  bool isPriceVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstLoad();
    _createApiRepository();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    isPriceVisible = await ServiceSharedPreferences.getSharedBool(
            SharedPreferencesKey.isPriceVisible) ??
        false;

    try {
      summaryListResponse =
          await apiRepository.getPurchaseOrderSummaryListSearch(
              1,
              "bubirdenemedirverigelmeyecek",
              "customerSearchQuery",
              "orderStatusQuery",
              "userEmail",
              4);
      isConnected = true;
      isFetched = true;
    } catch (e) {
      isConnected = false;
      isFetched = true;
    }

    setState(() {});
  }

  void firstLoad() async {
    var results = await _dbHelper.getPurchaseOrderSummaryList();
    performSearch(searchQuery);
    setState(() {
      orderHeaderList = results;
    });
  }

  void performSearch(String query) async {
    if (query.isNotEmpty && query.length > 0) {
      var results = await _dbHelper.searchPurchaseOrderHeader(query);

      setState(() {
        searchQuery = query;
        orderHeaderList = results;
      });
    } else {
      var results = await _dbHelper.getPurchaseOrderSummaryList();

      setState(() {
        searchQuery = '';
        orderHeaderList = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: isFetched
          ? _localOrderElementsBody(context)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(
          color: Colors.deepOrange[700], size: 32 //change your color here
          ),
      title: Text(
        'Yerelde Kayıtlı Satın Alma \n Siparişleri',
        style: TextStyle(
            color: Colors.deepOrange[700],
            fontWeight: FontWeight.bold,
            fontSize: 17),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    );
  }

  Column _localOrderElementsBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            onChanged: (value) => performSearch(value),
            controller: editingController,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900]),
            decoration: InputDecoration(
              isDense: true,
              alignLabelWithHint: true,
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.grey[700],
                size: 28,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(24.0),
                // Kenar yuvarlatma
              ),
              //labelText: 'Search Products',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              suffixIcon: SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey[900],
                        size: 28,
                      ),
                      onPressed: () {
                        editingController.clear();
                        performSearch('');
                      },
                    ),
                    // IconButton(
                    //   icon: const Icon(
                    //     Icons.filter_alt,
                    //     color: Colors.blueGrey,
                    //     size: 28,
                    //   ),
                    //   onPressed: () {
                    //     _changeVisible();
                    //     //editingController.clear();
                    //     //performSearch('');
                    //   },
                    // ),
                  ],
                ),
              ),

              fillColor: Colors.amber.shade100,
              filled: true,
            ),
          ),
        ),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text((orderHeaderList?.length ?? 0) > 0
                ? "${orderHeaderList?.length ?? 0} Sipariş Bulundu"
                : "Siparişleri Filtreleyiniz"),
          ),
        ),
        Expanded(
          flex: 6,
          child: ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all(Colors.grey.shade700),
            ),
            child: Scrollbar(
              //thickness: 8.0,
              radius: const Radius.circular(4),
              thumbVisibility: true,
              interactive: true,
              child: ListView.builder(
                primary: true,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: orderHeaderList?.length ?? 0,
                itemBuilder: (context, index) {
                  return orderHeaderInfo(orderHeaderList![index]);
                },
                // separatorBuilder: (context, index) {
                //   return const Divider(
                //     indent: 30,
                //     endIndent: 30,
                //     color: Colors.white,
                //     height: 8,
                //   );
                // },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget orderHeaderInfo(PurchaseOrderSummaryLocal productItem) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: EdgeInsets.all(6),
          minVerticalPadding: 1,
          trailing: Container(
            width: 60,
            height: 78,
            alignment: Alignment.center,
            child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Text(
                    productItem.orderStatus ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 3),
            child: VerticalDivider(
              thickness: 4,
              color: EntityConstants.getColorBasedOnOrderStatus(
                  productItem.orderStatus.toString(),
                  productItem.isPartialOrder!),
            ),
          ),
          title: Text(
            "#${productItem.ficheNo}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${productItem.customer} ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                "Tarih: ${DateFormat('dd-MM-yyyy').format(productItem.ficheDate)}  Saat: ${DateFormat('HH:mm:ss').format(productItem.ficheDate)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 10, color: Colors.black), // Genel stil
                  children: <TextSpan>[
                    const TextSpan(
                        text: 'Depo ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold)), // Bold kısım
                    TextSpan(text: '${productItem.warehouse}'), // Normal stil
                    // const TextSpan(
                    //     text: ' Adet ',
                    //     style: TextStyle(fontWeight: FontWeight.bold)),
                    // TextSpan(text: '${productItem.totalQty ?? ""} '),

                    // const TextSpan(
                    //     text: ' Status ',
                    //     style: TextStyle(fontWeight: FontWeight.bold)),
                    // TextSpan(
                    //     text:
                    //         '${productItem.isAssing == true ? "Atanmış" : "Atanmamış"}'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 16, color: Colors.brown.shade900), // Genel stil
                  children: <TextSpan>[
                    const TextSpan(
                        text: 'Tutar : ', style: TextStyle(fontSize: 12)),
                    TextSpan(
                      text: isPriceVisible ? productItem.total : "***",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ), // Bold kısım
                    const TextSpan(
                        text: '   Atanmış   ', style: TextStyle(fontSize: 12)),
                    TextSpan(
                        text:
                            '${productItem.isAssing == true ? "Atanmış" : "Atanmamış"} ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          // trailing: const Icon(
          //   Icons.supervised_user_circle_outlined,
          //   color: Colors.black45,
          //   size: 24,
          // ),
          //isThreeLine: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => isConnected
                    ? PurchaseOrderDetailRemote(
                        item: _convertToOrderSummaryItem(productItem),
                        purchaseOrderId: productItem.id,
                        onValueChanged: (value) {},
                      )
                    : PurchaseOrderDetailLocal(
                        item: _convertToOrderSummaryItem(productItem),
                      ),
              ),
            ).then((value) async {
              firstLoad();
            });
          },

          dense: true,
        ),
      ),
    );
  }

  PurchaseOrderSummaryItem _convertToOrderSummaryItem(
      PurchaseOrderSummaryLocal productItem) {
    return PurchaseOrderSummaryItem(
      orderId: productItem.id,
      ficheNo: productItem.ficheNo,
      ficheDate: productItem.ficheDate,
      customer: productItem.customer,
      shippingMethod: productItem.shippingMethod,
      warehouse: productItem.warehouse,
      lineCount: productItem.lineCount,
      orderStatus: productItem.orderStatus,
      totalQty: productItem.totalQty,
      total: productItem.total,
      isAssing: productItem.isAssing,
      assingmentEmail: productItem.assingmentEmail,
      assingCode: productItem.assingCode,
      assingmetFullname: productItem.assingmetFullname,
      isPartialOrder: productItem.isPartialOrder,
    );
  }
}
