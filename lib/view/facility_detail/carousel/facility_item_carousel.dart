// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/customcomponentfields/RadioModel.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/facility_detail/carousel/bloc/bloc.dart';
import 'package:slc/view/facility_detail/facility_menu/bloc/facility_menu_bloc.dart';
import 'package:slc/view/facility_detail/facility_menu/bloc/facility_menu_event.dart';

class FacilityItemCarousel extends StatelessWidget {
  double height;

  FacilityItemCarousel({this.height});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    return BlocProvider<FacilityItemDetailBloc>(
//      create: (context) => FacilityItemDetailBloc(
//          facilityDetailBloc: BlocProvider.of<FacilityDetailBloc>(context),
//          facilityDetailRepository: FacilityDetailRepository()),
//      child: _FacilityItemCarousel(),
//    );
//          ..add(GetFacilityItemDetails(facilityId: facilityId)));

    return _FacilityItemCarousel(
      height: height,
    );
  }
}

class _FacilityItemCarousel extends StatefulWidget {
  double height;

  _FacilityItemCarousel({this.height});

  @override
  State<StatefulWidget> createState() {
    return _Carousel();
  }
}

List<RadioModel> sampleData = [];

class _Carousel extends State<_FacilityItemCarousel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FacilityItemDetailBloc, FacilityItemDetailState>(
        builder: (context, state) {
          if (state is LoadingFacilityItemDetails) {
            return Container();
          } else if (state is LoadedFacilityItemDetails) {
            if (!SPUtil.getBool(Constants.IS_MENU_TAB_FULL, defValue: false)) {
              SPUtil.putBool(Constants.IS_MENU_TAB_FULL, true);
              sampleData.clear();
              sampleData.add(new RadioModel(
                  isSelected: true,
                  mobileCategoryId: -1,
                  mobileCategoryName: tr("overview"),
                  menuType: Constants.MENU_TYPE_OVERVIEW,
                  response: state.facilityDetailResponse));

              state.facilityDetailResponse.tabList.forEach((f) => {
                    sampleData.add(getTabView(f, state.facilityDetailResponse))
                  });

              sampleData.add(new RadioModel(
                  isSelected: false,
                  mobileCategoryId: -2,
                  mobileCategoryName: tr("contact_us"),
                  menuType: Constants.MENU_TYPE_CONTACTUS,
                  response: state.facilityDetailResponse));
              BlocProvider.of<FacilityMenuBloc>(context)
                ..add(LoadFacilityMenu(
                    tabList: sampleData,
                    facilityDetailResponse: state.facilityDetailResponse));
            }
            return mainUI(context, state.facilityDetailResponse);
          } else if (state is ReLoadedFacilityItemDetails) {
            if (!SPUtil.getBool(Constants.IS_MENU_TAB_FULL, defValue: false)) {
              SPUtil.putBool(Constants.IS_MENU_TAB_FULL, true);
              sampleData.clear();
              sampleData.add(new RadioModel(
                  isSelected: true,
                  mobileCategoryId: -1,
                  mobileCategoryName: tr("overview"),
                  menuType: Constants.MENU_TYPE_OVERVIEW,
                  response: state.facilityDetailResponse));

              state.facilityDetailResponse.tabList.forEach((f) => {
                    sampleData.add(getTabView(f, state.facilityDetailResponse))
                  });

              sampleData.add(new RadioModel(
                  isSelected: false,
                  mobileCategoryId: -2,
                  mobileCategoryName: tr("contact_us"),
                  menuType: Constants.MENU_TYPE_CONTACTUS,
                  response: state.facilityDetailResponse));
              BlocProvider.of<FacilityMenuBloc>(context)
                ..add(ReLoadFacilityMenu(
                    tabList: sampleData,
                    facilityDetailResponse: state.facilityDetailResponse));
            }
            return mainUI(context, state.facilityDetailResponse);
          }
          return Container();
        },
      ),
    );
  }

  RadioModel getTabView(
      TabList f, FacilityDetailResponse facilityDetailResponse) {
    // debugPrint(" GGHFFFGDFSDFSGSDGSDGDSGDSGDD " +
    //     f.mobileCategoryName +
    //     " " +
    //     f.isGallery.toString());
    if (f.isGallery) {
      return new RadioModel(
          isSelected: false,
          mobileCategoryId: f.mobileCategoryId,
          mobileCategoryName: f.mobileCategoryName,
          menuType: Constants.MENU_TYPE_GALLERY,
          response: facilityDetailResponse);
    } else if (f.isHall) {
      return new RadioModel(
          isSelected: false,
          mobileCategoryId: f.mobileCategoryId,
          mobileCategoryName: f.mobileCategoryName,
          menuType: Constants.MENU_TYPE_HALL,
          response: facilityDetailResponse);
      // } else if (f.isFitness) {
      //   return new RadioModel(
      //       isSelected: false,
      //       mobileCategoryId: f.mobileCategoryId,
      //       mobileCategoryName: f.mobileCategoryName,
      //       menuType: Constants.MENU_TYPE_FITNESS,
      //       response: facilityDetailResponse);
    } else if (f.isProfile) {
      return new RadioModel(
          isSelected: false,
          mobileCategoryId: f.mobileCategoryId,
          mobileCategoryName: f.mobileCategoryName,
          menuType: Constants.MENU_TYPE_PROFILE,
          response: facilityDetailResponse);
    } else if (f.isReview) {
      return new RadioModel(
          isSelected: false,
          mobileCategoryId: f.mobileCategoryId,
          mobileCategoryName: f.mobileCategoryName,
          menuType: Constants.MENU_TYPE_REVIEWS,
          response: facilityDetailResponse);
    } else {
      return new RadioModel(
          isSelected: false,
          mobileCategoryId: f.mobileCategoryId,
          mobileCategoryName: f.mobileCategoryName,
          menuType: Constants.MENU_TYPE_SERVICES,
          response: facilityDetailResponse);
    }
  }

  Widget mainUI(
      BuildContext context, FacilityDetailResponse facilityDetailResponse) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          carouselUi(context, facilityDetailResponse.imageList),
          Align(
            alignment: Localizations.localeOf(context).languageCode == "ar"
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 10.0,
                  left: (Localizations.localeOf(context).languageCode == "en")
                      ? 10.0
                      : 0.0,
                  right: Localizations.localeOf(context).languageCode == "en"
                      ? 0.0
                      : 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, 0);
                },
                child: Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black45,
                  ),
                  constraints: BoxConstraints(
                      minWidth: 35, minHeight: 35, maxHeight: 35, maxWidth: 35),
                  child: Center(
                    child: Icon(
                      FacilityHomeIcon.facility_home_run,
                      color: ColorData.primaryColor,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ),
//              child: Container(
//                margin: EdgeInsets.all(10.0),
//                padding: EdgeInsets.all(2),
//                decoration: new BoxDecoration(
//                  color: Colors.black26,
//                  borderRadius: BorderRadius.circular(6),
//                ),
//                constraints: BoxConstraints(
//                    minWidth: 25, minHeight: 25, maxHeight: 25, maxWidth: 25),
//              )
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(
                      right: 5.0,
                      left: 5.0,
                    ),
                    child:
//                    PackageListHead.facility_details_page_title(
//                      context,
//                      facilityDetailResponse.facilityGroupName,
//                    ),

                        new AutoSizeText(
                            facilityDetailResponse.facilityGroupName != null
                                ? facilityDetailResponse.facilityGroupName
                                : "",
                            maxFontSize: 20.0,
                            minFontSize: 18.0,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
//                              color: ColorData.inActiveIconColor,
                              color: Theme.of(context).primaryColor,
//                                fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: tr('currFontFamily'),
                            )),
                  ),
                ),
                height: 35.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.white, Colors.white])),
              )),
