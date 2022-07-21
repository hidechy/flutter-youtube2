import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../model/youtube_data.dart';
import '../model/video.dart';

final videoHistoryProvider =
    StateNotifierProvider.autoDispose<VideoHistoryStateNotifier, List<Video>>(
        (ref) {
  return VideoHistoryStateNotifier([])..getVideoData();
});

class VideoHistoryStateNotifier extends StateNotifier<List<Video>> {
  VideoHistoryStateNotifier(List<Video> state) : super(state);

  ///
  void getVideoData() async {
    try {
      String url = "http://toyohide.work/BrainLog/api/getYoutubeList";
      Map<String, String> headers = {'content-type': 'application/json'};

      Response response = await post(Uri.parse(url), headers: headers);
      final youtubeData = youtubeDataFromJson(response.body);
      state = youtubeData.data;
    } catch (e) {
      throw e.toString();
    }
  }
}
