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
import 'package:flutter/material.dart';
import 'package:kite/entity/edu/index.dart';
import 'package:kite/global/event_bus.dart';
import 'package:kite/page/timetable/sheet.dart';
import 'package:kite/util/edu/icon.dart';

import 'cache.dart';
import 'header.dart';
import 'util.dart';

class DailyTimetable extends StatefulWidget {
  /// 教务系统课程列表
  final List<Course> allCourses;

  /// 初始日期
  final DateTime? initialDate;

  const DailyTimetable(this.allCourses, {Key? key, this.initialDate}) : super(key: key);

  @override
  _DailyTimetableState createState() => _DailyTimetableState(allCourses, initialDate ?? DateTime.now());
}

class _DailyTimetableState extends State<DailyTimetable> {
  static const String _courseIconPath = 'assets/course/';

  /// 教务系统课程列表
  final List<Course> allCourses;

  /// 初始日期
  final DateTime initialDate;

  /// 课表应该显示的周（页数 + 1）
  int _currentWeek = 0;

  /// 当前页应显示的星期几
  int _currentDay = 0;

  /// 翻页控制
  late final PageController _pageController;

  _DailyTimetableState(this.allCourses, this.initialDate);

  @override
  void initState() {
    super.initState();
    eventBus.on(EventNameConstants.onJumpTodayTimetable, _onJumpToday);
    // 跳转到初始页
    _setDate(initialDate);
    _pageController = PageController(initialPage: _currentWeek);
  }

  @override
  void dispose() {
    eventBus.off(EventNameConstants.onJumpTodayTimetable, _onJumpToday);
    _pageController.dispose();
    super.dispose();
  }

  void _setWeekDay(int week, int day) {
    _currentWeek = week;
    _currentDay = day;
  }

  /// 设置页面为对应日期页.
  void _setDate(DateTime theDay) {
    int days = theDay.difference(dateSemesterStart).inDays;

    int week = days ~/ 7 + 1, day = days % 7 + 1;
    if (days >= 0 && 1 <= week && week <= 20 && 1 <= day && day <= 7) {
      _setWeekDay(week, day);
    } else {
      _setWeekDay(1, 1);
    }
  }

  void _onJumpToday(_) {
    _setDate(DateTime.now());
    _jumpToDay(_currentWeek, _currentDay);
  }

  /// 跳转到指定星期与天
  void _jumpToDay(int week, int day) {
    if (_pageController.hasClients) {
      _pageController.jumpToPage((week - 1) * 7 + day - 1);
    }
  }

  Widget _buildCourseCard(Course course) {
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyText2;
    final Widget courseIcon = Image.asset(_courseIconPath + CourseCategory.query(course.courseName) + '.png');
    final timetable = getBuildingTimetable(course.campus, course.place);
    final description = formatTimeIndex(
        timetable, course.timeIndex, '${course.weekText} 周${weekWord[course.dayIndex - 1]}\nss - ee ${course.place}');

    return Card(
        margin: const EdgeInsets.all(8),
        child: ListTile(
          // 点击卡片打开课程详情.
          onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) => Sheet(course.courseId, allCourses),
            context: context,
          ),
          leading: courseIcon,
          title: Text(course.courseName, textScaleFactor: 1.1, style: textStyle?.copyWith(color: Colors.black54)),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(course.teacher.join(','), style: textStyle),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(description, style: textStyle),
                Text(course.place, softWrap: true, overflow: TextOverflow.ellipsis, style: textStyle),
              ],
            ),
          ]),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        clipBehavior: Clip.antiAlias,
        color: const Color.fromARGB(255, 228, 235, 245));
  }

  Widget _buildEmptyPage() {
    // TODO: 搞好看点
    return const Center(child: Text("今天没有课哦"));
  }

  /// 构建第 index 页视图
  Widget _pageBuilder(int index) {
    _currentWeek = index ~/ 7 + 1;
    _currentDay = index % 7 + 1;
    final List<Course> todayCourse = TableCache.filterCourseOnDay(allCourses, _currentWeek, _currentDay);

    return Column(
      children: [
        // 翻页不影响选择的星期, 因此沿用 _currentDay.
        Expanded(
          child: DateHeader(
            _currentWeek,
            _currentDay,
            onTap: (selectedDay) {
              _currentDay = selectedDay;
              _jumpToDay(_currentWeek, _currentDay);
            },
          ),
        ),
        Expanded(
          flex: 10,
          child: todayCourse.isNotEmpty
              ? ListView(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  children: todayCourse.map(_buildCourseCard).toList())
              : _buildEmptyPage(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      // TODO: 存储
      itemCount: 20 * 7,
      itemBuilder: (_, int index) => _pageBuilder(index),
    );
  }
}
