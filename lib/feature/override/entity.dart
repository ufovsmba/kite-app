import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@JsonSerializable()
class RouteOverrideItem {
  // 要拦截的路由
  String inputRoute = '';
  // 被替换的路由
  String outputRoute = '';
  // 被替换的路由参数
  Map<String, dynamic> args = {};
  RouteOverrideItem();

  factory RouteOverrideItem.fromJson(Map<String, dynamic> json) => _$RouteOverrideItemFromJson(json);
  Map<String, dynamic> toJson() => _$RouteOverrideItemToJson(this);
}

@JsonSerializable()
class ExtraHomeItem {
  String title = '';
  String route = '';
  String description = '';
  String iconUrl = '';
  ExtraHomeItem();
  factory ExtraHomeItem.fromJson(Map<String, dynamic> json) => _$ExtraHomeItemFromJson(json);
  Map<String, dynamic> toJson() => _$ExtraHomeItemToJson(this);
}

@JsonSerializable()
class FunctionOverrideInfo {
  List<RouteOverrideItem> routeOverride = [];
  List<ExtraHomeItem> extraHomeItem = [];
  FunctionOverrideInfo();
  factory FunctionOverrideInfo.fromJson(Map<String, dynamic> json) => _$FunctionOverrideInfoFromJson(json);
  Map<String, dynamic> toJson() => _$FunctionOverrideInfoToJson(this);
}
