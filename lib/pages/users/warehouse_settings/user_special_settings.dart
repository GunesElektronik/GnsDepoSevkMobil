import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/user_special_setting_response.dart';
import 'package:gns_warehouse/models/new_api/users/user_list_response.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/users/warehouse_settings/components/user_warehouse_settings_select_area.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';

class UserSpecialSettingsPage extends StatefulWidget {
  const UserSpecialSettingsPage({super.key, required this.user});
  final UserListResponse user;
  @override
  State<UserSpecialSettingsPage> createState() =>
      _UserSpecialSettingsPageState();
}

class _UserSpecialSettingsPageState extends State<UserSpecialSettingsPage> {
  bool isFetched = false;
  String tabType = "inWarehouse";
  String userId = "";
  late ApiRepository apiRepository;
  WorkplaceListResponse? workplaceListResponse;
  late UserSpecialSettingsResponse userSpecialSettingsResponse;
  List<String> userSpecialWarehouseInIdList = [];
  List<WorkplaceDepartmentWarehouse> userSpecialWarehouseInNameList = [];
  List<String> userSpecialWarehouseOutIdList = [];
  List<WorkplaceDepartmentWarehouse> userSpecialWarehouseOutNameList = [];
  List<WorkplaceDepartmentWarehouse> allWarehouse = [];
  @override
  void initState() {
    super.initState();
    print(widget.user.userId);
    userId = widget.user.userId.toString();
    _createApiRepository();
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    workplaceListResponse = await apiRepository.getWorkplaceList();
    try {
      userSpecialSettingsResponse =
          await apiRepository.getUserSpecialSettings(userId);
      _getUserSpecialWarehouseList();
      allWarehouse = await _getAllWarehouse();
      userSpecialWarehouseInNameList =
          await _getUserSpecialWarehouseNameList(userSpecialWarehouseInIdList);
      userSpecialWarehouseOutNameList =
          await _getUserSpecialWarehouseNameList(userSpecialWarehouseOutIdList);

      setState(() {
        isFetched = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void _getUserSpecialWarehouseList() {
    userSpecialSettingsResponse.userSpecialSettings!.forEach((element) {
      if (element.userSpecialSettingCardId == 1) {
        userSpecialWarehouseInIdList =
            _decodeJsonValueToListString(element.value!);
      } else if (element.userSpecialSettingCardId == 3) {
        userSpecialWarehouseOutIdList =
            _decodeJsonValueToListString(element.value!);
      }
    });
  }

  Future<List<WorkplaceDepartmentWarehouse>> _getUserSpecialWarehouseNameList(
      List<String> idList) async {
    List<WorkplaceDepartmentWarehouse> nameList = [];
    workplaceListResponse!.workplaces!.items!.forEach((workplace) {
      workplace.departments!.forEach((department) {
        department.warehouse!.forEach((warehouse) {
          idList.forEach((id) {
            if (id.toLowerCase() == warehouse.warehouseId!.toLowerCase()) {
              WorkplaceDepartmentWarehouse item = WorkplaceDepartmentWarehouse(
                workplace: workplace.definition!,
                department: department.definition!,
                warehouse: warehouse.definition!,
                warehouseId: warehouse.warehouseId!,
              );
              nameList.add(item);
            }
          });
        });
      });
    });

    return nameList;
  }

  Future<List<WorkplaceDepartmentWarehouse>> _getAllWarehouse() async {
    List<WorkplaceDepartmentWarehouse> nameList = [];
    workplaceListResponse!.workplaces!.items!.forEach((workplace) {
      workplace.departments!.forEach((department) {
        department.warehouse!.forEach((warehouse) {
          WorkplaceDepartmentWarehouse item = WorkplaceDepartmentWarehouse(
            workplace: workplace.definition!,
            department: department.definition!,
            warehouse: warehouse.definition!,
            warehouseId: warehouse.warehouseId!,
          );
          nameList.add(item);
        });
      });
    });

    return nameList;
  }

  List<String> _decodeJsonValueToListString(String jsonString) {
    if (jsonString.isNotEmpty) {
      List<dynamic> decodedValue = jsonDecode(jsonString);

      return List<String>.from(decodedValue);
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.only(left: 0, top: 10, right: 0),
          child: Container(
            color: const Color(0xfffafafa),
            child: isFetched
                ? Column(
                    children: [
                      Expanded(
                        child: UserWarehouseSettingsSelectArea(
                          user: widget.user,
                          workplaceListResponse: workplaceListResponse!,
                          allWarehouse: allWarehouse,
                          userSpecialInWarehouseNameList:
                              userSpecialWarehouseInNameList,
                          userSpecialOutWarehouseNameList:
                              userSpecialWarehouseOutNameList,
                          onSelectChange: (value) {
                            tabType = value!;
                          },
                        ),
                      ),

                      // Expanded(
                      //   child: SingleChildScrollView(
                      //     child: Column(children: [
                      //       ListView.builder(
                      //         primary: false,
                      //         shrinkWrap: true,
                      //         itemCount: widget.orderDetailItemList!.length,
                      //         itemBuilder: (context, index) {
                      //           return OrderProductItemRow(
                      //             item: widget.orderDetailItemList![index],
                      //             index: index,
                      //             scannedBarcode: _scannedBarcode,
                      //             scannedTimes: _scannedTimes,
                      //             seriOrBarcode: seriOrBarcode,
                      //             productId: productId,
                      //           );
                      //         },
                      //       ),
                      //     ]),
                      //   ),
                      // ),
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(
          color: Colors.deepOrange[700], size: 32 //change your color here
          ),
      title: Text(
        "Kullanıcı Ambar Ayarları",
        style: TextStyle(
            color: Colors.deepOrange[700],
            fontWeight: FontWeight.bold,
            fontSize: 20),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class WorkplaceDepartmentWarehouse {
  final String workplace;
  final String department;
  final String warehouse;
  final String warehouseId;

  WorkplaceDepartmentWarehouse({
    required this.workplace,
    required this.department,
    required this.warehouse,
    required this.warehouseId,
  });
}
