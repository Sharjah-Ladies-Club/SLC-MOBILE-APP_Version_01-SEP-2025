import 'package:equatable/equatable.dart';
import 'package:slc/model/obb_recommendation_response.dart';

abstract class ObbConsultState extends Equatable {
  const ObbConsultState();
}

class InitialObbConsultState extends ObbConsultState {
  List<Object> get props => [];
}

class GetRecommendationState extends ObbConsultState {
  final List<Recommendation> recommendation;

  const GetRecommendationState({this.recommendation});

  // TODO: implement props
  List<Object> get props => [recommendation];
}

class GetFurtherRecommendationState extends ObbConsultState {
  final List<FurtherRecommendation> furtherRecommendation;
  const GetFurtherRecommendationState({this.furtherRecommendation});

  // TODO: implement props
  List<Object> get props => [furtherRecommendation];
}

class GetDownloadUrlState extends ObbConsultState {
  final String downloadUrl;
  final String dtoken;
  final String timeStamp;
  const GetDownloadUrlState({this.downloadUrl, this.dtoken, this.timeStamp});

  // TODO: implement props
  List<Object> get props => [downloadUrl, dtoken, timeStamp];
}

class OnFailure extends ObbConsultState {
  final String error, timestamp;

  const OnFailure({this.error, this.timestamp});

  @override
  // TODO: implement props
  List<Object> get props => [error, timestamp];
}
