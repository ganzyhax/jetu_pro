import 'package:jetu/data/app/full_location.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

extension ConvertToFullLocation on Place {
  FullLocation convertToFullLocation() {
    return FullLocation(
        latlng: LatLng(lat, lon),
        address: displayName,
        title: nameDetails?['name'] ?? "Unknown");
  }
}