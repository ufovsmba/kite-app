/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:dio/dio.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';

import '../entity/index.dart';

const String serviceFunctionList = 'https://xgfy.sit.edu.cn/app/public/queryAppManageJson';
const String serviceFunctionDetail = 'https://xgfy.sit.edu.cn/app/public/queryAppFormJson';

class OfficeFunctionService extends AService {
  OfficeFunctionService(ASession session) : super(session);

  Future<List<SimpleFunction>> selectFunctions() async {
    String payload = '{"appObject":"student","appName":null}';

    final Response response = await session.post(
      serviceFunctionList,
      data: payload,
      options: Options(responseType: ResponseType.json),
    );

    final Map<String, dynamic> data = response.data;
    final List<SimpleFunction> functionList = (data['value'] as List<dynamic>)
        .map((e) => SimpleFunction.fromJson(e))
        .where((element) => element.status == 1) // Filter functions unavailable.
        .toList();

    return functionList;
  }

  Future<List<SimpleFunction>> selectFunctionsByCountDesc() async {
    final functions = await selectFunctions();
    functions.sort((a, b) => b.count.compareTo(a.count));
    return functions;
  }

  Future<FunctionDetail> getFunctionDetail(String functionId) async {
    final String payload = '{"appID":"$functionId"}';

    final response = await session.post(
      serviceFunctionDetail,
      data: payload,
      options: Options(responseType: ResponseType.json),
    );
    final Map<String, dynamic> data = response.data;
    final List<FunctionDetailSection> sections =
        (data['value'] as List<dynamic>).map((e) => FunctionDetailSection.fromJson(e)).toList();

    return FunctionDetail(functionId, sections);
  }
}
