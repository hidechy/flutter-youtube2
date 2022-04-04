class Video {
  Video({
    required this.youtubeId,
    required this.title,
    required this.getdate,
    required this.url,
    this.bunrui,
    this.special,
    required this.pubdate,
    required this.channelId,
    required this.channelTitle,
    required this.playtime,
  });

  String youtubeId;
  String title;
  String getdate;
  String url;
  dynamic bunrui;
  dynamic special;
  String pubdate;
  String channelId;
  String channelTitle;
  String playtime;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        youtubeId: json["youtube_id"],
        title: json["title"],
        getdate: json["getdate"],
        url: json["url"],
        bunrui: json["bunrui"],
        special: json["special"],
        pubdate: json["pubdate"],
        channelId: json["channel_id"],
        channelTitle: json["channel_title"],
        playtime: json["playtime"],
      );

  Map<String, dynamic> toJson() => {
        "youtube_id": youtubeId,
        "title": title,
        "getdate": getdate,
        "url": url,
        "bunrui": bunrui,
        "special": special,
        "pubdate": pubdate,
        "channel_id": channelId,
        "channel_title": channelTitle,
        "playtime": playtime,
      };
}
