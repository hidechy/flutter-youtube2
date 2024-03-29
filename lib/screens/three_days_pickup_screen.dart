// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:youtubeplayer2/utilities/utility.dart';

import 'bunrui_list_screen.dart';

import '../model/youtube_data.dart';
import '../model/video.dart';

import 'components/video_list_item.dart';

import 'components/functions.dart';

class ThreeDaysPickupScreen extends StatelessWidget {
  ThreeDaysPickupScreen({Key? key}) : super(key: key);

  final Utility _utility = Utility();

  late BuildContext _context;

  ///
  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      appBar: AppBar(
        title: const Text('3days Pickup'),
        backgroundColor: Colors.redAccent.withOpacity(0.3),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: const Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              backHomeScreen(context: context);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(context: context),
          Column(
            children: [
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final videoList = ref.watch(videoSearchProvider);

                    return ListView.separated(
                      itemBuilder: (context, index) =>
                          _listItem(videoList[index]),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(color: Colors.white),
                      itemCount: ref.watch(videoSearchProvider).length,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _listItem(Video video) {
    return Card(
      color: Colors.black.withOpacity(0.1),
      child: ListTile(
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(child: Container()),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: (video.bunrui == 0)
                                        ? const Text('----------')
                                        : Text(video.bunrui),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        _context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BunruiListScreen(
                                                  bunrui: video.bunrui),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 50,
                                      child: const Text('Go'),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.yellowAccent
                                            .withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              VideoListItem(
                data: Video(
                  youtubeId: video.youtubeId,
                  title: video.title,
                  url: video.url,
                  channelId: video.channelId,
                  channelTitle: video.channelTitle,
                  playtime: video.playtime,
                  getdate: video.getdate,
                  pubdate: video.pubdate,
                  special: video.special,
                ),
                linkDisplay: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////

final videoSearchProvider =
    StateNotifierProvider.autoDispose<VideoSearchStateNotifier, List<Video>>(
        (ref) {
  return VideoSearchStateNotifier([])..getVideoData();
});

//////////////////////////////////////////////////////////////////////////

class VideoSearchStateNotifier extends StateNotifier<List<Video>> {
  VideoSearchStateNotifier(List<Video> state) : super(state);

  ///
  void getVideoData() async {
    try {
      String url = "http://toyohide.work/BrainLog/api/getYoutubeList";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({"threedays": 1});
      Response response =
          await post(Uri.parse(url), headers: headers, body: body);
      final youtubeData = youtubeDataFromJson(response.body);
      state = youtubeData.data;
    } catch (e) {
      throw e.toString();
    }
  }
}
