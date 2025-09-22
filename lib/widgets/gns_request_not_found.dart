import 'package:flutter/material.dart';

Center requestNotFound(String content) {
  return Center(
    child: Text(
      "$content Bulunamadı",
      style: const TextStyle(
          color: Colors.deepOrange, fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}
