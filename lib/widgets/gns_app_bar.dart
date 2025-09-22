import 'package:flutter/material.dart';

AppBar GnsAppBar(String title, BuildContext context,
    {List<Widget>? actions = const []}) {
  return AppBar(
    iconTheme: IconThemeData(
        color: Colors.deepOrange[700], size: 32 //change your color here
        ),
    title: Text(
      title,
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
    actions: actions,
  );
}
