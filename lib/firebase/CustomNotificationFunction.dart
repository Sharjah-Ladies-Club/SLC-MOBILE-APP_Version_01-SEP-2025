import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:slc/firebase/utilImage.dart';

Future<NotificationDetails> _image(Image picture) async {
  final picturePath = await saveImage(picture);

  final bigPictureStyleInformation =
      BigPictureStyleInformation(FilePathAndroidBitmap(picturePath));

  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    Platform.isAndroid ? 'com.sharjah.ladies.club' : 'com.sharjah.ladiesclub',
    'SLC',
    //'your channel description',
    //style: AndroidNotificationStyle.BigPicture,
    styleInformation: bigPictureStyleInformation,
  );

  return NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: null, macOS: null);
}

Future showImageNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required Image picture,
  int id = 0,
}) async =>
    notifications.show(id, title, body, await _image(picture));

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid ? 'com.sharjah.ladies.club' : 'com.sharjah.ladiesclub',
      'SLC',
      // 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      icon: "ic_launcher");
  final iOSChannelSpecifics = DarwinNotificationDetails();
  return NotificationDetails(
      android: androidChannelSpecifics, iOS: iOSChannelSpecifics, macOS: null);
}

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);
