import 'package:flutter/material.dart';

void showSnackBar(String message,BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: const Duration(seconds: 1), content: Text(message)));
}