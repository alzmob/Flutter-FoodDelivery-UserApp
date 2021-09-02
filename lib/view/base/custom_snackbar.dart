import 'package:efood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String message, {bool isError = true}) {
  Get.showSnackbar(GetBar(
    backgroundColor: isError ? Colors.red : Colors.green,
    message: message,
    duration: Duration(seconds: 3),
    snackStyle: SnackStyle.FLOATING,
    margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
    borderRadius: 10,
    isDismissible: true,
    dismissDirection: SnackDismissDirection.HORIZONTAL,
  ));
}