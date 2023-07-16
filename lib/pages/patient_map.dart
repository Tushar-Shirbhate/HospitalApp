import 'dart:async';

// import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:video_call_5/utils/ScreenArgumentLatLng.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:google_directions_api/google_directions_api.dart';
// import '../Service/direction_service.dart';

class PatientMap extends StatefulWidget {
  const PatientMap({Key? key}) : super(key: key);

  @override
  State<PatientMap> createState() => _PatientMapState();
}
class _PatientMapState extends State<PatientMap>{
  final Completer<GoogleMapController> _controller = Completer();
  // late BitmapDescriptor customMarker;
  String googleApikey = "AIzaSyAwm1h25tQAMi_M3jWfDE1WDhQIkXxjFTM";
  double latitude = 27.666994; //latitude
  double longitude = 85.309289; //longitude
  var args;
  String address = "";
  String stAddress="";

  static const CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(19.0269,72.8554),
      zoom:14
  );

  final List<Marker> _markers =  <Marker>[
    // Marker(
    //     markerId: MarkerId('1'),
    //     position: LatLng(21.1702, 72.8311),
    //     infoWindow: InfoWindow(
    //         title: 'The title of the marker'
    //     )
    // )
  ];

  loadData(){
    getUserCurrentLocation().then((value) async{
      print('my current location');
      print(value.latitude.toString() +" "+value.longitude.toString());

      _markers.add(
          Marker(
              markerId: MarkerId('1'),
              // icon: customMarker,
              position: LatLng(value.latitude,value.longitude),
              infoWindow: InfoWindow(
                  title: '${args.source}'
              )
          )
      );

      CameraPosition cameraPosition = CameraPosition(
          zoom:14,
          target: LatLng(value.latitude,value.longitude)
      );

      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {

      });
    });
  }
  Future<Position> getUserCurrentLocation() async{
    await Geolocator.requestPermission().then((value){

    }).onError((error, stackTrace){
      print("error" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ScreenArgumentsLatLng;
    _markers.add(
      Marker(
          markerId: MarkerId('2'),
          // icon: customMarker,
          position: LatLng(args.lat,args.lng),
          infoWindow: InfoWindow(
              title: '${args.dest}'
          )
      )
    );
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(_markers),
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
          // print(locations);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff8f94fb),
        onPressed: () async{
          getUserCurrentLocation().then((value) async{
            print('my current location');
            print(value.latitude.toString() +" "+value.longitude.toString());

            _markers.add(
                Marker(
                    markerId: MarkerId('1'),
                    position: LatLng(value.latitude,value.longitude),
                    infoWindow: InfoWindow(
                        title: '${args.source}'
                    )
                )
            );

            CameraPosition cameraPosition = CameraPosition(
                zoom:14,
                target: LatLng(value.latitude,value.longitude)
            );

            final GoogleMapController controller = await _controller.future;

            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {

            });
          });
        },
        child: Icon(Icons.my_location,),
      ),
    );
  }
}

