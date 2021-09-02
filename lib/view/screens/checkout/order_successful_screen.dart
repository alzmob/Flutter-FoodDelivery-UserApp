import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/payment_failed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessfulScreen extends StatelessWidget {
  final String orderID;
  final int status;
  OrderSuccessfulScreen({@required this.orderID, @required this.status});

  @override
  Widget build(BuildContext context) {
    if(status == 0) {
      Get.dialog(PaymentFailedDialog(orderID: orderID), barrierDismissible: false);
    }
    return Scaffold(
      body: Center(child: SizedBox(width: 1170, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Image.asset(status == 1 ? Images.checked : Images.warning, width: 100, height: 100),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

        Text(
          status == 1 ? 'you_placed_the_order_successfully'.tr : 'your_order_is_failed_to_place'.tr,
          style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Text(
            status == 1 ? 'your_order_is_placed_successfully'.tr : 'your_order_is_failed_to_place_because'.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 30),

        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: CustomButton(buttonText: 'back_to_home'.tr, onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute())),
        ),
      ]))),
    );
  }
}
