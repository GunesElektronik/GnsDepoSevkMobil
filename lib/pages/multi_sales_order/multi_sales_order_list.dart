import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/database/model/waybills_local.dart';
import 'package:gns_warehouse/pages/home.dart';
import 'package:gns_warehouse/pages/multi_sales_order/multi_sales_order_detail.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';
import 'package:gns_warehouse/widgets/gns_drawer_menu.dart';

class MultiSalesOrderList extends StatefulWidget {
  const MultiSalesOrderList({super.key});

  @override
  State<MultiSalesOrderList> createState() => _MultiSalesOrderListState();
}

class _MultiSalesOrderListState extends State<MultiSalesOrderList> {
  final DbHelper _dbHelper = DbHelper.instance;
  List<WaybillLocalModel>? waybillsHeaderList = [];

  late ApiRepository apiRepository;
  String employeeName = "";
  String searchQuery = "";
  bool _isVisible = false;
  bool isPriceVisible = false;
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getParameter();
    firstLoad();
  }

  void _changeVisible() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void firstLoad() async {
    var results = await _dbHelper.getMultiSalesOrderHeaderList();
    setState(() {
      waybillsHeaderList = results;
    });
  }

  void getParameter() async {
    apiRepository = await ApiRepository.create(context);
    isPriceVisible = await ServiceSharedPreferences.getSharedBool(
            SharedPreferencesKey.isPriceVisible) ??
        false;
    employeeName =
        await ServiceSharedPreferences.getSharedString("EmployeeName") ?? "";
  }

  Future<void> updateOrderHeader() async {
    var results = await _dbHelper.getMultiSalesOrderHeaderList();
    setState(() {
      waybillsHeaderList = results;
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
          iconTheme: IconThemeData(
              color: Colors.deepOrange[700], size: 32 //change your color here
              ),
          title: Text(
            'Sipariş Listesi',
            style: TextStyle(
                color: Colors.deepOrange[700],
                fontWeight: FontWeight.bold,
                fontSize: 20),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     //scanQRCode();
        //   },
        //   backgroundColor: Colors.orange,
        //   elevation: 4,
        //   child: const Icon(
        //     Icons.qr_code_2_outlined,
        //     color: Color(0XFFFFFFFF),
        //     size: 30,
        //   ),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            /*
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
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
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
            */
            /*
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
                        Navigator.of(context).push<String>(MaterialPageRoute(
                          builder: (context) => const WaybillsOrderList(),
                        ));
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
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
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
                        Navigator.of(context).push<String>(MaterialPageRoute(
                          builder: (context) => const PurchaseOrderControl(),
                        ));
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
                                style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            */
            SizedBox(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text((waybillsHeaderList?.length ?? 0) > 0
                      ? "${waybillsHeaderList?.length ?? 0} Sipariş Bulundu"
                      : "Siparişleri Filtreleyiniz"),
                ),
              ),
            ),
            Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  child: ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: waybillsHeaderList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return orderHeaderInfo(waybillsHeaderList![index]);
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
                ))
          ],
        ),
        bottomNavigationBar: bottomNavBar());
  }

  Widget orderHeaderInfo(WaybillLocalModel productItem) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.amber, borderRadius: BorderRadius.circular(8)),
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
                child: const Text(
                  "",
                  style: TextStyle(fontWeight: FontWeight.bold),
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
              "${productItem.customerName}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Text(
              " ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 10, color: Colors.black), // Genel stil
                children: <TextSpan>[
                  TextSpan(
                      text: 'Depo: ${productItem.warehouseName}',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold)), // Bold kısım
                  const TextSpan(text: ' '), // Normal stil
                  const TextSpan(
                      text: '  ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' '),

                  const TextSpan(
                      text: '  ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: '  '),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 16, color: Colors.brown.shade900), // Genel stil
                children: <TextSpan>[
                  TextSpan(
                      text:
                          'Tutar : ${isPriceVisible ? productItem.grosstotal : "***"}',
                      style: const TextStyle(fontSize: 12)),
                  const TextSpan(
                    text: "  ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ), // Bold kısım
                  const TextSpan(
                      text: '      ', style: TextStyle(fontSize: 12)),
                  const TextSpan(
                      text: '   ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
                builder: (context) => MultiSalesOrderDetail(
                  multiSalesId: productItem.waybillsId,
                  waybillLocalModel: productItem,
                  ficheNo: productItem.ficheNo!,
                ),
              )).then((value) async {
            firstLoad();
          });
        },
        dense: true,
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
            // IconButton(
            //     onPressed: () {
            //       //_refreshOrderHeaderList();
            //     },
            //     icon: const Icon(
            //       Icons.published_with_changes_outlined,
            //       size: 30,
            //       color: Colors.deepOrange,
            //     )),
            // IconButton(
            //     onPressed: () {
            //       //Navigator.pop(context);
            //       /*
            //       Navigator.of(context).push<String>(MaterialPageRoute(
            //         builder: (context) => const OrderFilterSettingsPage(),
            //       ));
            //       */
            //     },
            //     icon: const Icon(
            //       Icons.settings,
            //       size: 30,
            //       color: Colors.deepOrange,
            //     )),
            // const SizedBox(
            //   width: 60,
            // ),
          ],
        ),
      ),
    );
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
}
