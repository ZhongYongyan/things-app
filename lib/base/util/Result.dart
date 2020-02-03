typedef T ObjectDecodeHandler<T>(Map<String, dynamic> data);

class Result<T> {
  Result({this.name, this.message, this.data});

  String name;
  String message;
  T data;

  bool get success {
    return name == null || name.isEmpty || name == "0";
  }

  Result.fromJson(Map<String, dynamic> json, [ObjectDecodeHandler<T> handler]) {
    name = json['name'];
    message = json['message'];

    Map<String, dynamic> dataJson = json['data'];
    if (dataJson != null && handler != null) {
      data = handler(dataJson);
    }
  }
}
