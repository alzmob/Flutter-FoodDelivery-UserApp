import 'package:efood_multivendor/controller/campaign_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_shimmer.dart';
import 'package:efood_multivendor/view/base/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemCampaignScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<CampaignController>().getItemCampaignList(false);

    return Scaffold(
      appBar: CustomAppBar(title: 'campaigns'.tr),
      body: Scrollbar(child: SingleChildScrollView(child: Center(child: SizedBox(
        width: 1170,
        child: GetBuilder<CampaignController>(builder: (campController) {
          return campController.itemCampaignList != null ? campController.itemCampaignList.length > 0 ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              childAspectRatio: 4,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: campController.itemCampaignList.length,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            itemBuilder: (context, index) {
              return ProductWidget(
                product: campController.itemCampaignList[index], isRestaurant: false, restaurant: null,
                hasDivider: index != campController.itemCampaignList.length - 1, isCampaign: true,
              );
            },
          ) : NoDataScreen(text: 'no_campaign_found'.tr) : GridView.builder(
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
              return ProductShimmer(isEnabled: campController.itemCampaignList == null, isRestaurant: false);
            },
          );
        }),
      )))),
    );
  }
}
