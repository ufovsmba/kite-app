import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/sso/sso.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';

void main() {
  test('test login', () async {
    var session = Session();
    var a = await session.login('', '');
    var index = await session.get('https://myportal.sit.edu.cn/');
    var list = BeautifulSoup(index.data)
        .find('div', class_: 'composer')!
        .findAll('li')
        .map((e) => e.text.trim().replaceAll('\n', '').replaceAll(' ', ''))
        .toList();
    expect(list[0].contains('姓名'), true);
  });
}
