List<List<int>> createCommand(String value, int command, int length) {
  List<int> bytes = value.codeUnits;
  List<int> writeData = List(length);
  for (int i = 0; i < writeData.length; i++) {
    writeData[i] = 0;
  }

  for (int i = 0; i < bytes.length && i <= length; i++) {
    writeData[i] = bytes[i];
  }

  List<List<int>> result = List<List<int>>();

  List<int> buffer = List();
  buffer.add(0xAA);
  buffer.add(0xFF);
  buffer.add(command);
  buffer.addAll(writeData.getRange(0, 15));
  buffer.add(0x0D);
  buffer.add(0x0A);
  result.add(buffer);

  if (length == 30) {
    buffer = List();
    buffer.add(0xAA);
    buffer.add(0xFF);
    buffer.add(command + 1);
    buffer.addAll(writeData.getRange(15, 30));
    buffer.add(0x0D);
    buffer.add(0x0A);
    result.add(buffer);
  }

  return result;
}
