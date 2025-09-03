import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/obb_recommendation_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';

import './bloc.dart';

class ObbConsultBloc extends Bloc<ObbConsultEvent, ObbConsultState> {
  final ObbConsultBloc obbConsultBloc;

  ObbConsultBloc({@required this.obbConsultBloc}) : super(null);
  ObbConsultState get initialState => InitialObbConsultState();

  Stream<ObbConsultState> mapEventToState(
    ObbConsultEvent event,
  ) async* {
    if (event is GetRecommendationEvent) {
      Meta m = await FacilityDetailRepository()
          .getRecommendationList(event.facilityId);
      if (m.statusCode == 200) {
        List<Recommendation> recommendationList = new List<Recommendation>();
        print(jsonDecode(m.statusMsg).toString());
        List<Recommendation> response = jsonDecode(m.statusMsg)['response']
            .forEach(
                (f) => recommendationList.add(new Recommendation.fromJson(f)));
        yield GetRecommendationState(recommendation: recommendationList);
      } else {
        yield OnFailure(
            error: m.statusMsg, timestamp: DateTime.now().toString());
      }
    } else if (event is GetFurtherRecommendation) {
      Meta m = await FacilityDetailRepository().getFurtherRecommendationList(
          event.facilityId, event.recommendationId);
      if (m.statusCode == 200) {
        List<FurtherRecommendation> furtherRecommendationList =
            new List<FurtherRecommendation>();
        List<FurtherRecommendation> response =
            jsonDecode(m.statusMsg)['response'].forEach((f) =>
                furtherRecommendationList
                    .add(new FurtherRecommendation.fromJson(f)));
        yield GetFurtherRecommendationState(
            furtherRecommendation: furtherRecommendationList);
      } else {
        yield OnFailure(
            error: m.statusMsg, timestamp: DateTime.now().toString());
      }
    } else if (event is GetDownloadUrlEvent) {
      Meta m = await FacilityDetailRepository()
          .getOBBDownload(event.recommendationId, event.facilityId);
      if (m.statusCode == 200) {
        Map<String, dynamic> documentResp = <String, dynamic>{};
        documentResp = jsonDecode(m.statusMsg);
        print(documentResp);
        DownloadData dd =
            DownloadData.fromJson(jsonDecode(m.statusMsg)['response']);
        yield GetDownloadUrlState(
            downloadUrl: dd.durl,
            dtoken: dd.dtoken,
            timeStamp: DateTime.now().toString());
      }
    }
  }
}
