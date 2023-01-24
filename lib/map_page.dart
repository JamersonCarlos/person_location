import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:personal_location/models/LocationModel.dart';
import 'package:personal_location/repositories/Database.dart';

class MyMap extends StatefulWidget {
  LatLng? initialPosition;
  MyMap({super.key, this.initialPosition});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  List<dynamic>? locationsModel;
  List<LatLng> testeTappedPoints = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DBprovider.db.AllLocations().then((value) {
      setState(() {
        locationsModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var markers = locationsModel != null
        ? locationsModel!.map((value) {
            return Marker(
                height: 80,
                width: 80,
                point: LatLng(value["latitude"], value["longitude"]),
                builder: (ctx) => Column(
                      children: [
                        Text(
                          value["nomeMarcador"],
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          child: const Icon(
                            Icons.pin_drop,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ));
          }).toList()
        : null;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DBprovider.db.deletAllLocations();
          setState(() {
            DBprovider.db
                .AllLocations()
                .then((value) => locationsModel = value);
          });
        },
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text("Flutter Map"),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: widget.initialPosition,
          zoom: 17,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          locationsModel != null
              ? MarkerLayerOptions(markers: markers!)
              : MarkerLayerOptions(),
        ],
      ),
    );
  }
}
