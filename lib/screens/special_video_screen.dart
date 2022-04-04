import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../model/bunrui.dart';
import '../model/special_video.dart';
import '../model/video.dart';

import '../utilities/utility.dart';

import './components/video_list_item.dart';

class SpecialVideoScreen extends StatelessWidget {
  SpecialVideoScreen({Key? key}) : super(key: key);

  final Utility _utility = Utility();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Special Video'),
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
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(context: context),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final specialVideo = ref.watch(specialVideoProvider);

              final videoBunrui = ref.watch(videoBunruiProvider);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (specialVideo.isNotEmpty)
                      _dispSpecialData(data: specialVideo, bunrui: videoBunrui),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ///
  Widget _dispSpecialData(
      {required Map<String, List<Video>> data, required List<String> bunrui}) {
    List<Widget> _list = [];

    for (int i = 0; i < bunrui.length; i++) {
      if (data[bunrui[i]] != null) {
        _list.add(
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
                      child: Text(bunrui[i]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        for (int j = 0; j < data[bunrui[i]]!.length; j++) {
          _list.add(
            VideoListItem(
              data: Video(
                youtubeId: data[bunrui[i]]![j].youtubeId,
                title: data[bunrui[i]]![j].title,
                url: data[bunrui[i]]![j].url,
                channelId: data[bunrui[i]]![j].channelId,
                channelTitle: data[bunrui[i]]![j].channelTitle,
                playtime: data[bunrui[i]]![j].playtime,
                getdate: data[bunrui[i]]![j].getdate,
                pubdate: data[bunrui[i]]![j].pubdate,
                special: data[bunrui[i]]![j].special,
              ),
            ),
          );
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _list,
    );
  }
}

//////////////////////////////////////////////////////////////////////////
final videoBunruiProvider =
    StateNotifierProvider.autoDispose<VideoBunruiStateNotifier, List<String>>(
        (ref) {
  return VideoBunruiStateNotifier([])..getVideoBunrui();
});

//////////////////////////////////////////////////////////////////////////
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

//////////////////////////////////////////////////////////////////////////
final specialVideoProvider = StateNotifierProvider.autoDispose<
    SpecialVideoStateNotifier, Map<String, List<Video>>>((ref) {
  return SpecialVideoStateNotifier({})..getSpecialVideo();
});

//////////////////////////////////////////////////////////////////////////
class SpecialVideoStateNotifier
    extends StateNotifier<Map<String, List<Video>>> {
  SpecialVideoStateNotifier(Map<String, List<Video>> state) : super(state);

  ///
  void getSpecialVideo() async {
    try {
      String url = "http://toyohide.work/BrainLog/api/getSpecialVideo";
      Map<String, String> headers = {'content-type': 'application/json'};
      Response response = await post(Uri.parse(url), headers: headers);
      final specialVideo = specialVideoFromJson(response.body);
      state = specialVideo.data;
    } catch (e) {
      throw e.toString();
    }
  }
}