// To parse this JSON data, do
//
//     final bunrui = bunruiFromJson(jsonString);

import 'dart:convert';

Bunrui bunruiFromJson(String str) => Bunrui.fromJson(json.decode(str));

String bunruiToJson(Bunrui data) => json.encode(data.toJson());

class Bunrui {
  Bunrui({
    required this.data,
  });

  List<String> data;

  factory Bunrui.fromJson(Map<String, dynamic> json) => Bunrui(
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
