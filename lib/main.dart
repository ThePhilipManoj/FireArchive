// ignore_for_file: unnecessary_new

import 'dart:async';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:fire_archive/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fire_archive/Navbar.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'), 
      title: 'Fire Archive',
      home: const MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _locationController = TextEditingController();

  final Set<Marker> _markers = <Marker>{};
  final Set<Polygon> _polygons = <Polygon>{};
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  // ignore: prefer_typing_uninitialized_variables
  late List<List<dynamic>> locations;

  void getHotspots() async {
    var url = Uri.parse(
        'https://firms.modaps.eosdis.nasa.gov/api/country/csv/ecc82b64df96a0490420a20ea4546b65/VIIRS_SNPP_NRT/USA/1');
    // make http get request
    var response = await http.get(url);
    // check the status code for the result
    if (response.statusCode == 200) {
      locations = const CsvToListConverter().convert(response.body);
      print(locations);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(39.113014, -105.358887),
    zoom: 3,
  );

  // country_id,latitude,longitude,bright_ti4,scan,track,acq_date,acq_time,satellite,instrument,confidence,version,bright_ti5,frp,daynight

  @override
  void initState() {
    super.initState();
    getHotspots();
    // ignore: unused_local_variable
    var timer = Timer(const Duration(seconds: 15), () => {
      for (var i = 0; i < locations.length; i++) {
        _setMarker(LatLng(locations[i][1] as double, locations[i][2] as double))
      }
    });
    
    // _setMarker(const LatLng(37.42796133580664, -122.085749655962));
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker'),
          position: point,
        ),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
      ),
    );
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  late String searchedLocation;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text("FireArchive"),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(15),
                        hintText: 'Search Location',
                        hintStyle: const TextStyle(
                        color: Color(0xffDDDADA),
                        fontSize: 15,
                        ),
                        prefixIcon: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          'assets/icons/loc-1.svg',
                          colorFilter:  ColorFilter.mode(Color.fromARGB(255, 109, 107, 106), BlendMode.srcIn),
                          ),
                        ),
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                        ),
                      ),

                      onChanged: (value) {
                        searchedLocation = value;
                      },
                    ),
                    // TextFormField(
                    //   controller: _destinationController,
                    //   decoration: const InputDecoration(hintText: ' Destination'),
                    //   onChanged: (value) {
                    //     print(value);
                    //   },
                    // ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  // var directions = await LocationService().getDirections(
                  //   _originController.text,
                  //   _destinationController.text,
                  // );
                  // _goToPlace(
                  //   directions['start_location']['lat'],
                  //   directions['start_location']['lng'],
                  //   directions['bounds_ne'],
                  //   directions['bounds_sw'],
                  // );

                  // _setPolyline(directions['polyline_decoded']);
                },
              icon: const Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: _markers,
              polygons: _polygons,
              polylines: _polylines,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (point) {
                setState(() {
                  polygonLatLngs.add(point);
                  _setPolygon();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar myappbar() {
    return AppBar(
      title: 
        const Text('FireArchive🔥', 
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold
        )),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap:(){

        },
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration:BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)

          ),
          child: SvgPicture.asset(
            'assets/icons/menu-1.svg',
            height: 40,
            width: 40,
          ),
        ),
      ),

      actions: [
        GestureDetector(
          onTap:(){

          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            decoration:BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: SvgPicture.asset(
              'assets/icons/admin-1.svg',
              height: 40,
              width: 40,
            ),
          ),
        ),  
      ],
    );
  }

  Future<void> _goToPlace(
    // Map<String, dynamic> place,
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          25),
    );
    _setMarker(LatLng(lat, lng));
  }
}
