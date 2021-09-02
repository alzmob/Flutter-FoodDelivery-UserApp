import 'package:efood_multivendor/controller/campaign_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/basic_campaign_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_shimmer.dart';
import 'package:efood_multivendor/view/base/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignScreen extends StatelessWidget {
  final BasicCampaignModel campaign;
  CampaignScreen({@required this.campaign});

  @override
  Widget build(BuildContext context) {
    Get.find<CampaignController>().getBasicCampaignDetails(campaign.id);

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<CampaignController>(builder: (campaignController) {
        return CustomScrollView(
          slivers: [

            SliverAppBar(
              expandedHeight: 230,
              toolbarHeight: 50,
              pinned: true,
              floating: false,
              backgroundColor: Theme.of(context).primaryColor,
              leading: IconButton(icon: Icon(Icons.chevron_left, color: Colors.white), onPressed: () => Get.back()),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  campaign.title,
                  style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.white),
                ),
                background: CustomImage(
                  fit: BoxFit.cover,
                  image: '${Get.find<SplashController>().configModel.baseUrls.campaignImageUrl}/${campaign.image}',
                ),
              ),
            ),

            SliverToBoxAdapter(child: Center(child: Container(
              width: 1170,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
              ),
              child: campaignController.campaign != null ? campaignController.campaign.restaurants.length > 0 ? Column(
                children: [

                  Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel.baseUrls.campaignImageUrl}/${campaignController.campaign.image}',
                        height: 40, width: 50, fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        campaignController.campaign.title, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        campaignController.campaign.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                      ),
                    ])),
                  ]),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  campaignController.campaign.startTime != null ? Row(children: [
                    Text('campaign_schedule'.tr, style: robotoRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor,
                    )),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      '${DateConverter.isoStringToLocalDateOnly(campaignController.campaign.startDate)}'
                          ' - ${DateConverter.isoStringToLocalDateOnly(campaignController.campaign.endDate)}',
                      style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).primaryColor),
                    ),
                  ]) : SizedBox(),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  campaignController.campaign.startTime != null ? Row(children: [
                    Text('daily_time'.tr, style: robotoRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor,
                    )),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      '${DateConverter.convertTimeToTime(campaignController.campaign.startTime)}'
                          ' - ${DateConverter.convertTimeToTime(campaignController.campaign.endTime)}',
                      style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).primaryColor),
                    ),
                  ]) : SizedBox(),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      childAspectRatio: 4,
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                    ),
                    itemCount: campaignController.campaign.restaurants.length,
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductWidget(
                        product: null, isRestaurant: true, restaurant: campaignController.campaign.restaurants[index],
                        hasDivider: index != campaignController.campaign.restaurants.length-1,
                      );
                    },
                  ),
                ],
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
                  return ProductShimmer(isEnabled: campaignController.campaign == null, isRestaurant: true);
                },
              ),
            ))),
          ],
        );
      }),
    );
  }
}