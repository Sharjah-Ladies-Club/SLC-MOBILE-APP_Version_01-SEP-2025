import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/RadioModel.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/events/event_tab_choice/bloc/bloc.dart';
import 'package:slc/view/events/events.dart';
import 'package:slc/view/events/tab_content/bloc/bloc.dart';

int selectedIndex = 0;

int currentSelected = 0;
var currentSelectedLabel;
var buttonLabels = tabHeader;

//var buttonValues = buttonLabels;

// ignore: must_be_immutable
class EventTab extends StatelessWidget {
  double tabContentWidth;

  EventTab(this.tabContentWidth);

  @override
  Widget build(BuildContext context) {
    return TabChoiceChip(tabContentWidth);
  }
}

// ignore: must_be_immutable
class TabChoiceChip extends StatefulWidget {
  double tabContentWidth;

  TabChoiceChip(this.tabContentWidth);

  @override
  State<StatefulWidget> createState() {
    return _TabChoiceChip();
  }
}

class _TabChoiceChip extends State<TabChoiceChip>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      if (!SPUtil.getBool(Constants.IS_SILENT_NOTIFICATION_CALLED_FOR_EVENT)) {
        if (Constants.eventsCurrentSelectedChoiseChip == 0) {
          currentSelectedLabel = buttonLabels[0];
          BlocProvider.of<TabContentBloc>(context).add(GetEventList());
        } else {
          currentSelectedLabel = buttonLabels[1];
          BlocProvider.of<TabContentBloc>(context).add(GetReviewList());
        }
      } else {
        BlocProvider.of<TabContentBloc>(context)
            .add(GetSilentRefreshEventList());
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    currentSelected = 0;
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return BlocListener<TabChoiceChipBloc, TabChoiceChipState>(
      listener: (context, state) {
        if (state is ShowEventNewTabHeader) {
          currentSelectedLabel = buttonLabels[0];
          BlocProvider.of<TabContentBloc>(context).add(GetEventList());
        } else if (state is ShowRefreshEventTabState) {
          BlocProvider.of<TabContentBloc>(context)
              .add(RefreshShowProgressBar());
//          if (currentSelectedLabel == buttonLabels[0]) {
          if (Constants.eventsCurrentSelectedChoiseChip == 0) {
            BlocProvider.of<TabContentBloc>(context).add(GetRefreshEventList());
          } else {
            BlocProvider.of<TabContentBloc>(context)
                .add(GetRefreshReviewList());
          }
        } else if (state is ShowSilentRefreshEventTabState) {
//          if (currentSelectedLabel == buttonLabels[0]) {
          if (Constants.eventsCurrentSelectedChoiseChip == 0) {
            BlocProvider.of<TabContentBloc>(context)
                .add(GetSilentRefreshEventList());
          } else {
            BlocProvider.of<TabContentBloc>(context)
                .add(GetSilentRefreshReviewList());
          }
        }
      },
      child: BlocBuilder<TabChoiceChipBloc, TabChoiceChipState>(
        builder: (context, state) {
          if (state is ShowEventNewTabState) {
            return tabUI(state.tab);
          } else if (state is ShowRefreshEventTabState) {
            return tabUI(state.tab);
          } else if (state is ShowSilentRefreshEventTabState) {
            return tabUI(state.tab);
          }
          return Container();
        },
      ),
    );
  }

  Widget tabUI(List<RadioModel> tabHeader) {
//    return Container(
//     // height: 50.0,
//      child: ListView.builder(
//        scrollDirection: Axis.horizontal,
//        itemCount: tabHeader.length,
//        itemBuilder: (BuildContext context, int index) {
//          return new InkWell(
//            onTap: () {
//              if (tabHeader[index].mobileCategoryName ==
//                  tr('seeAll')) {
//                BlocProvider.of<TabContentBloc>(context).add(GetEventList());
//               } else if (tabHeader[index].mobileCategoryName ==
//                   tr('reviews')) {
//                 BlocProvider.of<TabContentBloc>(context).add(GetReviewList());
//              }
//              setState(() {
//                tabHeader.forEach((element) => element.isSelected = false);
//                tabHeader[index].isSelected = true;
//                selectedIndex = index;
//              });
//            },
//            child: Container(
//              child: new RadioItem(tabHeader[index], index),
//              width: (MediaQuery.of(context).size.width / 2 - 8),
//        //   width: (MediaQuery.of(context).size.width / 1 - 8),
//
//            ),
//          );
//        },
//      ),
//    );

    return customButton();
  }

  Widget customButton() {
    return Center(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: buttonLabels.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
//            color: currentSelectedLabel == buttonLabels[index]
            color: Constants.eventsCurrentSelectedChoiseChip == index
                ? Theme.of(context).primaryColor
                //Color.fromRGBO(14, 150, 119, 1)
                : Colors.black12,
            elevation: 0,
            child: Container(
              width: (MediaQuery.of(context).size.width / 2 - 16),
              decoration: BoxDecoration(
                border: currentSelectedLabel == buttonLabels[index]
                    ? Border(
                        top: BorderSide(color: Theme.of(context).primaryColor),
                        bottom:
                            BorderSide(color: Theme.of(context).primaryColor),
                        left: BorderSide(color: Theme.of(context).primaryColor),
                        right:
                            BorderSide(color: Theme.of(context).primaryColor))
                    : Border(
                        top: BorderSide(color: Colors.black12),
                        bottom: BorderSide(color: Colors.black12),
                        left: BorderSide(color: Colors.black12),
                        right: BorderSide(color: Colors.black12)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: MaterialButton(
//                shape: OutlineInputBorder(
////                  borderSide: currentSelectedLabel == buttonLabels[index]
//                  borderSide: Constants.eventsCurrentSelectedChoiseChip == index
//                      ? BorderSide(color: Colors.black12, width: 1)
//                      : BorderSide(color: Colors.black26, width: 1),
//                  borderRadius: BorderRadius.zero,
//                ),

                onPressed: () {
                  if (tabHeader[index].mobileCategoryName == 'events') {
                    BlocProvider.of<TabContentBloc>(context)
                        .add(GetEventList());
                  } else if (tabHeader[index].mobileCategoryName == 'reviews') {
                    BlocProvider.of<TabContentBloc>(context)
                        .add(GetReviewList());
                  }
                  setState(() {
                    tabHeader.forEach((element) => element.isSelected = false);
//                    currentSelected = index;
                    Constants.eventsCurrentSelectedChoiseChip = index;
                    tabHeader[index].isSelected = true;
                    currentSelectedLabel = buttonLabels[index];
                  });
                  setState(() {});
                },
                child: Text(
                  buttonLabels[index].mobileCategoryName.tr(),
                  style: TextStyle(
                    color: Constants.eventsCurrentSelectedChoiseChip == index
//                    color: currentSelectedLabel == buttonLabels[index]
                        ? Colors.white
                        : ColorData.primaryTextColor,
//                        : Color.fromRGBO(83, 87, 90, 1),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
