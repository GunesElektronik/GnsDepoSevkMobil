import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/user_special_settings.dart';
import 'package:gns_warehouse/database/dbhelper.dart';
import 'package:gns_warehouse/pages/login.dart';
import 'package:gns_warehouse/pages/order_list.dart';
import 'package:gns_warehouse/pages/purchase_orders/purchase_order_main_list2.dart';
import 'package:gns_warehouse/pages/settings_page/settings_page.dart';
import 'package:gns_warehouse/pages/startpage.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';

class GNSDrawerMenu extends StatefulWidget {
  GNSDrawerMenu({super.key, required this.employeeName});
  String employeeName;
  @override
  State<GNSDrawerMenu> createState() => _GNSDrawerMenuState();
}

class _GNSDrawerMenuState extends State<GNSDrawerMenu> {
  final DbHelper _dbHelper = DbHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(230, 255, 98, 50),
              image: DecorationImage(
                  image: const AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7),
                    BlendMode.dstOut,
                  )),
            ),
            child: Text(
              '${widget.employeeName.toUpperCase()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.sync,
          //     color: Colors.deepOrange,
          //     size: 20,
          //   ),
          //   title: const Text('Sipariş Güncelleme'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          //       return Synchronize();
          //     }));
          //   },
          // ),
          ListTile(
            title: const Text('Satış Sipariş Listesi'),
            leading: const Icon(
              Icons.list,
              color: Colors.deepOrange,
              size: 20,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const OrderList();
              }));
            },
          ),
          ListTile(
            title: const Text('Satın Alma Sipariş Listesi'),
            leading: const Icon(
              Icons.list,
              color: Colors.deepOrange,
              size: 20,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const PurchaseOrderMainList2();
              }));
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.qr_code_2_rounded,
              color: Colors.deepOrange,
              size: 20,
            ),
            title: const Text('Kurulum Yap'),
            onTap: () async {
              await showDialogForReinstallation(
                  context, "Bu işlem sonunda yerel veritabanı silinecektir.");
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.deepOrange,
              size: 20,
            ),
            title: const Text('Ayarlar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const SettingsPage();
              }));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.deepOrange,
              size: 20,
            ),
            title: const Text('Çıkış'),
            onTap: () async {
              /*
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Login();
            }));
            */
              await showDialogForLogout(
                  context, "Bu işlem sonunda yerel veritabanı silinecektir.");
              // ServiceSharedPreferences.setSharedString("jwtToken", "");
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const Login(),
              //   ),
              //   (Route<dynamic> route) => false,
              // );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllDatabaseTable() async {
    ServiceSharedPreferences.setSharedString("jwtToken", "");
    ServiceSharedPreferences.setSharedString(
        UserSpecialSettingsUtils.userWarehouseAuthIn, "");
    ServiceSharedPreferences.setSharedString(
        UserSpecialSettingsUtils.showPriceOnOrder, "");
    ServiceSharedPreferences.setSharedString(
        UserSpecialSettingsUtils.userDefaultWarehouseIn, "");
    ServiceSharedPreferences.setSharedString(
        UserSpecialSettingsUtils.userDefaultWarehouseOut, "");
    ServiceSharedPreferences.setSharedString(
        UserSpecialSettingsUtils.userWarehouseAuthOut, "");

    ServiceSharedPreferences.setSharedString(
        UserSpecialSettingsUtils.isAuthSalesCancelAssign, "");
    ServiceSharedPreferences.setSharedString(
        UserSpecialSettingsUtils.isAuthSalesMakeAssign, "");
    ServiceSharedPreferences.setSharedString(
        UserSpecialSettingsUtils.isAuthSalesChangeOrderStatus, "");
    ServiceSharedPreferences.setSharedString(
        UserSpecialSettingsUtils.isAuthPurchaseCancelAssign, "");
    ServiceSharedPreferences.setSharedString(
        UserSpecialSettingsUtils.isAuthPurchaseMakeAssign, "");
    ServiceSharedPreferences.setSharedString(
        UserSpecialSettingsUtils.isAuthPurchaseChangeOrderStatus, "");
    ServiceSharedPreferences.setSharedInt(
        UserSpecialSettingsUtils.userOrderListFilterId, 1);

    await _dbHelper.clearAllDatabase();
  }

  Future<dynamic> showDialogForReinstallation(
      BuildContext context, String content) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
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
                "İptal",
                style: TextStyle(color: Colors.black),
              )),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange),
            ),
            onPressed: (() async {
              await _clearAllDatabaseTable();
              Navigator.of(context).pop();
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return StartPage();
              }));
            }),
            child: const Text(
              "Evet",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
        title: const Text("Emin Misiniz ?"),
        contentPadding: const EdgeInsets.all(20.0),
        content: Text(content),
      ),
    );
  }

  Future<dynamic> showDialogForLogout(BuildContext context, String content) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
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
                "İptal",
                style: TextStyle(color: Colors.black),
              )),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange),
            ),
            onPressed: (() async {
              await _clearAllDatabaseTable();
              Navigator.of(context).pop();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
                (Route<dynamic> route) => false,
              );
            }),
            child: const Text(
              "Evet",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
        title: const Text("Emin Misiniz ?"),
        contentPadding: const EdgeInsets.all(20.0),
        content: Text(content),
      ),
    );
  }
}
