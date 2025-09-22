import 'package:flutter/material.dart';

Padding GnsLineButton(String content, IconData icon, Color textColor,
    Color backgroundColor, VoidCallback? onTap) {
  return Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            30), // Kenar yuvarlaklığını burada ayarlayabilirsiniz
      ),
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: ListTile(
          leading: Icon(
            icon,
            color: textColor,
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              content,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        ),
      ),
    ),
  );
}
