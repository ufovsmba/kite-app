import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/freshman/entity.dart';

import '../dao.dart';
import '../init.dart';
import 'component/basic_info.dart';

class FreshmanAnalysisPage extends StatefulWidget {
  static bool isFan = true;
  const FreshmanAnalysisPage({Key? key}) : super(key: key);

  @override
  State<FreshmanAnalysisPage> createState() => _FreshmanAnalysisPageState();
}

class _FreshmanAnalysisPageState extends State<FreshmanAnalysisPage> {
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyFutureBuilder<List<dynamic>>(
        future: Future.wait([freshmanDao.getAnalysis(), freshmanDao.getInfo()]),
        // builder: (context, data) {
        //   return AnimatedSwitcher(
        //       duration: const Duration(milliseconds: 2000),
        //       key: GlobalKey(),
        //       transitionBuilder: (Widget child, Animation<double> animation) {
        //         var tween = Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0));
        //         return MySlideTransition(position: tween.animate(animation), child: child);
        //       },
        //       child: StaticValue.isFan
        //           ? _buildBodyStack(context, data[0], data[1])
        //           : _buildBodyBasicInfo(context, data[0], data[1]));
        // },
        builder: (context, data) {
          return FreshmanAnalysisPage.isFan
              ? _buildBodyStack(context, data[0], data[1])
              : _buildBodyBasicInfo(context, data[0], data[1]);
        },
      ),
      floatingActionButton: IconButton(
        iconSize: 50,
        color: !FreshmanAnalysisPage.isFan ? Theme.of(context).primaryColorDark : Colors.red,
        onPressed: () {
          setState(() {
            FreshmanAnalysisPage.isFan = !FreshmanAnalysisPage.isFan;
          });
        },
        icon: const Icon(Icons.change_circle),
      ),
    );
  }

  //信息风格分析
  Widget _buildBodyBasicInfo(BuildContext context, Analysis data, FreshmanInfo info) {
    return BasicInfoPageWidget(
      name: info.name,
      college: info.college,
      infoItems: [
        if (data.sameName != 0) InfoItem(Icons.person, "同名人数", '${data.sameName} 人'),
        if (data.sameCity != -1) InfoItem(Icons.location_city, "来自同一个城市的人数", '${data.sameCity} 人'),
        if (data.sameHighSchool != -1) InfoItem(Icons.face, "来自同一个高中的人数", '${data.sameHighSchool} 人'),
        InfoItem(Icons.school, "学院总人数", '${data.collegeCount} 人'),
        InfoItem(Icons.emoji_objects, "专业总人数", '${data.major.total} 人'),
        InfoItem(Icons.male, "专业男生人数", '${data.major.boys} 人'),
        InfoItem(Icons.female, "专业女生人数", '${data.major.girls} 人'),
      ],
    );
  }

  //分享图风格分析
  Widget _buildBodyStack(BuildContext context, Analysis data, FreshmanInfo info) {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.pinkAccent.withAlpha(10)]))),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 120.h,
            ),
          ],
        ),
        Positioned(
            top: 300.h, left: MediaQuery.of(context).size.width / 4, child: buildTextColumn(context, data, info)),
        Align(
            alignment: const Alignment(0, -0.9),
            child: Image.asset(
              'assets/freshman/welcome_bg.png',
              width: 350,
              height: 350,
            )),
        Positioned(
          left: 30.w,
          top: 30.h,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: SvgPicture.asset(
              'assets/home/kite.svg',
              width: 70,
              height: 70,
            ),
          ),
        ),
      ],
    );
  }

  //文字列抽离
  Widget buildTextColumn(BuildContext context, Analysis data, FreshmanInfo info) {
    TextStyle italicText = const TextStyle(fontStyle: FontStyle.italic, fontSize: 15);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAnalysisTextRow(text: '终于等到你 ', analysis: info.name),
        buildAnalysisTextRow(text: '欢迎来到上海应用技术大学'),
        SizedBox(height: 15.h),
        buildAnalysisTextRow(text: '有 ', analysis: data.collegeCount.toString(), text2: '人和你一起'),
        buildAnalysisTextRow(text: '来到了 ', analysis: info.college),
        buildAnalysisTextRow(text: '你的专业共有 ', analysis: data.major.total.toString(), text2: '人'),
        Row(
          children: [
            buildAnalysisTextRow(text: '其中男生', analysis: data.major.boys.toString(), text2: '人，'),
            buildAnalysisTextRow(text: '女生', analysis: data.major.girls.toString(), text2: '人'),
          ],
        ),
        SizedBox(height: 15.h),
        if (data.sameCity > 0)
          buildAnalysisTextRow(text: '还有 ', analysis: data.sameCity.toString(), text2: '人和你来自同一座城市'),
        if (data.sameHighSchool > 0)
          buildAnalysisTextRow(text: '其他 ', analysis: data.sameHighSchool.toString(), text2: '人是你的高中校友'),
        if (data.sameHighSchool > 0 || data.sameCity > 0) buildAnalysisTextRow(text: '有时间可以认识一下哦'),
        SizedBox(height: 15.h),
        if (data.sameName > 0) buildAnalysisTextRow(text: '哦，还有', analysis: data.sameName.toString(), text2: '人和你同名'),
        if (data.sameName > 0) buildAnalysisTextRow(text: '也许会在某一不期而遇'),
        SizedBox(height: 20.h),
        buildAnalysisTextRow(text: '生活是一种绵延不绝的渴望,', style: italicText),
        buildAnalysisTextRow(text: '渴望不断上升，', style: italicText),
        buildAnalysisTextRow(text: '变得更伟大而高贵。', style: italicText),
        buildAnalysisTextRow(text: '--杜伽尔', style: italicText),
      ],
    );
  }

  //文字行抽离
  Widget buildAnalysisTextRow({
    required String text,
    String? analysis,
    String? text2,
    TextStyle? style,
    double fontSize = 18,
  }) {
    return Row(
      children: [
        Text(
          text,
          style: style ?? TextStyle(fontSize: fontSize),
        ),
        if (![null, ''].contains(analysis))
          Text(
            analysis!,
            style: TextStyle(fontSize: fontSize, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        if (![null, ''].contains(text2))
          Text(
            text2!,
            style: TextStyle(fontSize: fontSize),
          )
      ],
    );
  }
}

// class MySlideTransition extends AnimatedWidget {
//   const MySlideTransition({
//     Key? key,
//     required Animation<Offset> position,
//     this.transformHitTests = true,
//     required this.child,
//   }) : super(key: key, listenable: position);
//
//   final bool transformHitTests;
//
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     final position = listenable as Animation<Offset>;
//     Offset offset = position.value;
//     if (position.status == AnimationStatus.reverse) {
//       offset = Offset(-offset.dx, offset.dy);
//     }
//     return FractionalTranslation(
//       translation: offset,
//       transformHitTests: transformHitTests,
//       child: child,
//     );
//   }
// }
