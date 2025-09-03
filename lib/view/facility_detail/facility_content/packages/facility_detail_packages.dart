import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/expansiontile/expan_collapse.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/view/facility_detail/bloc/facility_detail_bloc.dart';

import 'bloc/bloc.dart';

// ignore: must_be_immutable
class FacilityDetailPackages extends StatelessWidget {
  int facilityId, facilityTabId;
  FacilityDetailBloc facilityDetailBloc;
  Key key;
  String colorCode;
  int listId = -1;
  int menuId = -1;

  FacilityDetailPackages(
      {this.key,
      this.facilityId,
      this.facilityTabId,
      this.facilityDetailBloc,
      this.colorCode,
      this.listId,
      this.menuId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FacilityDetailPackagesBloc>(
      create: (context) => FacilityDetailPackagesBloc(
          facilityDetailBloc: facilityDetailBloc,
          facilityDetailRepository: FacilityDetailRepository())
        ..add(GetFacilityServiceDetails(
            facilityId: facilityId, facilityMenuId: facilityTabId)),
      child: Packages(
        colorCode: this.colorCode,
        listId: this.listId,
        menuId: this.menuId,
        facilityId: this.facilityId,
      ),
    );
//    return Services();
  }
}

// ignore: must_be_immutable
class Packages extends StatefulWidget {
  String colorCode;
  int facilityId;
  int listId = -1;
  int menuId = -1;

  Packages({this.colorCode, this.listId, this.menuId, this.facilityId});

  @override
  State<StatefulWidget> createState() {
    return PackagesState();
  }
}

class PackagesState extends State<Packages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorData.backgroundColor,
      body:
          BlocBuilder<FacilityDetailPackagesBloc, FacilityDetailPackagesState>(
        builder: (context, state) {
          if (state is LoadingFacilityService) {
            return Container();
          } else if (state is LoadedFacilityService) {
            int listIndex = -1;
            for (var l = 0; l < state.facilityItemList.length; l++) {
              if (widget.listId == -1) {
                break;
              } else if (widget.listId ==
                  state.facilityItemList[l].facilityItemGroupId) {
                listIndex = l;
              }
            }
            return CustomExpandTile(
              facilityItemList: state.facilityItemList,
              colorCode: widget.colorCode,
              listIndex: listIndex,
              facilityId: widget.facilityId,
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.listId = -1;
    super.dispose();
  }
}
