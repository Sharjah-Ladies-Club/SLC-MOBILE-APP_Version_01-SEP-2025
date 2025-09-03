import 'package:slc/utils/constant.dart';

enum Flavor { DEV, BETA, RELEASE }

class Injector {
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  String get baseUrl {
    String url = "";
    switch (_flavor) {
      case Flavor.DEV:
        url = Constants.BaseUrlDev;
        break;
      case Flavor.BETA:
        url = Constants.BaseUrlTest;
        break;
      case Flavor.RELEASE:
        url = Constants.BaseUrlRelease;
        break;
    }

    print("Base URL is $url");

    return url;
  }

  String get botBaseUrl {
    String url = "";
    switch (_flavor) {
      case Flavor.DEV:
        url = Constants.ChatBotBaseUrlDev;
        break;
      case Flavor.BETA:
        url = Constants.ChatBotBaseUrlQA;
        break;
      case Flavor.RELEASE:
        url = Constants.ChatBotBaseUrlUAT;
        break;
    }

    print("Bot Base URL is $url");

    return url;
  }
}
