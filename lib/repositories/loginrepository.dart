import 'dart:convert';
import 'package:gns_warehouse/constants/service_constants.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:gns_warehouse/constants/system_settings.dart';
import 'package:gns_warehouse/constants/user_special_settings.dart';
import 'package:gns_warehouse/models/new_api/firms/firm_list_response.dart';
import 'package:gns_warehouse/models/new_api/system_settings/system_settings_list_response.dart';
import 'package:gns_warehouse/models/new_api/user_special_setting_response.dart';
import 'package:gns_warehouse/models/new_api/users/user_permission_response.dart';

import '../models/employeeresult.dart';
import '../services/sharedpreferences.dart';
import 'package:http/http.dart' as http;

class LoginRepository {
  /*
  //eski api
  Future<bool> checkApi(String? apiurl) async {
    try {
      bool isSecure = apiurl!.contains('https://') ? true : false;

      apiurl = apiurl
          ?.replaceAll('"', '')
          .replaceAll('https://', '')
          .replaceAll('http://', '');

      if (apiurl != null) {
        var url = isSecure
            ? Uri.https(apiurl, '/api/TestService')
            : Uri.http(apiurl, '/api/TestService');

        var response = await http.get(url);

        if (response.statusCode == 200) {
          var apiresult = response.body;
          return (apiresult == 'true');
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }
  */

