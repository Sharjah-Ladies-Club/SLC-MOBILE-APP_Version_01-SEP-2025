import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/GenderResponse.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/repo/event_repository.dart';
import 'package:slc/repo/generic_repo.dart';
import 'package:slc/repo/profile_repository.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'bloc.dart';

class EventAddPeopleBloc
    extends Bloc<EventAddPeopleEvent, EventAddPeopleState> {
  EventAddPeopleBloc() : super(null);

  EventAddPeopleState get initialState => InitialEventAddPeopleState();

  Stream<EventAddPeopleState> mapEventToState(
    EventAddPeopleEvent event,
  ) async* {
    if (event is SaveEventRegistrationEvent) {
      yield ShowEventRegistrationProgressBar();
      Meta m = await EventRepository().saveEventRegistration(event.request);
      if (m.statusCode == 200) {
        yield HideEventRegistrationProgressBar();
        yield OnSuccessEventRegistration();
      } else {
        yield HideEventRegistrationProgressBar();
        yield OnFailureEventRegistration(error: m.statusMsg);
      }
    } else if (event is GetInitiallData) {
      yield ShowEventRegistrationProgressBar();
      List<Meta> metaList = await Future.wait(
          [GeneralRepo().getNationalityList(), GeneralRepo().getGenderList()]);
      if (metaList[0].statusCode == 200 && metaList[1].statusCode == 200) {
        List<NationalityResponse> nationalityList = [];
        List<GenderResponse> genderList = [];
        jsonDecode(metaList[0].statusMsg)["response"].forEach(
            (f) => nationalityList.add(new NationalityResponse.fromJson(f)));

        jsonDecode(metaList[1].statusMsg)["response"]
            .forEach((f) => genderList.add(new GenderResponse.fromJson(f)));
        yield LoadInitialData(
            nationalityList: nationalityList, genderList: genderList);
        yield HideEventRegistrationProgressBar();
      } else {
        yield OnInitialDataFailureEventRegistration();
      }
    } else if (event is GetUserProfileEvent) {
      yield ShowEventRegistrationProgressBar();
      Meta meta = await ProfileRepo().getProfileDetail();
      if (meta.statusCode == 200) {
        UserProfileInfo userProfileInfo = new UserProfileInfo.fromJson(
            jsonDecode(meta.statusMsg)["response"]);

        yield GetProfileState(userProfileInfo: userProfileInfo);

        yield HideEventRegistrationProgressBar();
      } else {
        yield OnInitialDataFailureEventRegistration();
      }
    } else if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    } else if (event is GetPaymentTerms) {
      Meta m =
          await FacilityDetailRepository().getPaymentTerms(event.facilityId);
      if (m.statusCode == 200) {
        PaymentTerms paymentTerms =
            PaymentTerms.fromJson(jsonDecode(m.statusMsg)['response']);
        yield GetPaymentTermsResult(paymentTerms: paymentTerms);
      }
    }
  }
}
