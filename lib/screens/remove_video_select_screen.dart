// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../data/bunrui_list_state.dart';

import '../utilities/utility.dart';

import '../model/video.dart';

import '../view_model/youtube_list_view_model.dart';
import 'components/video_list_item.dart';

class RemoveVideoSelectScreen extends ConsumerWidget {
  RemoveVideoSelectScreen({Key? key}) : super(key: key);

  final Utility _utility = Utility();

  late WidgetRef _ref;
  late BuildContext _context;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;
    _context = context;

    var removeVideoYearState = ref.watch(removeVideoYearProvider);

    final now = DateTime.now();
    var exNow = now.toString().split('-');

    if (removeVideoYearState == 0) {
      removeVideoYearState = int.parse(exNow[0]);
    }

    var removeVideoYearViewModel = ref.watch(removeVideoYearProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Remove Old Video'),
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
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(context: context),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 15),
                      child: Slider(
                        value: double.parse(removeVideoYearState.toString()),
                        min: 2015,
                        max: double.parse(exNow[0]),
                        onChanged: (double value) {
                          var exValue = value.toString().split('.');

                          removeVideoYearViewModel.setYear(
                            year: int.parse(exValue[0]),
                          );
                        },
                      ),
                    ),
                    Text(removeVideoYearState.toString()),
                  ],
                ),
              ),
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent.withOpacity(0.3),
                        ),
                        onPressed: () => _uploadEraseItems(),
                        child: const Text('分類消去'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent.withOpacity(0.3),
                        ),
                        onPressed: () => _uploadDeleteItems(),
                        child: const Text('削除'),
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
  void _uploadEraseItems() async {
    final state = _ref.watch(removeVideoProvider);
    final viewModel = _ref.watch(removeVideoProvider.notifier);

    if (state.selectedList.isNotEmpty) {
      var _list = [];
      for (var element in state.selectedList) {
        _list.add("'$element'");
      }

      viewModel.uploadBunruiItems(
        flag: 'erase',
        bunruiItems: _list,
        bunrui: 'erase',
      );

      Navigator.pop(_context);
    }
  }

  ///
  void _uploadDeleteItems() async {
    final state = _ref.watch(removeVideoProvider);
    final viewModel = _ref.watch(removeVideoProvider.notifier);

    if (state.selectedList.isNotEmpty) {
      var _list = [];
      for (var element in state.selectedList) {
        _list.add("'$element'");
      }

      viewModel.uploadBunruiItems(
        flag: 'delete',
        bunruiItems: _list,
        bunrui: 'delete',
      );

      Navigator.pop(_context);
    }
  }

  ///
  Widget _getVideoList() {
    List<Video> videoList = _getYearVideoList();

    final DateTime threeDaysAgo =
        DateTime.now().add(const Duration(days: 3) * -1);

    return ListView.separated(
      itemBuilder: (_context, index) {
        var video = videoList[index];

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
                          linkDisplay: true,
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
      itemCount: videoList.length,
    );
  }

  ///
  List<Video> _getYearVideoList() {
    List<Video> list = [];

    var removeVideoYearState = _ref.watch(removeVideoYearProvider);

    final now = DateTime.now();
    var exNow = now.toString().split('-');

    if (removeVideoYearState == 0) {
      removeVideoYearState = int.parse(exNow[0]);
    }

    final videoHistoryState = _ref.watch(videoHistoryProvider);

    for (var i = 0; i < videoHistoryState.length; i++) {
      var exPubDate = videoHistoryState[i].pubdate.split('-');

      if (exPubDate[0] == removeVideoYearState.toString()) {
        list.add(videoHistoryState[i]);
      }
    }

    return list;
  }

  ///
  void _addSelectedAry({required String youtubeId}) {
    final viewModel = _ref.watch(removeVideoProvider.notifier);
    viewModel.addSelectedAry(youtubeId: youtubeId);
  }

  ///
  Color _getSelectedBgColor({required String youtubeId}) {
    final state = _ref.watch(removeVideoProvider);
    if (state.selectedList.contains(youtubeId)) {
      return Colors.greenAccent.withOpacity(0.3);
    } else {
      return Colors.black.withOpacity(0.1);
    }
  }
}

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

final removeVideoYearProvider =
    StateNotifierProvider.autoDispose<RemoveVideoYearStateNotifier, int>((ref) {
  return RemoveVideoYearStateNotifier(0);
});

class RemoveVideoYearStateNotifier extends StateNotifier<int> {
  RemoveVideoYearStateNotifier(int state) : super(state);

  ///
  void setYear({required int year}) async {
    state = year;
  }
}

//////////////////////////////////////////////////////////////////////////

final removeVideoProvider = StateNotifierProvider.autoDispose<
    RemoveVideoStateNotifier, BunruiListState>((ref) {
  return RemoveVideoStateNotifier();
});

class RemoveVideoStateNotifier extends StateNotifier<BunruiListState> {
  RemoveVideoStateNotifier()
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
