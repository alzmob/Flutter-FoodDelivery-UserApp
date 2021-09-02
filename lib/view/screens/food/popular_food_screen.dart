import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_shimmer.dart';
import 'package:efood_multivendor/view/base/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularFoodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<ProductController>().getPopularProductList(true);

    return Scaffold(
      appBar: CustomAppBar(title: 'popular_foods_nearby'.tr, showCart: true),
      body: Scrollbar(child: SingleChildScrollView(child: Center(child: SizedBox(
        width: 1170,
        child: GetBuilder<ProductController>(builder: (productController) {
          return productController.popularProductList != null ? productController.popularProductList.length > 0 ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              childAspectRatio: 4,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: productController.popularProductList.length,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            itemBuilder: (context, index) {
              return ProductWidget(
                product: productController.popularProductList[index], isRestaurant: false, restaurant: null,
                hasDivider: index != productController.popularProductList.length-1,
              );
            },
          ) : NoDataScreen(text: 'no_food_available'.tr) : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              childAspectRatio: 4,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
            ),
            itemCount: 20,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ProductShimmer(isEnabled: productController.popularProductList == null, isRestaurant: false);
            },
          );
        }),
      )))),
    );
  }
}