//          Align(
//              alignment: Alignment.topCenter,
//              child: Container(
//                height: kBottomNavigationBarHeight,
////                color: Colors.black12,
//                decoration: BoxDecoration(
//                    color: Colors.red,
//                    borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.circular(10),
//                        bottomRight: Radius.circular(10)),
//                    gradient: LinearGradient(
//                        begin: Alignment.bottomCenter,
//                        end: Alignment.topCenter,
//                        colors: [Colors.black26, Colors.white60])),
//                child: Row(
//                  children: <Widget>[
//                    //    Align(
////                      alignment: Localizations.localeOf(context).languageCode == "ar"
////                          ? Alignment.centerRight
////                          : Alignment.centerLeft,
//                    //     child:
//                    Padding(
//                      padding:
//                          Localizations.localeOf(context).languageCode == "ar"
//                              ? EdgeInsets.only(right: 10.0)
//                              : EdgeInsets.only(left: 10.0),
//                      child: GestureDetector(
//                        child: Icon(
//                          Icons.arrow_back_ios,
//                          color: ColorData.activeIconColor,
//                        ),
//                        onTap: () => Navigator.pop(context, 0),
//                      ),
//                    ),
//                    //   ),
//                  ],
//                ),
//              )),
        ],
      ),
    );
  }

  Widget carouselUi(BuildContext context, List<ImageList> result) {
    if (result != null && result.length > 0) {
      return Container(
        color: ColorData.whiteColor,
        padding: EdgeInsets.only(bottom: 2.0),
        child: CarouselSlider.builder(
          itemCount: result.length,
          itemBuilder: (BuildContext context, int itemIndex, int realIndex) =>
              imageUI(result[itemIndex].imageUrl, result[itemIndex].isLogo),
          options: CarouselOptions(
              enlargeCenterPage: true,
              height: widget.height,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              pauseAutoPlayOnTouch: true,
              scrollDirection: Axis.horizontal),
        ),
      );
    } else {
      return Container(
        child: Center(
          child: Text('No Data Found'),
        ),
      );
    }
  }

  Widget imageUI(String url, bool isLogo) {
    return CachedNetworkImage(
      imageUrl: url != null ? url : Icons.warning,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
//            fit: isLogo ? BoxFit.none : BoxFit.cover,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        child: Center(
          child: SizedBox(
              height: 30.0, width: 30.0, child: CircularProgressIndicator()),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
