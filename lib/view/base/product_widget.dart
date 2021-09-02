import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final Restaurant restaurant;
  final bool isRestaurant;
  final bool hasDivider;
  final bool inRestaurant;
  final bool isCampaign;
  ProductWidget({@required this.product, @required this.isRestaurant, @required this.restaurant, @required this.hasDivider,
    this.inRestaurant = false, this.isCampaign = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    double _discount;
    String _discountType;
    bool _isAvailable;
    if(isRestaurant) {
      _discount = restaurant.discount != null ? restaurant.discount.discount : 0;
      _discountType = restaurant.discount != null ? restaurant.discount.discountType : 'percent';
      _isAvailable = DateConverter.isAvailable(restaurant.openingTime, restaurant.closeingTime);
    }else {
      _discount = (product.restaurantDiscount == 0 || isCampaign) ? product.discount : product.restaurantDiscount;
      _discountType = (product.restaurantDiscount == 0 || isCampaign) ? product.discountType : 'percent';
      _isAvailable = DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds)
          && DateConverter.isAvailable(product.restaurantOpeningTime, product.restaurantClosingTime);
    }

    return InkWell(
      onTap: () {
        if(isRestaurant) {
          Get.toNamed(RouteHelper.getRestaurantRoute(restaurant.id), arguments: RestaurantScreen(restaurant: restaurant));
        }else {
          ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
            ProductBottomSheet(product: product, inRestaurantPage: inRestaurant, isCampaign: isCampaign),
            backgroundColor: Colors.transparent, isScrollControlled: true,
          ) : Get.dialog(
            Dialog(child: ProductBottomSheet(product: product, inRestaurantPage: inRestaurant, isCampaign: isCampaign)),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Row(children: [

                Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    child: CustomImage(
                      image: '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl
                          : _baseUrls.productImageUrl}'
                          '/${isRestaurant ? restaurant.logo : product.image}',
                      height: 65, width: 80, fit: BoxFit.cover,
                    ),
                  ),
                  DiscountTag(
                    discount: _discount, discountType: _discountType,
                    freeDelivery: isRestaurant ? restaurant.freeDelivery == 1 : false,
                  ),
                  _isAvailable ? SizedBox() : NotAvailableWidget(isRestaurant: isRestaurant),
                ]),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                    Text(
                      isRestaurant ? restaurant.name : product.name, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      isRestaurant ? restaurant.address : product.restaurantName ?? '',
                      style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor),
                      maxLines: isRestaurant ? 2 : 1, overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isRestaurant ? 5 : 0),

                    !isRestaurant ? RatingBar(
                      rating: isRestaurant ? restaurant.avgRating : product.avgRating, size: 12,
                      ratingCount: isRestaurant ? restaurant.ratingCount : product.ratingCount,
                    ) : SizedBox(),
                    isRestaurant ? RatingBar(
                      rating: isRestaurant ? restaurant.avgRating : product.avgRating, size: 12,
                      ratingCount: isRestaurant ? restaurant.ratingCount : product.ratingCount,
                    ) : Row(children: [
                      Text(
                        PriceConverter.convertPrice(product.price, discount: _discount, discountType: _discountType),
                        style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                      ),
                      SizedBox(width: _discount > 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                      _discount > 0 ? Text(
                        PriceConverter.convertPrice(product.price),
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ) : SizedBox(),
                    ]),

                  ]),
                ),

                Column(mainAxisAlignment: isRestaurant ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [
                  !isRestaurant ? Icon(Icons.add) : SizedBox(),
                  GetBuilder<WishListController>(builder: (wishController) {
                    bool _isWished = isRestaurant ? wishController.wishRestIdList.contains(restaurant.id)
                        : wishController.wishProductIdList.contains(product.id);
                    return InkWell(
                      onTap: () {
                        if(Get.find<AuthController>().isLoggedIn()) {
                          _isWished ? wishController.removeFromWishList(isRestaurant ? restaurant.id : product.id, isRestaurant)
                              : wishController.addToWishList(product, restaurant, isRestaurant);
                        }else {
                          showCustomSnackBar('you_are_not_logged_in'.tr);
                        }
                      },
                      child: Icon(
                        _isWished ? Icons.favorite : Icons.favorite_border,
                        color: _isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                      ),
                    );
                  }),
                ]),

              ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 90),
            child: Divider(color: hasDivider ? Theme.of(context).disabledColor : Colors.transparent),
          ),
        ],
      ),
    );
  }
}
