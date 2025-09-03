import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BaseInfoOneEvent extends Equatable {
  const BaseInfoOneEvent();
}

class PageOneContinueButtonPressed extends BaseInfoOneEvent {
  final String mobileNumber;
  final String email;
  final int countryId;
  final String countrycode;
  final String pagePath;

  const PageOneContinueButtonPressed(
      {@required this.mobileNumber,
      @required this.email,
      @required this.countryId,
      @required this.pagePath,
      @required this.countrycode});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'PageOneContinueButtonPressed';
}

// class PageOneLanguageChanged extends BaseInfoOneEvent {
//   final int selectedLanguage;

//   const PageOneLanguageChanged({this.selectedLanguage});

//   @override
//   List<Object> get props => [selectedLanguage];

//   @override
//   String toString() => 'LanguageChanged :$selectedLanguage }';
// }

class OnLanguagechangeInReg extends BaseInfoOneEvent {
  final BuildContext context;

  const OnLanguagechangeInReg({
    @required this.context,
  });

  @override
  // TODO: implement props
  List<Object> get props => null;
}

// class CountryCodeButtonPressed extends BaseInfoOneEvent {
//   final CountryCode countryCode;

//   const CountryCodeButtonPressed({
//     @required this.countryCode,
//   });

//   @override
//   // TODO: implement props
//   List<Object> get props => null;
// }

// class CountryCodeSelected extends BaseInfoOneEvent {
//   final CountryCode countryCode;

//   const CountryCodeSelected({@required this.countryCode});

//   @override
//   // TODO: implement props
//   List<Object> get props => null;

//   @override
//   String toString() => 'CountryCodeSelected :$countryCode }';
// }
