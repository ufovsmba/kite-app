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
import 'package:kite/entity/expense.dart';
import 'package:kite/page/expense/icon.dart';

import 'bill.dart';
import 'statistics.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  /// 底部导航键的标志位
  int _currentIndex = 0;
  int _stateindex = 1;
  String _expensetype = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("消费记录"),
        actions: [
          _onBillsRefresh(),
          _currentIndex == 0 ? _buildPopupMenuItems() : const Padding(padding: EdgeInsets.all(0)),
        ],
      ),
      body: _currentIndex == 0 ? BillPage(_stateindex, _expensetype) : const StatisticsPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: '账单',
            icon: Icon(Icons.assignment_rounded),
          ),
          BottomNavigationBarItem(
            label: '统计',
            icon: Icon(Icons.data_saver_off),
          )
        ],
        currentIndex: _currentIndex,
        onTap: (int tapIndex) {
          setState(() => {_currentIndex = tapIndex, _stateindex = 0});
        },
      ),
    );
  }

  ///筛选
  _buildPopupMenuItems() {
    return PopupMenuButton(
      tooltip: '筛选',
      onSelected: (String value) {
        setState(() => _expensetype = value);
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        PopupMenuItem(
          value: 'canteen',
          child: Row(
            children: [Icon(Icons.local_mall, size: 30, color: Theme.of(context).primaryColor), const Text('全部')],
          ),
        ),
        PopupMenuItem(
          value: 'canteen',
          child: Row(children: [buildIcon(ExpenseType.canteen, context), const Text('食堂')]),
        ),
        PopupMenuItem(
          value: 'store',
          child: Row(children: [
            buildIcon(ExpenseType.store, context),
            const Text('超市'),
          ]),
        ),
        PopupMenuItem(
          value: 'coffee',
          child: Row(children: [
            buildIcon(ExpenseType.coffee, context),
            const Text('咖啡吧'),
          ]),
        ),
        PopupMenuItem(
          value: 'shower',
          child: Row(children: [
            buildIcon(ExpenseType.shower, context),
            const Text('洗浴'),
          ]),
        ),
        PopupMenuItem(
          value: 'water',
          child: Row(children: [
            buildIcon(ExpenseType.water, context),
            const Text('热水'),
          ]),
        ),
        PopupMenuItem(
          value: 'unknown',
          child: Row(children: [
            buildIcon(ExpenseType.unknown, context),
            const Text('未知'),
          ]),
        )
      ],
    );
  }

  _onBillsRefresh() {
    return IconButton(
      tooltip: '刷新',
      icon: const Icon(Icons.refresh),
      onPressed: () {
        setState(() => _stateindex = 1);
      },
    );
  }
}
