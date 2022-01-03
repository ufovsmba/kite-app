import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/services/office/office.dart';
import 'package:kite/services/office/src/signature.dart';

part 'function.g.dart';

const String serviceFunctionList = 'https://xgfy.sit.edu.cn/app/public/queryAppManageJson';
const String serviceFunctionDetail = 'https://xgfy.sit.edu.cn/app/public/queryAppFormJson';

@JsonSerializable()
class SimpleFunction {
  @JsonKey(name: 'appID')
  final String id;
  @JsonKey(name: 'appName')
  final String name;
  @JsonKey(name: 'appDescribe')
  final String summary;
  @JsonKey(name: 'appStatus')
  final int status;
  @JsonKey(name: 'appCount')
  final int count;

  const SimpleFunction(this.id, this.name, this.summary, this.status, this.count);

  factory SimpleFunction.fromJson(Map<String, dynamic> json) => _$SimpleFunctionFromJson(json);
}

Future<List<SimpleFunction>> selectFunctions(OfficeSession session) async {
  String payload = '{"appObject":"student","appName":null}';

  final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  final Response response = await session.dio.post(serviceFunctionList,
      data: payload,
      options: Options(headers: {
        'content-type': 'application/json',
        'Authorization': session.jwtToken,
        'timestamp': timestamp,
        'signature': sign(timestamp),
      }));

  final Map<String, dynamic> data = response.data;
  final List<SimpleFunction> functionList =
      (data['value'] as List<dynamic>).map((e) => SimpleFunction.fromJson(e)).toList();

  return functionList;
}

@JsonSerializable()
class FunctionDetailSection {
  @JsonKey(name: 'formName')
  final String section;
  final String type;
  final DateTime createTime;
  final String content;

  const FunctionDetailSection(this.section, this.type, this.createTime, this.content);
  factory FunctionDetailSection.fromJson(Map<String, dynamic> json) => _$FunctionDetailSectionFromJson(json);
}

class FunctionDetail {
  final String id;
  final List<FunctionDetailSection> sections;

  const FunctionDetail(this.id, this.sections);
}

Future<FunctionDetail> getFunctionDetail(OfficeSession session, String functionId) async {
  final String payload = '{"appID":"$functionId"}';

  final response = await session.dio.post(serviceFunctionDetail,
      data: payload,
      options: Options(headers: {
        'content-type': 'application/json',
        'authorization': session.jwtToken,
      }));
  final Map<String, dynamic> data = jsonDecode(response.data);
  final List<FunctionDetailSection> sections =
      (data['value'] as List<dynamic>).map((e) => FunctionDetailSection.fromJson(e)).toList();

  return FunctionDetail(functionId, sections);
}
