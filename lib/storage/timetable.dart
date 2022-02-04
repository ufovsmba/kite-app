/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:hive/hive.dart';
import 'package:kite/dao/edu/timetable.dart';
import 'package:kite/entity/edu/index.dart';

class CourseStorage implements TimetableStorageDao {
  final Box<Course> box;

  const CourseStorage(this.box);

  @override
  void add(Course item) {
    box.put(item.courseId.toString() + item.week.toString() + item.timeIndex.toString(), item);
  }

  @override
  void addAll(List<Course> courseList) {
    courseList.forEach((item) {
      box.put(item.courseId.toString() + item.week.toString() + item.timeIndex.toString(), item);
    });
  }

  @override
  void delete(String record) {
    box.delete(record.hashCode);
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys.map((e) => e.hashCode));
  }

  @override
  bool isEmpty() {
    return box.isEmpty;
  }

  @override
  bool clear() {
    box.clear();
    return true;
  }

  @override
  Future<List<Course>> getTimetable(SchoolYear schoolYear, Semester semester) async {
    var result = box.values.toList();
    return result;
  }
}
