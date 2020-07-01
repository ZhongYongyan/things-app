List<List<int>> createCommand(String value, int command) {
  int dateLen = 12;
  List<int> bytes = value.codeUnits;
  List<int> writeData = List();
  List<List<int>> result = List<List<int>>();
  int nums = 1;
  if(bytes.length > dateLen ) {
    nums = bytes.length~/dateLen;
    if (bytes.length%dateLen != 0) {
      nums = nums + 1;
    }
  }
  int num = 0x01;
  for (int i = 0; i < bytes.length; i++) {
    writeData.add(bytes[i]);
    if(i != 0 && ((i+1) % dateLen == 0 || i == bytes.length - 1)) {
      List<int> buffer = List();
      buffer.add(0xAA);
      buffer.add(0xFF);
      buffer.add(command);
      buffer.add(nums);
      buffer.add(num);
      buffer.add(writeData.length);
      buffer.addAll(writeData.getRange(0, writeData.length));
      int check_num = 0x00;
      for(int j in buffer) {
        check_num ^= j;
      }
      buffer.add(check_num);
      buffer.add(0x0D);
      buffer.add(0x0A);
      result.add(buffer);
      num += 1;
      writeData = List();
    }
  }

  return result;
}
