import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/RadioModel.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/facility_detail/facility_content/bloc/facility_content_bloc.dart';
import 'package:slc/view/facility_detail/facility_content/bloc/facility_content_event.dart';

FacilityDetailResponse response;

int selectedIndex = 0;
int currentSelected = 0;
var currentSelectedLabel;
var buttonLabels;

// ignore: must_be_immutable
class FacilityTabChoice extends StatelessWidget {
  List tablist;
  int menuId;
  FacilityDetailResponse facilityDetailResponse;
  Function tabClickCalbck;

  FacilityTabChoice(this.tablist, this.facilityDetailResponse, this.menuId,
      this.tabClickCalbck);

  @override
  Widget build(BuildContext context) {
    return _FacilityTabChoiceMenu(
        tablist, facilityDetailResponse, menuId, tabClickCalbck);
  }
}

// ignore: must_be_immutable
class _FacilityTabChoiceMenu extends StatefulWidget {
  List tablist;
  FacilityDetailResponse facilityDetailResponse;
  int menuId;
  Function tabClickCalbck;

//  double height;
  _FacilityTabChoiceMenu(this.tablist, this.facilityDetailResponse, this.menuId,
      this.tabClickCalbck);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return __FacilityTabChoiceMenuState(tablist, facilityDetailResponse);
  }
}

class __FacilityTabChoiceMenuState extends State<_FacilityTabChoiceMenu> {
  List tablist;
  FacilityDetailResponse facilityDetailResponse;

  __FacilityTabChoiceMenuState(this.tablist, this.facilityDetailResponse);

  @override
  void initState() {
    super.initState();
    initializeTab();
  }

  void initializeTab() {
    if (widget.menuId != null && widget.menuId >= 0) {
      for (int i = 0; i < tablist.length; i++) {
        if (widget.menuId == tablist[i].mobileCategoryId) {
          currentSelectedLabel = i;
          selectedIndex = i;
          currentSelected = i;
        }
      }
    } else {
      currentSelectedLabel = tablist[0];
      selectedIndex = 0;
      currentSelected = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: menuList(tablist));
  }

  Widget menuList(List<RadioModel> tabList) {
    if (SPUtil.getBool(Constants.REFRESH_FACILITYDETAILS)) {
      SPUtil.putBool(Constants.REFRESH_FACILITYDETAILS, false);
      initializeTab();
    }
    buttonLabels = tabList;
    currentSelectedLabel = tablist[currentSelected];

    // buttonValues = buttonLabels;

    BlocProvider.of<FacilityContentBloc>(context)
      ..add(FetchTabContent(
        tabId: tabList[selectedIndex].mobileCategoryId,
        tabName: tabList[selectedIndex].mobileCategoryName,
        tabType: tabList[selectedIndex].menuType,
        response: tabList[selectedIndex].response,
        // menuId : tabList[selectedIndex].mobileCategoryId
      ));

    var myColorInt;
    if (facilityDetailResponse.colorCode != null) {
      String colorCode = "0xFF" + facilityDetailResponse.colorCode;
      myColorInt = int.parse(colorCode);
    }

    return Container(
      margin: EdgeInsets.only(top: 7.0, bottom: 7.0),
      // padding: EdgeInsets.only(top: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
//        shrinkWrap: true,
        itemCount: tabList.length,
        itemBuilder: (BuildContext context, int index) {
          return Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                setState(() {
                  currentSelected = index;
                  currentSelectedLabel = buttonLabels[index];
                  tabList.forEach((element) => element.isSelected = false);
                  tabList[currentSelected].isSelected = true;
                  selectedIndex = currentSelected;
                  SPUtil.putInt(Constants.FACILITY_SELECTED_INDEX, index);
                });
              },
              child: Card(
                color: currentSelectedLabel == buttonLabels[index]
                    ? facilityDetailResponse.colorCode != null
                        ? Color(myColorInt)
                        : Theme.of(context).primaryColor
                    //Color.fromRGBO(14, 150, 119, 1)
                    : Colors.black12,
                elevation: 0,
                child: Container(
                  decoration: new BoxDecoration(
                    border: currentSelectedLabel == buttonLabels[index]
                        ? Border(
                            top: BorderSide(color: Color(myColorInt)),
                            bottom: BorderSide(color: Color(myColorInt)),
                            left: BorderSide(color: Color(myColorInt)),
                            right: BorderSide(color: Color(myColorInt)))
                        : Border(
                            top: BorderSide(color: Colors.black12),
                            bottom: BorderSide(color: Colors.black12),
                            left: BorderSide(color: Colors.black12),
                            right: BorderSide(color: Colors.black12)),
//                    color: ColorData
//                        .blackColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: MaterialButton(
//                    shape: OutlineInputBorder(
//                      borderSide: BorderSide(color: Colors.black12, width: 1),
//                      borderRadius: new BorderRadius.circular(0),
//                    ),
                    onPressed: () {
                      setState(() {
                        currentSelected = index;
                        currentSelectedLabel = buttonLabels[index];
                        tabList
                            .forEach((element) => element.isSelected = false);
                        tabList[currentSelected].isSelected = true;
                        selectedIndex = currentSelected;
                        SPUtil.putInt(Constants.FACILITY_SELECTED_INDEX, index);
                        widget.tabClickCalbck();
                      });
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: Text(
                          buttonLabels[index].mobileCategoryName.toString(),
                          style: TextStyle(
                            fontFamily: tr("currFontFamily"),
                            color: currentSelectedLabel == buttonLabels[index]
                                ? Colors.white
                                : ColorData.primaryTextColor,
//                                : Color.fromRGBO(83, 87, 90, 1),
                            // fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
