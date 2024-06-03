import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hello_worl2/pages/WaterstationDetails.dart';
import 'package:hello_worl2/restApi/mapper.dart';
import 'package:hello_worl2/restApi/waterEnums.dart';
import 'package:latlong2/latlong.dart';

import 'package:hello_worl2/restApi/apiService.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapScreen> {
  List<RefillStation> waterStations = [];
  List<RefillStationMarker> refillStationLocations = [];

  @override
  void initState() {
    super.initState();
    fetchWaterStations();
  }

  Future<void> fetchWaterStations() async {
    final markers = await ApiService().getAllRefillMarker();
    setState(() {
      refillStationLocations = markers;
    });
  }

  void navigateToDetailsPage(
      BuildContext context, RefillStationMarker marker) async {
    var refillstation = await ApiService().getRefillstationById(marker.id);
    var averageReview = await ApiService().getRefillStationReviewAverage(marker.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Waterstationdetails(station: refillstation, averageReview: averageReview.average,),
      ),
    );
  }

  Widget _buildMarkerChild(bool status) {
    if (status) {
      return Container(
        child: Container(
          child: Image.asset('assets/image/frontpage.png'),
        ),
      );
    } else {
      return Container(
        child: Container(
          child: Image.asset('assets/image/frontpage_dark.png'), // Replace with your alternative image path
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(49.440067, 7.749126),
        initialZoom: 13,
        minZoom: 10,
        maxZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: refillStationLocations
              .map((marker) => Marker(
                    point: LatLng(marker.latitude, marker.longitude),
                    // Use the existing point property
                    width: 80.0,
                    height: 80.0,
                    child: GestureDetector(
                      onTap: () => navigateToDetailsPage(context, marker),
                      child: _buildMarkerChild(marker.status),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

}
