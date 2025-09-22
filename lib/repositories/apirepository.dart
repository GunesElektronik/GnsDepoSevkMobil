import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/sharedpreferences_key.dart';
import 'package:gns_warehouse/database/model/product_stock_warehouse_location.dart';
import 'package:gns_warehouse/models/customer_list_response.dart';
import 'package:gns_warehouse/models/new_api/customer_addresses_response.dart';
import 'package:gns_warehouse/models/new_api/customer_risk_limit_response.dart';
import 'package:gns_warehouse/models/new_api/doc_number_get_fiche_number.dart';
import 'package:gns_warehouse/models/new_api/error/error_response.dart';
import 'package:gns_warehouse/models/new_api/locations/stock_location_barcode_response.dart';
import 'package:gns_warehouse/models/new_api/locations/stock_locations_list_response.dart';
import 'package:gns_warehouse/models/new_api/minus_count_fiche/minus_count_fiche_detail_response.dart';
import 'package:gns_warehouse/models/new_api/minus_count_fiche/minus_count_fiche_list_reponse.dart';
import 'package:gns_warehouse/models/new_api/minus_count_fiche/minus_count_fiche_request_body.dart';
import 'package:gns_warehouse/models/new_api/new_customer_list_response.dart';
import 'package:gns_warehouse/models/new_api/order_assing_status_response_new.dart';
import 'package:gns_warehouse/models/new_api/order_change_qty_item_model.dart';
import 'package:gns_warehouse/models/new_api/order_detail_new_model.dart';
import 'package:gns_warehouse/models/new_api/order_header_response_new.dart';
import 'package:gns_warehouse/models/new_api/order_item_entity.dart';
import 'package:gns_warehouse/models/new_api/over_count_fiche/over_count_fiche_detail_response.dart';
import 'package:gns_warehouse/models/new_api/over_count_fiche/over_count_fiche_list_response.dart';
import 'package:gns_warehouse/models/new_api/over_count_fiche/over_count_fiche_request_body.dart';
import 'package:gns_warehouse/models/new_api/product_detail_barcode_response.dart';
import 'package:gns_warehouse/models/new_api/product_list_reponse.dart';
import 'package:gns_warehouse/models/new_api/product_location_list_response.dart';
import 'package:gns_warehouse/models/new_api/project/project_list_response.dart';
import 'package:gns_warehouse/models/new_api/purchase_order/create_purchase_order_request.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_detail.dart';
import 'package:gns_warehouse/models/new_api/purchase_order_summary_list_response.dart';
import 'package:gns_warehouse/models/new_api/purchase_sales_waybills_response.dart';
import 'package:gns_warehouse/models/new_api/request_body/transfer_fiche_request_body.dart';
import 'package:gns_warehouse/models/new_api/sales_order/create_sales_order_request.dart';
import 'package:gns_warehouse/models/new_api/sales_order/create_sales_order_response.dart';
import 'package:gns_warehouse/models/new_api/sales_waybills_response.dart';
import 'package:gns_warehouse/models/new_api/salesman/salesman_list_response.dart';
import 'package:gns_warehouse/models/new_api/shipping_type_list_response.dart';
import 'package:gns_warehouse/models/new_api/stock_counting_fiche/stock_counting_fiche_detail.dart';
import 'package:gns_warehouse/models/new_api/stock_counting_fiche/stock_counting_fiche_update_request.dart';
import 'package:gns_warehouse/models/new_api/stock_counting_fiche/stock_couting_fiche_list_response.dart';
import 'package:gns_warehouse/models/new_api/stock_response.dart';
import 'package:gns_warehouse/models/new_api/transfer_fiche/transfer_fiche_detail_response.dart';
import 'package:gns_warehouse/models/new_api/transfer_fiche/transfer_fiche_list_response.dart';
import 'package:gns_warehouse/models/new_api/transporter_list_response.dart';
import 'package:gns_warehouse/models/new_api/user_special_setting_response.dart';
import 'package:gns_warehouse/models/new_api/users/create_user_warehouse_special_settings_body.dart';
import 'package:gns_warehouse/models/new_api/users/user_list_response.dart';
import 'package:gns_warehouse/models/new_api/warehouse_reverse_response.dart';
import 'package:gns_warehouse/models/new_api/warehouse_transfer_create_body.dart';
import 'package:gns_warehouse/models/new_api/warehouse_transfer_list_response.dart';
import 'package:gns_warehouse/models/new_api/waybill_order_detail_reponse.dart';
import 'package:gns_warehouse/models/new_api/waybill_purchase_order_detail_response.dart';
import 'package:gns_warehouse/models/new_api/waybill_request_body_new.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/models/order_assing_status_response.dart';
import 'package:gns_warehouse/models/order_detail_response.dart';
import 'package:gns_warehouse/models/order_fast_service_item_body.dart';
import 'package:gns_warehouse/models/order_summary.dart';
import 'package:gns_warehouse/models/product_barcode_detail_response.dart';
import 'package:gns_warehouse/models/waybills_request_body.dart';
import 'package:gns_warehouse/repositories/loginrepository.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../database/dbhelper.dart';
import '../models/order_header_summary_result.dart';
import '../pages/login.dart';
import '../services/sharedpreferences.dart';
import 'package:http/http.dart' as http;

