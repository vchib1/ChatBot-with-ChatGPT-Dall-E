import 'package:flutter/material.dart';

const BorderRadius senderBorder = BorderRadius.only(
  topLeft: Radius.circular(10),
  topRight: Radius.circular(10),
  bottomLeft: Radius.circular(10),
  bottomRight: Radius.circular(0),
);

const BorderRadius receiverBorder = BorderRadius.only(
  topLeft: Radius.circular(10),
  topRight: Radius.circular(10),
  bottomLeft: Radius.circular(0),
  bottomRight: Radius.circular(10),
);

const String apiKey = "get your own key from open ai's website";