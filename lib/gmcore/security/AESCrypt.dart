import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class AESCrypt {
  static String vectorKey;
  static String secretKey;
  bool isEnabled = true;

  void configure(String secretKey, String vectorKey) {
    AESCrypt.secretKey = secretKey;
    AESCrypt.vectorKey = vectorKey;
  }

  String encrypt(String data) {
    return _encrypt(data, vectorKey, secretKey);
  }

  String _encrypt(String value, String vk, String sk) {
    // log("QQQQQQQQQQQQQQQQ\nvk-$vk\nsk-$sk\ntok-${SPUtil.getString(Constants.KEY_TOKEN_1)}");
    String data;
    try {
      List<int> bytes = utf8.encode(sk);
      var byte = bytes.sublist(0, 32);
      final key = Key.fromBase64(base64.encode(byte));
      final iv = IV.fromUtf8(vk);

      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final encryptedString = encrypter.encrypt(value, iv: iv);
      data = encryptedString.base64;
    } catch (e) {
      print(e);
    }
    return data;
  }

  String decrypt(String data) {
    return _decrypt(data, vectorKey, secretKey);
  }

  String _decrypt(String value, String vk, String sk) {
    String data;
    try {
      List<int> bytes = utf8.encode(sk);
      var byte = bytes.sublist(0, 32);
      final key = Key.fromBase64(base64.encode(byte));
      final iv = IV.fromUtf8(vk);

      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final decryptedString =
          encrypter.decrypt(Encrypted.fromBase64(value), iv: iv);

      data = decryptedString.toString();
    } catch (e) {
      print(e);
    }
    return data;
  }
}
