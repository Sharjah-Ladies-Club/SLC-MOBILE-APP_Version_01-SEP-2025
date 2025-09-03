import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/review_details.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/view/events/tab_content/event_review_details/event_review_detail_content/bloc/event_review_detail_content_bloc.dart';
import 'package:slc/view/events/tab_content/event_review_details/event_review_detail_content/bloc/event_review_detail_content_event.dart';

import 'bloc/event_review_detail_carousal_bloc.dart';
import 'bloc/event_review_detail_carousal_state.dart';

// ignore: must_be_immutable
class EventReviewDetailsCarousal extends StatelessWidget {
  double height;
  ReviewDetails reviewDetails;

  EventReviewDetailsCarousal({this.height, this.reviewDetails});

  @override
  Widget build(BuildContext context) {
    return _EventItemCarousal(
      height: height,
    );
  }
}

// ignore: must_be_immutable
class _EventItemCarousal extends StatefulWidget {
  double height;
  ReviewDetails reviewDetails;

  _EventItemCarousal({this.height, this.reviewDetails});

  State<StatefulWidget> createState() {
    return _EventReviewCarousal(
        height: this.height, reviewDetails: this.reviewDetails);
  }
}

class _EventReviewCarousal extends State<_EventItemCarousal> {
  ReviewDetails reviewDetails;
  double height;

  _EventReviewCarousal({this.height, this.reviewDetails});

  Widget build(BuildContext context) {
    return BlocBuilder<EventReviewDetailsCarousalBloc,
        EventReviewDetailCarousalState>(
      builder: (context, state) {
        if (state is OnEventReviewListLoadSuccessState) {
          reviewDetails = state.reviewDetails;
          BlocProvider.of<EventReviewDetailContentBloc>(context)
            ..add(
                OnReviewDetailSuccessEvent(reviewDetails: state.reviewDetails));

          return mainUI(context, height);
        }
        return Container();
      },
    );
  }

  mainUI(BuildContext context, double height) {
    return Scaffold(
      body: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            carouselUi(
                context,
                reviewDetails != null
                    ? reviewDetails.eventBasicDetail.imageList != null
                        ? reviewDetails.eventBasicDetail.imageList
                        : []
                    : [],
                height),
            Align(
              alignment: Localizations.localeOf(context).languageCode == "ar"
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: Padding(
                padding: Localizations.localeOf(context).languageCode == "ar"
                    ? EdgeInsets.only(right: 10, top: height * 0.17)
                    : EdgeInsets.only(left: 10, top: height * 0.17),
                child: GestureDetector(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorData.whiteColor,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: Localizations.localeOf(context).languageCode == "ar"
                      ? EdgeInsets.only(right: 10, top: height * 0.12)
                      : EdgeInsets.only(left: 10, top: height * 0.15),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: PackageListHead.homePageTitleFontTextStyle(
                        context, tr("review")),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 30.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.white, Colors.white])),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget carouselUi(
      BuildContext context, List<ReviewDetailImageList> imageList, height) {
    if (imageList != null && imageList.length > 0) {
      return Container(
        color: ColorData.whiteColor,
        padding: EdgeInsets.only(bottom: 2.0),
        child: CarouselSlider.builder(
          itemCount: imageList.length,
          itemBuilder: (BuildContext context, int itemIndex, int realIndex) =>
              imageUI(imageList[itemIndex].imageUrl),
          options: CarouselOptions(
              enlargeCenterPage: true,
              height: height,
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
        color: ColorData.whiteColor,
        child: Center(
          child: Image.asset(
            'assets/images/ic_launcher.png',
          ),
        ),
      );
    }
  }

  Widget imageUI(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
//              colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
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
//  Widget imageUI(String url) {
//    return CustomCachedImage(url);
//  }
}
