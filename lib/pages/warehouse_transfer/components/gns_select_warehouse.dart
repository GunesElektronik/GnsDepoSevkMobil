import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/custom_colors.dart';
import 'package:gns_warehouse/constants/user_special_settings.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';
import 'package:gns_warehouse/services/sharedpreferences.dart';

class GNSSelectWarehouseList extends StatefulWidget {
  GNSSelectWarehouseList({
    super.key,
    required this.title,
    required this.response,
    required this.isErrorActiveForWorkplace,
    required this.isErrorActiveForDepartment,
    required this.isErrorActiveForWarehouse,
    required this.onValueChanged,
    this.titleTextColor = Colors.deepOrange,
  });

  final String title;
  final bool isErrorActiveForWorkplace;
  final bool isErrorActiveForDepartment;
  final bool isErrorActiveForWarehouse;
  WorkplaceListResponse response;
  final ValueChanged<WorkplaceDepartmentWarehouse> onValueChanged;
  Color titleTextColor;
  @override
  State<GNSSelectWarehouseList> createState() => _GNSSelectWarehouseListState();
}

class _GNSSelectWarehouseListState extends State<GNSSelectWarehouseList> {
  late ApiRepository apiRepository;

  String workplaceNameInit = "İş Yeri";
  String departmentNameInit = "Departman";
  String warehouseNameInit = "Ambar";

  String workplaceName = "İş Yeri";
  String departmentName = "Departman";
  String warehouseName = "Ambar";

  String workplaceId = "";
  String departmentId = "";
  String warehouseId = "";

  bool isErrorActiveForWorkplace = false;
  bool isErrorActiveForDepartment = false;
  bool isErrorActiveForWarehouse = false;

  List<Departments> departments = [];
  List<WorkplaceWarehouse> warehouses = [];
  List<WorkplaceWarehouse> allWarehouse = [];

  List<String> userSpecialWarehouseList = [];
  String userSpecialDefaultWarehouse = "";
  bool isThereWarehouseBoundForUser = false;

  bool isLoading = false;
  bool isFetched = false;

