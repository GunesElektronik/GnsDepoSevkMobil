import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:gns_warehouse/pages/settings_page/filter_settings_page/order_filter_settings.dart';
import 'package:gns_warehouse/pages/settings_page/filter_settings_page/purchase_order_filter_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.deepOrange[700], size: 32 //change your color here
            ),
        title: Text(
          "Ayarlar",
          style: TextStyle(
              color: Colors.deepOrange[700], fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.amber[50],
        width: double.infinity,
        child: Column(
          children: [
            _settingCard("Sipariş Verme Filtre Ayarları", () {
              Navigator.of(context).push<String>(MaterialPageRoute(
                builder: (context) => const OrderFilterSettingsPage(),
              ));
            }),
            _settingCard("Sipariş Alma Filtre Ayarları", () {
              Navigator.of(context).push<String>(MaterialPageRoute(
                builder: (context) => const PurchaseOrderFilterSettingsPage(),
              ));
            }),
          ],
        ),
      ),
    );
  }

  Padding _settingCard(String title, Function()? onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Card(
        color: Colors.amber[200],
        child: ListTile(
          onTap: onTap,
          leading: const Icon(Icons.tune),
          trailing: const Icon(
            Icons.chevron_right,
            size: 30,
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
      ),
    );
  }
}
