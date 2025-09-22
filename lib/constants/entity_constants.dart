// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class EntityConstants {
  //ORDER STATUSES ---------------
  static int OrderStatusBeklemede = 1;
  static int OrderStatusKapandi = 2;
  static int OrderStatusToplaniyor = 3;

  static List<String> OrderStatusList = ["Beklemede", "Kapandı", "Toplanıyor"];

  static String getStatusDescription(int statusId) {
    switch (statusId) {
      case 1:
        return "Beklemede";
      case 2:
        return "Kapandı";
      case 3:
        return "Toplanıyor";
      default:
        return "Bilinmeyen Durum";
    }
  }

  static int getStatusId(String statusDescription) {
    switch (statusDescription) {
      case "Beklemede":
        return 1;
      case "Kapandı":
        return 2;
      case "Toplanıyor":
        return 3;
      default:
        return -1;
    }
  }

  static Color getColorBasedOnOrderStatus(
      String orderStatusName, bool isPartial) {
    switch (orderStatusName) {
      case "Beklemede":
        return const Color.fromARGB(255, 23, 198, 83);
      case "Kapandı":
        return const Color.fromARGB(255, 27, 132, 255);
      case "Toplanıyor":
        if (isPartial) {
          return const Color.fromARGB(255, 27, 132, 255);
        } else {
          return const Color.fromARGB(255, 27, 132, 255);
        }

      default:
        return const Color.fromARGB(255, 27, 132, 255);
    }
  }
  //------------------------------
}
