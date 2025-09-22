import 'package:flutter/material.dart';
import 'package:gns_warehouse/constants/custom_colors.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/bottom_sheets/gns_whs_trs_project_bottom.dart';
import 'package:gns_warehouse/pages/warehouse_transfer/components/bottom_sheets/gns_whs_trs_transporter_bottom.dart';
import 'package:gns_warehouse/repositories/apirepository.dart';

class GNSSelectProject extends StatefulWidget {
  GNSSelectProject(
      {super.key,
      required this.onValueChanged,
      required this.isErrorActive,
      required this.projectName});

  @override
  State<GNSSelectProject> createState() => _GNSSelectProjectState();
  final ValueChanged<ProjectIdAndName> onValueChanged;

  final bool isErrorActive;
  String projectName;
}

class _GNSSelectProjectState extends State<GNSSelectProject> {
  bool isFetched = false;

  String projectNameInit = "Proje";
  String projectName = "Proje";
  String projectId = "";

  Color errorColor = GNSCustomColor().errorColor;
  bool isErrorActive = false;

  @override
  void initState() {
    super.initState();
    isErrorActive = widget.isErrorActive;
    if (widget.projectName.isNotEmpty) {
      projectName = widget.projectName;
    }
    //scrollController.addListener(_scrollListener);
    //_createApiRepository();
  }

  @override
  void didUpdateWidget(GNSSelectProject oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isErrorActive != widget.isErrorActive) {
      isErrorActive = widget.isErrorActive;
      setState(() {});
    }
  }

  // _createApiRepository() async {
  //   apiRepository = await ApiRepository.create(context);
  //   //customerResponse = await apiRepository.getCustomerDeneme(customerPage);
  //   //customerItems = customerResponse!.customers!.items!;
  //   customerAddressesResponse = null;
  //   setState(() {
  //     isFetched = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return _row(projectName, projectNameInit, () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        // builder: (context) =>
        //     _customerListBottomSheet(widget.response),

        //klavye açıldığında bottomSheeti üste çıkartmak için
        // padding: EdgeInsets.only(
        //   bottom: MediaQuery.of(context).viewInsets.bottom,
        // ),
        builder: (context) => GNSWhsTrsProjectBottom(
          onValueChanged: (value) async {
            projectName = value.projectName;
            projectId = value.projectId;

            updateInfo();

            setState(() {});
          },
        ),
      );
    });
  }

  void updateInfo() {
    widget.onValueChanged(ProjectIdAndName(
      projectId: projectId,
      projectName: projectName,
    ));
  }

  Row _row(String title, String initTitle, Function()? onTap) {
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
}

class ProjectIdAndName {
  String projectId;
  String projectName;

  ProjectIdAndName({
    required this.projectId,
    required this.projectName,
  });
}
