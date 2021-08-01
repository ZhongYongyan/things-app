import 'package:app/base/util/Result.dart';

class Paged<T> {
  List<T> items;
  int pageCount;
  int pageIndex;
  int pageSize;
  int itemCount;

  Paged(this.items, this.pageCount, this.pageIndex, this.pageSize,
      this.itemCount);

  Paged.fromJson(Map<String, dynamic> json, [ObjectDecodeHandler<T> handler]) {
    pageCount = json['pageCount'];
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    itemCount = json['itemCount'];

    List<dynamic> dataJson = json['items'];
    if (dataJson != null && handler != null) {
      var result = dataJson.map((item) {
        return handler(item);
      });
      items = result.toList();
    }
  }
}
