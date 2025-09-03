import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/expansiontile/expan_collapse_gallery.dart';
import 'package:slc/view/facility_detail/bloc/bloc.dart';
import 'package:slc/view/facility_detail/facility_content/gallery/bloc/bloc.dart';

// ignore: must_be_immutable
class FacilityDetailGallery extends StatelessWidget {
  int facilityId, facilityTabId;
  String title, colorCode;
  FacilityDetailBloc facilityDetailBloc;

  FacilityDetailGallery(
      {this.facilityId,
      this.facilityTabId,
      this.facilityDetailBloc,
      this.title,
      this.colorCode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FacilityDetailGalleryBloc>(
      create: (context) =>
          FacilityDetailGalleryBloc(facilityDetailBloc: facilityDetailBloc)
            ..add(GetFacilityGalleryDetails(
                facilityId: facilityId, facilityMenuId: facilityTabId)),
      child: Gallery(
        title,
        colorCode: this.colorCode,
      ),
    );
  }
}

// ignore: must_be_immutable
class Gallery extends StatefulWidget {
  String title, colorCode;

  Gallery(this.title, {this.colorCode});

  @override
  State<StatefulWidget> createState() {
    return GalleryState();
  }
}

class GalleryState extends State<Gallery> {
  GalleryState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorData.backgroundColor,
      body: BlocBuilder<FacilityDetailGalleryBloc, FacilityDetailGalleryState>(
        builder: (context, state) {
          if (state is LoadingFacilityGallery) {
            return Container();
          } else if (state is LoadedFacilityGallery) {
            return CustomExpandGalleryTile(
              facilityGalleryDetail: state.facilityGalleryDetail,
              title: widget.title,
              colorCode: widget.colorCode,
            );
          }
          return Container();
        },
      ),
    );
  }
}
