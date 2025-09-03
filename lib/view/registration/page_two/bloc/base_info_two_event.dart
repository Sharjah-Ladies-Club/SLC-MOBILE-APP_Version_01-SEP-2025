import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:slc/customcomponentfields/custom_country_code_picker/custom_country_code.dart';

abstract class BaseInfoTwoEvent extends Equatable {
  const BaseInfoTwoEvent();
}

class NationalityClicked extends BaseInfoTwoEvent {
  final CountryCode countryCode;

  const NationalityClicked({
    @required this.countryCode,
  });

  List<Object> get props => [countryCode];

  String toString() => 'countryCode { countryCode: $countryCode }';
}

class GenderClicked extends BaseInfoTwoEvent {
  final CountryCode countryCode;

  const GenderClicked({
    @required this.countryCode,
  });

  List<Object> get props => [countryCode];

  String toString() => 'countryCode { countryCode: $countryCode }';
}

class OnLanguagechangeInRegTwo extends BaseInfoTwoEvent {
  final BuildContext context;

  const OnLanguagechangeInRegTwo({
    @required this.context,
  });

  // TODO: implement props
  List<Object> get props => null;
}
