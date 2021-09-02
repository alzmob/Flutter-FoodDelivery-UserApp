import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_shimmer.dart';
import 'package:efood_multivendor/view/base/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantView extends StatelessWidget {
  final ScrollController scrollController;
  RestaurantView({this.scrollController});

  @override
  Widget build(BuildContext context) {
    Get.find<RestaurantController>().setOffset(1);
    scrollController?.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<RestaurantController>().restaurantList != null
          && !Get.find<RestaurantController>().isLoading) {
        int pageSize = (Get.find<RestaurantController>().popularPageSize / 10).ceil();
        if (Get.find<RestaurantController>().offset < pageSize) {
          Get.find<RestaurantController>().setOffset(Get.find<RestaurantController>().offset+1);
          print('end of the page');
          Get.find<RestaurantController>().showBottomLoader();
          Get.find<RestaurantController>().getRestaurantList(Get.find<RestaurantController>().offset.toString(), false);
        }
      }
    });
    return GetBuilder<RestaurantController>(builder: (restController) {
      return Column(children: [
        restController.restaurantList != null ? restController.restaurantList.length > 0 ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10,
            childAspectRatio: 4,
            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
          ),
          itemCount: restController.restaurantList.length,
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_SMALL),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return ProductWidget(
              product: null, isRestaurant: true,
              restaurant: restController.restaurantList[index],
              hasDivider: index != restController.restaurantList.length-1,
            );
          },
        ) : NoDataScreen(text: 'no_food_available'.tr) : GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10,
            childAspectRatio: 4,
            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
          ),
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return ProductShimmer(isEnabled: restController.restaurantList == null, isRestaurant: true);
          },
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        ),

        restController.isLoading ? Center(child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        )) : SizedBox(),
      ]);
    });
  }
}
