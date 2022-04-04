// To parse this JSON data, do
//
//     final specialVideo = specialVideoFromJson(jsonString);

import 'dart:convert';

import 'video.dart';

SpecialVideo specialVideoFromJson(String str) =>
    SpecialVideo.fromJson(json.decode(str));

String specialVideoToJson(SpecialVideo data) => json.encode(data.toJson());

class SpecialVideo {
  SpecialVideo({
    required this.data,
  });

  Map<String, List<Video>> data;

  factory SpecialVideo.fromJson(Map<String, dynamic> json) => SpecialVideo(
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, List<Video>>(
                k, List<Video>.from(v.map((x) => Video.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(
            k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}
