import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_detail_response.dart';

abstract class FacilityContentEvent extends Equatable {
  const FacilityContentEvent();
}

class FetchTabContent extends FacilityContentEvent {
  final String tabName;
  final String tabType;
  final int tabId;
  final FacilityDetailResponse response;
  // final int menuId;
  const FetchTabContent({this.tabId, this.tabName, this.tabType, this.response
      // ,this.menuId
      });

  @override
  // TODO: implement props
  List<Object> get props => [
        tabId, tabName, tabType
        // ,menuId
      ];
}

class GetKunoozBookingData extends FacilityContentEvent {
  final int bookingId;
  // final int menuId;
  const GetKunoozBookingData({this.bookingId});

  @override
  // TODO: implement props
  List<Object> get props => [bookingId];
}

class GetKunoozAmendContractData extends FacilityContentEvent {
  final int amendId;
  // final int menuId;
  const GetKunoozAmendContractData({this.amendId});

  @override
  // TODO: implement props
  List<Object> get props => [amendId];
}

class GetKunoozPaymentTerms extends FacilityContentEvent {
  final int facilityId;

  const GetKunoozPaymentTerms({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}

class GetKunoozContractDownload extends FacilityContentEvent {
  final int bookingId;

  const GetKunoozContractDownload({this.bookingId});

  @override
  // TODO: implement props
  List<Object> get props => [bookingId];
}

class GetKunoozAmendmentDownload extends FacilityContentEvent {
  final int amendmentId;

  const GetKunoozAmendmentDownload({this.amendmentId});

  @override
  // TODO: implement props
  List<Object> get props => [amendmentId];
}

class GetKunoozCancelBooking extends FacilityContentEvent {
  final int bookingId;

  const GetKunoozCancelBooking({this.bookingId});

  @override
  // TODO: implement props
  List<Object> get props => [bookingId];
}

class GetKunoozRevertAmendmentEvent extends FacilityContentEvent {
  final int bookingId;
  final int isAccept;
  const GetKunoozRevertAmendmentEvent({this.bookingId, this.isAccept});

  @override
  // TODO: implement props
  List<Object> get props => [bookingId, isAccept];
}
