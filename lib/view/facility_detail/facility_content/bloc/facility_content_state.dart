import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/knooz_response_dto.dart';

import '../../../../model/terms_condition.dart';

abstract class FacilityContentState extends Equatable {
  const FacilityContentState();
}

class InitialFacilityContentState extends FacilityContentState {
  @override
  List<Object> get props => [];
}

class PopulateFacilityTabData extends FacilityContentState {
  final String tabName;
  final String tabType;
  final int tabId;
  final FacilityDetailResponse response;
  // final int menuId;
  const PopulateFacilityTabData(
      {this.tabId, this.tabName, this.tabType, this.response
      // ,this.menuId
      });

  @override
  // TODO: implement props
  List<Object> get props => [
        tabId, tabName, tabType
        // ,menuId
      ];
}

class KunoozBookingData extends FacilityContentState {
  final KunoozBookingDto bookingResponse;
  const KunoozBookingData({this.bookingResponse});

  @override
  // TODO: implement props
  List<Object> get props => [bookingResponse];
}

class KunoozAmendContractData extends FacilityContentState {
  final KunuoozContractDto contractResponse;
  const KunoozAmendContractData({this.contractResponse});

  @override
  // TODO: implement props
  List<Object> get props => [contractResponse];
}

class KunoozPaymentTerms extends FacilityContentState {
  final List<TermsCondition> termsList;
  const KunoozPaymentTerms({this.termsList});

  @override
  // TODO: implement props
  List<Object> get props => [termsList];
}

class KunoozContractDownload extends FacilityContentState {
  final String url;
  final String timeStamp;
  const KunoozContractDownload({this.url, this.timeStamp});

  @override
  // TODO: implement props
  List<Object> get props => [url, timeStamp];
}

class KunoozAmendmentDownload extends FacilityContentState {
  final String url;
  final String timeStamp;
  const KunoozAmendmentDownload({this.url, this.timeStamp});

  @override
  // TODO: implement props
  List<Object> get props => [url, timeStamp];
}

class KunoozCancelBooking extends FacilityContentState {
  final String cancelResp;
  const KunoozCancelBooking({this.cancelResp});

  @override
  // TODO: implement props
  List<Object> get props => [cancelResp];
}

class KunoozRevertAmendmentState extends FacilityContentState {
  final String revertMessage;

  const KunoozRevertAmendmentState({this.revertMessage});

  @override
  // TODO: implement props
  List<Object> get props => [revertMessage];
}
