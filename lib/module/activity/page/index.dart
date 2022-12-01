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

import '../using.dart';
import 'list.dart';
import 'profile.dart';
import 'search.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> with SingleTickerProviderStateMixin {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.ftype_activity.txt, actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => showSearch(context: context, delegate: SearchBar()),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: currentIndex == 0 ? const ActivityListPage() : const ProfilePage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: i18n.activityList,
            icon: const Icon(Icons.list_alt_rounded),
          ),
          BottomNavigationBarItem(
            label: i18n.activityMyApplication,
            icon: const Icon(Icons.person_rounded),
          )
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}
