import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/models/order_summary.dart';
import 'package:gns_warehouse/models/purchase_order_summary_local.dart';
import 'package:gns_warehouse/pages/home.dart';
import 'package:gns_warehouse/pages/purchase_order_waybills/multi_purchase_order_list.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order_control.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order_detail.dart';
import 'package:gns_warehouse/pages/settings_page/filter_settings_page/order_filter_settings.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:gns_warehouse/widgets/drawer_menu.dart';
import 'package:gns_warehouse/widgets/gns_drawer_menu.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseOrderMainList extends StatefulWidget {
  const PurchaseOrderMainList({super.key});

  @override
  State<PurchaseOrderMainList> createState() => _PurchaseOrderMainListState();
}

class _PurchaseOrderMainListState extends State<PurchaseOrderMainList> {
  final DbHelper _dbHelper = DbHelper.instance;
  List<PurchaseOrderSummaryLocal>? orderHeaderList = [];
  bool? isOnlyIsAssingFalse = false;

  late ApiRepository apiRepository;
  String employeeName = "";
  String searchQuery = "";
  bool _isVisible = false;

  TextEditingController editingController = TextEditingController();

  late SharedPreferences sharedPreferences;
  late SharedPreferencesKey sharedPreferencesKey;

  void performSearch(String query) async {
    if (query.isNotEmpty && query.length > 0) {
      var results = await _dbHelper.searchPurchaseOrderHeader(query);
      if (isOnlyIsAssingFalse!) {
        results = results.where((element) => !element.isAssing).toList();

        print("Liste sayısı: ${orderHeaderList!.length.toString()}");
      }

      setState(() {
        searchQuery = query;
        orderHeaderList = results;
      });
    } else {
      var results = await _dbHelper.getPurchaseOrderSummaryList();

      if (isOnlyIsAssingFalse!) {
        results = results!.where((element) => !element.isAssing).toList();

        print("Liste sayısı: ${orderHeaderList!.length.toString()}");
      }

      setState(() {
        searchQuery = '';
        orderHeaderList = results;
      });
    }
  }

  void _changeVisible() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void firstLoad() async {
    var results = await _dbHelper.getPurchaseOrderSummaryList();
    setState(() {
      orderHeaderList = results;
    });
  }

  Future<void> updateOrderHeader() async {
    var results = await _dbHelper.getPurchaseOrderSummaryList();
    setState(() {
      orderHeaderList = results;
    });
  }

