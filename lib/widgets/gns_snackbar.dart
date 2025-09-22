import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
void ShowSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2), // Snackbar'ın görünür olma süresi
    ),
  );
}
