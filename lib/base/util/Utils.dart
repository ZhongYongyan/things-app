import 'dart:math';

String clearHtml(String html) {
  if (html == null) return '';
  return html
      .replaceAll('white-space: nowrap;', '')
      .replaceAll('font-family: &quot;Microsoft YaHei&quot;;', '');
}

String random() {
  String alphabet =
      '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  int strLenght = 20;
  String left = '';
  for (var i = 0; i < strLenght; i++) {
    left = left + alphabet[Random().nextInt(alphabet.length)];
  }
  return left;
}

bool isEmpty(String value) {
  return value == null || value.isEmpty;
}

bool nonEmpty(String value) {
  return !isEmpty(value);
}

String beijingTime(String text) {
  DateTime beijingTime= DateTime.parse("${text.substring(0,19)}-0800");
  return beijingTime.toString().substring(0,19);
}