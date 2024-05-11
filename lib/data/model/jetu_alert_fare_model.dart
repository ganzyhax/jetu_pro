import 'package:jetu/data/model/jetu_driver_model.dart';
import 'package:jetu/data/model/jetu_user_model.dart';

class JetuAlertFareModel {
  JetuAlertFareModel({
    required this.id,
    this.driver,
    this.user,
    this.cost,
    this.isUserSend,
    this.isReject,
  });

  final String id;
  final JetuDriverModel? driver;
  final JetuUserModel? user;
  final String? cost;
  final bool? isUserSend;
  final bool? isReject;

  JetuAlertFareModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        driver = data['jetu_driver'] != null
            ? JetuDriverModel.fromJson(data['jetu_driver'])
            : null,
        user = data['jetu_user'] != null
            ? JetuUserModel.fromJson(data['jetu_user'])
            : null,
        cost = data['cost'],
        isUserSend = data['isUserSend'],
        isReject = data['isReject'];
}

class JetuAlertFareList {
  final List<JetuAlertFareModel> orders;

  JetuAlertFareList.fromUserJson(Map<String, dynamic> data, {String? name})
      : orders = (data[name ?? "alert_fare"] as List)
            .map((e) => JetuAlertFareModel.fromJson(e))
            .toList();
}
