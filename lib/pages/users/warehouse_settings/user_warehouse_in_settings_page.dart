import 'package:flutter/material.dart';
import 'package:gns_warehouse/models/new_api/users/create_user_warehouse_special_settings_body.dart';
import 'package:gns_warehouse/models/new_api/workplace_list_response.dart';
import 'package:gns_warehouse/pages/users/warehouse_settings/components/user_special_warehouse_item_row.dart';
import 'package:gns_warehouse/pages/users/warehouse_settings/user_special_settings.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';

// ignore: must_be_immutable
class UserWarehouseInSettingsPage extends StatefulWidget {
  UserWarehouseInSettingsPage(
      {super.key,
      required this.userId,
      required this.userSpecialWarehouseNameList,
      required this.allWarehouse,
      required this.workplaceListResponse});
  List<WorkplaceDepartmentWarehouse> userSpecialWarehouseNameList;
  List<WorkplaceDepartmentWarehouse> allWarehouse;
  WorkplaceListResponse workplaceListResponse;
  String userId;

  @override
  State<UserWarehouseInSettingsPage> createState() =>
      _UserWarehouseInSettingsPageState();
}

class _UserWarehouseInSettingsPageState
    extends State<UserWarehouseInSettingsPage>
    with AutomaticKeepAliveClientMixin {
  final Color contentDarkColor = const Color.fromARGB(255, 0, 108, 196);
  List<WorkplaceDepartmentWarehouse> finalWarehouseList = [];
  late ApiRepository apiRepository;
  int userSpecialSettingCardId = 1;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createApiRepository();
    widget.userSpecialWarehouseNameList.forEach((element) {
      finalWarehouseList.add(element);
    });
  }

  _createApiRepository() async {
    apiRepository = await ApiRepository.create(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                padding:
                    const EdgeInsets.only(top: 0, right: 8, bottom: 0, left: 8),
                itemCount: widget.allWarehouse.length,
                itemBuilder: (context, index) {
                  bool isSelectedBefore = false;

                  widget.userSpecialWarehouseNameList
                      .forEach((selectedWarehouse) {
                    if (selectedWarehouse.warehouseId.toLowerCase() ==
                        widget.allWarehouse[index].warehouseId.toLowerCase()) {
                      isSelectedBefore = true;
                    }
                  });
                  return UserSpecialWarehouseItemRow(
                      item: widget.allWarehouse[index],
                      isSelected: (newValue) {
                        if (newValue!) {
                          finalWarehouseList.add(widget.allWarehouse[index]);
                        } else {
                          finalWarehouseList.removeWhere((item) =>
                              item.warehouseId ==
                              widget.allWarehouse[index].warehouseId);
                        }
                      },
                      isSelectedBefore: isSelectedBefore,
                      index: index + 1);
                  // return _row(
                  //     widget.userSpecialWarehouseNameList[index], index + 1);
                },
              ),
            ),
          ),
          _saveChangesButton(),
        ],
      ),
    ));
  }

  Padding _row(WorkplaceDepartmentWarehouse item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 230, 220, 202),
            borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 20),
          minVerticalPadding: 1,
          leading: Text(
            index < 10 ? '0$index' : index.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          title: Text(
            item.warehouse,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${item.workplace} - ${item.department}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          onTap: null,
          dense: true,
        ),
      ),
    );
  }

  _showLoadingScreen(bool isLoading, String content) {
    if (isLoading) {
      return showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: content,
              ),
            );
          });
    } else {
      Navigator.pop(context); // Loading screen'i kapat
    }
  }

  Padding _saveChangesButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Card(
            color: Colors.orangeAccent,
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: const Color.fromARGB(255, 255, 223, 187),
              onTap: () async {
                _showLoadingScreen(true, "Güncelleniyor...");
                await apiRepository
                    .createUserWarehouseSpecialSettings(_createRequestBody());
                _showLoadingScreen(false, "Güncelleniyor...");
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kaydedildi'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Değişiklikleri Kaydet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  CreateUserWarehouseSpecialSettingsBody _createRequestBody() {
    List<String> warehouseIdList =
        finalWarehouseList.map((item) => item.warehouseId).toList();

    return CreateUserWarehouseSpecialSettingsBody(
      userId: widget.userId,
      userSpecialSettingCardId: userSpecialSettingCardId,
      warehouseIds: warehouseIdList,
    );
  }
}
