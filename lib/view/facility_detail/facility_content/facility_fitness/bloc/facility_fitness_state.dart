import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/customcomponentfields/custom_food_picker/custom_food_code.dart';

abstract class FacilityFitnessState extends Equatable {
  const FacilityFitnessState();
}

class InitialFacilityFitnessState extends FacilityFitnessState {
  @override
  List<Object> get props => [];
}

class PopulateFacilityFitnessVideoData extends FacilityFitnessState {
  final List<FitnessUserVideos> response;
  // final int menuId;
  const PopulateFacilityFitnessVideoData({this.response
      // ,this.menuId
      });

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class PopulateFacilityFitnessDietData extends FacilityFitnessState {
  final List<FoodCode> response;
  // final int menuId;
  const PopulateFacilityFitnessDietData({this.response
      // ,this.menuId
      });

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class SaveFacilityFitnessDietData extends FacilityFitnessState {
  final String response;
  // final int menuId;
  const SaveFacilityFitnessDietData({this.response
      // ,this.menuId
      });

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class ShowProgressBar extends FacilityFitnessState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideProgressBar extends FacilityFitnessState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
