class Colour {
  int colourid;
  String colourname;

  Colour.fromJson(Map<String, dynamic> json) {
    colourid = json['colourid'] ?? 0;
    colourname = json['colourname'] ?? "";
  }
}