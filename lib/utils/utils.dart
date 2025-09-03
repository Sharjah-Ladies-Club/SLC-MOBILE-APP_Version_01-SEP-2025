import 'dart:math' as math;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_common.dart';
import 'package:slc/db/table_facility.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/utils/constant.dart';
import 'custom_permisson_handler.dart';

class Utils {
  saveOfflineData(String cid, Meta content) async {
    var db = new DatabaseHelper();
    await db.saveOrUpdateContent(cid, jsonEncode(content));
  }

  Future<int> deleteOfflineDataByCID(String cid) async {
    var db = new DatabaseHelper();
    return await db.delete(cid);
  }

  saveFacilityOfflineData(String cid, Meta content) async {
    var db = new DatabaseHelper();
//    await db.saveOrUpdateFacilityContent(cid, jsonEncode(content));
    await db.saveOrUpdateContent(cid, jsonEncode(content));
  }

  // ignore: missing_return
  Future<Meta> getOfflineData(String cid) async {
    var db = new DatabaseHelper();
    CommonTable tempTable = await db.getContentByCID(cid);
    if (tempTable != null) {
      if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
              Constants.LANGUAGE_ENGLISH ||
          SPUtil.getInt(Constants.CURRENT_LANGUAGE) == 0) {
        if (tempTable.englishContent == null) {
          return Meta(statusCode: 201, statusMsg: "No Data Found");
        }
        return Meta.fromJson(jsonDecode(tempTable.englishContent));
      } else if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
          Constants.LANGUAGE_ARABIC) {
        if (tempTable.arabicContent == null) {
          return Meta(statusCode: 201, statusMsg: "No Data Found");
        }
        return Meta.fromJson(jsonDecode(tempTable.arabicContent));
      }
    } else {
      return Meta(statusCode: 201, statusMsg: "No Data Found");
    }
  }

  // ignore: missing_return
  Future<Meta> getFacilityOfflineData(String cid) async {
    var db = new DatabaseHelper();
    FacilityTable tempTable = await db.getFacilityContentByCID(cid);
    if (tempTable != null) {
      if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
              Constants.LANGUAGE_ENGLISH ||
          SPUtil.getInt(Constants.CURRENT_LANGUAGE) == 0) {
        if (tempTable.englishContent == null) {
          return Meta(statusCode: 201, statusMsg: "No Data Found");
        }
        return Meta.fromJson(jsonDecode(tempTable.englishContent));
      } else if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
          Constants.LANGUAGE_ARABIC) {
        if (tempTable.arabicContent == null) {
          return Meta(statusCode: 201, statusMsg: "No Data Found");
        }
        return Meta.fromJson(jsonDecode(tempTable.arabicContent));
      }
    } else {
      return Meta(statusCode: 201, statusMsg: "No Data Found");
    }
  }

  int getInterNetSpeed() {
    return SPUtil.getInt(Constants.INTERNET_SPEED,
        defValue: Constants.NET_SPEED_LOW);
  }

  customGetSnackBarWithActionButton(titlemsg, contentmsg, context,
      {onPressed}) {
    return Get.snackbar(titlemsg, contentmsg,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorData.activeIconColor,
        isDismissible: true,
        duration: Duration(hours: 1),
        mainButton: TextButton(
          child: Text(
            tr('ok'),
            style: TextStyle(
                color: Colors.white, fontFamily: tr('currFontFamily')),
          ),
          onPressed: () => {
            onPressed == null ? Get.back : onPressed,
          },
        ));
  }

  customGetSnackBarWithOutActionButton(titlemsg, contentmsg, context) {
    return Get.snackbar(
      titlemsg,
      contentmsg,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: ColorData.activeIconColor,
      isDismissible: true,
      duration: Duration(seconds: 3),
    );
  }

  getAmount({double amount}) {
    return " " + amount.toStringAsFixed(2);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<double> _determinePosition() async {
    const double orderLat = 25.3782582;
    const double orderLang = 55.3952436;
    bool serviceEnabled;
    LocationPermission permission = await Geolocator.checkPermission();

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await openAppSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position _currentPosition = await Geolocator.getCurrentPosition();
    return getDistanceFromLatLonInMeter(_currentPosition.latitude,
        _currentPosition.longitude, orderLat, orderLang);
  }

  Future<CheckDistance> getLoc(context) async {
    CheckDistance nd = CheckDistance();
    nd.allow = false;
    nd.distance = 0;
    double actualDistance = await _determinePosition();
    double permitAreainMeter = 162.80;
    if (actualDistance <= permitAreainMeter) {
      nd.allow = true;
      nd.distance = 0;
    } else {
      nd.allow = false;
      nd.distance = (actualDistance - permitAreainMeter) / 1000;
    }
    return nd;
  }

  double getDistanceFromLatLonInMeter(lat1, lon1, lat2, lon2) {
    // var R = 6371; // Radius of the earth in km
    double earthRadius = 6371000;

    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = earthRadius * c; // Distance in meters
    return d;
  }

  double deg2rad(deg) {
    return deg * (math.pi / 180);
  }
}
