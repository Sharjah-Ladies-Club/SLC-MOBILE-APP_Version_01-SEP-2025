import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/event_review_question_details.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/view/event_specific_view/event_specific_view_content/bloc/event_review_write_content_bloc.dart';
import 'package:slc/view/event_specific_view/event_specific_view_content/bloc/event_review_write_content_event.dart';

import 'bloc/bloc.dart';

// ignore: must_be_immutable
class EventItemCarousal extends StatelessWidget {
  double height;

  EventItemCarousal({this.height});

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

  _EventItemCarousal({this.height});

  @override
  State<StatefulWidget> createState() {
    return _EventReviewCarousal();
  }
}

class _EventReviewCarousal extends State<_EventItemCarousal> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventReviewWriteCarousalBloc,
        EventReviewWriteCarousalState>(
      builder: (context, state) {
        if (state is OnQuestionLoadSuccessState) {
          BlocProvider.of<EventReviewWriteContentBloc>(context)
            ..add(OnQuestionSuccessEvent(
                eventReviewQuestion: state.eventReviewQuestion));

          return mainUI(context, state.eventReviewQuestion, widget);
        }
        return Container();
      },
    );
  }
}

mainUI(BuildContext context, EventReviewQuestion eventReviewQuestion, widget) {
  return Scaffold(
    body: SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          carouselUi(
              context,
              eventReviewQuestion != null
                  ? eventReviewQuestion.eventBasic.imageList != null
                      ? eventReviewQuestion.eventBasic.imageList
                      : []
                  : [],
              widget.height),
          Align(
            alignment: Localizations.localeOf(context).languageCode == "ar"
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Padding(
              padding: Localizations.localeOf(context).languageCode == "ar"
                  ? EdgeInsets.only(right: 10, top: widget.height * 0.17)
                  : EdgeInsets.only(left: 10, top: widget.height * 0.17),
              child: GestureDetector(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorData.whiteColor,
                ),
                onTap: () => Navigator.pop(context, 0),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: Localizations.localeOf(context).languageCode == "ar"
                    ? EdgeInsets.only(right: 10, top: widget.height * 0.12)
                    : EdgeInsets.only(left: 10, top: widget.height * 0.15),
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

Widget carouselUi(BuildContext context, List<ImageList> imageList, height) {
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
//  return CustomCachedImage(url);
  return CachedNetworkImage(
    imageUrl: url != null ? url : Icons.warning,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
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
