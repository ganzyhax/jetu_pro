class JetuDriverModel {
  JetuDriverModel({
    this.id,
    this.name,
    this.surname,
    this.rating,
    this.phone,
    this.avatarUrl,
    this.carModel,
    this.carColor,
    this.carNumber,
    this.lat,
    this.long,
    this.isVerified,
  });

  final String? id;
  final String? name;
  final String? surname;
  final double? rating;
  final String? phone;
  final String? avatarUrl;
  final String? carModel;
  final String? carColor;
  final String? carNumber;
  final double? lat;
  final double? long;
  final bool? isVerified;

  JetuDriverModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        surname = data['surname'],
        rating = data['rating'] != null
            ? double.parse(data['rating'].toString())
            : 0.0,
        phone = data['phone'],
        avatarUrl = data['avatar_url'],
        carModel = data['car_model'],
        carColor = data['car_color'],
        carNumber = data['car_number'],
        lat = double.tryParse(data['lat'].toString()),
        isVerified = data['is_verified'],
        long = double.tryParse(data['long'].toString());
}

class JetuDriverList {
  final List<JetuDriverModel> users;

  JetuDriverList.fromUserJson(Map<String, dynamic> data, {String? name})
      : users = (data[name ?? "jetu_drivers"] as List)
            .map((e) => JetuDriverModel.fromJson(e))
            .toList();
}
