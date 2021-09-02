import 'package:efood_multivendor/controller/search_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_shimmer.dart';
import 'package:efood_multivendor/view/base/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemView extends StatelessWidget {
  final bool isRestaurant;
  ItemView({@required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SearchController>(builder: (searchController) {
        bool _isNull = true;
        int _length = 0;
        if(isRestaurant) {
          _isNull = searchController.searchRestList == null;
          if(!_isNull) {
            _length = searchController.searchRestList.length;
          }
        }else {
          _isNull = searchController.searchProductList == null;
          if(!_isNull) {
            _length = searchController.searchProductList.length;
          }
        }
        return SingleChildScrollView(
          child: Center(child: SizedBox(width: 1170, child: !_isNull ? _length > 0 ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              childAspectRatio: 4,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _length,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            itemBuilder: (BuildContext context, int index) {
              return ProductWidget(
                product: isRestaurant ? null : searchController.searchProductList[index],
                isRestaurant: isRestaurant,
                restaurant: isRestaurant ? searchController.searchRestList[index] : null,
                hasDivider: isRestaurant ? index != searchController.searchRestList.length-1
                    : index != searchController.searchProductList.length-1,
              );
            },
          ) : NoDataScreen(text: 'no_food_available'.tr) : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              childAspectRatio: 4,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
            ),
            itemCount: 10,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ProductShimmer(isEnabled: _isNull, isRestaurant: isRestaurant);
            },
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          ))),
        );
      }),
    );
  }
}
