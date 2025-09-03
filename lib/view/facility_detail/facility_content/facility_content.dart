// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/facility_detail/bloc/facility_detail_bloc.dart';
import 'package:slc/view/facility_detail/facility_content/bloc/bloc.dart';
import 'package:slc/view/facility_detail/facility_content/contact_us/facility_detail_contact_us.dart';
import 'package:slc/view/facility_detail/facility_content/facility_review/facility_detail_review.dart';
import 'package:slc/view/facility_detail/facility_content/packages/facility_detail_packages.dart';
import 'package:slc/view/facility_detail/facility_profile/facility_profile.dart';

import '../facility_profile/spaobb_profile.dart';
import 'gallery/facility_detail_gallery.dart';
import 'new_facility_hall/hall_details.dart';
import 'overview/facility_detail_overivew_details.dart';

class FacilityContent extends StatelessWidget {
  double height;
  int listId = -1;
  int menuId = -1;

  FacilityContent({this.height, this.listId, this.menuId});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    return BlocProvider<FacilityContentBloc>(
//      create: (context) => FacilityContentBloc(),
//      child: _FacilityContent(),

//    );
    return _FacilityContent(listId: listId, menuId: menuId);
  }
}

class _FacilityContent extends StatefulWidget {
  int listId = -1;
  int menuId = -1;

  _FacilityContent({this.listId, this.menuId});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContentView();
  }
}

class _ContentView extends State<_FacilityContent> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<FacilityContentBloc, FacilityContentState>(
        builder: (context, state) {
          if (state is PopulateFacilityTabData) {
            if (state.tabType == Constants.MENU_TYPE_OVERVIEW) {
              if (state.response != null &&
                  state.response.contentOverview != null) {
                return FacilityOverView(state.response.contentOverview);
              } else {
                return Center(
                  child: Container(
                    child: Text(
                      tr("noDataFound"),
                      style: TextStyle(
                          color: ColorData.primaryTextColor,
                          fontFamily: tr('currFontFamily')),
                    ),
                  ),
                );
              }
            } else if (state.tabType == Constants.MENU_TYPE_CONTACTUS) {
              return FacilityDetailContactUs(
                  state.response.contactList, state.response.colorCode);
            } else if (state.tabType == Constants.MENU_TYPE_GALLERY) {
              return FacilityDetailGallery(
                facilityId: state.response.facilityId,
                facilityTabId: state.tabId,
                facilityDetailBloc:
                    BlocProvider.of<FacilityDetailBloc>(context),
                title: state.tabName,
                colorCode: state.response.colorCode,
              );
            } else if (state.tabType == Constants.MENU_TYPE_HALL) {
              // return FacilityDetailHall(
              //     imageVR: state.response.imageVR,
              //     cateringTypeList: state.response.cateringTypeList,
              //     partyHallEnquiryList: state.response.partyHallEnquiryList,
              //     colorCode: state.response.colorCode,
              //     facilityId: state.response.facilityId);
              return HallDetailView(
                  imageVR: state.response.imageVR,
                  cateringTypeList: state.response.cateringTypeList,
                  partyHallEnquiryList: state.response.partyHallEnquiryList,
                  colorCode: state.response.colorCode,
                  facilityId: state.response.facilityId);
            } else if (state.tabType == Constants.MENU_TYPE_REVIEWS) {
              return FacilityDetailReview(
                  reviews: state.response.reviews,
                  colorCode: state.response.colorCode,
                  facilityId: state.response.facilityId);
              // } else if (state.tabType == Constants.MENU_TYPE_FITNESS) {
              //   return FacilityDetailFitness(
              //       fitnessUI: state.response.fitnessUI,
              //       colorCode: state.response.colorCode,
              //       facilityId: state.response.facilityId);
            } else if (state.tabType == Constants.MENU_TYPE_PROFILE) {
              if (state.response.facilityId == Constants.FacilityFitness) {
                return FitnessProfile(
                  slcMembership: state.response.slcMembership,
                  facilityMembership: state.response.memberShipDetail,
                  classAvailablity: state.response.classAvailDetail,
                  colorCode: state.response.colorCode,
                  facilityId: state.response.facilityId,
                  isShopClosed: state.response.isClosed,
                );
              } else if (state.response.facilityId ==
                      Constants.FacilityBeauty ||
                  state.response.facilityId == Constants.FacilitySpa) {
                return SpaOBBProfile(
                  slcMembership: state.response.slcMembership,
                  facilityMembership: state.response.memberShipDetail,
                  classAvailablity: state.response.classAvailDetail,
                  colorCode: state.response.colorCode,
                  facilityId: state.response.facilityId,
                  isShopClosed: state.response.isClosed,
                  showViewConsultation: state.response.showViewConsultation,
                );
              }
            } else if (state.tabType == Constants.MENU_TYPE_SERVICES) {
              return FacilityDetailPackages(
                key: PageStorageKey(state.tabId.toString()),
                facilityId: state.response.facilityId,
                facilityTabId: state.tabId,
                facilityDetailBloc:
                    BlocProvider.of<FacilityDetailBloc>(context),
                colorCode: state.response.colorCode,
                listId: widget.listId,
                menuId: widget.menuId,
              );
            }
          }
          return Container();
        },
      ),
    );
  }
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   widget.listId = -1;
  //   super.dispose();
  // }
}
