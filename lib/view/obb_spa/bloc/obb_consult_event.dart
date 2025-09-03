import 'package:equatable/equatable.dart';

abstract class ObbConsultEvent extends Equatable {
  const ObbConsultEvent();
}

class GetRecommendationEvent extends ObbConsultEvent {
  final int facilityId;
  final String mobileNo;

  const GetRecommendationEvent({this.facilityId, this.mobileNo});

  // TODO: implement props
  List<Object> get props => [facilityId, mobileNo];
}

class GetFurtherRecommendation extends ObbConsultEvent {
  final int facilityId;
  final int recommendationId;

  const GetFurtherRecommendation({this.facilityId, this.recommendationId});

  // TODO: implement props
  List<Object> get props => [facilityId, recommendationId];
}

class GetDownloadUrlEvent extends ObbConsultEvent {
  final int facilityId;
  final int recommendationId;

  const GetDownloadUrlEvent({this.facilityId, this.recommendationId});

  // TODO: implement props
  List<Object> get props => [facilityId, recommendationId];
}
