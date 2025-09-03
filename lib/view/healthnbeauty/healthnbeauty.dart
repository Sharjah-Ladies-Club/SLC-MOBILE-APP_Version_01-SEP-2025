import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/model/facility_response.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:slc/view/retail_cart/Retail_Cart_Page.dart';
import 'package:slc/view/retail_cart/Gift_Card_Page.dart';

// ignore: must_be_immutable
class Healthnbeauty extends StatefulWidget {
  String appBarTitle;
  List<FacilityResponse> facilityResponseList;
  bool shop = false;
  Healthnbeauty(this.appBarTitle, this.facilityResponseList, this.shop);

  @override
  _HealthnbeautyState createState() => _HealthnbeautyState();
}

class _HealthnbeautyState extends State<Healthnbeauty> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(63.0),
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: widget.shop ? tr("shoppingCart") : widget.appBarTitle,
            ),
          ],
        ),
      ),
      backgroundColor: ColorData.whiteColor,
      body:
          // new GridView.count(
          //   crossAxisCount: 2,
          //   mainAxisSpacing: 4.0,
          //   crossAxisSpacing: 4.0,
          //   padding: const EdgeInsets.all(0.0),
          // ),
          Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/main_bg.png"),
                fit: BoxFit.cover)),
        child: Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: GridView(
            scrollDirection: Axis.vertical,
            controller: ScrollController(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 0.9, maxCrossAxisExtent: 300.0),
            children:
                List.generate(widget.facilityResponseList.length, (index) {
              return GestureDetector(
                onTap: () {
                  // print("coming in ********************************" +
                  //     widget.facilityResponseList[index].isClosed.toString());
                  if (widget.shop &&
                      widget.facilityResponseList[index].isClosed) {
                  } else {
                    if (widget.shop) {
                      Navigator.pop(context);
                    }
                    Navigator.push(context, new MaterialPageRoute(
                      builder: (context) {
                        // Dashboard(analytics, observer),
                        if (widget.shop) {
                          if (widget.facilityResponseList[index].facilityId ==
                              Constants.FacilityMembership) {
                            return GiftCardPage(
                              facilityId:
                                  widget.facilityResponseList[index].facilityId,
                              colorCode:
                                  widget.facilityResponseList[index].colorCode,
                            );
                          } else {
                            return RetailCartPage(
                              facilityId:
                                  widget.facilityResponseList[index].facilityId,
                              retailItemSetId: 0,
                              facilityItems: [],
                              colorCode:
                                  widget.facilityResponseList[index].colorCode,
                            );
                          }
                        } else {
                          return FacilityDetailsPage(
                            facilityId:
                                widget.facilityResponseList[index].facilityId,
                          );
                        }
                      },
                    ));
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10.0, top: 10.0),

                  child: Center(
                    child: GridTile(
                      child: imageUI(
                          widget.facilityResponseList[index].facilityImageURL),
                    ),
                  ),
                  // color: Colors.blue[400],
                  margin: EdgeInsets.all(1.0),
                ),
              );
            }),
          ),
        ),
      ),
    ));
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
}
