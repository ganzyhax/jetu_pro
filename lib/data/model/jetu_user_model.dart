class JetuUserModel {
  JetuUserModel({
    this.id,
    this.name,
    this.surname,
    this.phone,
    this.email,
    this.rating,
    this.avatarUrl,
  });

  final String? id;
  final String? name;
  final String? surname;
  final String? phone;
  final String? email;
  final double? rating;
  final String? avatarUrl;

  JetuUserModel.fromJson(Map<String, dynamic> data, {String name = ''})
      : id = name.isNotEmpty ? data[name]['id'] : data['id'],
        name = name.isNotEmpty ? data[name]['name'] : data['name'],
        surname = name.isNotEmpty ? data[name]['surname'] : data['surname'],
        phone = name.isNotEmpty ? data[name]['phone'] : data['phone'],
        email = name.isNotEmpty ? data[name]['email'] : data['email'],
        rating = name.isNotEmpty
            ? data[name]['rating'] != null
                ? double.parse(data[name]['rating'].toString())
                : data['rating'] != null
                    ? double.parse(data['rating'].toString())
                    : 0.0
            : 0.0,
        avatarUrl =
            name.isNotEmpty ? data[name]['avatarUrl'] : data['avatarUrl'];
}

class JetuUserList {
  final List<JetuUserModel> users;

  JetuUserList.fromUserJson(Map<String, dynamic> data, {String? name})
      : users = (data[name ?? "jetu_users"] as List)
            .map((e) => JetuUserModel.fromJson(e))
            .toList();
}
