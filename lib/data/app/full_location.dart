import 'package:latlong2/latlong.dart';

class FullLocation {
  String title;
  String address;
  LatLng latlng;

  FullLocation({
    required this.latlng,
    required this.address,
    required this.title,
  });
}
