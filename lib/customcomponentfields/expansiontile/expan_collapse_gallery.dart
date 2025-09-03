import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/facility_detail_item_gallery_response.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/view/facility_detail/facility_content/gallery/facility_carousel_slider.dart';

import 'groovenexpan.dart';

// ignore: must_be_immutable
class CustomExpandGalleryTile extends StatefulWidget {
  String title, colorCode;
  List<FacilityGalleryDetail> facilityGalleryDetail;

  CustomExpandGalleryTile(
      {Key key, this.facilityGalleryDetail, this.title, this.colorCode})
      : super(key: key);

  @override
  _CustomExpandGalleryTileState createState() =>
      _CustomExpandGalleryTileState();
}

class _CustomExpandGalleryTileState extends State<CustomExpandGalleryTile> {
  int selectedIndex = -1;
  int selectedHeadIndex = -1;

  bool isExpanded = false;
  bool isMainExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(child: getView());
  }

  Widget getView() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 3;
    final double itemWidth = size.width / 2;

    return Container(
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.facilityGalleryDetail.length,
        // shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, i) {
          return Card(
            color: Colors.white,
            elevation: isExpanded && selectedIndex == i ? 5.0 : 0.0,
            child: GroovinExpansionTile(
              btnIndex: i,
              selectedIndex: selectedIndex,
              onTap: (isExpanded, btnIndex) {
                updateSelectedIndex(btnIndex);
              },
              onExpansionChanged: (val) {
                setState(() {
                  isExpanded = val;
                });
              },
              defaultTrailingIconColor: isExpanded && selectedIndex == i
                  ? ColorData.toColor(widget.colorCode)
                  : Colors.grey,
              title: PackageListHead.facilityExpandTileTextStyle(
                  context,
                  1.0,
                  Localizations.localeOf(context).languageCode == "en"
                      ? widget.facilityGalleryDetail[i].facilityGalleryTypeName
                          .trim()
                      : widget.facilityGalleryDetail[i]
                          .facilityGalleryTypeNameArabic
                          .trim(),
                  ColorData.toColor(widget.colorCode),
                  isExpanded && selectedIndex == i),
              children: <Widget>[
                Container(
                  child: NestedScrollViewInnerScrollPositionKeyWidget(
                    Key("gallery_grid"),
                    GridView.count(
                      shrinkWrap: true,
                      controller: ScrollController(),
                      crossAxisCount: 3,
                      childAspectRatio: (itemWidth / itemHeight),
                      children: List.generate(
                          widget.facilityGalleryDetail[i].imageList.length,
                          (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.push(context, new MaterialPageRoute(
                                builder: (context) {
                                  return FacilityGridCarousel(
                                      index,
                                      widget.facilityGalleryDetail[i].imageList,
                                      widget.title,
                                      widget.facilityGalleryDetail[i]
                                          .facilityGalleryTypeName
                                          .trim());
                                },
                              ));
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: imageUI(widget.facilityGalleryDetail[i]
                                .imageList[index].imageUrl),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget imageUI(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
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

  void updateSelectedIndex(btnIndex) {
    setState(() {
      selectedIndex = btnIndex;
      isExpanded = false;
    });
  }

  updateHeadSelectedIndex(btnHeadIndex) {
    setState(() {
      selectedHeadIndex = btnHeadIndex;
      isMainExpanded = false;
    });
  }
}
