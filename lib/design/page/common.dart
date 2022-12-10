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
import 'package:flutter_svg/svg.dart';
import 'package:kite/l10n/extension.dart';
import '../colors.dart';
import 'package:rettulf/rettulf.dart';

class LeavingBlank extends StatelessWidget {
  final WidgetBuilder iconBuilder;
  final String desc;
  final VoidCallback? onIconTap;

  const LeavingBlank.builder({super.key, required this.iconBuilder, required this.desc, this.onIconTap});

  factory LeavingBlank(
      {Key? key, required IconData icon, required String desc, VoidCallback? onIconTap, double size = 120}) {
    return LeavingBlank.builder(
      iconBuilder: (ctx) => icon.make(size: size, color: ctx.darkSafeThemeColor),
      desc: desc,
      onIconTap: onIconTap,
    );
  }

  factory LeavingBlank.svgAssets(
      {Key? key,
      required String assetName,
      required String desc,
      VoidCallback? onIconTap,
      double width = 120,
      double height = 120}) {
    return LeavingBlank.builder(
      iconBuilder: (ctx) => SvgPicture.asset(assetName, width: width, height: height),
      desc: desc,
      onIconTap: onIconTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = iconBuilder(context).padAll(20);
    if (onIconTap != null) {
      icon = icon.on(tap: onIconTap);
    }
    return [
      icon.expanded(),
      desc
          .text(
            style: context.textTheme.titleLarge,
          )
          .center()
          .padAll(10)
          .expanded(),
    ].column(maa: MAAlign.spaceAround).center();
  }
}

class UnauthorizedTip extends StatefulWidget {
  const UnauthorizedTip({super.key});

  @override
  State<UnauthorizedTip> createState() => _UnauthorizedTipState();
}

class _UnauthorizedTipState extends State<UnauthorizedTip> {
  @override
  Widget build(BuildContext context) {
    return LeavingBlank(icon: Icons.person_off_outlined, desc: i18n.unauthorizedUsernameTip);
  }
}

class UnauthorizedTipPage extends StatefulWidget {
  const UnauthorizedTipPage({Key? key}) : super(key: key);

  @override
  State<UnauthorizedTipPage> createState() => _UnauthorizedTipPageState();
}

class _UnauthorizedTipPageState extends State<UnauthorizedTipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.unauthorizedTipTitle.text(),
      ),
      body: const UnauthorizedTip(),
    );
  }
}
