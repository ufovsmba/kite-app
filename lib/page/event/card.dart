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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geopattern_flutter/geopattern_flutter.dart';
import 'package:geopattern_flutter/patterns/overlapping_circles.dart';

class EventCard extends StatelessWidget {
  const EventCard({Key? key}) : super(key: key);

  Widget _buildBg(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gen = Random();
        final pattern = OverlappingCircles(
          radius: 60,
          nx: 6,
          ny: 6,
          fillColors: List.generate(
              36,
              (_) => Color.fromARGB(10 + (gen.nextDouble() * 100).round(), 50 + gen.nextInt(2) * 150,
                  50 + gen.nextInt(2) * 150, 50 + gen.nextInt(2) * 150)),
        );
        return ClipRect(
          child: CustomPaint(
            willChange: true,
            painter: FullPainter(pattern: pattern, background: Colors.yellow),
            child: SizedBox(width: constraints.maxWidth, height: constraints.maxHeight),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 1.8,
        child: Card(
          margin: const EdgeInsets.all(10),
          child: Stack(
            children: [
              // Background
              _buildBg(context),
            ],
          ),
        ),
      ),
    );
  }
}