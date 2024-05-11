class JetuServicesModel {
  JetuServicesModel({
    this.id,
    this.title,
    this.icon,
    this.info,
    this.isActive,
    this.height,
    this.width,
  });

  final String? id;
  final String? title;
  final String? icon;
  final String? info;
  final bool? isActive;
  final double? height;
  final double? width;

  JetuServicesModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        icon = data['icon_assets'],
        info = data['info'],
        height = data['height'],
        width = data['width'],
        isActive = data['enable'];
}

class JetuServicesList {
  final List<JetuServicesModel> services;

  JetuServicesList.fromUserJson(Map<String, dynamic> data)
      : services = (data["jetu_services"] as List)
            .map((e) => JetuServicesModel.fromJson(e))
            .toList();
}
