// To parse this JSON data, do
//
//     final searchLocation = searchLocationFromJson(jsonString);

import 'dart:convert';

SearchLocation searchLocationFromJson(String str) => SearchLocation.fromJson(json.decode(str));

GeoCodeSearch geoSearchLocationFromJson(String str) => GeoCodeSearch.fromJson(json.decode(str));

class SearchLocation {
  SearchLocation({
    this.candidates,
    this.status,
  });

  List<Candidate>? candidates;
  String? status;

  factory SearchLocation.fromJson(Map<String, dynamic> json) => SearchLocation(
    candidates: List<Candidate>.from(json["candidates"].map((x) => Candidate.fromJson(x))),
    status: json["status"],
  );
}

class Candidate {
  Candidate({
    this.formattedAddress,
    this.geometry,
    this.name,
  });

  String? formattedAddress;
  Geometry? geometry;
  String? name;

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
    formattedAddress: json["formatted_address"],
    geometry: Geometry.fromJson(json["geometry"]),
    name: json["name"],
  );
}

class Geometry {
  Geometry({
    this.location,
  });

  Location? location;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: Location.fromJson(json["location"]),
  );
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );
}

class GeoCodeSearch {
  List<Result> results;
  String status;

  GeoCodeSearch({
    required this.results,
    required this.status,
  });

  factory GeoCodeSearch.fromJson(Map<String, dynamic> json) => GeoCodeSearch(
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    status: json["status"],
  );

}

class Result {
  List<AddressComponent> addressComponents;
  String formattedAddress;
  Geometry geometry;
  String placeId;
  List<String> types;

  Result({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
    required this.types,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    addressComponents: List<AddressComponent>.from(json["address_components"].map((x) => AddressComponent.fromJson(x))),
    formattedAddress: json["formatted_address"],
    geometry: Geometry.fromJson(json["geometry"]),
    placeId: json["place_id"],
    types: List<String>.from(json["types"].map((x) => x)),
  );

}

class AddressComponent {
  String longName;
  String shortName;
  List<String> types;

  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
    longName: json["long_name"],
    shortName: json["short_name"],
    types: List<String>.from(json["types"].map((x) => x)),
  );
}
