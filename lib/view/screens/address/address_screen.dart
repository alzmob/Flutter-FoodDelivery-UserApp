import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_loader.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/address/widget/address_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn) {
      Get.find<LocationController>().getAddressList();
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'my_address'.tr),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Theme.of(context).cardColor),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Get.toNamed(RouteHelper.getAddAddressRoute()),
      ),
      body: _isLoggedIn ? GetBuilder<LocationController>(builder: (locationController) {
        return locationController.addressList != null ? locationController.addressList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await locationController.getAddressList();
          },
          child: Scrollbar(child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(
              width: 1170,
              child: ListView.builder(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                itemCount: locationController.addressList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (dir) {
                      Get.dialog(CustomLoader(), barrierDismissible: false);
                      locationController.deleteUserAddressByID(locationController.addressList[index].id, index).then((response) {
                        Get.back();
                        showCustomSnackBar(response.message, isError: !response.isSuccess);
                      });
                    },
                    child: AddressWidget(
                      address: locationController.addressList[index], fromAddress: true,
                      onTap: () {
                        Get.toNamed(RouteHelper.getMapRoute(
                          locationController.addressList[index].address, locationController.addressList[index].addressType,
                          locationController.addressList[index].latitude, locationController.addressList[index].longitude,
                          locationController.addressList[index].contactPersonName, locationController.addressList[index].contactPersonNumber,
                          locationController.addressList[index].id, locationController.addressList[index].userId, 'address',
                        ));
                      },
                      onRemovePressed: () {
                        Get.dialog(CustomLoader(), barrierDismissible: false);
                        locationController.deleteUserAddressByID(locationController.addressList[index].id, index).then((response) {
                          Get.back();
                          showCustomSnackBar(response.message, isError: !response.isSuccess);
                        });
                      },
                    ),
                  );
                },
              ),
            )),
          )),
        ) : NoDataScreen(text: 'no_saved_address_found'.tr) : Center(child: CircularProgressIndicator());
      }) : NotLoggedInScreen(),
    );
  }
}
