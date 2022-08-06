import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../model/bunrui.dart';
import '../model/youtube_data.dart';
import '../model/video.dart';

final videoBunruiProvider =
    StateNotifierProvider.autoDispose<VideoBunruiStateNotifier, List<String>>(
        (ref) {
  return VideoBunruiStateNotifier([])..getVideoBunrui();
});

class VideoBunruiStateNotifier extends StateNotifier<List<String>> {
  VideoBunruiStateNotifier(List<String> state) : super(state);

  ///
  void getVideoBunrui() async {
    try {
      String url = "http://toyohide.work/BrainLog/api/getBunruiName";
      Map<String, String> headers = {'content-type': 'application/json'};
      Response response = await post(Uri.parse(url), headers: headers);
      final bunrui = bunruiFromJson(response.body);
      state = bunrui.data;
    } catch (e) {
      throw e.toString();
    }
  }
}

final videoSearchProvider =
    StateNotifierProvider.autoDispose<VideoSearchStateNotifier, List<Video>>(
        (ref) {
  return VideoSearchStateNotifier([])..getVideoData();
});

class VideoSearchStateNotifier extends StateNotifier<List<Video>> {
  VideoSearchStateNotifier(List<Video> state) : super(state);

  ///
  void getVideoData() async {
    try {
      String url = "http://toyohide.work/BrainLog/api/getYoutubeList";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({"bunrui": 'blank'});
      Response response =
          await post(Uri.parse(url), headers: headers, body: body);
      final youtubeData = youtubeDataFromJson(response.body);
      state = youtubeData.data;
    } catch (e) {
      throw e.toString();
    }
  }
}
