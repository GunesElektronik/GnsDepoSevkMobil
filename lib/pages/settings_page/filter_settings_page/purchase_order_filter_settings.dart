import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseOrderFilterSettingsPage extends StatefulWidget {
  const PurchaseOrderFilterSettingsPage({super.key});

  @override
  State<PurchaseOrderFilterSettingsPage> createState() =>
      _PurchaseOrderFilterSettingsPageState();
}

class _PurchaseOrderFilterSettingsPageState
    extends State<PurchaseOrderFilterSettingsPage> {
  bool isLocalDataFetch = false;
  late SharedPreferences sharedPreferences;
  late SharedPreferencesKey sharedPreferencesKey;
  bool isOnlyIsAssingFalse = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPreferencesKey = SharedPreferencesKey();
    _getSharedPreferences();
  }

  void _getSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isOnlyIsAssingFalse = sharedPreferences
              .getBool(sharedPreferencesKey.isOnlyIsAssingFalseForPurchase) ??
          false;
      isLocalDataFetch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.deepOrange[700], size: 32 //change your color here
            ),
        title: Text(
          "Sipariş Filtre Ayarları",
          style: TextStyle(
              color: Colors.deepOrange[700],
              fontWeight: FontWeight.bold,
              fontSize: 20),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: isLocalDataFetch ? _bottomSaveNewFilterData() : null,
      body: isLocalDataFetch ? _body() : _loadingScreen(),
    );
  }

  Center _loadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Container _body() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Card(
            color: Colors.yellow[100],
            child: ListTile(
              trailing: Switch.adaptive(
                value: isOnlyIsAssingFalse,
                onChanged: (value) {
                  setState(() {
                    isOnlyIsAssingFalse = value;
                  });
                },
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.red[200],
                trackOutlineColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
              ),
              title: const Text(
                "Sadece Atanmamış Siparişleri Göster",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          ),
        ],
      ),
    );
  }

  void _saveIsOnlyIsAssingFalseData() {
    sharedPreferences.setBool(
        sharedPreferencesKey.isOnlyIsAssingFalseForPurchase,
        isOnlyIsAssingFalse);
    Navigator.pop(context);
  }

  SizedBox _bottomSaveNewFilterData() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          _saveIsOnlyIsAssingFalseData();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          shadowColor: const Color.fromARGB(255, 255, 251, 0),
          elevation: 5,
        ),
        child: const Text(
          "DEĞİŞİKLİKLERİ KAYDET",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
