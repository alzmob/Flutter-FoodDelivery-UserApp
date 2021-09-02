import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({this.apiClient, this.sharedPreferences});

  Future<Response> getAllAddress() async {
    return await apiClient.getData(AppConstants.ADDRESS_LIST_URI);
  }

  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.ZONE_URI}?lat=$lat&lng=$lng');
  }

  Future<Response> removeAddressByID(int id) async {
    return await apiClient.postData('${AppConstants.REMOVE_ADDRESS_URI}$id', {"_method": "delete"});
  }

  Future<Response> addAddress(AddressModel addressModel) async {
    return await apiClient.postData(AppConstants.ADD_ADDRESS_URI, addressModel.toJson());
  }

  Future<Response> updateAddress(AddressModel addressModel, int addressId) async {
    return await apiClient.postData('${AppConstants.UPDATE_ADDRESS_URI}$addressId', addressModel.toJson());
  }

  Future<bool> saveUserAddress(String address, int zoneID) {
    apiClient.updateHeader(sharedPreferences.getString(AppConstants.TOKEN), zoneID.toString());
    return sharedPreferences.setString(AppConstants.USER_ADDRESS, address);
  }

  String getUserAddress() {
    return sharedPreferences.getString(AppConstants.USER_ADDRESS);
  }
}
