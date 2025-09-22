import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';

import '../repositories/apirepository.dart';
import '../repositories/loginrepository.dart';
import '../services/sharedpreferences.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  LoginRepository _loginRepository = new LoginRepository();

  late ApiRepository apiRepository;
  ServiceSharedPreferences sharedPreferences = ServiceSharedPreferences();
  String _resultMessage = "Lütfen giriş yapınız.";

  String firmTitle = "";

  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    //initApiRepository();
    _getFirmTitle();
  }

  void _getFirmTitle() async {
    firmTitle = await ServiceSharedPreferences.getSharedString(
            SharedPreferencesKey.firmTitle) ??
        "";

    setState(() {});
  }

  void initApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.dstOut,
              )),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Color.fromARGB(218, 255, 225, 191),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Icon(
                            Icons.account_circle_outlined,
                            color: Color.fromARGB(255, 33, 37, 37),
                            size: 60,
                          ),
                          const SizedBox(
                            width: 80,
                            height: 20,
                          ),
                          const Text(
                            'Merhaba',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            _resultMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: userName,
                            onChanged: (value) {},
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF4F5F7),
                              hintText: "Kullanıcı Adı",
                              prefixIcon: const Icon(
                                Icons.person_pin_circle_outlined,
                                color: Color(0XFF2e7d32),
                                size: 20,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            validator: (value) {
                              if (value != null) {
                                if (value.isEmpty) {
                                  return 'Kullanıcı Adı Gerekli';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: password,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF4F5F7),
                              hintText: "Şifre",
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0XFF2e7d32),
                                size: 16,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            validator: (value) {
                              if (value != null) {
                                if (value.isEmpty) {
                                  return 'Şifre Gerekli';
                                }
                              }
                              return null;
                            },
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (newValue) {
                                  setState(() {
                                    rememberMe = newValue!;
                                  });
                                },
                                activeColor: Colors.amber,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    rememberMe =
                                        !rememberMe; // Checkbox'ın değerini tersine çevir
                                  });
                                },
                                child: const Text(
                                  "Beni Hatırla",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Color(0XFFFFFFFF)),
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          semanticsLabel: "Yükleniyor...",
                                        ),
                                      );
                                    });

                                final formIsValid =
                                    formKey.currentState?.validate();

                                print("valid : ${formIsValid}");

                                if (formIsValid == true) {
                                  var _result =
                                      await _loginRepository.getLoginEmployee(
                                          userName.text, password.text);
                                  if (_result != null) {
                                    if (rememberMe) {
                                      ServiceSharedPreferences.setSharedString(
                                          "EmployeeUsername", userName.text);
                                      ServiceSharedPreferences.setSharedString(
                                          "EmployeePassword", password.text);
                                    }
                                    await _loginRepository
                                        .getUserSpecialSettings(
                                            _result.token!, _result.userUid!);
                                    await _loginRepository.getUserPermission(
                                        _result.token!, _result.userUid!);
                                    await _loginRepository
                                        .getFirmInformation(_result.token!);
                                    await _loginRepository
                                        .getSystemSettingsList(_result.token!);
                                    Navigator.of(context).pop();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Home(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  } else {
                                    setState(() {
                                      _resultMessage = "Kullanıcı Bulunamadı";
                                      Navigator.of(context).pop();
                                    });
                                  }
                                } else {
                                  print("Form Geçersiz");
                                  setState(() {
                                    _resultMessage = "Eksik Bilgileri Giriniz";
                                    Navigator.of(context).pop();
                                  });
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Text("Giriş Yap",
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: const Color.fromARGB(218, 255, 225, 191),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        firmTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 192, 52, 9),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
