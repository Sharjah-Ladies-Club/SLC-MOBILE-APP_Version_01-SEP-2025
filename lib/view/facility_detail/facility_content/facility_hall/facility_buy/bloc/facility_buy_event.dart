import 'package:equatable/equatable.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/facility_detail_item_response.dart';

abstract class FacilityBuyEvent extends Equatable {
  const FacilityBuyEvent();
}

class GetItemDetailsEvent extends FacilityBuyEvent {
  final int facilityId;
  final String retailItemSetId;

  const GetItemDetailsEvent({this.facilityId, this.retailItemSetId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId, retailItemSetId];
}

class GetDiscountEvent extends FacilityBuyEvent {
  final int facilityId;
  final double billAmount;

  const GetDiscountEvent({this.facilityId, this.billAmount});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId, billAmount];
}

class GetOrderStatusEvent extends FacilityBuyEvent {
  final String merchantReferenceNo;

  const GetOrderStatusEvent({this.merchantReferenceNo});

  @override
  // TODO: implement props
  List<Object> get props => [merchantReferenceNo];
}

class GetPaymentTerms extends FacilityBuyEvent {
  final int facilityId;

  const GetPaymentTerms({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}

class FitnessBuyEnquirySaveEvent extends FacilityBuyEvent {
  final EnquiryDetailResponse enquiryDetailResponse;
  final FacilityItems facilityItem;
  const FitnessBuyEnquirySaveEvent(
      {this.enquiryDetailResponse, this.facilityItem});

  @override
  // TODO: implement props
  List<Object> get props => [enquiryDetailResponse];
}