  Future<bool> checkApi(String? apiurl) async {
    try {
      bool isSecure = apiurl!.contains('https://') ? true : false;

      apiurl = apiurl
          ?.replaceAll('"', '')
          .replaceAll('https://', '')
          .replaceAll('http://', '');

      if (apiurl != null) {
        var url = isSecure
            ? Uri.https(apiurl, '/tests/control')
            : Uri.http(apiurl, '/tests/control');

        var response = await http.get(url);

        if (response.statusCode == 200) {
          var apiresult = response.body;
          return (apiresult == 'true');
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }

/*
  Future<EmployeeResult?> getLoginEmployee(
      String username, String password) async {
    String? apiUrl =
        await ServiceSharedPreferences.getSharedString("apiUrl") ?? "";

    if (apiUrl.isNotEmpty) {}
    bool isSecure = apiUrl.contains('https://') ? true : false;

    apiUrl = apiUrl
        .replaceAll('"', '')
        .replaceAll('https://', '')
        .replaceAll('http://', '');

    var url = isSecure
        ? Uri.https(apiUrl, '/api/User/login')
        : Uri.http(apiUrl, '/api/User/login');

    try {
      var body = jsonEncode({'userName': username, 'password': password});

      var headers = {'Content-Type': 'application/json'};

      var response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        var result = EmployeeResult.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.token != null) {
          ServiceSharedPreferences.setSharedString(
              "jwtToken", result.token.toString());
          ServiceSharedPreferences.setSharedString(
              "EmployeeUID", result.userUid ?? '');
          ServiceSharedPreferences.setSharedString(
              "EmployeeCode", result.code ?? '');
          ServiceSharedPreferences.setSharedString(
              "EmployeeName", result.fullName ?? '');
        }

        return result;
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }
  */

  Future<EmployeeResult?> getLoginEmployee(
      String username, String password) async {
    String? apiUrl =
        await ServiceSharedPreferences.getSharedString("apiUrl") ?? "";

    if (apiUrl.isNotEmpty) {}
    bool isSecure = apiUrl.contains('https://') ? true : false;

    apiUrl = apiUrl
        .replaceAll('"', '')
        .replaceAll('https://', '')
        .replaceAll('http://', '');

    var url = isSecure
        ? Uri.https(apiUrl, '/users/login')
        : Uri.http(apiUrl, '/users/login');

    try {
      var body = jsonEncode({'userName': username, 'password': password});

      var headers = {'Content-Type': 'application/json'};

      var response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        var result = EmployeeResult.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.token != null) {
          ServiceSharedPreferences.setSharedString(
              "jwtToken", result.token.toString());
          ServiceSharedPreferences.setSharedString(
              "EmployeeUID", result.userUid ?? '');
          ServiceSharedPreferences.setSharedString(
              "EmployeeCode", result.code ?? '');
          ServiceSharedPreferences.setSharedString(
              "EmployeeName", result.fullName ?? '');
          ServiceSharedPreferences.setSharedString(
              "EmployeeEmail", result.uEmail ?? '');
          // ServiceSharedPreferences.setSharedString(
          //     "EmployeeUsername", username);
          // ServiceSharedPreferences.setSharedString(
          //     "EmployeePassword", password);
        }

        return result;
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  Future<UserSpecialSettingsResponse?> getUserSpecialSettings(
      String token, String userId) async {
    String? apiUrl =
        await ServiceSharedPreferences.getSharedString("apiUrl") ?? "";

    if (apiUrl.isNotEmpty) {}
    bool isSecure = apiUrl.contains('https://') ? true : false;

    apiUrl = apiUrl
        .replaceAll('"', '')
        .replaceAll('https://', '')
        .replaceAll('http://', '');

    var url = isSecure
        ? Uri.https(apiUrl, '/users/userSpecialSettings/$userId')
        : Uri.http(apiUrl, '/users/userSpecialSettings/$userId');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var result = UserSpecialSettingsResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.userSpecialSettings!.isNotEmpty) {
          result.userSpecialSettings!.forEach((element) {
            if (element.userSpecialSettingCardId! == 1) {
              ServiceSharedPreferences.setSharedString(
                  UserSpecialSettingsUtils.userWarehouseAuthIn, element.value!);
            } else if (element.userSpecialSettingCardId! == 2) {
              ServiceSharedPreferences.setSharedBool(
                  SharedPreferencesKey.isPriceVisible, element.value!);
            } else if (element.userSpecialSettingCardId! == 3) {
              ServiceSharedPreferences.setSharedString(
                  UserSpecialSettingsUtils.userWarehouseAuthOut,
                  element.value!);
            } else if (element.userSpecialSettingCardId! == 4) {
              ServiceSharedPreferences.setSharedString(
                  UserSpecialSettingsUtils.userDefaultWarehouseIn,
                  element.value!);
            } else if (element.userSpecialSettingCardId! == 5) {
              ServiceSharedPreferences.setSharedString(
                  UserSpecialSettingsUtils.userDefaultWarehouseOut,
                  element.value!);
            } else if (element.userSpecialSettingCardId! == 6) {
              int filterId = 1;
              try {
                filterId = int.parse(element.value!);
              } catch (e) {}
              ServiceSharedPreferences.setSharedInt(
                  UserSpecialSettingsUtils.userOrderListFilterId, filterId);
            }
          });
        }

        return result;
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  Future<void> getUserPermission(String token, String userId) async {
    String? apiUrl =
        await ServiceSharedPreferences.getSharedString("apiUrl") ?? "";

    if (apiUrl.isNotEmpty) {}
    bool isSecure = apiUrl.contains('https://') ? true : false;

    apiUrl = apiUrl
        .replaceAll('"', '')
        .replaceAll('https://', '')
        .replaceAll('http://', '');

    var url = isSecure
        ? Uri.https(apiUrl, '/users/permission/$userId')
        : Uri.http(apiUrl, '/users/permission/$userId');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var result = UserPermissionResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.permissions!.isNotEmpty) {
          result.permissions!.forEach((element) {
            if (element.permissionName! ==
                ServiceConstants.SalesMakeAssignPermission) {
              ServiceSharedPreferences.setSharedBool(
                  UserSpecialSettingsUtils.isAuthSalesMakeAssign,
                  element.isAuth!);
            } else if (element.permissionName! ==
                ServiceConstants.SalesCancelAssignPermission) {
              ServiceSharedPreferences.setSharedBool(
                  UserSpecialSettingsUtils.isAuthSalesCancelAssign,
                  element.isAuth!);
            } else if (element.permissionName! ==
                ServiceConstants.SalesChangeOrderStatus) {
              ServiceSharedPreferences.setSharedBool(
                  UserSpecialSettingsUtils.isAuthSalesChangeOrderStatus,
                  element.isAuth!);
            } else if (element.permissionName! ==
                ServiceConstants.PurchaseMakeAssignPermission) {
              ServiceSharedPreferences.setSharedBool(
                  UserSpecialSettingsUtils.isAuthPurchaseMakeAssign,
                  element.isAuth!);
            } else if (element.permissionName! ==
                ServiceConstants.PurchaseCancelAssignPermission) {
              ServiceSharedPreferences.setSharedBool(
                  UserSpecialSettingsUtils.isAuthPurchaseCancelAssign,
                  element.isAuth!);
            } else if (element.permissionName! ==
                ServiceConstants.PurchaseChangeOrderStatus) {
              ServiceSharedPreferences.setSharedBool(
                  UserSpecialSettingsUtils.isAuthPurchaseChangeOrderStatus,
                  element.isAuth!);
            }
          });
        }
      }
    } on Exception {
      return null;
    }
  }

  Future<SystemSettingsListResponse?> getSystemSettingsList(
      String token) async {
    String? apiUrl =
        await ServiceSharedPreferences.getSharedString("apiUrl") ?? "";

    if (apiUrl.isNotEmpty) {}
    bool isSecure = apiUrl.contains('https://') ? true : false;

    apiUrl = apiUrl
        .replaceAll('"', '')
        .replaceAll('https://', '')
        .replaceAll('http://', '');

    var url = isSecure
        ? Uri.https(apiUrl, '/systemsettings/list')
        : Uri.http(apiUrl, '/systemsettings/list');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var result = SystemSettingsListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.systemSettings != null) {
          result.systemSettings!.forEach((settingsElement) {
            if (settingsElement.systemSettingId == 6) {
              //WaybillTypeSelection
              ServiceSharedPreferences.setSharedString(
                  GNSSystemSettingsUtils.WaybillTypeSelection,
                  settingsElement.value!);
            } else if (settingsElement.systemSettingId == 7) {
              //WarehouseTransferTypeSelection
              ServiceSharedPreferences.setSharedString(
                  GNSSystemSettingsUtils.WarehouseTransferTypeSelection,
                  settingsElement.value!);
            } else if (settingsElement.systemSettingId == 20) {
              //WarehouseTransferTypeSelection
              ServiceSharedPreferences.setSharedBool(
                  GNSSystemSettingsUtils.OrderAssignAutoDrop,
                  settingsElement.value! == "true");
            }
          });
        }

        // if (result.!.isNotEmpty) {
        //   result.userSpecialSettings!.forEach((element) {
        //     if (element.userSpecialSettingCardId! == 1) {
        //       ServiceSharedPreferences.setSharedString(
        //           UserSpecialSettingsUtils.userWarehouseAuthIn, element.value!);
        //     } else if (element.userSpecialSettingCardId! == 2) {
        //       ServiceSharedPreferences.setSharedBool(
        //           SharedPreferencesKey.isPriceVisible, element.value!);
        //     } else if (element.userSpecialSettingCardId! == 3) {
        //       ServiceSharedPreferences.setSharedString(
        //           UserSpecialSettingsUtils.userWarehouseAuthOut,
        //           element.value!);
        //     } else if (element.userSpecialSettingCardId! == 4) {
        //       ServiceSharedPreferences.setSharedString(
        //           UserSpecialSettingsUtils.userDefaultWarehouseIn,
        //           element.value!);
        //     } else if (element.userSpecialSettingCardId! == 5) {
        //       ServiceSharedPreferences.setSharedString(
        //           UserSpecialSettingsUtils.userDefaultWarehouseOut,
        //           element.value!);
        //     }
        //   });
        // }

        return result;
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  Future<void> getFirmInformation(String token) async {
    String? apiUrl =
        await ServiceSharedPreferences.getSharedString("apiUrl") ?? "";

    if (apiUrl.isNotEmpty) {}
    bool isSecure = apiUrl.contains('https://') ? true : false;

    apiUrl = apiUrl
        .replaceAll('"', '')
        .replaceAll('https://', '')
        .replaceAll('http://', '');

    var url = isSecure
        ? Uri.https(apiUrl, '/firms/list')
        : Uri.http(apiUrl, '/firms/list');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = json.encode({
      "page": 1,
      "pageSize": 100,
      "filters": [
        {"field": "string", "operator": 1, "value": "string"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = FirmListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.firms?.items?[0].title != null) {
          ServiceSharedPreferences.setSharedString(
              SharedPreferencesKey.firmTitle,
              result.firms!.items![0].title.toString());
        }
      } else if (response.statusCode == 401) {
      } else {
        throw Exception('Failed to load firm info');
      }
    } finally {}
  }
}
