import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool isRestaurant;
  ProductShimmer({@required this.isEnabled, this.isRestaurant = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 10, spreadRadius: 1)],
      ),
      child: Shimmer(
        duration: Duration(seconds: 2),
        enabled: isEnabled,
        child: Row(children: [
          Container(
            height: 70, width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              color: Colors.grey[300],
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(height: 15, width: double.maxFinite, color: Colors.grey[300]),
            SizedBox(height: 5),
            RatingBar(rating: 0.0, size: 12, ratingCount: 0),
            SizedBox(height: 10),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ])),
          SizedBox(width: 10),

          isRestaurant ? Icon(Icons.favorite_border, color: Colors.grey) : Column(children: [
            Icon(Icons.favorite_border, color: Colors.grey),
            Expanded(child: SizedBox()),
            Icon(Icons.add, color: Theme.of(context).disabledColor),
          ]),

        ]),
      ),
    );
  }
}
