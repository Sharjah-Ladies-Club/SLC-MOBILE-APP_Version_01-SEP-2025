import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/carousel_response.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/event_details/event_details.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:slc/view/home/facility_group/bloc/bloc.dart';
import 'package:slc/view/web_view/notification_detail_webview.dart';

import 'bloc/bloc.dart';

class Carousel extends StatelessWidget {
  final double height;

  const Carousel({this.height});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarouselBloc, CarouselState>(
      listener: (context, state) {
        if (state is RefreshCarouselLoadedState) {
          BlocProvider.of<FacilityGroupBloc>(context)
            ..add(RefreshGetFacilityGroupList());
        }
      },
      child: BlocBuilder<CarouselBloc, CarouselState>(
        builder: (context, state) {
          if (state is CarouselLoadingState) {
            return Container();
          } else if (state is CarouselLoadedState) {
            return carouselUi(context, state.result);
          } else if (state is RefreshCarouselLoadedState) {
            return carouselUi(context, state.result);
          }
          return Container();
        },
      ),
    );
  }

  Widget carouselUi(BuildContext context, List<CarouselResponse> result) {
    if (result != null && result.length > 0) {
      return Container(
        height: height,
        width: MediaQuery.of(context).size.width,
        child: CarouselSlider.builder(
          itemCount: result.length,
          itemBuilder: (BuildContext context, int itemIndex, int realIndex) =>
              showCarouselItem(result[itemIndex], context),
          options: CarouselOptions(
              aspectRatio: 16 / 9,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              pauseAutoPlayOnTouch: true,
              enlargeCenterPage: true,
//          onPageChanged: callbackFunction,
              scrollDirection: Axis.horizontal),
        ),
      );
    } else {
      return Container(
        child: Center(
            child: Text(tr("noDataFound"),
                style: TextStyle(
                    color: ColorData.primaryTextColor,
                    fontFamily: tr("currFontFamily")))),
      );
    }
  }

  Widget showCarouselItem(CarouselResponse response, BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Container(
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
              child: Stack(
                children: <Widget>[
                  imageUI(response.imageURL),
                  response.hasNavigation
                      ? Align(
                          alignment:
                              Localizations.localeOf(context).languageCode ==
                                      "ar"
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 10.0,
                                left: (Localizations.localeOf(context)
                                            .languageCode ==
                                        "en")
                                    ? 10.0
                                    : 0.0,
                                right: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? 0.0
                                    : 10.0),
                            child: Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1.0, color: Colors.white70),
                                color: Colors.black45,
                              ),
                              constraints: BoxConstraints(
                                  minWidth: 35,
                                  minHeight: 35,
                                  maxHeight: 35,
                                  maxWidth: 35),
                              child: Center(
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color: ColorData.primaryColor,
                                  size: 17,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              )),
        ),
      ),
      onTap: () {
        if (response.hasNavigation) {
          if (response.navigationTypeId == Constants.CarouselInsideNavigation) {
            if (!response.hasEventNavigation && response.facilityId != null) {
              SPUtil.putInt(Constants.FACILITY_SELECTED_INDEX, 0);

              if (response.mobileCategoryId == null &&
                  response.mobileItemGroupId == null) {
                Navigator.push(context, new MaterialPageRoute(
                  builder: (context) {
                    // Dashboard(analytics, observer),
                    return FacilityDetailsPage(
                      facilityId: response.facilityId,
                    );
                  },
                ));
              } else if (response.mobileCategoryId != null &&
                  response.mobileItemGroupId == null) {
                Navigator.push(context, new MaterialPageRoute(
                  builder: (context) {
                    // Dashboard(analytics, observer),
                    return FacilityDetailsPage(
                      facilityId: response.facilityId,
                      menuId: response.mobileCategoryId,
                    );
                  },
                ));
              } else if (response.mobileCategoryId != null &&
                  response.mobileItemGroupId != null) {
                Navigator.push(context, new MaterialPageRoute(
                  builder: (context) {
                    // Dashboard(analytics, observer),
                    return FacilityDetailsPage(
                      facilityId: response.facilityId,
                      menuId: response.mobileCategoryId,
                      listId: response.mobileItemGroupId,
                    );
                  },
                ));
                print('touched position ${response.toJson()}');
              }
            } else if (response.hasEventNavigation &&
                response.eventId != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return EventDetails(eventId: response.eventId);
                  },
                ),
              );
            }
          } else if (response.navigationTypeId ==
              Constants.CarouselOutsideNavigation) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return NotificationWebView(
                      Constants.CarouselNavigationTitle, response.webUrl);
                },
              ),
            );
          }
        }

//
      },
    );
  }

  Widget imageUI(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
