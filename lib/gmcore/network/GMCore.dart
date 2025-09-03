library gm_core;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:slc/gmcore/model/GMAPIResponse.dart';
import 'package:slc/gmcore/model/GMError.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/model/login_meta.dart';
import 'package:slc/gmcore/security/AESCrypt.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/ErrorCode.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/strings.dart';
// import 'package:http/http.dart';

class GMAPIService {
  static int connectionTimeOut = 30000;
  static int receiveTimeout = 30000;

  static Dio dio;
  var log = new Logger();

  void configAPI() {
    // Set default configs
    dio = new Dio();
    dio.options.connectTimeout = connectionTimeOut;
    dio.options.receiveTimeout = receiveTimeout;
    dio.options.headers["content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";

//    dio.options.headers["User-Agent"] = "Android";
//    dio.options.headers["Platform"] = "Android";
  }

  bool validateRequest(String url) {
    if (null != url && url.length > 0) {
      return true;
    }
    return false;
  }

  Future<Meta> getLevel1Token(String url, Map<String, dynamic> data) async {
    return await getLevelOneToken(url, data);
  }

  Future<LoginMeta> getLevel2Token(
      String url, Map<String, dynamic> data, String authToken) async {
    return getLeve2OneToken(url, data, authToken);
  }

// working code
  Future<Meta> processGetURL(String url, String authToken) async {
    logPrinting(" UUUUUUUUUUUUUUUUURL" + url);
    if (validateRequest(url)) {
      bool isNetworkAvailable = await GMUtils().isInternetConnected();
      if (isNetworkAvailable) {
        try {
          dio.options.headers["Authorization"] = "Bearer " + authToken;
          dio.options.headers['Content-Length'] = 0;
//        dio.interceptors.add(LogInterceptor(responseBody: false));

          Response response = await dio.get(url);

          return _getResponse(response);
        } catch (error) {
          return handleError(error);
        }
      } else {
        Meta meta = new Meta(
            statusCode: ErrorCode.INTERNET_ERROR,
            statusMsg: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                    Constants.LANGUAGE_ARABIC
                ? Strings.chknetArbStr
                : Strings.chknetEngStr);
        return meta;
      }
    } else {
      Meta meta = new Meta(
          statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
      return meta;
    }
  }

  Future<Meta> getLevelOneToken(String url, Map<String, dynamic> data) async {
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(jsonEncode(data));

        dio.options.headers['Content-Length'] = bodyData.length.toString();
        // dio.interceptors.add(LogInterceptor(responseBody: false));
        try {
          Response response = await dio.post(url, data: json.encode(bodyData));
          return getToken(response);
        } catch (e) {
          return handleError(e);
        }
      } else {
        Meta meta = new Meta(
            statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = new Meta(
          statusCode: ErrorCode.INTERNET_ERROR,
          statusMsg: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                  Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr);
      return meta;
    }
  }

  Future<LoginMeta> getLeve2OneToken(
      String url, Map<String, dynamic> data, String authToken) async {
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(jsonEncode(data));
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        // dio.interceptors.add(LogInterceptor(responseBody: false));
        try {
          Response response = await dio.post(url, data: json.encode(bodyData));
          return getLoginToken(response);
        } catch (e) {
          return handleLoginError(e);
        }
      } else {
        LoginMeta meta = new LoginMeta(
            statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      LoginMeta meta = new LoginMeta(
          statusCode: ErrorCode.INTERNET_ERROR,
          statusMsg: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                  Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr);
      return meta;
    }
  }

  Future<Meta> processPostURL(
      String url, Map<String, dynamic> data, String authToken) async {
    logPrinting(" UUUUUUUUUUUUUUUUURL" + url);
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(jsonEncode(data));
        // print("YYYYYYYYYYY\n$bodyData");
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        try {
          Response response = await dio.post(url, data: jsonEncode(bodyData));

          return _getResponse(response);
        } catch (e) {
          return handleError(e);
        }
      } else {
        Meta meta = new Meta(
            statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = new Meta(
          statusCode: ErrorCode.INTERNET_ERROR,
          statusMsg: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                  Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr);
      return meta;
    }
  }

  Future<Meta> processPutURL(
      String url, Map<String, dynamic> data, String authToken) async {
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(jsonEncode(data));
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        dio.options.headers['Content-Length'] = bodyData.length.toString();

        try {
          Response response = await dio.put(url, data: jsonEncode(bodyData));

          return _getResponse(response);
        } catch (e) {
          return handleError(e);
        }
      } else {
        Meta meta = new Meta(
            statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = new Meta(
          statusCode: ErrorCode.INTERNET_ERROR,
          statusMsg: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                  Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr);
      return meta;
    }
  }

  // ignore: missing_return
  Future<Meta> processDeleteURL(
      String url, String data, String authToken) async {
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(data.toString());
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
        try {
          Response response = await dio.delete(url, data: data);

          return _getResponse(response);
        } catch (e) {
          handleError(e);
        }
      } else {
        Meta meta = new Meta(
            statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = new Meta(
          statusCode: ErrorCode.INTERNET_ERROR,
          statusMsg: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                  Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr);
      return meta;
    }
  }

  // ignore: missing_return
  Future<Meta> imageUpload(
      String url, String filePath, String authToken) async {
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        try {
          var formData = FormData();
          formData.files.add(MapEntry(
            "file",
            await MultipartFile.fromFile(filePath),
          ));
          Response response = await dio.post(url, data: formData);

          return _getResponse(response);
        } catch (e) {
          handleError(e);
        }
      } else {
        Meta meta = new Meta(
            statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = new Meta(
          statusCode: ErrorCode.INTERNET_ERROR,
          statusMsg: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                  Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr);
      return meta;
    }
  }

  // ignore: missing_return
  Future<Meta> imageUploadWithParam(String url, Map<String, String> params,
      String filePath, String authToken) async {
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        try {
          String parameters = "?";
          params.forEach((k, v) => (parameters += k + "=" + v + "&"));
          var formData = FormData();
          formData.files.add(MapEntry(
            "file",
            await MultipartFile.fromFile(filePath),
          ));
          Response response = await dio.post(url + parameters, data: formData);

          return _getResponse(response);
        } catch (e) {
          handleError(e);
        }
      } else {
        Meta meta = new Meta(
            statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = new Meta(
          statusCode: ErrorCode.INTERNET_ERROR,
          statusMsg: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                  Constants.LANGUAGE_ARABIC
              ? Strings.chknetArbStr
              : Strings.chknetEngStr);
      return meta;
    }
  }

  Meta throwError(int errorCode, String errorMsg) {
    Meta meta = new Meta(statusCode: errorCode, statusMsg: errorMsg);
    return meta;
  }

  LoginMeta throwLoginError(int errorCode, String errorMsg) {
    LoginMeta meta = new LoginMeta(statusCode: errorCode, statusMsg: errorMsg);
    return meta;
  }

  Meta handleError(error) {
    if (error.type == DioErrorType.receiveTimeout ||
        error.type == DioErrorType.connectTimeout) {
      return throwError(ErrorCode.CONNECTION_TIMEOUT, "Connection Timeout!");
    } else if (error.type == DioErrorType.response) {
      if (error.response.statusCode == 401 &&
          error.response.data == 'TOKEN EXPIRED') {
        SilentNotificationHandler silentNotificationHandler =
            SilentNotificationHandler.instance;
        silentNotificationHandler.updateData(
            {Constants.NOTIFICATION_KEY: Constants.NOTIFICATION_TOKEN_EXPIRED});
      }
      return throwError(error.response.statusCode, error.response.toString());
    } else {
      return throwError(ErrorCode.COMMUNICATION_ERROR, "Communication Error");
    }
  }

  // ignore: missing_return
  LoginMeta handleLoginError(error) {
    if (error.type == DioErrorType.receiveTimeout ||
        error.type == DioErrorType.connectTimeout) {
      return throwLoginError(
          ErrorCode.CONNECTION_TIMEOUT, "Connection Timeout!");
    } else if (error.type == DioErrorType.response) {
      if (error.response.statusCode == 401 &&
          error.response.data == 'TOKEN EXPIRED') {
        SilentNotificationHandler silentNotificationHandler =
            SilentNotificationHandler.instance;
        silentNotificationHandler.updateData(
            {Constants.NOTIFICATION_KEY: Constants.NOTIFICATION_TOKEN_EXPIRED});
        return throwLoginError(
            ErrorCode.UNAUTHORZIED_USER, error.response.data);
      } else {
        switch (error.response.statusCode) {
          case 401:
            return throwLoginError(
                ErrorCode.UNAUTHORZIED_USER, "User not Authorized");
          case 403:
            return throwLoginError(403, "Forbidden");
          case 404:
            return throwLoginError(404, "Not Found");
          case 409:
            return throwLoginError(ErrorCode.THROTTLE_ERROR, "Throttle Error");
          case 500:
            return throwLoginError(500, "Internal Server Error");
        }
      }
    } else {
      return throwLoginError(
          ErrorCode.COMMUNICATION_ERROR, "Communication Error");
    }
  }

  void logPrinting(String response) {
    log.v(response);
  }

  Meta _getResponse(Response response) {
    Meta data = new Meta();
    if (response.statusCode == 200) {
      if (response.data.toString().isNotEmpty) {
        data = getData(response);
      }
    } else if (response.statusCode == 409) {
      data.statusMsg = response.data.toString();
      data.statusCode = response.statusCode;
    } else {
      if (response.data != null && response.data.toString().length > 0) {
        data = getData(response);
      } else {
        data.statusMsg = response.data.toString();
        data.statusCode = response.statusCode;
      }
    }
    return data;
  }

  Meta getToken(Response response) {
    Meta data = new Meta();
    if (response.statusCode == 200) {
      if (response.data.toString().isNotEmpty) {
        data = getTokenData(response);
      }
    } else if (response.statusCode == 409) {
      data.statusMsg = response.data.toString();
      data.statusCode = response.statusCode;
    } else {
      if (response.data != null && response.data.toString().length > 0) {
        var data = getTokenData(response);
        data.statusMsg = response.data.toString();
        data.statusCode = response.statusCode;
      } else {
        data.statusMsg = response.data.toString();
        data.statusCode = response.statusCode;
      }
    }
    return data;
  }

  LoginMeta getLoginToken(Response response) {
    LoginMeta data = new LoginMeta();
    if (response.statusCode == 200) {
      if (response.data.toString().isNotEmpty) {
        data = getLevel2TokenData(response);
      }
    } else if (response.statusCode == 409) {
      data.statusMsg = response.data.toString();
      data.statusCode = response.statusCode;
    } else {
      if (response.data != null && response.data.toString().length > 0) {
        var data = getLevel2TokenData(response);
        data.statusMsg = response.data.toString();
        data.statusCode = response.statusCode;
      } else {
        data.statusMsg = response.data.toString();
        data.statusCode = response.statusCode;
      }
    }
    return data;
  }

  Meta getData(Response response) {
    GMAPIResponse gmResponse = new GMAPIResponse.fromJson(response.data);
    Meta data = new Meta();

    if (null != gmResponse.result && gmResponse.result.length > 0) {
      data.statusMsg = AESCrypt().decrypt(gmResponse.result);
      data.statusCode = 200;
    } else {
      data.statusMsg =
          GMError.fromJson(jsonDecode(AESCrypt().decrypt(gmResponse.error)))
              .message;
      data.statusCode = 201;
    }
    logPrinting(data.toJson().toString());
    return data;
  }

  Meta getTokenData(Response response) {
    GMAPIResponse gmResponse = new GMAPIResponse.fromJson(response.data);
    Meta data = new Meta();
    if (null != gmResponse.token && gmResponse.token.length > 0) {
      data.statusMsg = gmResponse.token;
      data.statusCode = 200;
    } else {
      data.statusMsg =
          GMError.fromJson(jsonDecode(AESCrypt().decrypt(gmResponse.error)))
              .message;
      data.statusCode = 201;
    }
    logPrinting(data.toJson().toString());
    return data;
  }

  LoginMeta getLevel2TokenData(Response response) {
    print("I am here to check");
    GMAPIResponse gmResponse = new GMAPIResponse.fromJson(response.data);
    LoginMeta data = new LoginMeta();
    print("I am here to check" + gmResponse.token);
    if (null != gmResponse.token && gmResponse.token.length > 0) {
      data.level2token = gmResponse.token;
      data.statusMsg = AESCrypt().decrypt(gmResponse.result);
      data.statusCode = 200;
    } else if (null != gmResponse.result && gmResponse.result.length > 0) {
      data.statusMsg = AESCrypt().decrypt(gmResponse.result);
      data.statusCode = 200;
    } else {
      data.statusMsg =
          GMError.fromJson(jsonDecode(AESCrypt().decrypt(gmResponse.error)))
              .message;
      data.statusCode = 201;
    }
    logPrinting(data.toJson().toString());
    return data;
  }

  Future<double> getNetSpeed(String url) async {
    double finalDownloadRate = 0.0;
    var startTime = new DateTime.now().millisecondsSinceEpoch;
    try {
      Response response = await dio.get(
        url,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      print(response.headers);
      var endTime = new DateTime.now().millisecondsSinceEpoch;
      var downloadElapsedTime = (endTime - startTime) / 1000.0;
      var contentLength = response.headers.value("content-length");
      var kbs = (int.parse(contentLength)) / (1024);
      finalDownloadRate = (kbs / downloadElapsedTime);
      return finalDownloadRate;
    } catch (e) {
      print(e);
      return finalDownloadRate;
    }
  }

  Future<String> imageUploadWithoutResponse(
      String url, String filePath, String authToken) async {
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        try {
          var formData = FormData();
          formData.files.add(MapEntry(
            "file",
            await MultipartFile.fromFile(filePath),
          ));
          Response response = await dio.post(url, data: formData);
          logPrinting(response.data.toString());
          return response.data.toString();
        } catch (e) {
          return "Not a valid URL";
        }
      } else {
        return "Not a valid URL";
      }
    } else {
      return Strings.chknetEngStr;
    }
  }
}
