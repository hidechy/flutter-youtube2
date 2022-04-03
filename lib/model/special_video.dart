// To parse this JSON data, do
//
//     final specialVideo = specialVideoFromJson(jsonString);

import 'dart:convert';

SpecialVideo specialVideoFromJson(String str) =>
    SpecialVideo.fromJson(json.decode(str));

String specialVideoToJson(SpecialVideo data) => json.encode(data.toJson());

class SpecialVideo {
  SpecialVideo({
    required this.data,
  });

  Map<String, List<SpecialVideoData>> data;

  factory SpecialVideo.fromJson(Map<String, dynamic> json) => SpecialVideo(
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, List<SpecialVideoData>>(
                k,
                List<SpecialVideoData>.from(
                    v.map((x) => SpecialVideoData.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(
            k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}

class SpecialVideoData {
  SpecialVideoData({
    required this.youtubeId,
    required this.title,
    required this.getdate,
    required this.url,
    required this.pubdate,
    required this.channelId,
    required this.channelTitle,
    required this.playtime,
    this.bunrui,
  });

  String youtubeId;
  String title;
  String getdate;
  String url;
  DateTime pubdate;
  String channelId;
  String channelTitle;
  String playtime;
  dynamic bunrui;

  factory SpecialVideoData.fromJson(Map<String, dynamic> json) =>
      SpecialVideoData(
        youtubeId: json["youtube_id"],
        title: json["title"],
        getdate: json["getdate"],
        url: json["url"],
        pubdate: DateTime.parse(json["pubdate"]),
        channelId: json["channel_id"],
        channelTitle: json["channel_title"],
        playtime: json["playtime"],
        bunrui: null,
      );

  Map<String, dynamic> toJson() => {
        "youtube_id": youtubeId,
        "title": title,
        "getdate": getdate,
        "url": url,
        "pubdate":
            "${pubdate.year.toString().padLeft(4, '0')}-${pubdate.month.toString().padLeft(2, '0')}-${pubdate.day.toString().padLeft(2, '0')}",
        "channel_id": channelId,
        "channel_title": channelTitle,
        "playtime": playtime,
        "bunrui": null,
      };
}
