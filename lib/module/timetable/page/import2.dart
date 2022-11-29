import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../entity/course.dart';
import '../entity/meta.dart';
import '../init.dart';
import '../mock/courses.dart';
import '../using.dart';
import '../user_widget/meta_editor.dart';

enum ImportStatus {
  none,
  importing,
  end,
  failed;
}

class ImportTimetablePage extends StatefulWidget {
  final DateTime? defaultStartDate;

  const ImportTimetablePage({super.key, this.defaultStartDate});

  @override
  State<ImportTimetablePage> createState() => _ImportTimetablePageState();
}

class _ImportTimetablePageState extends State<ImportTimetablePage> {
  final timetableService = TimetableInit.timetableService;
  final timetableStorage = TimetableInit.timetableStorage;
  var _status = ImportStatus.none;
  late ValueNotifier<DateTime> selectedDate = ValueNotifier(
    widget.defaultStartDate != null
        ? widget.defaultStartDate!
        : Iterable.generate(7, (i) {
            return DateTime.now().add(Duration(days: i));
          }).firstWhere((e) => e.weekday == DateTime.monday),
  );
  late int selectedYear;
  late Semester selectedSemester;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day, 8, 20);
    // 先根据当前时间估算出是哪个学期
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    selectedSemester = (now.month >= 3 && now.month <= 7) ? Semester.secondTerm : Semester.firstTerm;
  }

  late final semesterNames = makeSemesterL10nName();

  String getTip({required ImportStatus by}) {
    switch (by) {
      case ImportStatus.none:
        return i18n.timetableSelectSemseterTip;
      case ImportStatus.importing:
        return i18n.timetableImportImporting;
      case ImportStatus.end:
        return i18n.timetableImportEndTip;
      default:
        return i18n.timetableImportFailedTip;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.timetableImportTitle.txt),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: buildImportPage(context),
      ),
    );
  }

  Widget buildTip(BuildContext ctx) {
    final tip = getTip(by: _status);
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Text(
          key: ValueKey(_status),
          tip,
          style: ctx.textTheme.titleLarge,
        ));
  }

  Widget buildImportPage(BuildContext ctx) {
    final isImporting = _status == ImportStatus.importing;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          child: AnimatedContainer(
            margin: isImporting ? const EdgeInsets.all(60) : EdgeInsets.zero,
            width: isImporting ? 120.0 : 0.0,
            height: isImporting ? 120.0 : 0.0,
            alignment: isImporting ? Alignment.center : AlignmentDirectional.topCenter,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child: const SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                strokeWidth: 12,
              ),
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 30), child: buildTip(ctx)),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: SemesterSelector(
              yearSelectCallback: (year) {
                setState(() => selectedYear = year);
              },
              semesterSelectCallback: (semester) {
                setState(() => selectedSemester = semester);
              },
              initialYear: selectedYear,
              initialSemester: selectedSemester,
              showEntireYear: false,
              showNextYear: true,
            )),
        Padding(
          padding: const EdgeInsets.all(24),
          child: buildImportButton(ctx),
        )
      ],
    );
  }

  Future<List<Course>> _fetchTimetable(SchoolYear year, Semester semester) async {
    return await timetableService.getTimetable(year, semester);
  }

  Future<bool> handleTimetableData(BuildContext ctx, List<Course> courses, int year, Semester semester) async {
    final defaultName = i18n.timetableInfoDefaultName(semesterNames[semester] ?? "", year, year + 1);
    final meta = TimetableMeta()
      ..name = defaultName
      ..schoolYear = year
      ..semester = semester.index;
    final saved = await editingMeta(ctx, meta, SchoolYear(year), semester);
    if (saved == true) {
      timetableStorage.addTable(meta, courses);
      return true;
    }
    return false;
  }

  Widget buildImportButton(BuildContext ctx) {
    return ElevatedButton(
      onPressed: _status == ImportStatus.importing
          ? null
          : () async {
              setState(() {
                _status = ImportStatus.importing;
              });
              try {
                final semester = selectedSemester;
                await Future.wait([
                  //_fetchTimetable(year, semester),
                  fetchMockCourses(),
                  Future.delayed(const Duration(milliseconds: 5000)),
                ]).then((value) async {
                  setState(() {
                    _status = ImportStatus.end;
                  });
                  final saved = await handleTimetableData(ctx, value[0], selectedYear, semester);
                  if (mounted) Navigator.of(ctx).pop(saved);
                  setState(() {
                    _status = ImportStatus.none;
                  });
                });
              } catch (e) {
                setState(() {
                  _status = ImportStatus.failed;
                });
                if (!mounted) return;
                await showAlertDialog(ctx,
                    title: i18n.timetableImportErrorTitle,
                    content: i18n.timetableImportError.txt,
                    actionWidgetList: [TextButton(onPressed: () {}, child: i18n.ok.txt)]);
              } finally {
                if (_status == ImportStatus.importing) {
                  setState(() {
                    _status = ImportStatus.end;
                  });
                }
              }
            },
      child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            i18n.timetableImportImportBtn,
            style: ctx.textTheme.titleLarge,
          )),
    );
  }

  void _updateTableName() {
    final year = selectedYear;
    final semester = selectedSemester;
  }

  Future<dynamic> editingMeta(BuildContext ctx, TimetableMeta meta, SchoolYear year, Semester semester) async {
    return await showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(48))),
        builder: (ctx) {
          return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom), child: MetaEditor(meta: meta));
        });
  }
}
