import 'package:kite/dao/edu/index.dart';
import 'package:kite/entity/edu/index.dart';
import 'package:kite/service/edu/index.dart';

import '../mock_util.dart';

void main() async {
  await init();
  await login();
  final eduSession = SessionPool.eduSession;
  TimetableDao timetableDao = TimetableService(eduSession);
  test('timetable test', () async {
    final table = await timetableDao.getTimetable(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });
}