class ApiRepository {
  final DbHelper _dbHelper = DbHelper.instance;
  final LoginRepository _loginRepository = LoginRepository();
  final String apiUrlAddress; // = "services.mozaikyazilim.com.tr";
  final bool isSecure;
  final String jwtToken;
  final String employeeUid;
  final String employeeName;
  final String employeeEmail;
  final String employeeUsername;
  final String employeePassword;
  final BuildContext context;

  ApiRepository._init(
      this.apiUrlAddress,
      this.isSecure,
      this.jwtToken,
      this.employeeUid,
      this.employeeName,
      this.employeeEmail,
      this.employeeUsername,
      this.employeePassword,
      this.context);

  static Future<ApiRepository> create(BuildContext context) async {
    String apiUrl =
        await ServiceSharedPreferences.getSharedString("apiUrl") ?? "";
    String token =
        await ServiceSharedPreferences.getSharedString("jwtToken") ?? "";
    String employeeUid =
        await ServiceSharedPreferences.getSharedString("EmployeeUID") ?? "";
    String employeeName =
        await ServiceSharedPreferences.getSharedString("EmployeeName") ?? "";
    String employeeEmail =
        await ServiceSharedPreferences.getSharedString("EmployeeEmail") ?? "";
    String employeeUsername =
        await ServiceSharedPreferences.getSharedString("EmployeeUsername") ??
            "";
    String employeePassword =
        await ServiceSharedPreferences.getSharedString("EmployeePassword") ??
            "";

    bool secured = apiUrl.contains('https://') ? true : false;

    String url = apiUrl.replaceAll("https://", "").replaceAll("http://", "");

    return ApiRepository._init(url, secured, token, employeeUid, employeeName,
        employeeEmail, employeeUsername, employeePassword, context);
  }

  void redirectToLoginPage() {
    ServiceSharedPreferences.setSharedString("jwtToken", "");
    ServiceSharedPreferences.setSharedString("EmployeeUID", "");
    ServiceSharedPreferences.setSharedString("EmployeeName", "");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void createNewToken() async {
    await _loginRepository.getLoginEmployee(employeeUsername, employeePassword);
  }
/*
//eski api
  Future<bool> setOrderAssingStatus(
      bool isAssing, String userId, String orderId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/api/v1/OrderAssingStatus/change');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/api/v1/OrderAssingStatus/change');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    var body = json.encode({
      "isAssing": isAssing,
      "userId": userId,
      "orderId": orderId,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = OrderAssingStatusResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
        return result.data!.isSuccess as bool;
      } else if (response.statusCode == 401) {
        MyApp().navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => const Login()),
            );
        return false;
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  */

  Future<bool> setOrderAssingStatus(
      bool isAssing, String userId, String orderId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/orders/change/assing');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/orders/change/assing');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    var body = json.encode({
      "isAssing": isAssing,
      "userId": userId,
      "orderId": orderId,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = OrderAssingStatusResponseNew.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
        return result.isSuccess as bool;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
        return false;
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> setSalesOrderStatus(String orderId, int orderStatusId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/orders/change/orderstatus');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/orders/change/orderstatus');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    var body = json.encode({
      "orderId": orderId,
      "orderStatusId": orderStatusId,
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var result = OrderAssingStatusResponseNew.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
      return result.isSuccess as bool;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
      return false;
    } else {
      var errorBody = json.decode(response.body);
      ErrorResponse errorResponse = ErrorResponse.fromJson(errorBody);

      throw 'Hata kodu: ${errorResponse.status} \n ${errorResponse.title} \n ${errorResponse.detail}';
    }
  }

  Future<bool> setPurchaseOrderStatus(String orderId, int orderStatusId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/purchaseorders/change/orderstatus');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/purchaseorders/change/orderstatus');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    var body = json.encode({
      "orderId": orderId,
      "orderStatusId": orderStatusId,
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var result = OrderAssingStatusResponseNew.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
      return result.isSuccess as bool;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
      return false;
    } else {
      var errorBody = json.decode(response.body);
      ErrorResponse errorResponse = ErrorResponse.fromJson(errorBody);

      throw 'Hata kodu: ${errorResponse.status} \n ${errorResponse.title} \n ${errorResponse.detail}';
    }
  }

  Future<bool> setPurchaseOrderAssingStatus(
      bool isAssing, String userId, String purchaseOrderId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/purchaseorders/change/assing');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/purchaseorders/change/assing');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    var body = json.encode({
      "isAssing": isAssing,
      "userId": userId,
      "orderId": purchaseOrderId,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = OrderAssingStatusResponseNew.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
        return result.isSuccess as bool;
      } else if (response.statusCode == 401) {
        /*
        MyApp().navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => const Login()),
            );
            */
        redirectToLoginPage();
        return false;
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      return false;
    }
  }

/*
//eski api
  Future<OrderDetailResponse> getOrderDetail(String orderId) async {
    //var url = Uri.parse("$apiUrlAddress/api/v1/Order/$orderId/detail");
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/api/v1/Order/$orderId/detail');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/api/v1/Order/$orderId/detail');
    }
    print("token: $jwtToken");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = OrderDetailResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        MyApp().navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => const Login()),
            );
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get order detail \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }
  */
  Future<OrderDetailResponseNew> getOrderDetail(String orderId) async {
    //var url = Uri.parse("$apiUrlAddress/api/v1/Order/$orderId/detail");
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/order/$orderId');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/order/$orderId');
    }
    print("token: $jwtToken");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = OrderDetailResponseNew.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get order detail \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<ProductBarcodeDetailResponse> getProductBasedOnBarcode(
      String productBarcode) async {
    //var url = Uri.parse("$apiUrlAddress/api/v1/Order/$orderId/detail");
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/products/get/$productBarcode');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/products/get/$productBarcode');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    var response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      var result = ProductBarcodeDetailResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>);

      return result;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else if (response.statusCode == 404) {
      throw Exception('Girdiğiniz barkodla eşleşen bir ürün bulunamadı.');
    } else {
      throw Exception(
          'Failed to get product detail \nStatus Code: ${response.statusCode}');
    }

    throw Exception('Beklenmedik bir hata');
  }

/*
//ESKİ ENDPOINT
  Future<List<OrderSummary>?> getOrderSummaryList() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/api/v1/OrderHeaderSummary/list');
    } else {
      url = Uri.http(apiUrlAddress, '/api/v1/OrderHeaderSummary/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "paging": {"page": 1, "limit": 100}
    });

    List<OrderSummary>? ordersummaries = [];

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = OrderSummaryResult.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.data != null) {
          ordersummaries = result.data;
          await _dbHelper.addOrderHeaders(result.data!);
        }

        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

        ServiceSharedPreferences.setSharedString("UpdateDate", formattedDate);
      } else if (response.statusCode == 401) {
        MyApp().navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => const Login()),
            );
      } else {
        throw Exception('Failed to load Product Item');
      }
    } finally {}

    return ordersummaries;
  }
  */

