// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:slc/view/event_details/event_detail_content/map_pin_pill.dart';
import 'package:slc/model/pin_pill_info.dart';
import 'package:flutter/material.dart';

const double CAMERA_ZOOM = 12;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(25.3777149, 55.3961745);
const LatLng DEST_LOCATION = LatLng(25.3777149, 55.3961745);

class EventDirection extends StatelessWidget {
  String colorCode;
  int facilityId;
  double platitude;
  double plongitude;
  EventDirection(
      {this.colorCode, this.facilityId, this.platitude, this.plongitude});

  @override
  Widget build(BuildContext context) {
    return Direction(colorCode, facilityId, platitude, plongitude);
  }
}

class Direction extends StatefulWidget {
  String colorCode;
  int facilityId;
  double platitude;
  double plongitude;

  Direction(this.colorCode, this.facilityId, this.platitude, this.plongitude);

  @override
  State<StatefulWidget> createState() {
    return DirectionState();
  }
}

class DirectionState extends State<Direction> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
// for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  bool initialized = false;
  String googleAPIKey = 'AIzaSyDPj2kWT9p_UmXzTh4M7kPYUKI4drTxOeI';

// for my custom marker pins
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
// the user's initial location and current location
// as it moves
  LocationData currentLocation;
// a reference to the destination location
  LocationData destinationLocation;
// wrapper around the location API
  Location location;
  CameraPosition initialCameraPosition;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  PinInformation sourcePinInfo;
  PinInformation destinationPinInfo;

  // @override
  // void initState() {
  //   super.initState();
  //   // create an instance of Location
  // }

  void setSourceAndDestinationIcons() async {
    try {
      await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(48, 48)),
              'assets/images/destination_map_marker.png')
          .then((onValue) {
        sourceIcon = onValue;
      });

      await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(48, 48)),
              'assets/images/destination_map_marker.png')
          .then((onValue) {
        destinationIcon = onValue;
      });
      getCurrentLocation();
    } catch (e) {
      // debugPrint("EXCEEEEEEEEEEEEEEEEEEEEEEEEEEE");
    }
  }

  Future<void> setInitialLocation() async {
    var location = new Location();

    polylinePoints = new PolylinePoints();

    //await setSourceAndDestinationIcons();

    currentLocation = await location.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap(
        {"latitude": widget.platitude, "longitude": widget.plongitude});
    showPinsOnMap();
    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      debugPrint(" current location   cccccv" + currentLocation.toString());
      if (sourcePinInfo != null && initialized) {
        updatePinOnMap();
      }
    });
    //// set custom marker pins
  }

  @override
  Widget build(BuildContext context) {
    return getDirection();
  }

  void getCurrentLocation() async {
    var location = new Location();
    currentLocation = await location.getLocation();
    setState(() {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    });
  }

  Widget getDirection() {
    setSourceAndDestinationIcons();
    if (initialCameraPosition == null) {
      return Scaffold(
        body: Stack(children: <Widget>[Text("Loading...")]),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          automaticallyImplyLeading: true,
          title: Text(tr("map_navigation"),
              style: TextStyle(color: Colors.blue[200])),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.blue[200],
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
                myLocationEnabled: true,
                compassEnabled: true,
                tiltGesturesEnabled: false,
                markers: _markers,
                polylines: _polylines,
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onTap: (LatLng loc) {
                  pinPillPosition = -100;
                },
                onMapCreated: (GoogleMapController controller) async {
                  controller.setMapStyle(MapStyleUtils.mapStyles);
                  _controller.complete(controller);

                  await setInitialLocation();
                  // my map has completed being created;
                  // i'm ready to show the pins on the map
                }),
            MapPinPillComponent(
                pinPillPosition: pinPillPosition,
                currentlySelectedPin: currentlySelectedPin)
          ],
        ),
      );
    }
  }

  void showPinsOnMap() {
    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    // get a LatLng out of the LocationData object
    var destPosition = LatLng(widget.platitude, widget.plongitude);

    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          // setState(() {
          //   currentlySelectedPin = sourcePinInfo;
          //   pinPillPosition = 0;
          // });
        },
        icon: BitmapDescriptor.defaultMarker));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          // setState(() {
          //   currentlySelectedPin = destinationPinInfo;
          //   pinPillPosition = 0;
          // });
        },
        icon: BitmapDescriptor.defaultMarker));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
    initialized = true;
  }

  void setPolylines() async {
    // debugPrint(" current :" +
    //     currentLocation.latitude.toString() +
    //     " " +
    //     currentLocation.longitude.toString() +
    //     " p :" +
    //     widget.platitude.toString() +
    //     "," +
    //     widget.plongitude.toString());

    PolylinePoints polylinePoints = PolylinePoints();
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //   googleAPIKey,
    //   PointLatLng(currentLocation.latitude, currentLocation.longitude),
    //   PointLatLng(widget.platitude, widget.plongitude),
    // );
    await polylinePoints
        .getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(widget.platitude, widget.plongitude),
    )
        .then((result) {
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });

        setState(() {
          _polylines.add(Polyline(
              width: 2, // set the width of the polylines
              polylineId: PolylineId("poly"),
              color: Color.fromARGB(255, 40, 122, 198),
              points: polylineCoordinates));
        });
      }
    });
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);

    //sourcePinInfo.location = pinPosition;
    // the trick is to remove the marker (by id)
    // and add it again at the updated location
    _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
    Marker m = Marker(
        markerId: MarkerId('sourcePin'),
        onTap: () {
          // setState(() {
          //   currentlySelectedPin = sourcePinInfo;
          //   pinPillPosition = 0;
          // });
        },
        position: pinPosition, // updated position
        icon: BitmapDescriptor.defaultMarker);
    //});
    _markers.add(m);
  }
}

class MapStyleUtils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
