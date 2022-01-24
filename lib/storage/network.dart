import 'package:hive/hive.dart';
import 'package:kite/dao/setting/network.dart';
import 'package:kite/storage/constants.dart';

class NetworkSettingStorage implements NetworkSettingDao {
  final Box<dynamic> box;

  NetworkSettingStorage(this.box);

  @override
  String get proxy => box.get(NetworkKeys.networkProxy, defaultValue: '');
  @override
  set proxy(String foo) => box.put(NetworkKeys.networkProxy, foo);

  @override
  bool get useProxy => box.get(NetworkKeys.networkUseProxy, defaultValue: false);
  @override
  set useProxy(bool foo) => box.put(NetworkKeys.networkUseProxy, foo);
}