import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:gns_warehouse/pages/stock_counting_fiche/count_fiche_detail.dart';
import 'package:gns_warehouse/pages/stock_counting_fiche/count_fiche_scan.dart';
import 'package:gns_warehouse/pages/minus_count_fiche/list_minus_count_fiche.dart';

import 'package:gns_warehouse/pages/order_list.dart';
import 'package:gns_warehouse/pages/over_count_fiche/list_over_count_fiche.dart';

import 'package:gns_warehouse/pages/purchase_orders/purchase_order_main_list2.dart';
import 'package:gns_warehouse/pages/stock_counting_fiche/list_stock_counting_fiche.dart';

import 'package:gns_warehouse/pages/transfer_fiche/list_transfer_fiche.dart';
import 'package:gns_warehouse/pages/users/user_list.dart';

import 'package:gns_warehouse/pages/warehouse_transfer/warehouse_transfer_list.dart';
import 'package:gns_warehouse/pages/waybills/waybills_list.dart';

import 'package:gns_warehouse/widgets/gns_drawer_menu.dart';

import '../services/sharedpreferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //final DbHelper _dbHelper = DbHelper.instance;
  String employeeName = "";
  // late ApiRepository apiRepository;
  // final LoginRepository _loginRepository = LoginRepository();
  // late String employeeUsername;
  // late String employeePassword;
  // WorkplaceListResponse? response;

  //bool isFetched = false;

  @override
  void initState() {
    super.initState();
    getSharedParameter();
  }

  void getSharedParameter() async {
    //apiRepository = await ApiRepository.create(context);
    employeeName =
        await ServiceSharedPreferences.getSharedString("EmployeeName") ?? "";
    // employeeUsername =
    //     await ServiceSharedPreferences.getSharedString("EmployeeUsername") ??
    //         "";
    // employeePassword =
    //     await ServiceSharedPreferences.getSharedString("EmployeePassword") ??
    //         "";
    // response = await apiRepository.getWorkplaceList();
    // if (response == null) {
    //   await _loginRepository.getLoginEmployee(
    //       employeeUsername, employeePassword);
    // }
    setState(() {
      //isFetched = true;
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
        title: const Text(
          'GNS Depo',
          style: TextStyle(
              color: Color(0XFF8a9d9c),
              fontWeight: FontWeight.bold,
              fontSize: 20),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      /*
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            /*
            Navigator.pop(context);
            Navigator.of(context).push<String>(MaterialPageRoute(
              builder: (context) => const ScanQr(),
            ));
            */
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        */
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 36,
            child: Center(
              child: Text(
                'Sn. ${employeeName.toUpperCase()}. Hoş Geldiniz.',
                style: const TextStyle(color: Color(0XFF8a9d9c)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 6,
            child: Center(
                child: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: MaterialStateProperty.all(Colors.green.shade700),
              ),
              child: Scrollbar(
                //thickness: 10.0,
                radius: const Radius.circular(10),
                thumbVisibility: true,
                interactive: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: [
                      _menuItem(
                        "assets/svg/satis.svg",
                        "Satış Siparişleri",
                        () {
                          Navigator.of(context).push<String>(MaterialPageRoute(
                            builder: (context) => const OrderList(),
                          ));
                        },
                      ),
                      _menuItem(
                        "assets/svg/satin_alma.svg",
                        "Satın Alma Siparişleri",
                        () {
                          Navigator.of(context).push<String>(MaterialPageRoute(
                            builder: (context) =>
                                // const PurchaseOrderMainList(),
                                const PurchaseOrderMainList2(),
                          ));
                        },
                      ),
                      _menuItem(
                        "assets/svg/irsaliyeler.svg",
                        "İrsaliyeler",
                        () {
                          Navigator.of(context).push<String>(MaterialPageRoute(
                            builder: (context) => WaybillsList(),
                          ));
                        },
                      ),
                      _menuItem(
                        "assets/svg/ambar_transfer.svg",
                        "Ambar Transfer",
                        () {
                          Navigator.of(context).push<String>(MaterialPageRoute(
                            builder: (context) => const WarehouseTransferList(),
                          ));
                        },
                      ),
                      // _menuItem(
                      //   "assets/svg/stok_fisleri.svg",
                      //   "Stok Fişleri",
                      //   () {
                      //     Navigator.of(context).push<String>(MaterialPageRoute(
                      //       builder: (context) => const FicheTransferList(),
                      //     ));
                      //   },
                      // ),
                      _menuItem(
                        "assets/svg/stok_fisleri.svg",
                        "Devir Fişleri",
                        () {
                          Navigator.of(context).push<String>(MaterialPageRoute(
                            builder: (context) => const FicheTransferList(),
                          ));
                        },
                      ),
                      _menuItem(
                        "assets/svg/stok_yerleri.svg",
                        "Stok Sayım Fişleri",
                        () {
                          Navigator.of(context).push<String>(MaterialPageRoute(
                            builder: (context) =>
                                const StockCountingFicheList(),
                          ));
                        },
                      ),
                      _menuItem(
                        "assets/svg/over_count_fiche.svg",
                        "Sayım Fazlası Fişleri",
                        () {
                          Navigator.of(context).push<String>(MaterialPageRoute(
                            builder: (context) => const OverCountFicheList(),
                          ));
                        },
                      ),
                      _menuItem(
                        "assets/svg/minus_count_fiche.svg",
                        "Sayım Eksiği Fişleri",
                        () {
                          Navigator.of(context).push<String>(MaterialPageRoute(
                            builder: (context) => const MinusCountFicheList(),
                          ));
                        },
                      ),
                      _menuItem(
                        "assets/svg/users.svg",
                        "Kullanıcılar",
                        () {
                          Navigator.of(context).push<String>(MaterialPageRoute(
                            builder: (context) => const UserList(),
                          ));
                        },
                      ),
                      // _menuItem(
                      //   "assets/svg/stok_yerleri.svg",
                      //   "Sayım Fişi",
                      //   () {
                      //     Navigator.of(context).push<String>(MaterialPageRoute(
                      //       builder: (context) => const CountFicheScan(),
                      //     ));
                      //   },
                      // ),
                      // _menuItem(
                      //   "assets/svg/stok_yerleri.svg",
                      //   "Stok Yerleri",
                      //   () {},
                      // ),
                    ],
                  ),
                ),
              ),
            )),
          ),
        ],
      ),
      // bottomNavigationBar: bottomWidget(context),
    );
  }

  Padding _menuItem(String iconPath, String title, void Function()? onTap) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Card(
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: Color.fromARGB(255, 255, 223, 187),
              onTap: onTap,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10), // Border radius'u ayarlayın
                    border: Border.all(
                      color:
                          const Color(0xffececec), // Kenar rengini belirleyin
                      width: 4, // Kenar kalınlığını belirleyin
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          iconPath,
                          width: 50,
                          height: 50,
                        ),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color(0xff757575),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Container _imageButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(
            20), // İstenen köşe yarıçapını burada belirtiyoruz
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push<String>(MaterialPageRoute(
            builder: (context) => const OrderList(),
          ));
        },
        child: Ink.image(
          image: const NetworkImage(
              "https://www.saleswarp.com/wp-content/uploads/some-orders-must-take-priority_619_40045444_0_14112918_500.jpg"),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> scanQRCode() async {
    // try {
    //   bool isSuccess = false;

    //   await FlutterBarcodeScanner.scanBarcode(
    //           '#ff6666', 'Cancel', true, ScanMode.QR)
    //       .then((value) => {
    //             if (value == "-1")
    //               {}
    //             else if (value.length > 0 || value.trim() != "-1")
    //               {
    //                 isSuccess = true,
    //                 Navigator.of(context).push<String>(MaterialPageRoute(
    //                   builder: (context) => OrderDetailDeneme(
    //                     orderId: value,
    //                   ),
    //                 ))
    //               }
    //           });

    //   //if (isSuccess) {}
    // } on PlatformException {
    //   print("platform uyumsuz");
    // }

    // if (!mounted) return;
  }
}
