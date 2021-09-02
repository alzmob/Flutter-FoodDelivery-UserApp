import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebMenuBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      width: 1170,
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: Row(children: [

        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getInitialRoute()),
          child: Image.asset(Images.logo, height: 50, width: 50),
        ),
        Expanded(child: SizedBox()),

        MenuButton(icon: Icons.home, title: 'home'.tr, onTap: () => Get.toNamed(RouteHelper.getInitialRoute())),
        SizedBox(width: 20),
        MenuButton(icon: Icons.favorite, title: 'favourite'.tr, onTap: () => Get.toNamed(RouteHelper.getMainRoute('favourite'))),
        SizedBox(width: 20),
        MenuButton(icon: Icons.shopping_bag, title: 'my_orders'.tr, onTap: () => Get.toNamed(RouteHelper.getMainRoute('order'))),
        SizedBox(width: 20),
        MenuButton(icon: Icons.menu, title: 'menu'.tr, onTap: () {
          Get.bottomSheet(MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
        }),
        SizedBox(width: 20),
        GetBuilder<AuthController>(builder: (authController) {
          return MenuButton(
            icon: authController.isLoggedIn() ? Icons.person : Icons.lock,
            title: authController.isLoggedIn() ? 'profile'.tr : 'sign_in'.tr,
            onTap: () => Get.toNamed(authController.isLoggedIn() ? RouteHelper.getProfileRoute() : RouteHelper.getSignInRoute(RouteHelper.main)),
          );
        }),
        SizedBox(width: 20),
        MenuButton(icon: Icons.shopping_cart, title: 'my_cart'.tr, isCart: true, onTap: () => Get.toNamed(RouteHelper.getMainRoute('cart'))),

      ]),
    ));
  }
  @override
  Size get preferredSize => Size(1170, 70);
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCart;
  final Function onTap;
  MenuButton({@required this.icon, @required this.title, this.isCart = false, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(children: [
        Stack(clipBehavior: Clip.none, children: [

          Icon(icon, size: 20),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          isCart ? GetBuilder<CartController>(builder: (cartController) {
            return cartController.cartList.length > 0 ? Positioned(
              top: -5, right: -5,
              child: Container(
                height: 15, width: 15, alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Theme.of(context).primaryColor,
                    border: Border.all(width: 1, color: Theme.of(context).cardColor)
                ),
                child: Text(
                  cartController.cartList.length.toString(),
                  style: robotoRegular.copyWith(fontSize: 8, color: Theme.of(context).cardColor),
                ),
              ),
            ) : SizedBox();
          }) : SizedBox(),
        ]),
        isCart ? SizedBox() : Text(title, style: robotoRegular),
      ]),
    );
  }
}

