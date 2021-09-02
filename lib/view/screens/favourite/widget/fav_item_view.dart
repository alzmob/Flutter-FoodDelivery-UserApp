import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_shimmer.dart';
import 'package:efood_multivendor/view/base/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavItemView extends StatelessWidget {
  final bool isRestaurant;
  FavItemView({@required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<WishListController>(builder: (wishController) {
        int _length = 0;
        if(wishController.wishProductList != null) {
          _length = isRestaurant ? wishController.wishRestList.length : wishController.wishProductList.length;
        }
        return RefreshIndicator(
          onRefresh: () async {
            await wishController.getWishList();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(
              width: 1170, child: wishController.wishProductList != null ? _length > 0 ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                childAspectRatio: 4,
                crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
              ),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: isRestaurant ? wishController.wishRestList.length : wishController.wishProductList.length,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              itemBuilder: (BuildContext context, int index) {
                return ProductWidget(
                  product: isRestaurant ? null : wishController.wishProductList[index],
                  restaurant: isRestaurant ? wishController.wishRestList[index] : null,
                  isRestaurant: isRestaurant, hasDivider: index != wishController.wishRestList.length-1,
                );
              },
            ) : NoDataScreen(text: 'no_wish_data_found'.tr) : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                childAspectRatio: 4,
                crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
              ),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return ProductShimmer(isEnabled: wishController.wishProductList == null, isRestaurant: isRestaurant);
              },
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            ),
            )),
          ),
        );
      }),
    );
  }
}
