//Libs
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
//Local
import 'store.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(35.689487, 139.691711),
          onLongPress: (tapPosition, point) => {
            // ignore: avoid_print
            print(tapPosition),
            print(point)
          },
          zoom: 14,
          maxZoom: 18,
          rotation: 180.0,
          keepAlive: true,
        ),
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: 'OpenStreetMap contributors',
            onSourceTapped: null,
          ),
        ],
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/stagfoo/ck7na75980hpr1iqnrfpg9ffr/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic3RhZ2ZvbyIsImEiOiJjazdsNXZodWIwNDY5M2VvbWF0ejc2M2ptIn0.-DgAxfXGVWow1PEToMyaOg',
            userAgentPackageName: 'com.example.app',
            additionalOptions: const {
              "access_token":
                  "pk.eyJ1Ijoic3RhZ2ZvbyIsImEiOiJjazdsNXZodWIwNDY5M2VvbWF0ejc2M2ptIn0.-DgAxfXGVWow1PEToMyaOg"
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(30, 40),
                width: 80,
                height: 80,
                builder: (context) => FlutterLogo(),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.toNamed("/add-marker");
        },
      ),
    );
  }
}

class GoalsPage extends StatelessWidget {
  const GoalsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: GetBuilder<GlobalState>(
          init: GlobalState(),
          builder: (_) => Text(
            '${_.counter}',
          ),
        ),
        onPressed: () {
          GlobalState.to.increment();
        },
      ),
    );
  }
}

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: GetBuilder<GlobalState>(
          init: GlobalState(),
          builder: (_) => Text(
            '${_.counter}',
          ),
        ),
        onPressed: () {
          GlobalState.to.increment();
        },
      ),
    );
  }
}

class AddMarkerPage extends StatelessWidget {
  const AddMarkerPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Go Back'),
        onPressed: () {
          Get.toNamed("/");
        },
      ),
    );
  }
}
