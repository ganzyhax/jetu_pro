import 'package:firebase_remote_config/firebase_remote_config.dart';

class ApiFirebaseRemoteConfigGateway {
  static Future<FirebaseRemoteConfig> getConfig() async {
    FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 1),
      ),
    );

    //await _remoteConfig.fetchAndActivate();

    RemoteConfigValue(null, ValueSource.valueStatic);

    return _remoteConfig;
  }
}
