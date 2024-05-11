import 'package:latlong2/latlong.dart';

class LocationModel {
  LocationModel({
    this.address,
    required this.location,
  });

  final String? address;
  final LatLng location;
}