  Color errorColor = GNSCustomColor().errorColor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isErrorActiveForWorkplace = widget.isErrorActiveForWorkplace;
    isErrorActiveForDepartment = widget.isErrorActiveForDepartment;
    isErrorActiveForWarehouse = widget.isErrorActiveForWarehouse;
    _createApiRepository();
    allWarehouse = _getAllWarehouseList();
  }

  @override
  void didUpdateWidget(GNSSelectWarehouseList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isErrorActiveForWorkplace !=
        widget.isErrorActiveForWorkplace) {
      isErrorActiveForWorkplace = widget.isErrorActiveForWorkplace;
      setState(() {});
    }

    if (oldWidget.isErrorActiveForDepartment !=
        widget.isErrorActiveForDepartment) {
      isErrorActiveForDepartment = widget.isErrorActiveForDepartment;
      setState(() {});
    }

    if (oldWidget.isErrorActiveForWarehouse !=
        widget.isErrorActiveForWarehouse) {
      isErrorActiveForWarehouse = widget.isErrorActiveForWarehouse;
      setState(() {});
    }
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
    userSpecialWarehouseList = await _getUserSpecialWarehouseSettings();
    if (userSpecialDefaultWarehouse.isNotEmpty) {
      await _reverseWarehouse(userSpecialDefaultWarehouse.toLowerCase());
      _fillDepartmenAndWarehouseListBasedOnDefaultWarehouse();
    }

    setState(() {
      isFetched = true;
    });
  }

  _fillDepartmenAndWarehouseListBasedOnDefaultWarehouse() {
    widget.response.workplaces!.items!.forEach((workplace) {
      if (workplaceId == workplace.workplaceId!) {
        departments = workplace.departments!;
        departments.forEach((department) {
          if (department.departmentId == departmentId) {
            warehouses = department.warehouse!;
          }
        });
      }
    });
  }

  Future<List<String>> _getUserSpecialWarehouseSettings() async {
    String userSpecialSetting;

    if (widget.title == "Giriş") {
      userSpecialSetting = await ServiceSharedPreferences.getSharedString(
              UserSpecialSettingsUtils.userWarehouseAuthIn) ??
          "";
      var sharedDefaultWarehouse =
          await ServiceSharedPreferences.getSharedString(
                  UserSpecialSettingsUtils.userDefaultWarehouseIn) ??
              "";
      if (sharedDefaultWarehouse.isNotEmpty) {
        userSpecialDefaultWarehouse = jsonDecode(sharedDefaultWarehouse);
      }
    } else {
      userSpecialSetting = await ServiceSharedPreferences.getSharedString(
              UserSpecialSettingsUtils.userWarehouseAuthOut) ??
          "";
      var sharedDefaultWarehouse =
          await ServiceSharedPreferences.getSharedString(
                  UserSpecialSettingsUtils.userDefaultWarehouseOut) ??
              "";
      if (sharedDefaultWarehouse.isNotEmpty) {
        userSpecialDefaultWarehouse = jsonDecode(sharedDefaultWarehouse);
      }
    }

    if (userSpecialSetting.isNotEmpty) {
      List<dynamic> decodedValue = jsonDecode(userSpecialSetting);

      setState(() {
        isThereWarehouseBoundForUser = true;
      });
      return List<String>.from(decodedValue);
    } else {
      return [];
    }
  }

  Future<void> _reverseWarehouse(String defaultWarehouseId) async {
    try {
      var response =
          await apiRepository.getWarehouseReverse(defaultWarehouseId);

      warehouseId = response.warehouse!.warehouseId.toString();
      warehouseName = response.warehouse!.code.toString();

      workplaceId = response.warehouse!.departments!.workplace!.workplaceId!;
      workplaceName = response.warehouse!.departments!.workplace!.code!;

      departmentId = response.warehouse!.departments!.departmentId!;
      departmentName = response.warehouse!.departments!.code!;

      updateInfo();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isFetched
        ? Column(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    color: widget.titleTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 7,
              ),
              _row(workplaceName, workplaceNameInit, isErrorActiveForWorkplace,
                  () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _workplaceBottomSheet(widget.response),
                );
              }),
              const SizedBox(
                height: 5,
              ),
              _row(departmentName, departmentNameInit,
                  isErrorActiveForDepartment, () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _departmentsBottomSheet(departments),
                );
              }),
              const SizedBox(
                height: 5,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : _row(
                      warehouseName,
                      warehouseNameInit,
                      isErrorActiveForWarehouse,
                      isWorkplaceIdAndDepartmentIdEmpty()
                          ? selectWarehouseReverse
                          : selectWarehouse,
                      // () {
                      //   showModalBottomSheet(
                      //     context: context,
                      //     builder: (context) => _warehouseBottomSheet(warehouses),
                      //   );
                      // },
                    ),
            ],
          )
        : const CircularProgressIndicator();
  }

  bool isWorkplaceIdAndDepartmentIdEmpty() {
    if (workplaceId.isEmpty && departmentId.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  List<WorkplaceWarehouse> _limitWarehouseBasedOnSetting(
      List<WorkplaceWarehouse> mainList, List<String> limitedList) {
    List<WorkplaceWarehouse> newList = [];
    mainList.forEach((element) {
      limitedList.forEach((warehouseId) {
        if (element.warehouseId!.toLowerCase() == warehouseId.toLowerCase()) {
          newList.add(element);
        }
      });
    });

    return newList;
  }

  void selectWarehouse() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _warehouseBottomSheet(isThereWarehouseBoundForUser
          ? _limitWarehouseBasedOnSetting(warehouses, userSpecialWarehouseList)
          : warehouses),
    );
  }

  void selectWarehouseReverse() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _selectWarehouseByAllWarehousBottomSheet(
          isThereWarehouseBoundForUser
              ? _limitWarehouseBasedOnSetting(
                  allWarehouse, userSpecialWarehouseList)
              : allWarehouse),
    );
  }

  Row _row(
      String title, String initTitle, bool isErrorActive, Function()? onTap) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              border: Border.all(
                color: isErrorActive ? errorColor : Colors.black,
                width: isErrorActive ? 1.5 : 1,
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color:
                      title == initTitle ? Colors.blueGrey[200] : Colors.black,
                ),
              ),
            ),
          ),
        ),
        // const SizedBox(
        //   width: 10,
        // ),
        SizedBox(
          height: 50,
          width: 50,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              splashColor: const Color.fromARGB(255, 255, 223, 187),
              onTap: onTap,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    // border: Border.all(
                    //   color: Colors.black,
                    //   width: 1.0,
                    // ),
                    border: Border(
                      top: BorderSide(
                        width: isErrorActive ? 1.5 : 1,
                        color: isErrorActive ? errorColor : Colors.black,
                      ),
                      bottom: BorderSide(
                        width: isErrorActive ? 1.5 : 1,
                        color: isErrorActive ? errorColor : Colors.black,
                      ),
                      right: BorderSide(
                        width: isErrorActive ? 1.5 : 1,
                        color: isErrorActive ? errorColor : Colors.black,
                      ),
                    ),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.view_list_rounded,
                    color: Colors.blueGrey[300],
                    size: 30,
                  ))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _workplaceBottomSheet(WorkplaceListResponse response) {
    double leftPadding = 8.0;
    return Container(
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            //Geçmiş İşlemler Text
            Container(
              decoration: BoxDecoration(
                color: Colors.deepOrange[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Workplace",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: response.workplaces!.items!.length,
                        itemBuilder: (context, index) {
                          return _selectingAreaRowItem(
                              response.workplaces!.items![index].code!, () {
                            workplaceId =
                                response.workplaces!.items![index].workplaceId!;
                            workplaceName =
                                response.workplaces!.items![index].code!;
                            departments =
                                response.workplaces!.items![index].departments!;

                            departmentName = "";
                            departmentId = "";
                            warehouseName = "";
                            warehouseId = "";

                            updateInfo();
                            Navigator.pop(context);
                            setState(() {});
                            showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  _departmentsBottomSheet(departments),
                            );
                          });
                        },
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _departmentsBottomSheet(List<Departments> departments) {
    double leftPadding = 8.0;
    return Container(
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            //Geçmiş İşlemler Text
            Container(
              decoration: BoxDecoration(
                color: Colors.deepOrange[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Department",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: departments.length,
                        itemBuilder: (context, index) {
                          return _selectingAreaRowItem(departments[index].code!,
                              () {
                            departmentName = departments[index].code!;
                            departmentId = departments[index].departmentId!;

                            warehouseName = "";
                            warehouseId = "";

                            warehouses = departments[index].warehouse!;
                            updateInfo();
                            Navigator.pop(context);

                            setState(() {});
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => _warehouseBottomSheet(
                                  isThereWarehouseBoundForUser
                                      ? _limitWarehouseBasedOnSetting(
                                          warehouses, userSpecialWarehouseList)
                                      : warehouses),
                            );
                          });
                        },
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _warehouseBottomSheet(List<WorkplaceWarehouse> warehouse) {
    double leftPadding = 8.0;
    return Container(
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            //Geçmiş İşlemler Text
            Container(
              decoration: BoxDecoration(
                color: Colors.deepOrange[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Warehouse",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: warehouse.length,
                        itemBuilder: (context, index) {
                          return _selectingAreaRowItem(warehouse[index].code!,
                              () {
                            warehouseName = warehouse[index].code!;
                            warehouseId = warehouse[index].warehouseId!;
                            updateInfo();
                            Navigator.pop(context);
                            setState(() {});
                          });
                        },
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectWarehouseByAllWarehousBottomSheet(
      List<WorkplaceWarehouse> warehouse) {
    double leftPadding = 8.0;
    return Container(
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            //Geçmiş İşlemler Text
            Container(
              decoration: BoxDecoration(
                color: Colors.deepOrange[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Warehouse",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: warehouse.length,
                        itemBuilder: (context, index) {
                          return _selectingAreaRowItem(warehouse[index].code!,
                              () async {
                            warehouseName = warehouse[index].code!;
                            warehouseId = warehouse[index].warehouseId!;
                            setState(() {
                              isLoading = true;
                            });
                            var response = await apiRepository
                                .getWarehouseReverse(warehouseId);
                            setState(() {
                              isLoading = false;
                            });
                            workplaceId = response.warehouse!.departments!
                                .workplace!.workplaceId!;
                            workplaceName = response
                                .warehouse!.departments!.workplace!.code!;

                            departmentId =
                                response.warehouse!.departments!.departmentId!;
                            departmentName =
                                response.warehouse!.departments!.code!;

                            widget.response.workplaces!.items!
                                .forEach((workplace) {
                              if (workplace.workplaceId == workplaceId) {
                                workplace.departments!.forEach((department) {
                                  if (department.departmentId == departmentId) {
                                    warehouses = department.warehouse!;
                                  }
                                });
                              }
                            });

                            updateInfo();
                            Navigator.pop(context);
                            setState(() {});
                          });
                        },
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _selectingAreaRowItem(String title, Function()? onTap) {
    return Card(
      elevation: 0,
      child: InkWell(
        splashColor: Colors.deepOrangeAccent,
        onTap: onTap,
        child: ListTile(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  List<WorkplaceWarehouse> _getAllWarehouseList() {
    List<WorkplaceWarehouse> list = [];
    widget.response.workplaces!.items!.forEach((workplace) {
      workplace.departments!.forEach((department) {
        department.warehouse!.forEach((warehouse) {
          list.add(warehouse);
        });
      });
    });

    return list;
  }

  void updateInfo() {
    WorkplaceDepartmentWarehouse info = WorkplaceDepartmentWarehouse(
      workplaceName: workplaceName,
      departmentName: departmentName,
      warehouseName: warehouseName,
      workplaceId: workplaceId,
      departmentId: departmentId,
      warehouseId: warehouseId,
    );
    widget.onValueChanged(info);
  }
}

class WorkplaceDepartmentWarehouse {
  final String workplaceName;
  final String departmentName;
  final String warehouseName;
  final String workplaceId;
  final String departmentId;
  final String warehouseId;

  WorkplaceDepartmentWarehouse({
    required this.workplaceName,
    required this.departmentName,
    required this.warehouseName,
    required this.workplaceId,
    required this.departmentId,
    required this.warehouseId,
  });
}
