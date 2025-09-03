import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

enum AppPermission { phone, storage, location, camera }

class CustomPermissionHandler {
  BuildContext _context;
  Permission _permission;
  CustomPermissionHandler(this._context);

  PermissionStatus _permissionStatus = PermissionStatus.permanentlyDenied;

  Future<void> getPermissionStatus(which) {
    switch (which) {
      case AppPermission.phone:
        requestPhonePermission();
        break;
      case AppPermission.storage:
        requestStoragePermission();
        break;
      case AppPermission.location:
        requestLocationPermission();
        break;
      case AppPermission.camera:
        requestCameraPermission();
        break;
    }
    // return false;
  }

  Future<void> requestPhonePermission() async {
    // final serviceStatus = await Permission.phone.isGranted;
    // bool isphoneOn = serviceStatus == ServiceStatus.enabled;
    final status = await Permission.phone.request();
    _permissionStatus = status;
    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }

  Future<void> requestStoragePermission() async {
    // final serviceStatus = await Permission.storage.isGranted;
    // bool isStorage = serviceStatus == ServiceStatus.enabled;
    final status = await Permission.storage.request();
    _permissionStatus = status;
    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }

  Future<void> requestCameraPermission() async {
    // final serviceStatus = await Permission.camera.isGranted;

    // bool isCameraOn = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.camera.request();
    _permissionStatus = status;
    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }

  Future<void> requestLocationPermission() async {
    final permissionLocation = Permission.location;
    final status = await permissionLocation.request();
    // bool isLocation = status == ServiceStatus.enabled;
    _permissionStatus = status;
    print("Print Status" + status.toString());

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }
}
