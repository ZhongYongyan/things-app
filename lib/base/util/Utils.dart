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
