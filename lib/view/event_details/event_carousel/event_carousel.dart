import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/event_detail_response.dart';
import 'package:slc/model/image_detail.dart';
import 'package:slc/view/event_details/event_carousel/bloc/bloc.dart';
import 'package:slc/view/event_details/event_detail_content/bloc/bloc.dart';

// ignore: must_be_immutable
class EventCarousel extends StatelessWidget {
  double height;

  EventCarousel({this.height});

  @override
  Widget build(BuildContext context) {
    return _EventCarousel(
      height: height,
    );
  }
}

// ignore: must_be_immutable
class _EventCarousel extends StatefulWidget {
  double height;

  _EventCarousel({this.height});

  @override
  State<StatefulWidget> createState() {
    return _EventCarouselPage();
  }
}

class _EventCarouselPage extends State<_EventCarousel> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCarouselBloc, EventCarouselState>(
      builder: (context, state) {
        if (state is LoadEventDetails) {
          BlocProvider.of<EventDetailContentBloc>(context)
            ..add(LoadEventDetailContentEvent(
                eventDetailResponse: state.eventDetailResponse));
          return mainUI(context, state.eventDetailResponse);
        }
        return Container();
      },
    );
  }

  Widget mainUI(BuildContext context, EventDetailResponse response) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          carouselUi(context, response.imageList),
          Align(
            alignment: Localizations.localeOf(context).languageCode == "en"
                ? Alignment.topLeft
                : Alignment.topRight,
            child: Padding(
              padding: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(left: 10, top: widget.height * 0.18)
                  : EdgeInsets.only(right: 10, top: widget.height * 0.18),
              child: GestureDetector(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: Localizations.localeOf(context).languageCode == "en"
                    ? EdgeInsets.only(left: 10, top: widget.height * 0.17)
                    : EdgeInsets.only(left: 10, top: widget.height * 0.17),
                child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      tr('events'),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: tr('currFontFamily')),
                    ))),
          ),
          Align(
            alignment: Localizations.localeOf(context).languageCode == "en"
                ? Alignment.topRight
                : Alignment.topLeft,
            child: response.webURL != null
                ? Padding(
                    padding: Localizations.localeOf(context).languageCode ==
                            "en"
                        ? EdgeInsets.only(right: 8, top: widget.height * 0.17)
                        : EdgeInsets.only(left: 8, top: widget.height * 0.17),
                    child: GestureDetector(
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Share.share(response.webURL, subject: response.name);
                        }),
                  )
                : Container(),
          ),
          Align(
            //  padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
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
    );
  }

  Widget carouselUi(BuildContext context, List<ImageDetails> result) {
    if (result != null && result.length > 0) {
      return Container(
        color: ColorData.whiteColor,
        padding: EdgeInsets.only(bottom: 2.0),
        child: CarouselSlider.builder(
          itemCount: result.length,
          itemBuilder: (BuildContext context, int itemIndex, int realIndex) =>
              imageUI(result[itemIndex].imageUrl),
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
//          onPageChaned: callbackFunction,
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

  Widget imageUI(String url) {
    return CachedNetworkImage(
      imageUrl: url != null ? url : Icons.warning,
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
}
