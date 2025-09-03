import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class BaseInfoTwoState extends Equatable {
  const BaseInfoTwoState();
}

class InitialBaseInfoTwoState extends BaseInfoTwoState {
  @override
  List<Object> get props => [];
}

class LanguageSwitched extends BaseInfoTwoState {
  // final List<NationalityResponse> nationalityResponse;
  // final List<GenderResponse> genderResponse;

  const LanguageSwitched(// {
      // @required this.nationalityResponse, @required this.genderResponse
      // }
      );

  @override
  List<Object> get props => [];
}

class ShowProgressBar extends BaseInfoTwoState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideProgressBar extends BaseInfoTwoState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnSuccess extends BaseInfoTwoState {
  // final List<NationalityResponse> nationalityResponse;
  // final List<GenderResponse> genderResponse;

  const OnSuccess(
      // {@required this.nationalityResponse, @required this.genderResponse}
      );

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnFailure extends BaseInfoTwoState {
  final String error;

  const OnFailure({
    @required this.error,
  });

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
