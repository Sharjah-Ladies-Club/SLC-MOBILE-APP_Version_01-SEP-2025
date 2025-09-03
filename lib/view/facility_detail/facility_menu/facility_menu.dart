import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/view/facility_detail/facility_menu/bloc/bloc.dart';
import 'grouped_tab_choice.dart';

FacilityDetailResponse response;
int selectedIndex = 0;
int currentSelected = 0;
var currentSelectedLabel;
var buttonLabels;
var buttonValues = buttonLabels;

// ignore: must_be_immutable
class FacilityMenu extends StatelessWidget {
  double height;
  int menuId;
  Function tabClickCalbck;

  FacilityMenu(this.height, this.menuId, this.tabClickCalbck);

  @override
  Widget build(BuildContext context) {
    return _FacilityMenu(height, menuId, tabClickCalbck);
  }
}

// ignore: must_be_immutable
class _FacilityMenu extends StatefulWidget {
  double height;
  int menuId;
  Function tabClickCalbck;

  _FacilityMenu(this.height, this.menuId, this.tabClickCalbck);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChoiceChipScreenState();
  }
}

class _ChoiceChipScreenState extends State<_FacilityMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    Constants.REFRESH_HOMEPAGE

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<FacilityMenuBloc, FacilityMenuState>(
        builder: (context, state) {
          if (state is PopulateMenu) {
            return Container(
                margin: EdgeInsets.only(left: 10.0, right: 20.0),
                child: FacilityTabChoice(
                    state.tabList, state.facilityDetailResponse, widget.menuId,
                    () {
                  widget.tabClickCalbck();
                }));
          } else if (state is RePopulateMenu) {
            return Container(
                margin: EdgeInsets.only(left: 10.0, right: 20.0),
                child: FacilityTabChoice(
                    state.tabList, state.facilityDetailResponse, widget.menuId,
                    () {
                  widget.tabClickCalbck();
                }));
          }
          return Container();
        },
      ),
    );
  }
}
