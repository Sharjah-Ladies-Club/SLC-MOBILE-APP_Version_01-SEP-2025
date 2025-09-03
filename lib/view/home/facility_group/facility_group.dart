import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/facility_group_response.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/home/facility/bloc/bloc.dart';
import 'package:slc/view/home/facility_group/bloc/bloc.dart';

int selectedIndex = 0;

class FacilityGroup extends StatelessWidget {
  final double height;

  const FacilityGroup({Key key, @required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _FacilityGroup(height);
  }
}

// ignore: must_be_immutable
class _FacilityGroup extends StatefulWidget {
  double height;

  _FacilityGroup(this.height);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FacilityPage(height);
  }
}

class _FacilityPage extends State<_FacilityGroup>
    with AutomaticKeepAliveClientMixin {
  double height;
  List<FacilityGroupResponse> facilityGroupList = [];

  _FacilityPage(this.height);

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return BlocListener<FacilityGroupBloc, FacilityGroupState>(
      listener: (context, state) {
        if (state is FacilityGroupLoaded) {
          BlocProvider.of<FacilityBloc>(context).add(RefreshFacility(
              selectedFacilityGroupId:
                  state.result[selectedIndex].facilityGroupId));
        } else if (state is RefreshFacilityGroupLoaded) {
          selectedIndex = 0;
          BlocProvider.of<FacilityBloc>(context).add(RefreshFacility(
              selectedFacilityGroupId:
                  state.result[selectedIndex].facilityGroupId));
        }
      },
      child: BlocBuilder<FacilityGroupBloc, FacilityGroupState>(
        builder: (context, state) {
          if (state is FacilityGroupLoaded) {
            //return facilityGroup(state.result);
            facilityGroupList = state.result;
          } else if (state is RefreshFacilityGroupLoaded) {
            facilityGroupList = state.result;
            //return facilityGroup(state.result);
          }
          return facilityGroup(facilityGroupList);
          //return Container();
        },
      ),
    );
  }

  Widget facilityGroup(List<FacilityGroupResponse> facilityGroupList) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 4.0),
            child: PackageListHead.homePageTitle(
              context,
              tr('services'),
            ),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    facilityGroupList != null ? facilityGroupList.length : 0,
                itemBuilder: (context, index) {
                  var selectedColor;
                  if (facilityGroupList[index].activeColorCode != null) {
                    String colorCode =
                        "0xFF" + facilityGroupList[index].activeColorCode;
                    selectedColor = int.parse(colorCode);
                  }

                  return GestureDetector(
                    onTap: () {
                      selectedIndex = index;
                      SPUtil.putInt(Constants.FACILITY_SELECTED_INDEX, 0);
                      setState(() {});
                      BlocProvider.of<FacilityBloc>(context).add(
                          FacilitySelected(
                              selectedFacilityGroupId:
                                  facilityGroupList[selectedIndex]
                                      .facilityGroupId));
                    },
                    child: Container(
//                      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                      padding: EdgeInsets.only(left: 10, right: 10, top: 2.0),
                      child: Column(
                        children: <Widget>[
                          AnimatedContainer(
                            width:
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? height * 0.55
                                    : height * 0.52,
                            height:
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? height * 0.55
                                    : height * 0.52,
                            duration: Duration(seconds: 1),
                            curve: Curves.ease,
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: index == selectedIndex
                                  ? Border.all(
                                      color: facilityGroupList[index]
                                                  .activeColorCode !=
                                              null
                                          ? Color(selectedColor)
                                          : Theme.of(context).primaryColor,
                                      width: 2)
                                  : Border.all(color: Colors.white, width: 0),
                            ),
                            child: index == selectedIndex
                                ? imageUI(
                                    facilityGroupList[index].activeImageURL)
                                : imageUI(
                                    facilityGroupList[index].inActiveImageURL),
                          ),
//                          Container(
//                              margin: EdgeInsets.only(left: 5.0, right: 5.0),
//                              padding: const EdgeInsets.only(top: 3.0),
//                              child: index == selectedIndex
//                                  ? PackageListHead
//                                      .facilityItemsSelectedListText(
//                                          context,
//                                          facilityGroupList[index]
//                                              .facilityGroupName)
//                                  : PackageListHead.facilityItemsListText(
//                                      context,
//                                      facilityGroupList[index]
//                                          .facilityGroupName)),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget imageUI(String url) {
    return CachedNetworkImage(
      imageUrl: url != null ? url : ImageData.slcLogImage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        child: Center(
          child: SizedBox(
              height: 15.0, width: 15.0, child: CircularProgressIndicator()),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
