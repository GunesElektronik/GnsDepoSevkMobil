import 'package:flutter/material.dart';
import 'package:gns_warehouse/pages/order_list.dart';
import 'package:gns_warehouse/pages/settings_page/settings_page.dart';
import 'package:gns_warehouse/pages/startpage.dart';
import 'package:gns_warehouse/pages/synchronize.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';

import '../pages/login.dart';

Widget drawerMenu(BuildContext context, String employeeName) {
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
            '${employeeName.toUpperCase()}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.sync,
            color: Colors.deepOrange,
            size: 20,
          ),
          title: const Text('Sipariş Güncelleme'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Synchronize();
            }));
          },
        ),
        ListTile(
          title: const Text('Sipariş Listesi'),
          leading: const Icon(
            Icons.list,
            color: Colors.deepOrange,
            size: 20,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return OrderList();
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
          onTap: () {
            /*
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Login();
            }));
            */
            ServiceSharedPreferences.setSharedString("jwtToken", "");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.qr_code_2_rounded,
            color: Colors.deepOrange,
            size: 20,
          ),
          title: const Text('Kurulum Yap'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return StartPage();
            }));
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
      ],
    ),
  );
}
