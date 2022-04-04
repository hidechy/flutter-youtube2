// To parse this JSON data, do
//
//     final youtubeData = youtubeDataFromJson(jsonString);

import 'dart:convert';

import 'video.dart';

YoutubeData youtubeDataFromJson(String str) =>
    YoutubeData.fromJson(json.decode(str));

String youtubeDataToJson(YoutubeData data) => json.encode(data.toJson());

class YoutubeData {
  YoutubeData({
    required this.data,
  });

  List<Video> data;

  factory YoutubeData.fromJson(Map<String, dynamic> json) => YoutubeData(
        data: List<Video>.from(json["data"].map((x) => Video.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
