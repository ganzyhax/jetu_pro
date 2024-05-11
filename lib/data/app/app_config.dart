import 'dart:convert';

AppConfig appConfigFromJson(String str) => AppConfig.fromJson(json.decode(str));

class AppConfig {
  AppConfig({
    this.version,
    this.forceScreen,
  });

  AppVersion? version;
  ForceScreen? forceScreen;

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
        version: AppVersion.fromJson(json["version"]),
        forceScreen: ForceScreen.fromJson(json["force_screen"]),
      );
}

class AppVersion {
  AppVersion({
    this.minVersion,
    this.showForceUpdate,
  });

  String? minVersion;
  bool? showForceUpdate;

  factory AppVersion.fromJson(Map<String, dynamic> json) => AppVersion(
        minVersion: json["min_version"],
        showForceUpdate: json["show_update"],
      );
}

class ForceScreen {
  ForceScreen({
    this.show = false,
    this.title = '',
    this.desc = '',
    this.showUpdateButton = false,
  });

  final bool show;
  final String title;
  final String desc;
  final bool showUpdateButton;

  factory ForceScreen.fromJson(Map<String, dynamic> json) => ForceScreen(
        show: json["show"],
        title: json["title"],
        desc: json["desc"],
        showUpdateButton: json["show_update_button"],
      );
}
