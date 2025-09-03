import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/carousel_response.dart';
import 'package:slc/repo/home_repository.dart';
import 'package:slc/view/home/bloc/bloc.dart';

import './bloc.dart';

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  final HomeBloc homeBloc;
  CarouselBloc({this.homeBloc}) : super(null);

  CarouselState get initialState => CarouselLoadingState();

  Stream<CarouselState> mapEventToState(
    CarouselEvent event,
  ) async* {
    if (event is GetCarouselList) {
      Meta m = await HomeRepository().getCarouselList();
      if (m.statusCode == 200) {
        List<CarouselResponse> carouselResponse = [];
        jsonDecode(m.statusMsg)['response'].forEach(
            (f) => carouselResponse.add(new CarouselResponse.fromJson(f)));
        //sort the carousel by display order
        carouselResponse
            .sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

        yield CarouselLoadedState(result: carouselResponse);
      } else {
        homeBloc..add(CommonFailure(error: m.statusMsg));
      }
    } else if (event is RefreshGetCarouselList) {
      Meta m = await HomeRepository().getCarouselList();
      if (m.statusCode == 200) {
        List<CarouselResponse> carouselResponse = [];
        jsonDecode(m.statusMsg)['response'].forEach(
            (f) => carouselResponse.add(new CarouselResponse.fromJson(f)));
        //sort the carousel by display order
        carouselResponse
            .sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

        yield RefreshCarouselLoadedState(result: carouselResponse);
      } else {
        homeBloc..add(CommonFailure(error: m.statusMsg));
      }
    } else if (event is ShowCarouselList) {
      yield CarouselLoadedState();
    }
  }
}
