import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/model/image_detail.dart';

// ignore: must_be_immutable
class FacilityGridCarousel extends StatefulWidget {
  int index;
  List<ImageDetails> imgList;
  String facilityTabTitle, facilityItemTitle;

  FacilityGridCarousel(
      this.index, this.imgList, this.facilityTabTitle, this.facilityItemTitle);

  @override
  _FacilityGridCarouselState createState() => _FacilityGridCarouselState();
}

class _FacilityGridCarouselState extends State<FacilityGridCarousel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorData.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: SafeArea(
          child: CustomAppBar(
            title: widget.facilityTabTitle,
          ),
        ),
      ),
      body: Hero(
        tag: "Image" + widget.index.toString(),
        child: Material(child: Center(child: getCarouselImage())),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                widget.facilityItemTitle,
                style: TextStyle(
                    color: ColorData.accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: tr('currFontFamily')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCarouselImage() {
    return new Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: CarouselSlider.builder(
          options: CarouselOptions(
              enableInfiniteScroll: true,
              autoPlay: false,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: widget.index,
              reverse: false,
              enlargeCenterPage: true,
              height: MediaQuery.of(context).size.height * 0.8),
          itemCount: widget.imgList.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Image.network(
                  widget.imgList[index].imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ));
  }
}