  void _getSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _getSettingsValues();
  }

  void _getSettingsValues() async {
    var sharedValue = await sharedPreferences.get(sharedPreferencesKey.isOnlyIsAssingFalseForPurchase);
    if (sharedValue != null) {
      isOnlyIsAssingFalse = sharedValue as bool;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    sharedPreferencesKey = SharedPreferencesKey();
    _getSharedPreferences();
    getParameter();
    firstLoad();
  }

  void getParameter() async {
    apiRepository = await ApiRepository.create(context);
    employeeName = await ServiceSharedPreferences.getSharedString("EmployeeName") ?? "";

    setState(() {
      performSearch(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: drawerMenu(context, employeeName),
        drawer: GNSDrawerMenu(
          employeeName: employeeName,
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.deepOrange[700], size: 32 //change your color here
              ),
          title: Text(
            'Sipariş Listesi',
            style: TextStyle(color: Colors.deepOrange[700], fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            scanQRCode();
          },
          backgroundColor: Colors.orange,
          elevation: 4,
          child: const Icon(
            Icons.qr_code_2_outlined,
            color: Color(0XFFFFFFFF),
            size: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                onChanged: (value) => performSearch(value),
                controller: editingController,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey[900]),
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                        IconButton(
                          icon: const Icon(
                            Icons.filter_alt,
                            color: Colors.blueGrey,
                            size: 28,
                          ),
                          onPressed: () {
                            _changeVisible();
                            //editingController.clear();
                            //performSearch('');
                          },
                        ),
                      ],
                    ),
                  ),

                  fillColor: Colors.amber.shade100,
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 6, right: 6),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Colors.orangeAccent,
                    elevation: 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      splashColor: const Color.fromARGB(255, 255, 223, 187),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MultiPurchaseOrderList()))
                            .then((value) async {
                          firstLoad();
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Çoklu Siparişlerimi Görüntüle",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 6, right: 6),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      splashColor: const Color.fromARGB(255, 255, 223, 187),
                      onTap: () {
                        /*
                        Navigator.of(context).push<String>(MaterialPageRoute(
                          builder: (context) => const PurchaseOrder(),
                        ));
                        
                        */
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PurchaseOrderControl()))
                            .then((value) async {
                          firstLoad();
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.orangeAccent, // Kenarlık rengi
                              width: 2.0, // Kenarlık kalınlığı
                            ),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Çoklu Sipariş Oluştur",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.orangeAccent, fontSize: 15, fontWeight: FontWeight.w800),
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text((orderHeaderList?.length ?? 0) > 0
                      ? "${orderHeaderList?.length ?? 0} Sipariş Bulundu"
                      : "Siparişleri Filtreleyiniz"),
                ),
              ),
            ),
            _filterScreen(context),
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
                  child: ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: orderHeaderList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return orderHeaderInfo(orderHeaderList![index]);
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        indent: 30,
                        endIndent: 30,
                        color: Colors.white,
                        height: 8,
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: bottomNavBar());
  }

  Padding _filterScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 0, right: 6, bottom: 6),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.amber[100],
        ),
        duration: const Duration(milliseconds: 200),
        height: _isVisible ? 200 : 0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CheckboxListTile(
                  value: isOnlyIsAssingFalse,
                  contentPadding: EdgeInsets.zero,
                  activeColor: Colors.amber,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (newBool) {
                    setState(() {
                      isOnlyIsAssingFalse = newBool;
                      //print(isOnlyIsAssingTrue);
                    });
                  },
                  title: const Text(
                    "Sadece Atanmamış Siparişler",
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {
                    //_filterSearchButtonClicked();
                    performSearch(searchQuery);
                    _changeVisible();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // Şekil değişimi
                      ),
                    ),
                  ),
                  child: const Text(
                    "Ara",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget orderHeaderInfo(PurchaseOrderSummaryLocal productItem) {
    return Container(
      decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(6),
        minVerticalPadding: 1,
        leading: Container(
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
        title: Text(
          "#${productItem.ficheNo}" ?? "",
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              "Adet: ${productItem.totalQty}    Tutar:  ${productItem.total ?? ""} ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 10, color: Colors.black), // Genel stil
                children: <TextSpan>[
                  const TextSpan(text: 'Depo ', style: TextStyle(fontWeight: FontWeight.bold)), // Bold kısım
                  TextSpan(text: '${productItem.warehouse}'), // Normal stil
                  const TextSpan(text: ' Adet ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${productItem.totalQty ?? ""} '),

                  const TextSpan(text: ' Status ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${productItem.isAssing == true ? "Atanmış" : "Atanmamış"}'),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.brown.shade900), // Genel stil
                children: <TextSpan>[
                  const TextSpan(text: 'Tutar : ', style: TextStyle(fontSize: 12)),
                  TextSpan(
                    text: productItem.total,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ), // Bold kısım
                  const TextSpan(text: '   Atanmış   ', style: TextStyle(fontSize: 12)),
                  TextSpan(
                      text: '${productItem.isAssing == true ? "Atanmış" : "Atanmamış"} ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.supervised_user_circle_outlined,
          color: Colors.black45,
          size: 24,
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PurchaseOrderDetailPage(
                        purchaseOrderId: productItem.id,
                      ))).then((value) async {
            firstLoad();
          });
        },
        onLongPress: () {
          print("onlongpress çalıştı");

          showModalBottomSheet(
            context: context,
            builder: (context) => bottomSheet(productItem),
          );
        },
        dense: true,
      ),
    );
  }

  Widget bottomSheet(PurchaseOrderSummaryLocal productItem) {
    double leftPadding = 8.0;
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
        child: Column(
          children: [
            //order status
            Container(
              decoration: BoxDecoration(
                color: Colors.amber[500],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "${productItem.orderStatus.toString().toUpperCase()} ",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  //isAssing and fullname
                  Container(
                    color: Colors.amber[200],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: leftPadding),
                                child: Text(
                                  productItem.isAssing ? "Atanmış" : "Atanmamış",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ),
                            const VerticalDivider(
                              width: 5,
                              color: Colors.amber,
                              thickness: 1.5,
                              indent: 1,
                              endIndent: 1, // Bölücünün container'dan başlangıç boşluğu
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: EdgeInsets.only(left: leftPadding),
                                child: Text(
                                  "${productItem.assingmetFullname == "null" ? "" : productItem.assingmetFullname}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //fiche no
                  Container(
                    width: double.infinity,
                    color: Colors.amber[100],
                    child: Padding(
                      padding: EdgeInsets.only(left: leftPadding, top: 5),
                      child: Text(
                        "#${productItem.ficheNo}" ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  _divider(Colors.amber[100]!, Colors.amber[300]!),
                  //warehouse
                  Container(
                    width: double.infinity,
                    color: Colors.amber[100],
                    child: Padding(
                      padding: EdgeInsets.only(left: leftPadding),
                      child: Text(
                        "Depo : ${productItem.warehouse}" ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  _divider(Colors.amber[100]!, Colors.amber[300]!),
                  //customer
                  Container(
                    width: double.infinity,
                    color: Colors.amber[100],
                    child: Padding(
                      padding: EdgeInsets.only(left: leftPadding, bottom: 5),
                      child: Text(
                        "Müşteri : ${(productItem.customer)}" ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  //fiche date
                  Container(
                    width: double.infinity,
                    color: Colors.amber[50],
                    child: Padding(
                      padding: EdgeInsets.only(left: leftPadding, top: 5),
                      child: Text(
                        "Sipariş Tarihi : ${DateFormat('dd-MM-yyyy').format(productItem.ficheDate)}" ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  _divider(Colors.amber[50]!, Colors.amber[200]!),
                  //total qty and total
                  Container(
                    color: Colors.amber[50],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: leftPadding),
                                child: Text(
                                  "Toplam Ürün Adeti: ${productItem.totalQty}" ?? "",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ),
                            VerticalDivider(
                              width: 5,
                              color: Colors.amber[200],
                              thickness: 2,
                              indent: 1,
                              endIndent: 1, // Bölücünün container'dan başlangıç boşluğu
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: leftPadding),
                                child: Text(
                                  "Tutar: ${productItem.total} ",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _divider(Colors.amber[50]!, Colors.amber[200]!),
                  //number of product types
                  Container(
                    width: double.infinity,
                    color: Colors.amber[50],
                    child: Padding(
                      padding: EdgeInsets.only(left: leftPadding, bottom: 5),
                      child: Text(
                        "Ürün Çeşit Sayısı: ${productItem.lineCount} " ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(Color backgroundColor, Color dividerColor) {
    return Container(
      color: backgroundColor,
      child: Divider(
        color: dividerColor,
        thickness: 1.5,
        indent: 10,
        endIndent: 10, // Bölücünün container'dan başlangıç boşluğu
      ),
    );
  }

  Widget bottomNavBar() {
    return Container(
      height: 60,
      child: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push<String>(MaterialPageRoute(
                    builder: (context) => const Home(),
                  ));
                },
                icon: const Icon(
                  Icons.apps_outlined,
                  size: 30,
                  color: Colors.deepOrange,
                )),
            IconButton(
                onPressed: () {
                  _refreshOrderHeaderList();
                },
                icon: const Icon(
                  Icons.published_with_changes_outlined,
                  size: 30,
                  color: Colors.deepOrange,
                )),
            IconButton(
                onPressed: () {
                  //Navigator.pop(context);
                  Navigator.of(context).push<String>(MaterialPageRoute(
                    builder: (context) => const OrderFilterSettingsPage(),
                  ));
                },
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                  color: Colors.deepOrange,
                )),
            const SizedBox(
              width: 60,
            ),
          ],
        ),
      ),
    );
  }

  _refreshOrderHeaderList() async {
    _showLoadingScreen(true, "Veriler Güncelleniyor ...");
    await apiRepository.getPurchaseOrderSummaryList();
    await updateOrderHeader();
    _showLoadingScreen(false, "Veriler Güncelleniyor ...");
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

  Future<void> scanQRCode() async {
    try {
      bool isSuccess = false;

      // await FlutterBarcodeScanner.scanBarcode(
      //         '#ff6666', 'Cancel', true, ScanMode.QR)
      //     .then((value) => {
      //           if (value == "-1")
      //             {}
      //           else if (value.length > 0 || value.trim() != "-1")
      //             {
      //               isSuccess = true,
      //             }
      //         });

      //if (isSuccess) {}
    } on PlatformException {
      print("platform uyumsuz");
    }

    if (!mounted) return;
  }
}
