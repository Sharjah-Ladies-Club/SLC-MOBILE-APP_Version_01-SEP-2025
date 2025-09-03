import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_response.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/Retail/Retail_Page.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:slc/view/healthnbeauty/healthnbeauty.dart';
import 'package:slc/view/home/facility/bloc/bloc.dart';
import 'package:slc/view/retail_cart/Retail_Cart_Page.dart';

class Facility extends StatelessWidget {
  final double height;
  const Facility({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<FacilityBloc, FacilityState>(
      builder: (context, state) {
        if (state is FacilityLoadingState) {
          return Container();
        } else if (state is FacilityLoadedState) {
          return facilityCategories(state.facilityResponseList, context);
        } else if (state is FacilityOnFailure) {
          return Container(
            child: Center(
              child: Text(state.error),
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget facilityCategories(
      List<FacilityResponse> facilityResponseList, context) {
    return (facilityResponseList != null && facilityResponseList.length > 0)
        ? Stack(children: [
            Container(
              height: height,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    // crossAxisAlignment: ,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding:
//                      EdgeInsets.only(left: 4.0, top: 5.0, bottom: 10.0),
                            EdgeInsets.only(left: 4.0, top: 3.0, bottom: 5.0),
                        child:
                            //Text(
                            // facilityResponseList[0].facilityGroupName,
                            //  style:
                            PackageListHead.homePageTitle(
                          context,
                          (facilityResponseList != null &&
                                  facilityResponseList.length > 0)
                              ? facilityResponseList[0].facilityGroupName
                              : '',
                        ),
                        // ),
                      ),
                      (facilityResponseList != null &&
                              facilityResponseList.length > 0)
                          ? GestureDetector(
                              onTap: () => {
                                Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) {
                                    // Dashboard(analytics, observer),
                                    return Healthnbeauty(
                                        facilityResponseList[0]
                                            .facilityGroupName,
                                        facilityResponseList,
                                        false);
                                  },
                                ))
                              },
                              child: PackageListHead.morePageTextStyle(
                                  context, 'seeAll'),
                            )
                          : Container(),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (facilityResponseList != null &&
                              facilityResponseList.length > 0)
                          ? facilityResponseList.length
                          : 0,
                      itemBuilder: (context, index) {
                        return facilityCategoriesItems(
                            facilityResponseList[index], index, context);
                      },
                    ),
                  )
                ],
              ),
            ),
            Visibility(
                visible: (facilityResponseList != null &&
                        facilityResponseList.length > 0 &&
                        facilityResponseList[0].facilityGroupId == 2)
                    ? true
                    : false,
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.26),
                    child: ElevatedButton(
                      child: Text(
                        tr("scan"),
                        style: TextStyle(color: Colors.white),
                      ),
                      // color: ColorData.colorBlue,
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorData.colorBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          )))),
                      onPressed: () async {
                        Utils util = new Utils();
                        CheckDistance withIn = await util.getLoc(context);
                        if (!withIn.allow) {
                          util.customGetSnackBarWithOutActionButton(
                              tr('info_msg'),
                              tr("youare") +
                                  withIn.distance.toStringAsFixed(2) +
                                  tr("from_beach"),
                              context);
                          //return;
                        }

                        displayDiscountModalBottomSheet(
                            facilityResponseList, context);
                      },
                    ))),
          ])
        : Container(
            child: Center(
              child: Text(tr("noDataFound"),
                  style: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontFamily: tr("currFontFamily"))),
            ),
          );
  }

  Widget facilityCategoriesItems(
      FacilityResponse response, int index, BuildContext context) {
    return SizedBox(
        width: 150,
        child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
          child: GestureDetector(
            onTap: () => {
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) {
                  // Dashboard(analytics, observer),
                  return FacilityDetailsPage(
                    facilityId: response.facilityId,
                    isClosed: response.isClosed,
                  );
                },
              )),
//              FacilityDetailRepository().getFacilityDetails(response.facilityId)
            },
            child: Stack(
              children: <Widget>[
                imageUI(response.facilityImageURL),
                Visibility(
                    visible:
                        response.facilityId == 1 || response.facilityId == 2
                            ? false
                            : false,
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.23),
                        child: ElevatedButton(
                          child: Text(
                            "Shop",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  ColorData.colorBlue),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              )))),
                          // color: ColorData.colorBlue,
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RetailCartPage(
                                        facilityId: response.facilityId,
                                        retailItemSetId: 0,
                                        facilityItems: [],
                                        colorCode: "",
                                      )),
                            );
                          },
                        ))),
              ],
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

  void displayDiscountModalBottomSheet(
      List<FacilityResponse> response, context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return new Container(
            padding: EdgeInsets.only(top: 10),
            decoration: new BoxDecoration(
                color: Colors.transparent,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    topRight: const Radius.circular(8.0))),
            constraints: BoxConstraints(minHeight: 300),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(8.0),
                      topRight: const Radius.circular(8.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        debugPrint("ssssssssssssssssssssssss" +
                            response[0].isClosed.toString() +
                            response[0].facilityId.toString());
                        if (!response[0].isClosed) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RetailPage(
                                      facilityId: 0,
                                      retailItemSetId: "100004",
                                      facilityItems: [],
                                      colorCode: null,
                                    )),
                          );
                        } else {
                          Utils util = new Utils();
                          util.customGetSnackBarWithOutActionButton(
                              tr("shopclosed"), tr("shopmaintenance"), context);
                        }
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.40,
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: imageUI(
                            (response[0].facilityOrderImageURL == "" ||
                                    response[0].facilityOrderImageURL == null)
                                ? response[0].facilityImageURL
                                : response[0].facilityOrderImageURL),
                      )),
                  // Visibility(
                  //     visible: !response[1].isClosed,
                  //     child: InkWell(
                  //         onTap: () {
                  //           debugPrint("DDDDDD" +
                  //               response[1].isClosed.toString() +
                  //               response[1].facilityId.toString());
                  //           if (!response[1].isClosed) {
                  //             Navigator.pop(context);
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => RetailPage(
                  //                         facilityId: 0,
                  //                         retailItemSetId: "100005",
                  //                         facilityItems: [],
                  //                         colorCode: null,
                  //                       )),
                  //             );
                  //           } else {
                  //             Utils util = new Utils();
                  //             util.customGetSnackBarWithOutActionButton(
                  //                 tr("shopclosed"),
                  //                 tr("shopmaintenance"),
                  //                 context);
                  //           }
                  //         },
                  //         child: SizedBox(
                  //           height: MediaQuery.of(context).size.height * 0.40,
                  //           width: MediaQuery.of(context).size.width * 0.45,
                  //           child: imageUI((response[1].facilityOrderImageURL ==
                  //                       "" ||
                  //                   response[1].facilityOrderImageURL == null)
                  //               ? response[1].facilityImageURL
                  //               : response[1].facilityOrderImageURL),
                  //         ))),
                ],
              ),
            ),
          );
        });
  }
  // Future<CheckDistance> getLoc(context) async {
  //   LocationData _currentPosition;
  //   Location location = Location();
  //
  //   // double slatitude = 25.378267;
  //   // double slongitude = 55.395315;
  //
  //   double slatitude = 25.3782582;
  //   double slongitude = 55.3952436;
  //
  //   await new CustomPermissionHandler(context)
  //       .requestPermission(PermissionGroup.location);
  //   _currentPosition = await location.getLocation();
  //   if (_currentPosition != null) {
  //     //debugPrint("Current Pos" + _currentPosition.toString());
  //     return checkDistance(_currentPosition.latitude,
  //         _currentPosition.longitude, slatitude, slongitude, 0.16277);
  //   }
  //   CheckDistance nd = CheckDistance();
  //   nd.allow = false;
  //   nd.distance = 0;
  //   return nd;
  // }

  // double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
  //   var R = 6371; // Radius of the earth in km
  //   var dLat = deg2rad(lat2 - lat1); // deg2rad below
  //   var dLon = deg2rad(lon2 - lon1);
  //   var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
  //       math.cos(deg2rad(lat1)) *
  //           math.cos(deg2rad(lat2)) *
  //           math.sin(dLon / 2) *
  //           math.sin(dLon / 2);
  //   var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  //   var d = R * c; // Distance in km
  //   return d;
  // }

  // double deg2rad(deg) {
  //   return deg * (math.pi / 180);
  // }

  // CheckDistance checkDistance(double latitude, double longitude, double srcLat,
  //     double srcLong, double distance) {
  //   CheckDistance dist = new CheckDistance();
  //   double lat_v = srcLat;
  //   double long_v = srcLong;
  //   double dis = getDistanceFromLatLonInKm(lat_v, long_v, latitude, longitude);
  //   dist.distance = dis;
  //   if (distance > dis) {
  //     dist.allow = true;
  //   } else {
  //     dist.allow = false;
  //   }
  //   return dist;
  // }
}
