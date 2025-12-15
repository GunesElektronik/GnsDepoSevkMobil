import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/pages/login.dart';
import 'package:gns_warehouse/pages/splash_screen/gns_splash_screen.dart';
import 'package:gns_warehouse/pages/startpage.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  Future<int> checkAuth() async {
    String apiUrl = await ServiceSharedPreferences.getSharedString("apiUrl") ?? "";
    // String jwtToken =
    //     await ServiceSharedPreferences.getSharedString("jwtToken") ?? "";
    String employeeUsername = await ServiceSharedPreferences.getSharedString("EmployeeUsername") ?? "";

    if (apiUrl.isNotEmpty && employeeUsername.isNotEmpty) {
      return 2;
    } else if (apiUrl.isNotEmpty && employeeUsername.isEmpty) {
      return 1;
    }
    return 0;
  }

  void hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    hideSystemUI();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.amber,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          )

          //primarySwatch: Colors.brown,
          // backgroundColor: const Color.fromARGB(255, 183, 156, 145)
          ),
      home: FutureBuilder<int>(
          future: checkAuth(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Hata: ${snapshot.error}');
            } else {
              if (snapshot.hasData) {
                if (snapshot.data == 2) {
                  return GNSSplashScreen();
                } else if (snapshot.data == 1) {
                  return Login();
                } else {
                  return StartPage();
                }
              } else {
                return StartPage();
              }
            }
          }),
    );
  }
}
