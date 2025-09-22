import 'package:flutter/material.dart';
import 'package:gns_warehouse/pages/settings_page/settings_page.dart';
import 'package:gns_warehouse/pages/synchronize.dart';
import '../pages/home.dart';

Widget bottomWidget(BuildContext context) {
  return Container(
    height: 60,
    child: BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push<String>(MaterialPageRoute(
                builder: (context) => const Home(),
              ));
            },
            icon: const Icon(
              Icons.apps_outlined,
              size: 30,
              color: Colors.deepOrange,
            ),
          ),
          /*
          IconButton(
            onPressed: () {
              //Navigator.pop(context);
              Navigator.of(context).push<String>(MaterialPageRoute(
                builder: (context) => const Synchronize(),
              ));
            },
            icon: const Icon(
              Icons.update_outlined,
              size: 30,
              color: Colors.deepOrange,
            ),
          ),
          
          const SizedBox(
            width: 60,
          ),
          */
          // IconButton(
          //     onPressed: () {
          //       //Navigator.pop(context);
          //       Navigator.of(context).push<String>(MaterialPageRoute(
          //         builder: (context) => const Synchronize(),
          //       ));
          //     },
          //     icon: const Icon(
          //       Icons.published_with_changes_outlined,
          //       size: 30,
          //       color: Colors.deepOrange,
          //     )),
          // IconButton(
          //     onPressed: () {
          //       //Navigator.pop(context);
          //       Navigator.of(context).push<String>(MaterialPageRoute(
          //         builder: (context) => const SettingsPage(),
          //       ));
          //     },
          //     icon: const Icon(
          //       Icons.settings,
          //       size: 30,
          //       color: Colors.deepOrange,
          //     )),
        ],
      ),
    ),
  );
}