  Future<OrderSummaryListResponseNew?> getOrderSummaryListSearch(
      int page,
      String ficheQuery,
      String customerQuery,
      String orderStatusQuery,
      String userEmail,
      int isAssingOperator) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/ordersummaries/list');
    } else {
      url = Uri.http(apiUrlAddress, '/ordersummaries/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "ficheNo", "operator": 4, "value": "$ficheQuery"},
        {"field": "customer", "operator": 4, "value": "$customerQuery"},
        {"field": "orderStatus", "operator": 4, "value": "$orderStatusQuery"},
        {
          "field": "assingmentEmail",
          "operator": isAssingOperator,
          "value": userEmail
        },
      ],
      "sorts": [
        {"field": "ficheDate", "direction": 2}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = OrderSummaryListResponseNew.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } finally {}

    return null;
  }

  Future<List<OrderSummaryItem>?> getOrderSummaryList() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/ordersummaries/list');
    } else {
      url = Uri.http(apiUrlAddress, '/ordersummaries/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": 0,
      "pageSize": 100,
      "filters": [
        {"field": "string", "operator": 1, "value": "string"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    List<OrderSummaryItem>? ordersummaries = [];

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = OrderSummaryListResponseNew.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.orders!.items != null) {
          ordersummaries = result.orders!.items;
          await _dbHelper.addOrderHeaders(result.orders!.items!);
        }

        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

        ServiceSharedPreferences.setSharedString("UpdateDate", formattedDate);
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } finally {}

    return ordersummaries;
  }
  /*
  Future<List<OrderItemHeader>?> getOrderSummaryListsilindi() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/orders/list');
    } else {
      url = Uri.http(apiUrlAddress, '/orders/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": 0,
      "pageSize": 0,
      "filters": [
        {"field": "string", "operator": 1, "value": "string"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    List<OrderItemHeader>? ordersummaries = [];

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = NewOrderItem.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.orders!.items != null) {
          ordersummaries = result.orders!.items;
          await _dbHelper.addOrderHeaders(result.orders!.items!);
        }

        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

        ServiceSharedPreferences.setSharedString("UpdateDate", formattedDate);
      } else if (response.statusCode == 401) {
        MyApp().navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => const Login()),
            );
      } else {
        throw Exception('Failed to load Product Item');
      }
    } finally {}

    return ordersummaries;
  }
  */

/*
//ESKİ ENDPOINTLER İLE YAPILDI
  Future<String> getOrderSummaryCount() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/api/v1/OrderHeaderSummary/list');
    } else {
      url = Uri.http(apiUrlAddress, '/api/v1/OrderHeaderSummary/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "paging": {"page": 1, "limit": 100}
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var result = OrderSummaryResult.fromJson(
          json.decode(response.body) as Map<String, dynamic>);

      if (result.data != null) {
        return result.data!.length.toString();
      } else {
        return "0";
      }
    } else if (response.statusCode == 401) {
      MyApp().navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => const Login()),
          );
    } else {
      throw Exception('Okunamadı');
    }

    return "0";
  }
  */

  Future<String> getOrderSummaryCount() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/ordersummaries/list');
    } else {
      url = Uri.http(apiUrlAddress, '/ordersummaries/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": 0,
      "pageSize": 0,
      "filters": [
        {"field": "string", "operator": 1, "value": "string"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var result = OrderSummaryListResponseNew.fromJson(
          json.decode(response.body) as Map<String, dynamic>);

      if (result.orders!.items != null) {
        return result.orders!.totalItems.toString();
      } else {
        return "0";
      }
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      throw Exception('Okunamadı');
    }

    return "0";
  }

/*
//eski api
  Future<CustomerListResponse?> getCustomer() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/api/v1/Customer/list');
    } else {
      url = Uri.http(apiUrlAddress, '/api/v1/Customer/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "paging": {"page": 1, "limit": 100}
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = CustomerListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
      } else {
        throw Exception('Failed to load Product Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
  */

  Future<NewCustomerListResponse?> getCustomer() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/customers/list');
    } else {
      url = Uri.http(apiUrlAddress, '/customers/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
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
        var result = NewCustomerListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<NewCustomerListResponse?> getCustomerDeneme(int page) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/customers/list');
    } else {
      url = Uri.http(apiUrlAddress, '/customers/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 200,
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
        var result = NewCustomerListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<NewCustomerListResponse?> getCustomerDenemeSearch(
      int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/customers/list');
    } else {
      url = Uri.http(apiUrlAddress, '/customers/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 200,
      "filters": [
        {"field": "name", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = NewCustomerListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<NewCustomerListResponse?> getCustomerBasedOnNameAndCode(
      int page, String name, String code) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/customers/list');
    } else {
      url = Uri.http(apiUrlAddress, '/customers/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 200,
      "filters": [
        {"field": "name", "operator": 1, "value": name},
        {"field": "code", "operator": 1, "value": code}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = NewCustomerListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

/*
//eski api
  Future<bool> updateOrderItems(String orderId, String customerId,
      List<OrderFastServiceItem> orderItems) async {
    Uri url;
    var jsonOrderItems =
        orderItems.map((orderItem) => orderItem.toJson()).toList();
    orderItems.map((orderItem) => orderItem.toJson()).toList();
    if (isSecure == true) {
      url =
          Uri.https(apiUrlAddress, '/api/v1/OrderFastService/$orderId/change');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/api/v1/OrderFastService/$orderId/change');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    var body = json.encode({
      "customerId": customerId,
      "orderItems": jsonOrderItems,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        return false;
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  */
  Future<bool> updateOrderItems(String orderId, String customerId,
      List<OrderUpdateQtyItem> orderItems) async {
    Uri url;
    var jsonOrderItems =
        orderItems.map((orderItem) => orderItem.toJson()).toList();
    orderItems.map((orderItem) => orderItem.toJson()).toList();
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/orders/change/shippedqty/');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/orders/change/shippedqty/');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    var body = json.encode({
      "orderId": orderId,
      "shippedQty": jsonOrderItems,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
        return false;
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePurchaseOrderItems(String orderId, String customerId,
      List<OrderUpdateQtyItem> orderItems) async {
    Uri url;
    var jsonOrderItems =
        orderItems.map((orderItem) => orderItem.toJson()).toList();
    orderItems.map((orderItem) => orderItem.toJson()).toList();
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/purchaseorders/change/shippedqty/');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/purchaseorders/change/shippedqty/');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    var body = json.encode({
      "orderId": orderId,
      "shippedQty": jsonOrderItems,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
        return false;
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<PurchaseOrderSummaryListResponse?> getPurchaseOrderSummaryListSearch(
      int page,
      String query,
      String customerQuery,
      String orderStatusQuery,
      String userEmail,
      int isAssingOperator) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/purchaseordersummaries/list');
    } else {
      url = Uri.http(apiUrlAddress, '/purchaseordersummaries/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "ficheNo", "operator": 4, "value": "$query"},
        {"field": "customer", "operator": 4, "value": "$customerQuery"},
        {"field": "orderStatus", "operator": 4, "value": "$orderStatusQuery"},
        {
          "field": "assingmentEmail",
          "operator": isAssingOperator,
          "value": userEmail
        },
      ],
      "sorts": [
        {"field": "ficheDate", "direction": 2}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = PurchaseOrderSummaryListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } finally {}

    return null;
  }

  Future<List<PurchaseOrderSummaryItem>?> getPurchaseOrderSummaryList() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/purchaseordersummaries/list');
    } else {
      url = Uri.http(apiUrlAddress, '/purchaseordersummaries/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": 0,
      "pageSize": 100,
      "filters": [
        {"field": "string", "operator": 1, "value": "string"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    List<PurchaseOrderSummaryItem>? ordersummaries = [];

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = PurchaseOrderSummaryListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.orders!.items != null) {
          ordersummaries = result.orders!.items;
          await _dbHelper.addPurchaseOrderSummarys(result.orders!.items!);
        }

        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

        ServiceSharedPreferences.setSharedString(
            SharedPreferencesKey().purchaseOrderUpdateDate, formattedDate);
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Order Purchase Item');
      }
    } finally {}

    return ordersummaries;
  }

  Future<List<PurchaseOrderSummaryItem>?>
      getPurchaseOrderSummaryListBasedOnCustomer(
          String customerName, String ficheNo) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/purchaseordersummaries/list');
    } else {
      url = Uri.http(apiUrlAddress, '/purchaseordersummaries/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": 0,
      "pageSize": 100,
      "filters": [
        {"field": "customer", "operator": 4, "value": customerName},
        {"field": "ficheNo", "operator": 4, "value": ficheNo}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    List<PurchaseOrderSummaryItem>? ordersummaries = [];

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = PurchaseOrderSummaryListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.orders!.items != null) {
          result.orders!.items!.forEach((element) {
            if (!element.isAssing!) {
              ordersummaries!.add(element);
            }
          });
        }
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Order Purchase Item');
      }
    } finally {}

    return ordersummaries;
  }

  Future<List<OrderSummaryItem>?> getSalesOrderSummaryListBasedOnCustomer(
      String customerName, String ficheNo) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/ordersummaries/list');
    } else {
      url = Uri.http(apiUrlAddress, '/ordersummaries/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": 0,
      "pageSize": 100,
      "filters": [
        {"field": "customer", "operator": 4, "value": customerName},
        {"field": "ficheNo", "operator": 4, "value": ficheNo}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    List<OrderSummaryItem>? ordersummaries = [];

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = OrderSummaryListResponseNew.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.orders!.items != null) {
          result.orders!.items!.forEach((element) {
            if (!element.isAssing!) {
              ordersummaries.add(element);
            }
          });
        }
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Order Purchase Item');
      }
    } finally {}

    return ordersummaries;
  }

  Future<String> getPurchaseOrderSummaryCount() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/purchaseordersummaries/list');
    } else {
      url = Uri.http(apiUrlAddress, '/purchaseordersummaries/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": 0,
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
        var result = PurchaseOrderSummaryListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        if (result.orders!.items != null) {
          return result.orders!.totalItems.toString();
        }
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Order Purchase Item');
      }
    } finally {}

    return "0";
  }

  Future<PurchaseOrderDetailResponse> getPurchaseOrderDetail(
      String orderId) async {
    //var url = Uri.parse("$apiUrlAddress/api/v1/Order/$orderId/detail");
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/purchaseorder/$orderId');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/purchaseorder/$orderId');
    }
    print("token: $jwtToken");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = PurchaseOrderDetailResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get purchase order detail \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<TransporterListResponse?> getTransporterList() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/transporters/list');
    } else {
      url = Uri.http(apiUrlAddress, '/transporters/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
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
        var result = TransporterListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load TransporterS List Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<TransporterListResponse?> getTransporterListSearch(
      int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/transporters/list');
    } else {
      url = Uri.http(apiUrlAddress, '/transporters/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "code", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = TransporterListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load TransporterS List Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<SalesmenListResponse?> getSalesmenListSearch(
      int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/salesmen/list');
    } else {
      url = Uri.http(apiUrlAddress, '/salesmen/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "name", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = SalesmenListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load TransporterS List Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<ShippingTypeListResponse?> getShippingTypeListSearch(
      int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/shippingType/list');
    } else {
      url = Uri.http(apiUrlAddress, '/shippingType/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "name", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = ShippingTypeListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load TransporterS List Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<ShippingTypeListResponse?> getShippingTypeList() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/shippingType/list');
    } else {
      url = Uri.http(apiUrlAddress, '/shippingType/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
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
        var result = ShippingTypeListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Shipping Type List Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<WorkplaceListResponse?> getWorkplaceList() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/workplaces/list');
    } else {
      url = Uri.http(apiUrlAddress, '/workplaces/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": 1,
      "pageSize": 10,
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
        var result = WorkplaceListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Shipping Type List Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<bool> createWaybill(WayybillsRequestBodyNew waybillBody) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/waybills');
    } else {
      url = Uri.http(apiUrlAddress, '/waybills');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode(waybillBody.toJson());

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      var errorBody = json.decode(response.body);
      ErrorResponse errorResponse = ErrorResponse.fromJson(errorBody);

      throw 'Hata kodu: ${errorResponse.status} \n ${errorResponse.title} \n ${errorResponse.detail}';
    }

    return false;
  }

  Future<bool> createWaybillPurchaseOrder(
      WayybillsRequestBodyNew waybillBody) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/purchasewaybills');
    } else {
      url = Uri.http(apiUrlAddress, '/purchasewaybills');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode(waybillBody.toJson());

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      var errorBody = json.decode(response.body);
      ErrorResponse errorResponse = ErrorResponse.fromJson(errorBody);

      throw 'Hata kodu: ${errorResponse.status} \n ${errorResponse.title} \n ${errorResponse.detail}';
    }

    return false;
  }

  Future<ProductStockWarehouseResponse> getProductStockWarehouse(
      String productId) async {
    //var url = Uri.parse("$apiUrlAddress/api/v1/Order/$orderId/detail");
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/stockWarehouseLocation/$productId');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/stockWarehouseLocation/$productId');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = ProductStockWarehouseResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get order detail \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<StockLocationsListResponse> getAllLocationList() async {
    //var url = Uri.parse("$apiUrlAddress/api/v1/Order/$orderId/detail");
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/StockLocations/list');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/StockLocations/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    var body = json.encode({
      "page": 1,
      "pageSize": 10,
      "filters": [
        {"field": "string", "operator": 1, "value": "string"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var result = StockLocationsListResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>);

      return result;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      print('HTTP Hata Kodu: ${response.statusCode}');
      throw Exception(
          'Failed to get order detail \nStatus Code: ${response.statusCode}');
    }

    throw Exception('Beklenmedik bir hata');
  }

  Future<ProductLocationResponse> getProductLocationList(
      String productId) async {
    //var url = Uri.parse("$apiUrlAddress/api/v1/Order/$orderId/detail");
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/productlocation/$productId');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/productlocation/$productId');
    }
    print("token: $jwtToken");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = ProductLocationResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get order detail \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<SalesWaybillsResponse?> getOrderWaybillSummaryList(
      int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/waybillsummaries/list');
    } else {
      url = Uri.http(apiUrlAddress, '/waybillsummaries/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "ficheNo", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var result = SalesWaybillsResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>);

      return result;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      throw Exception('Failed to load Product Item');
    }
  }

  Future<PurchaseSalesWaybillsResponse?> getPurchaseOrderWaybillSummaryList(
      int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/purchasewaybillsummaries/list');
    } else {
      url = Uri.http(apiUrlAddress, '/purchasewaybillsummaries/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "ficheNo", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var result = PurchaseSalesWaybillsResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>);

      return result;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      throw Exception('Failed to load Product Item');
    }
  }

  Future<WaybillPurchaseOrderDetailResponse> getWaybillPurchaseOrderDetail(
      String waybillId) async {
    //var url = Uri.parse("$apiUrlAddress/api/v1/Order/$orderId/detail");
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/purchaseWaybill/$waybillId');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/purchaseWaybill/$waybillId');
    }
    print("token: $jwtToken");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = WaybillPurchaseOrderDetailResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get purchase order detail \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<WaybillOrderDetailResponse> getWaybillOrderDetail(
      String waybillId) async {
    //var url = Uri.parse("$apiUrlAddress/api/v1/Order/$orderId/detail");
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/waybill/$waybillId');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/waybill/$waybillId');
    }
    print("token: $jwtToken");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = WaybillOrderDetailResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get purchase order detail \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<bool> createWarehouseTransfer(
      WarehouseTransferCreateBody transferBody) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/warehouseTransfer');
    } else {
      url = Uri.http(apiUrlAddress, '/warehouseTransfer');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode(transferBody.toJson());

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      var errorBody = json.decode(response.body);
      ErrorResponse errorResponse = ErrorResponse.fromJson(errorBody);

      throw 'Hata kodu: ${errorResponse.status} \n ${errorResponse.title} \n ${errorResponse.detail}';
    }

    return false;
  }

  Future<ProductListReponse?> getProductList() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/products/list');
    } else {
      url = Uri.http(apiUrlAddress, '/products/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": 1,
      "pageSize": 200,
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
        var result = ProductListReponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<ProductListReponse?> getProductListSearch(
      int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/products/list');
    } else {
      url = Uri.http(apiUrlAddress, '/products/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 200,
      "filters": [
        {"field": "definition", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = ProductListReponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<CustomerAddressesResponse> getCustomerAddresses(
      String customerId) async {
    //var url = Uri.parse("$apiUrlAddress/api/v1/Order/$orderId/detail");
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/customers/$customerId/addresses');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/customers/$customerId/addresses');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        var result = CustomerAddressesResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else if (response.statusCode == 404) {
        throw Exception('Adres Bulunamadı');
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get order detail \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<WarehouseTransferListResponse?> getWarehouseTransferList() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/warehouseTransfers/list');
    } else {
      url = Uri.http(apiUrlAddress, '/warehouseTransfers/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": 1,
      "pageSize": 200,
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
        var result = WarehouseTransferListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to fetch warehouse transfer list');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<WorkplaceListResponse?> getAuthBasedOnWorkplace() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/workplaces/list');
    } else {
      url = Uri.http(apiUrlAddress, '/workplaces/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": 1,
      "pageSize": 10,
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
        var result = WorkplaceListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        //redirectToLoginPage();
      } else {
        throw Exception('Failed to load Shipping Type List Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<ProductDetailBarcodeResponse> getProductDetailBarcodes(
      String productId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/products/$productId');
    } else {
      url = Uri.http(apiUrlAddress, '/products/$productId');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = ProductDetailBarcodeResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get product detail \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<StockResponse?> getStockByProductIdList(
      List<String> productIdList) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/stock/getStockByProductIdList');
    } else {
      url = Uri.http(apiUrlAddress, '/stock/getStockByProductIdList');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "productIdList": productIdList,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = StockResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Shipping Type List Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<WarehouseReverseResponse> getWarehouseReverse(
      String warehouseId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/warehouseReverse/$warehouseId');
    } else {
      url = Uri.http(apiUrlAddress, '/warehouseReverse/$warehouseId');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = WarehouseReverseResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get warehouse reverse \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<bool> getSystemSettingsList() async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/systemsettings/list');
    } else {
      url = Uri.http(apiUrlAddress, '/systemsettings/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
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
        ServiceSharedPreferences.setSharedBool(
            SharedPreferencesKey.isPriceVisible, false);
        // var result = PurchaseOrderSummaryListResponse.fromJson(
        //     json.decode(response.body) as Map<String, dynamic>);
        return true;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Order Purchase Item');
      }
    } finally {}

    return false;
  }

  Future<CustomerRiskLimitResponse> getCustomerRiskLimit(
      String customerId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/customers/$customerId/risklimit');
    } else {
      url = Uri.http(apiUrlAddress, '/customers/$customerId/risklimit');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = CustomerRiskLimitResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get warehouse reverse \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<DocNumberGetFicheNumberResponse?> getDocNumberFicheNumber(
      String userId, String transactionTypeId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/docnumber/getFicheNumber');
    } else {
      url = Uri.http(apiUrlAddress, '/docnumber/getFicheNumber');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "filteredRequestDto": {
        "userId": userId,
        "transactionTypeId": transactionTypeId
      }
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = DocNumberGetFicheNumberResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<ProductListReponse?> getProductListBasedOnBarcode(
      String barcode) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/products/list');
    } else {
      url = Uri.http(apiUrlAddress, '/products/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": 1,
      "pageSize": 1,
      "filters": [
        {"field": "barcode", "operator": 1, "value": barcode}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var result = ProductListReponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
      return result;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      throw Exception('Failed to load Product Item');
    }

    return null;
  }

  Future<bool> createTransferFiche(
      TransferFicheRequestBody transferBody) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/transferFiche');
    } else {
      url = Uri.http(apiUrlAddress, '/transferFiche');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode(transferBody.toJson());

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      var errorBody = json.decode(response.body);
      ErrorResponse errorResponse = ErrorResponse.fromJson(errorBody);

      throw 'Hata kodu: ${errorResponse.status} \n ${errorResponse.title} \n ${errorResponse.detail}';
    }

    return false;
  }

  Future<TransferFicheListResponse?> getTransferFicheList(
      int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/transferFiches/list');
    } else {
      url = Uri.http(apiUrlAddress, '/transferFiches/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "ficheNo", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = TransferFicheListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } finally {}

    return null;
  }

  Future<StockCountingFicheListResponse?> getStockCountingFicheList(
      int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/stockcountingfiches/list');
    } else {
      url = Uri.http(apiUrlAddress, '/stockcountingfiches/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "ficheNo", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "ficheDate", "direction": 2}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = StockCountingFicheListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } finally {}

    return null;
  }

  Future<StockCountingFicheDetail?> getStockCountingFicheDetail(
      String ficheId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/stockcountingfiche/$ficheId');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/stockcountingfiche/$ficheId');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var result = StockCountingFicheDetail.fromJson(
          json.decode(response.body) as Map<String, dynamic>);

      return result;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      throw Exception(
          'Detay bilgileri alınamadı \nStatus Code: ${response.statusCode}');
    }
  }

  Future<TransferFicheDetailResponse> getTransferFicheDetail(
      String ficheId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/transferFiche/$ficheId');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/transferFiche/$ficheId');
    }
    print("token: $jwtToken");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = TransferFicheDetailResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get purchase order detail \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<bool> createOverCountFiche(
      OverCountFicheRequestBody overCountFicheBody) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/overCountFiche');
    } else {
      url = Uri.http(apiUrlAddress, '/overCountFiche');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode(overCountFicheBody.toJson());

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      var errorBody = json.decode(response.body);
      ErrorResponse errorResponse = ErrorResponse.fromJson(errorBody);

      throw 'Hata kodu: ${errorResponse.status} \n ${errorResponse.title} \n ${errorResponse.detail}';
    }

    return false;
  }

  Future<OverCountFicheListResponse?> getOverCountFicheList(
      int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/overCountFiche/list');
    } else {
      url = Uri.http(apiUrlAddress, '/overCountFiche/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "ficheNo", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = OverCountFicheListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } finally {}

    return null;
  }

  Future<OverCountFicheDetailResponse> getOverCountFicheDetail(
      String ficheId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/overCountFiche/$ficheId');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/overCountFiche/$ficheId');
    }
    print("token: $jwtToken");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = OverCountFicheDetailResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get purchase order detail \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<bool> createMinusCountFiche(
      MinusCountFicheRequestBody minusCountFicheBody) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/minusCountFiche');
    } else {
      url = Uri.http(apiUrlAddress, '/minusCountFiche');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode(minusCountFicheBody.toJson());

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      var errorBody = json.decode(response.body);
      ErrorResponse errorResponse = ErrorResponse.fromJson(errorBody);

      throw 'Hata kodu: ${errorResponse.status} \n ${errorResponse.title} \n ${errorResponse.detail}';
    }

    return false;
  }

  Future<MinusCountFicheListResponse?> getMinusCountFicheList(
      int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/minusCountFiche/list');
    } else {
      url = Uri.http(apiUrlAddress, '/minusCountFiche/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "ficheNo", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = MinusCountFicheListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } finally {}

    return null;
  }

  Future<MinusCountFicheDetailResponse> getMinusCountFicheDetail(
      String ficheId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/minusCountFiche/$ficheId');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/minusCountFiche/$ficheId');
    }
    print("token: $jwtToken");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = MinusCountFicheDetailResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get purchase order detail \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<List<UserListResponse>?> getUserList(int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/users/list');
    } else {
      url = Uri.http(apiUrlAddress, '/users/list');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "ficheNo", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = json.decode(response.body).cast<Map<String, dynamic>>();
        return result
            .map<UserListResponse>((json) => UserListResponse.fromJson(json))
            .toList();
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load Product Item');
      }
    } finally {}

    return null;
  }

  Future<UserSpecialSettingsResponse> getUserSpecialSettings(
      String userId) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/users/userSpecialSettings/$userId');
    } else {
      url = Uri.http(apiUrlAddress, '/users/userSpecialSettings/$userId');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = UserSpecialSettingsResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        print('HTTP Hata Kodu: ${response.statusCode}');
        throw Exception(
            'Failed to get user special settings \nStatus Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    throw Exception('Beklenmedik bir hata');
  }

  Future<bool> createUserWarehouseSpecialSettings(
      CreateUserWarehouseSpecialSettingsBody settingsBody) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/users/userSpecialSettings');
    } else {
      url = Uri.http(apiUrlAddress, '/users/userSpecialSettings');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode(settingsBody.toJson());

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else if (response.statusCode == 500) {
      return false;
    } else {
      return false;
    }

    return false;
  }

  Future<ProjectListResponse?> getProjectListSearch(
      int page, String query) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/projects/list');
    } else {
      url = Uri.http(apiUrlAddress, '/projects/list');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode({
      "page": page,
      "pageSize": 100,
      "filters": [
        {"field": "code", "operator": 4, "value": "$query"}
      ],
      "sorts": [
        {"field": "string", "direction": 1}
      ]
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var result = ProjectListResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        return result;
      } else if (response.statusCode == 401) {
        redirectToLoginPage();
      } else {
        throw Exception('Failed to load TransporterS List Item');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<CreateSalesOrderResponse?> createSalesOrder(
      CreateSalesOrderRequest orderBody) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/orders');
    } else {
      url = Uri.http(apiUrlAddress, '/orders');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode(orderBody.toJson());

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var result = CreateSalesOrderResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
      return result;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      var errorBody = json.decode(response.body);
      ErrorResponse errorResponse = ErrorResponse.fromJson(errorBody);

      throw 'Hata kodu: ${errorResponse.status} \n ${errorResponse.title} \n ${errorResponse.detail}';
    }

    return null;
  }

  Future<CreateSalesOrderResponse?> createPurchaseOrder(
      CreatePurchaseOrderRequest orderBody) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/purchaseorders');
    } else {
      url = Uri.http(apiUrlAddress, '/purchaseorders');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode(orderBody.toJson());

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var result = CreateSalesOrderResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
      return result;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      var errorBody = json.decode(response.body);
      ErrorResponse errorResponse = ErrorResponse.fromJson(errorBody);

      throw 'Hata kodu: ${errorResponse.status} \n ${errorResponse.title} \n ${errorResponse.detail}';
    }

    return null;
  }

  Future<StockLocationBarcodeResponse?> getStockLocationBasedOnBarcode(
      String barcode) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/stockLocations/get/$barcode');
      print("url: $url");
    } else {
      url = Uri.http(apiUrlAddress, '/stockLocations/get/$barcode');
    }
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var result = StockLocationBarcodeResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>);

      return result;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      throw Exception(
          'Lokasyon bilgileri alınamadı \nStatus Code: ${response.statusCode}');
    }
  }

  Future<bool> updateStockCountingFiche(
      StockCountingFicheUpdateRequest updateBody) async {
    Uri url;
    if (isSecure == true) {
      url = Uri.https(apiUrlAddress, '/stockcountingfiche');
    } else {
      url = Uri.http(apiUrlAddress, '/stockcountingfiche');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = json.encode(updateBody.toJson());

    var response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      redirectToLoginPage();
    } else {
      var errorBody = json.decode(response.body);
      ErrorResponse errorResponse = ErrorResponse.fromJson(errorBody);

      throw 'Hata kodu: ${errorResponse.status} \n ${errorResponse.title} \n ${errorResponse.detail}';
    }

    return false;
  }
}
