import 'dart:async';
import 'dart:typed_data';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:kite/service/campus_card.dart';
import 'package:kite/util/flash.dart';
import 'package:nfc_manager/nfc_manager.dart';

class CampusCardRecord {
  final int cardId;

  bool isCardRecognized = false;
  final String studentName;
  final String studentId;
  final String major;

  final int ts = DateTime.now().millisecondsSinceEpoch;

  CampusCardRecord(this.cardId, this.studentName, this.studentId, this.major);

  static CampusCardRecord valid(int cardId, String studentName, String studentId, String major) {
    return CampusCardRecord(cardId, studentName, studentId, major);
  }

  static CampusCardRecord invalid(int cardId) {
    return CampusCardRecord(cardId, '未知卡', '', 'Unknown');
  }
}

class CampusCardPage extends StatefulWidget {
  const CampusCardPage({Key? key}) : super(key: key);

  @override
  _CampusCardPageState createState() => _CampusCardPageState();
}

class _CampusCardPageState extends State<CampusCardPage> {
  bool isNfcAvailable = false;
  final List<CampusCardRecord> _cardsRead = [];

  static String _dateToString(DateTime date) {
    final local = date.toLocal();

    return '${local.month} 月 ${local.day} 日 ${local.hour}:${local.minute}';
  }

  static String _tsToString(int ts) {
    return _dateToString(DateTime.fromMillisecondsSinceEpoch(ts));
  }

  Future<void> onNewCardDiscovered(NfcTag tag) async {
    late Uint8List uid;
    for (var properties in tag.data.values) {
      if (properties is Map) {
        if (properties.containsKey('identifier')) {
          uid = properties['identifier'];
          break;
        }
      }
    } // End of for statement.

    int cardUid = 0;
    cardUid = (uid.elementAt(3) << 24) | (uid.elementAt(2) << 16) | (uid.elementAt(1) << 8) | uid.elementAt(0);

    var completer = Completer();
    context.showBlockDialog(dismissCompleter: completer);

    getCardInfo(cardUid).then((cardInfo) {
      completer.complete();

      setState(() {
        if (cardInfo != null) {
          _cardsRead.add(CampusCardRecord.valid(cardUid, cardInfo.studentName, cardInfo.studentId, cardInfo.major));
        } else {
          _cardsRead.add(CampusCardRecord.invalid(cardUid));
        }
      });
    }).catchError((_) {
      completer.complete();
      showBasicFlash(context, const Text('网络错误'));
    });
  }

  @override
  void initState() {
    super.initState();

    // Start Session
    NfcManager.instance.isAvailable().then((value) {
      setState(() {
        isNfcAvailable = value;
      });
      if (isNfcAvailable) {
        NfcManager.instance.startSession(onDiscovered: onNewCardDiscovered);
      }
      print('$isNfcAvailable');
    });
  }

  @override
  void dispose() {
    // Stop session
    if (isNfcAvailable) {
      NfcManager.instance.stopSession();
    }
    super.dispose();
  }

  Widget buildFailedPrompt() {
    return const Center(
      child: Text(
        '设备的 NFC 功能不可用',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildPrompt() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            '请将卡片贴合到手机背面 NFC 读卡器处',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40.0),
          Image(image: AssetImage('assets/campus_card/illustration.png'), height: 300, width: 300),
        ],
      ),
    );
  }

  Widget buildCardItem(CampusCardRecord cardRecord) {
    return ListTile(
      leading: const Icon(Icons.credit_card_sharp),
      title: Text('${cardRecord.studentName} ${cardRecord.studentId}'),
      subtitle: Text(cardRecord.major),
      trailing: Text(
        _tsToString(cardRecord.ts),
      ),
    );
  }

  Widget buildCardRecord() {
    return Column(children: [
      const SizedBox(
          height: 30,
          child: Text(
            '数据源缺少补办卡信息, 结果仅供参考.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
      ListView(
        shrinkWrap: true,
        children: _cardsRead.map(
          (cardRecord) {
            return buildCardItem(cardRecord);
          },
        ).toList(),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('校园卡工具')),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: isNfcAvailable ? (_cardsRead.isNotEmpty ? buildCardRecord() : buildPrompt()) : buildFailedPrompt(),
        ),
      ),
    );
  }
}