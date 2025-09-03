// import 'dart:math';

// ignore_for_file: must_be_immutable

import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/facility_detail/facility_content/facility_fitness/bloc/bloc.dart';
import 'package:video_player/video_player.dart';

class FacilityWorkout extends StatelessWidget {
  List<FitnessUserVideos> videoList = [];
  String colorCode;
  int facilityId;
  FacilityWorkout({this.facilityId, this.colorCode});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FacilityFitnessBloc>(
      create: (context) => FacilityFitnessBloc(fitnessBloc: null)
        ..add(new FetchFitnessVideoContent(facilityId: this.facilityId)),
      child: _FacilityWorkout(
        videoList: this.videoList,
      ),
    );
  }
}

class _FacilityWorkout extends StatefulWidget {
  List<FitnessUserVideos> videoList = [];
  _FacilityWorkout({this.videoList});
  @override
  _FacilityWorkoutState createState() =>
      _FacilityWorkoutState(videoList: this.videoList);
}

class _FacilityWorkoutState extends State<_FacilityWorkout> {
  List<FitnessUserVideos> videoList = [];
  _FacilityWorkoutState({this.videoList});
  Utils util = Utils();
  var serverTestPath = URLUtils().getImageResultUrl();

  ProgressBarHandler _handler;
  @override
  Widget build(BuildContext context) {
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );
    return BlocListener<FacilityFitnessBloc, FacilityFitnessState>(
        listener: (context, state) async {
          if (state is ShowProgressBar) {
            _handler.show();
          } else if (state is HideProgressBar) {
            _handler.dismiss();
          } else if (state is PopulateFacilityFitnessVideoData) {
            if (state.response != null) {
              setState(() {
                widget.videoList = state.response;
              });
            }
          }
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: CustomAppBar(
                title: tr('FacilityWorkout'),
              ),
            ),
            body:
                // SingleChildScrollView(
                //   child:
                Container(
              height: MediaQuery.of(context).size.height * 0.99,
              width: MediaQuery.of(context).size.width * 0.99,
              color: Color(0xFFF0F8FF),
              child: Stack(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                      height: MediaQuery.of(context).size.height * 0.85,
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Container(
                            // margin: EdgeInsets.only(left: 8, right: 8),
                            child: getFitnessVideos(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                progressBar
              ]),
            ),
          ),
        ));
    // );
  }

  Widget getFitnessVideos() {
    if (widget.videoList == null) widget.videoList = [];
    return Expanded(
        child: ListView.builder(
            key: PageStorageKey("FitnessVideo_PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.videoList == null ? 0 : widget.videoList.length,
            itemBuilder: (context, j) {
              return Container(
                child: Stack(
                  children: <Widget>[
                    Card(
                        child: Container(
                      // color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width * 0.96,
                      decoration: BoxDecoration(
                          //border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Center(
                              child: Container(
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: MediaQuery.of(context).size.width * 0.96,
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlayVideo(
                                        video: widget.videoList[j],
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                  ),
                                  child: Image.asset(
                                      "assets/images/workout.jpg",
                                      fit: BoxFit.fill),
                                )),
                          )),
                          Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Center(
                                  child: Text(
                                      widget.videoList[j].fitnessVideoName,
                                      style: TextStyle(
                                          color: ColorData.inActiveIconColor,
                                          fontSize: Styles.textSizRegular)))),
                        ],
                      ),
                    )),
                    Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                            child: Icon(Icons.play_arrow,
                                size: 30, color: Colors.white)))
                    // VideoItem(video: widget.videoList[j])
                  ],
                ),
              );
            }));
  }
}

class PlayVideo extends StatelessWidget {
  FitnessUserVideos video;
  var serverTestPath = URLUtils().getImageResultUrl();

  PlayVideo({this.video});

  @override
  Widget build(BuildContext context) {
    return VideoItem(
      video: this.video,
      // controller: _controller,
      // chewieController: _chewieController,
    );
  }
}

class VideoItem extends StatefulWidget {
  FitnessUserVideos video;
  VideoItem({this.video});
  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  var serverTestPath = URLUtils().getImageResultUrl();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(serverTestPath +
        "UploadDocument/FitnessVideo/1/HQ/" +
        widget.video.videoUrl);
    _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: 3 / 2,
        autoPlay: true,
        looping: true,
        showControls: true,
        routePageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondAnimation, provider) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget child) {
              return Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  color: Colors.black,
                  child: provider,
                ),
              );
            },
          );
        }
        // Try playing around with some of these other options:

        // showControls: false,
        // materialProgressColors: ChewieProgressColors(
        //   playedColor: Colors.red,
        //   handleColor: Colors.blue,
        //   backgroundColor: Colors.grey,
        //   bufferedColor: Colors.lightGreen,
        //             ),
        // placeholder: Container(
        //   color: Colors.grey,
        // ),
        // autoInitialize: true,
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    _controller = null;
    _chewieController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child);
        },
        home: Scaffold(
            appBar: AppBar(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              automaticallyImplyLeading: true,
              title: Text(
                widget.video.fitnessVideoName,
                style: TextStyle(color: Colors.blue[200]),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.blue[200],
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pop(context);
                },
              ),
              actions: <Widget>[],
              backgroundColor: Colors.white,
            ),
            body: Column(children: <Widget>[
              Expanded(
                  child: Center(
                child: _controller.value.isInitialized
                    ? CircularProgressIndicator()
                    : Chewie(controller: _chewieController),
              ))
            ])));
  }
}
