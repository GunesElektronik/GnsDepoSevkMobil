import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/home.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/repositories/loginrepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';

class GNSSplashScreen extends StatefulWidget {
  const GNSSplashScreen({super.key});

  @override
  State<GNSSplashScreen> createState() => _GNSSplashScreenState();
}

class _GNSSplashScreenState extends State<GNSSplashScreen> {
  late ApiRepository apiRepository;
  final LoginRepository _loginRepository = LoginRepository();
  late String employeeUsername;
  late String employeePassword;
  WorkplaceListResponse? response;

  @override
  void initState() {
    super.initState();
    getSharedParameter();
  }

  void getSharedParameter() async {
    apiRepository = await ApiRepository.create(context);
    await Future.delayed(const Duration(seconds: 2));
    employeeUsername = await ServiceSharedPreferences.getSharedString("EmployeeUsername") ?? "";
    employeePassword = await ServiceSharedPreferences.getSharedString("EmployeePassword") ?? "";
    response = await apiRepository.getAuthBasedOnWorkplace();

    if (response == null) {
      // await _loginRepository.getLoginEmployee(
      //     employeeUsername, employeePassword);
      apiRepository = await ApiRepository.create(context);

      // await apiRepository.getSystemSettingsList();
    } else {
      // await apiRepository.getSystemSettingsList();
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Home()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Lütfen Bekleyiniz",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ClipOval(
                child: Image.asset(
                  'assets/images/background.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
