import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/data/model/response/menu_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/screens/menu/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    final List<MenuModel> _menuList = [
      MenuModel(icon: '', title: 'profile'.tr, backgroundColor: Color(0xFF4389FF), route: RouteHelper.getProfileRoute()),
      MenuModel(icon: Images.location, title: 'my_address'.tr, backgroundColor: Color(0xFFA9B9F1), route: RouteHelper.getAddressRoute()),
      MenuModel(icon: Images.language, title: 'language'.tr, backgroundColor: Color(0xFFF7BC7E), route: RouteHelper.getLanguageRoute('menu')),
      MenuModel(icon: Images.support, title: 'help_support'.tr, backgroundColor: Color(0xFF448AFF), route: RouteHelper.getSupportRoute()),
      MenuModel(icon: Images.policy, title: 'privacy_policy'.tr, backgroundColor: Color(0xFFFF8A80), route: RouteHelper.getHtmlRoute('privacy-policy')),
      MenuModel(icon: Images.about_us, title: 'about_us'.tr, backgroundColor: Color(0xFF62889C), route: RouteHelper.getHtmlRoute('about-us')),
      MenuModel(icon: Images.terms, title: 'terms_conditions'.tr, backgroundColor: Color(0xFFE040FB), route: RouteHelper.getHtmlRoute('terms-and-condition')),
      MenuModel(icon: Images.log_out, title: _isLoggedIn ? 'logout'.tr : 'sign_in'.tr, backgroundColor: Color(0xFFFF4B55), route: ''),
    ];

    return PointerInterceptor(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Theme.of(context).cardColor,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          InkWell(
            onTap: () => Get.back(),
            child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: (1/1.2),
              crossAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL, mainAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            itemCount: _menuList.length,
            itemBuilder: (context, index) {
              return MenuButton(menu: _menuList[index], isProfile: index == 0, isLogout: index == _menuList.length-1);
            },
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        ]),
      ),
    );
  }
}
