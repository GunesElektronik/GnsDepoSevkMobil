import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gns_warehouse/models/new_api/users/user_list_response.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/users/warehouse_settings/user_special_settings.dart';
import 'package:gns_warehouse/pages/users/warehouse_settings/user_warehouse_in_settings_page.dart';
import 'package:gns_warehouse/pages/users/warehouse_settings/user_warehouse_out_settings_page.dart';

// ignore: must_be_immutable
class UserWarehouseSettingsSelectArea extends StatefulWidget {
  UserWarehouseSettingsSelectArea({
    super.key,
    required this.user,
    required this.workplaceListResponse,
    required this.allWarehouse,
    required this.userSpecialInWarehouseNameList,
    required this.userSpecialOutWarehouseNameList,
    required this.onSelectChange,
  });
  List<WorkplaceDepartmentWarehouse> userSpecialInWarehouseNameList;
  List<WorkplaceDepartmentWarehouse> userSpecialOutWarehouseNameList;
  List<WorkplaceDepartmentWarehouse> allWarehouse;
  final UserListResponse user;
  final ValueChanged<String?> onSelectChange;
  WorkplaceListResponse workplaceListResponse;

  @override
  State<UserWarehouseSettingsSelectArea> createState() =>
      _UserWarehouseSettingsSelectAreaState();
}

class _UserWarehouseSettingsSelectAreaState
    extends State<UserWarehouseSettingsSelectArea>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;

  String inWarehouse = "inWarehouse";
  String outWarehouse = "outWarehouse";

  // @override
  // void didUpdateWidget(covariant UserWarehouseSettingsSelectArea oldWidget) {
  //   // TODO: implement didUpdateWidget
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 0) {
        widget.onSelectChange(inWarehouse);
      } else {
        widget.onSelectChange(outWarehouse);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    padding: const EdgeInsets.only(bottom: 0),
                    tabAlignment: TabAlignment.fill,
                    indicatorPadding: const EdgeInsets.symmetric(vertical: 2),
                    indicatorColor: Colors.deepOrange,
                    labelColor: Colors.deepOrange,
                    unselectedLabelColor: const Color(0xff959b9b),
                    indicator: BoxDecoration(
                        color: const Color(0xfffef8ec),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        border: Border.all(color: Colors.deepOrange, width: 1)),
                    //isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerHeight: 3,
                    dividerColor: Colors.deepOrange,
                    tabs: const [
                      Tab(
                        child: Text(
                          "GİRİŞ",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "ÇIKIŞ",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  _userNameText("${widget.user.name} ${widget.user.surname}"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    UserWarehouseInSettingsPage(
                      userId: widget.user.userId.toString(),
                      userSpecialWarehouseNameList:
                          widget.userSpecialInWarehouseNameList,
                      allWarehouse: widget.allWarehouse,
                      workplaceListResponse: widget.workplaceListResponse,
                    ),
                    UserWarehouseOutSettingsPage(
                      userId: widget.user.userId.toString(),
                      userSpecialWarehouseNameList:
                          widget.userSpecialOutWarehouseNameList,
                      allWarehouse: widget.allWarehouse,
                      workplaceListResponse: widget.workplaceListResponse,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  String capitalize(String input) {
    if (input.isEmpty) return input;

    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  Row _userNameText(String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "  Kullanıcı: ${capitalize(userName)}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
