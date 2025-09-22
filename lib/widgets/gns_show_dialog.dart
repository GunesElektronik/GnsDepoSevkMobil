import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Future<dynamic> GNSShowDialog(
    BuildContext context,
    String title,
    String content,
    String negativeButtonText,
    String positiveButtonText,
    Function() positiveOnPressed) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(5.0), // Köşe yuvarlama burada yapılır
      ),
      actions: [
        TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            child: Text(
              negativeButtonText,
              style: const TextStyle(color: Colors.black),
            )),
        TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange),
            ),
            onPressed: positiveOnPressed,
            child: Text(
              positiveButtonText,
              style: const TextStyle(color: Colors.black),
            )),
      ],
      title: Text(title),
      contentPadding: const EdgeInsets.all(20.0),
      content: Text(content),
    ),
  );
}
