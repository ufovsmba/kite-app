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
import 'package:flutter/material.dart';
import 'package:kite/page/game/old_game/game_list.dart';

import 'game_2048/index.dart';
import 'old_game/game_list.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('小游戏')),
      body: ListView(
        children: [
          ListTile(
              title: const Text('2048'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const Game2048Page(),
                ));
              }),
          ListTile(
              title: const Text('模拟器游戏'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const WebGameListPage(),
                ));
              }),
        ],
      ),
    );
  }
}
