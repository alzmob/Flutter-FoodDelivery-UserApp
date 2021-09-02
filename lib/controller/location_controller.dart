import 'dart:convert';

import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/campaign_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/data/repository/location_repo.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class LocationController extends GetxController implements GetxService {
  final LocationRepo locationRepo;
  LocationController({@required this.locationRepo});

  Position _position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  Position _pickPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  bool _loading = false;
  Placemark _placeMark = Placemark();
  Placemark _pickPlaceMark = Placemark();
  List<Marker> _markers = <Marker>[];
  List<AddressModel> _addressList;
  List<AddressModel> _allAddressList;
  int _addressTypeIndex = 0;
  List<String> _addressTypeList = ['home', 'office', 'others'];
  bool _isLoading = false;
  bool _inZone = false;
  bool _buttonDisabled = true;
  bool _changeAddress = true;
  GoogleMapController _mapController;

  bool get isLoading => _isLoading;
  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  Placemark get placeMark => _placeMark;
  Placemark get pickPlaceMark => _pickPlaceMark;
  List<Marker> get markers => _markers;
  List<AddressModel> get addressList => _addressList;
  List<String> get addressTypeList => _addressTypeList;
  int get addressTypeIndex => _addressTypeIndex;
  bool get inZone => _inZone;
  bool get buttonDisabled => _buttonDisabled;
  GoogleMapController get mapController => _mapController;

  Future<AddressModel> getCurrentLocation(bool fromAddress, {GoogleMapController mapController, LatLng defaultLatLng}) async {
    _loading = true;
    update();
    AddressModel _addressModel;
    Position _myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _myPosition = newLocalData;
    }catch(e) {
      _myPosition = Position(
        latitude: defaultLatLng != null ? defaultLatLng.latitude : double.parse(Get.find<SplashController>().configModel.defaultLocation.lat ?? '0'),
        longitude: defaultLatLng != null ? defaultLatLng.longitude : double.parse(Get.find<SplashController>().configModel.defaultLocation.lng ?? '0'),
        timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
      );
    }
    if(fromAddress) {
      _position = _myPosition;
    }else {
      _pickPosition = _myPosition;
    }
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_myPosition.latitude, _myPosition.longitude), zoom: 17),
      ));
    }
    Placemark _myPlaceMark;
    try {
      if(!GetPlatform.isWeb) {
        List<Placemark> placeMarks = await placemarkFromCoordinates(_myPosition.latitude, _myPosition.longitude);
        _myPlaceMark = placeMarks.first;
      }else {
        _myPlaceMark = Placemark(name: 'Unknown', locality: 'Location', postalCode: 'Found', country: '');
      }
    }catch (e) {
      _myPlaceMark = Placemark(name: 'Unknown', locality: 'Location', postalCode: 'Found', country: '');
    }
    fromAddress ? _placeMark = _myPlaceMark : _pickPlaceMark = _myPlaceMark;
    ResponseModel _responseModel = await getZone(_myPosition.latitude.toString(), _myPosition.longitude.toString(), true);
    _buttonDisabled = !_responseModel.isSuccess;
    _addressModel = AddressModel(
      latitude: _myPosition.latitude.toString(), longitude: _myPosition.longitude.toString(), addressType: 'others',
      zoneId: _responseModel.isSuccess ? int.parse(_responseModel.message) : 0,
      address: '${_myPlaceMark.name ?? ''} ${_myPlaceMark.locality ?? ''} ${_myPlaceMark.postalCode ?? ''} ${_myPlaceMark.country ?? ''}',
    );
    _loading = false;
    update();
    return _addressModel;
  }

  Future<ResponseModel> getZone(String lat, String long, bool markerLoad) async {
    if(markerLoad) {
      _loading = true;
    }else {
      _isLoading = true;
    }
    update();
    ResponseModel _responseModel;
    Response response = await locationRepo.getZone(lat, long);
    if(response.statusCode == 200) {
      _inZone = true;
      _responseModel = ResponseModel(true, response.body['zone_id'].toString());
    }else {
      _inZone = false;
      _responseModel = ResponseModel(false, response.statusText);
    }
    if(markerLoad) {
      _loading = false;
    }else {
      _isLoading = false;
    }
    update();
    return _responseModel;
  }

  void updatePosition(CameraPosition position, bool fromAddress) async {
    _loading = true;
    update();
    try {
      if(fromAddress) {
        _position = Position(
          latitude: position.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
          heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
        );
      }else {
        _pickPosition = Position(
          latitude: position.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
          heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
        );
      }
      ResponseModel _responseModel = await getZone(position.target.latitude.toString(), position.target.longitude.toString(), true);
      _buttonDisabled = !_responseModel.isSuccess;
      if(_changeAddress) {
        if (!GetPlatform.isWeb) {
          List<Placemark> placeMarks = await placemarkFromCoordinates(position.target.latitude, position.target.longitude);
          fromAddress ? _placeMark = placeMarks.first : _pickPlaceMark = placeMarks.first;
        } else {
          if(fromAddress) {
            _placeMark = Placemark(name: 'Unknown', locality: 'Location', postalCode: 'Found', country: '');
          }else {
            _pickPlaceMark = Placemark(name: 'Unknown', locality: 'Location', postalCode: 'Found', country: '');
          }
        }
      }else {
        _changeAddress = true;
      }
    }catch(e) {}
    _loading = false;
    update();
  }

  Future<ResponseModel> deleteUserAddressByID(int id, int index) async {
    Response response = await locationRepo.removeAddressByID(id);
    ResponseModel _responseModel;
    if (response.statusCode == 200) {
      _addressList.removeAt(index);
      _responseModel = ResponseModel(true, response.body['message']);
    } else {
      _responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return _responseModel;
  }

  Future<void> getAddressList() async {
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      _addressList = [];
      _allAddressList = [];
      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void filterAddresses(String queryText) {
    if(_addressList != null) {
      _addressList = [];
      if (queryText == null || queryText.isEmpty) {
        _addressList.addAll(_allAddressList);
      } else {
        _allAddressList.forEach((address) {
          if (address.address.toLowerCase().contains(queryText.toLowerCase())) {
            _addressList.add(address);
          }
        });
      }
      update();
    }
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _isLoading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    _isLoading = false;
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      getAddressList();
      String message = response.body["message"];
      responseModel = ResponseModel(true, message);
    } else {
      responseModel = ResponseModel(false, response.statusText == 'Out of coverage!' ? 'service_not_available_in_this_area'.tr : response.statusText);
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> updateAddress(AddressModel addressModel, int addressId) async {
    _isLoading = true;
    update();
    Response response = await locationRepo.updateAddress(addressModel, addressId);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      getAddressList();
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<bool> saveUserAddress(AddressModel address) async {
    String userAddress = jsonEncode(address.toJson());
    return locationRepo.saveUserAddress(userAddress, address.zoneId);
  }

  AddressModel getUserAddress() {
    AddressModel _addressModel;
    try {
      _addressModel = AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
    }catch(e) {}
    return _addressModel;
  }

  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }

  void saveAddressAndNavigate(AddressModel address, bool fromSignUp) {
    if(Get.find<CartController>().cartList.length > 0) {
      Get.dialog(ConfirmationDialog(
        icon: Images.warning, title: 'are_you_sure_to_reset'.tr, description: 'if_you_change_location'.tr,
        onYesPressed: () {
          Get.back();
          _setZoneData(address, fromSignUp);
        },
      ));
    }else {
      _setZoneData(address, fromSignUp);
    }
  }

  void _setZoneData(AddressModel address, bool fromSignUp) {
    Get.find<LocationController>().getZone(address.latitude, address.longitude, false).then((response) {
      if (response.isSuccess) {
        Get.find<CartController>().clearCartList();
        address.zoneId = int.parse(response.message);
        if(Get.find<LocationController>().getUserAddress() != null && Get.find<LocationController>().getUserAddress().zoneId != address.zoneId) {
          FirebaseMessaging.instance.unsubscribeFromTopic('zone_${Get.find<LocationController>().getUserAddress().zoneId}_customer');
          FirebaseMessaging.instance.subscribeToTopic('zone_${address.zoneId}_customer');
        }else {
          FirebaseMessaging.instance.subscribeToTopic('zone_${address.zoneId}_customer');
        }
        Get.find<LocationController>().saveUserAddress(address);
        Get.find<BannerController>().getBannerList(true);
        Get.find<ProductController>().getPopularProductList(true);
        Get.find<CampaignController>().getItemCampaignList(true);
        Get.find<RestaurantController>().getRestaurantList('1', true);
        if(fromSignUp) {
          Get.offAllNamed(RouteHelper.getInterestRoute());
        }else {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }
      } else {
        Get.back();
        showCustomSnackBar(response.message);
      }
    });
  }

  void setLocation(String placeID, String address, String key, GoogleMapController mapController) async {
    _loading = true;
    update();
    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: key, apiHeaders: await GoogleApiHeaders().getHeaders());
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeID);

    _pickPosition = Position(
      longitude: detail.result.geometry.location.lat, latitude: detail.result.geometry.location.lng,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
    );

    _pickPlaceMark = Placemark(name: address);
    _changeAddress = false;

    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
        detail.result.geometry.location.lat, detail.result.geometry.location.lng,
      ), zoom: 17)));
    }
    _loading = false;
    update();
  }

  void disableButton() {
    _buttonDisabled = true;
    _inZone = true;
    update();
  }

  void setAddAddressData() {
    _position = _pickPosition;
    _placeMark = _pickPlaceMark;
    update();
  }

  void setPickData() {
    _pickPosition = _position;
    _pickPlaceMark = _placeMark;
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

}
