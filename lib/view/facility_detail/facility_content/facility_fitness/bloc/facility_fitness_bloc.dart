import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/customcomponentfields/custom_food_picker/custom_food_code.dart';
import './bloc.dart';

class FacilityFitnessBloc
    extends Bloc<FacilityFitnessEvent, FacilityFitnessState> {
  final FacilityFitnessBloc fitnessBloc;

  FacilityFitnessBloc({@required this.fitnessBloc}) : super(null);

  FacilityFitnessState get initialState => InitialFacilityFitnessState();

  Stream<FacilityFitnessState> mapEventToState(
    FacilityFitnessEvent event,
  ) async* {
    if (event is FetchFitnessVideoContent) {
      Meta m = await FacilityDetailRepository()
          .getFitnessVideoList(event.facilityId);

      if (m.statusCode == 200) {
        List<FitnessUserVideos> videoList = [];
        jsonDecode(m.statusMsg)['response']
            .forEach((f) => videoList.add(new FitnessUserVideos.fromJson(f)));

        yield PopulateFacilityFitnessVideoData(response: videoList);
      } else {
        yield PopulateFacilityFitnessVideoData(response: []);
      }
    } else if (event is FetchFitnessDietContent) {
      List<FoodCode> foodList = [];
      Meta m = await (new FacilityDetailRepository()).getFoodList();
      if (m.statusCode == 200) {
        jsonDecode(m.statusMsg)["response"]
            .forEach((f) => foodList.add(new FoodCode.fromJson(f)));
      }
      if (m.statusCode == 200) {
        yield PopulateFacilityFitnessDietData(response: foodList);
      } else {
        yield PopulateFacilityFitnessDietData(response: []);
      }
    } else if (event is FetchFitnessDietSave) {
      try {
        yield ShowProgressBar();
        Meta m = await (new FacilityDetailRepository())
            .saveDietDetails(event.dietEntry);
        if (m.statusCode == 200) {
          // String result = jsonDecode(m.statusMsg)['response'];
          yield SaveFacilityFitnessDietData(response: "Success");
        } else {
          yield SaveFacilityFitnessDietData(response: m.statusMsg);
        }
        yield HideProgressBar();
      } catch (e) {
        print(e);
        yield HideProgressBar();
      }
    }
  }
}
