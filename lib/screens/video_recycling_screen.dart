// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../data/bunrui_list_state.dart';

import '../model/video.dart';
import '../model/youtube_data.dart';

import '../utilities/utility.dart';

import '../view_model/video_bunrui_view_model.dart';

import 'components/video_list_item.dart';
import 'components/functions.dart';

class VideoRecyclingScreen extends ConsumerWidget {
  VideoRecyclingScreen({Key? key}) : super(key: key);

  final Utility _utility = Utility();

  late WidgetRef _ref;

  late BuildContext _context;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    _context = context;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Recycling'),
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
                child: _getVideoList(),
              ),

              //-----------------------------//
              // 左右の半円と点線を引く方法

              Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(
                              (constraints.constrainWidth() / 30).floor(),
                              (index) {
                                return const SizedBox(
                                  width: 5,
                                  height: 3,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              //-----------------------------//

              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent.withOpacity(0.3),
                        ),
                        onPressed: () => _uploadRecyclingItems(),
                        child: const Text('復活'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _getVideoList() {
    final videoRecyclingState = _ref.watch(videoRecyclingProvider);

    final DateTime threeDaysAgo =
        DateTime.now().add(const Duration(days: 3) * -1);

    return ListView.separated(
      itemBuilder: (_context, index) {
        var video = videoRecyclingState[index];

        int diffDays =
            DateTime.parse(video.getdate).difference(threeDaysAgo).inDays;

        return Card(
          color: _getSelectedBgColor(youtubeId: video.youtubeId),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  padding:
                      const EdgeInsets.only(bottom: 3, right: 10, left: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.redAccent),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text((video.bunrui == 0) ? '-----' : video.bunrui),
                      Icon(
                        Icons.star,
                        color: (diffDays >= 0)
                            ? Colors.yellowAccent.withOpacity(0.7)
                            : Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              _addSelectedAry(youtubeId: video.youtubeId);
                            },
                            child: const Icon(
                              Icons.control_point,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DefaultTextStyle(
                        style: const TextStyle(fontSize: 12),
                        child: VideoListItem(
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
                          linkDisplay: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_context, index) => Container(),
      itemCount: videoRecyclingState.length,
    );
  }

  ///
  void _addSelectedAry({required String youtubeId}) {
    final viewModel = _ref.watch(recyclingVideoProvider.notifier);
    viewModel.addSelectedAry(youtubeId: youtubeId);
  }

  ///
  Color _getSelectedBgColor({required String youtubeId}) {
    final state = _ref.watch(recyclingVideoProvider);
    if (state.selectedList.contains(youtubeId)) {
      return Colors.greenAccent.withOpacity(0.3);
    } else {
      return Colors.black.withOpacity(0.1);
    }
  }

  ///
  void _uploadRecyclingItems() async {
    final state = _ref.watch(recyclingVideoProvider);
    final viewModel = _ref.watch(recyclingVideoProvider.notifier);

    if (state.selectedList.isNotEmpty) {
      var _list = [];
      for (var element in state.selectedList) {
        _list.add("'$element'");
      }

      viewModel.uploadBunruiItems(
        flag: 'recycling',
        bunruiItems: _list,
        bunrui: 'recycling',
      );

      _ref.watch(videoSearchProvider.notifier).getVideoData();

      backHomeScreen(context: _context);
    }
  }
}

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

final videoRecyclingProvider =
    StateNotifierProvider.autoDispose<VideoRcyclingStateNotifier, List<Video>>(
        (ref) {
  return VideoRcyclingStateNotifier([])..getRecyclingVideo();
});

class VideoRcyclingStateNotifier extends StateNotifier<List<Video>> {
  VideoRcyclingStateNotifier(List<Video> state) : super(state);

  ///
  void getRecyclingVideo() async {
    try {
      String url = "http://toyohide.work/BrainLog/api/getDeletedVideo";
      Map<String, String> headers = {'content-type': 'application/json'};

      Response response = await post(Uri.parse(url), headers: headers);
      final youtubeData = youtubeDataFromJson(response.body);
      state = youtubeData.data;
    } catch (e) {
      throw e.toString();
    }
  }
}

//////////////////////////////////////////////////////////////////////////

final recyclingVideoProvider = StateNotifierProvider.autoDispose<
    RecyclingVideoStateNotifier, BunruiListState>((ref) {
  return RecyclingVideoStateNotifier();
});

class RecyclingVideoStateNotifier extends StateNotifier<BunruiListState> {
  RecyclingVideoStateNotifier()
      : super(
          const BunruiListState(
            youtubeList: [],
            specialList: [],
            selectedList: [],
          ),
        );

  ///
  void addSelectedAry({required String youtubeId}) {
    List<String> _list = [...state.selectedList];

    if (_list.contains(youtubeId)) {
      _list.remove(youtubeId);
    } else {
      _list.add(youtubeId);
    }

    state = state.copyWith(selectedList: _list);
  }

  ///
  void uploadBunruiItems({
    required String flag,
    required List bunruiItems,
    required String bunrui,
  }) async {
    Map<String, dynamic> _uploadData = {};
    _uploadData['bunrui'] = flag;
    _uploadData['youtube_id'] = bunruiItems.join(',');

    String url = "http://toyohide.work/BrainLog/api/bunruiYoutubeData";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode(_uploadData);
    await post(Uri.parse(url), headers: headers, body: body);

    state = state.copyWith(selectedList: []);
  }
}
