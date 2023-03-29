import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;


class FullScreenMap extends StatefulWidget {
  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  late MapboxMapController mapController;

  final center = LatLng(37.810575, -122.477174);
  final position = LatLng(10.472467, -84.966887);
  String selectedStyle = 'mapbox://styles/klerith/ckcur145v3zxe1io3f7oj00w7';

  final obscuroStyle = 'mapbox://styles/klerith/ckcuqzbf741ba1imjtq6jmm3o';
  final streetStyle = 'mapbox://styles/klerith/ckcur145v3zxe1io3f7oj00w7';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(Uri.parse(url));
    return mapController.addImage(name, response.bodyBytes);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crearMapa(),
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {

          },
          child: const Icon(Icons.stairs),
        ),
        const SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomIn());
          },
          child: const Icon(Icons.zoom_in_map_outlined),
        ),
        const SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomOut());
          },
          child: const Icon(Icons.zoom_out_map_outlined),
        ),
        const SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          onPressed: () {
            mapController.addSymbol(SymbolOptions(
              iconImage: 'assetImage',
              iconSize: 0.3,
              geometry: center,
              textColor: '#000',
              textField: 'Prueba BDC',
              textOffset: const Offset(0, 1),
              textSize: 10,

            ));
          },
          child: const Icon(Icons.local_activity_rounded),
        ),
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
        accessToken:
            'sk.eyJ1IjoiYnVycm9kZWNhcmdhIiwiYSI6ImNsZnNxNTBhMzAxaDAzZm83MTF2NjIyNnUifQ.SSHxhLhq_Nsci-6yzooYOg',
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: center, zoom: 14));
  }
}
