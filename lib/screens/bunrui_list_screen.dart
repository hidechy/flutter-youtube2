// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../data/bunrui_list_state.dart';

import '../model/video.dart';
import '../model/youtube_data.dart';

import '../utilities/utility.dart';

import 'home_screen.dart';

import 'components/video_list_item.dart';

class BunruiListScreen extends ConsumerWidget {
  BunruiListScreen({Key? key, required this.bunrui}) : super(key: key);

  final String bunrui;

  final Utility _utility = Utility();

  late WidgetRef _ref;

  late BuildContext _context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    _context = context;

    final state = ref.watch(bunruiListProvider(bunrui));

    return Scaffold(
      appBar: AppBar(
        title: Text(bunrui),
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
            onPressed: () => _goHomeScreen(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(),
          Column(
            children: [
              if (state.youtubeList.isNotEmpty)
                Expanded(
                  child: _movieList(videoList: state.youtubeList),
                ),
              const Divider(
                color: Colors.redAccent,
                thickness: 3,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent.withOpacity(0.3),
                        ),
                        onPressed: () => _uploadSpecialItems(),
                        child: const Text('選出変更'),
                      ),
                    ),
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
  Widget _movieList({required List<Video> videoList}) {
    return ListView.separated(
      itemCount: videoList.length,
      itemBuilder: (context, int position) =>
          _listItem(video: videoList[position]),
      separatorBuilder: (_, __) {
        return const Divider(color: Colors.white);
      },
    );
  }

  ///
  Widget _listItem({required Video video}) {
    return Card(
      color: _getSelectedBgColor(youtubeId: video.youtubeId),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            Column(
              children: [
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _addSelectedAry(youtubeId: video.youtubeId),
                  child: const Icon(
                    Icons.control_point,
                    color: Colors.white,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  void _addSelectedAry({required String youtubeId}) {
    final viewModel = _ref.watch(bunruiListProvider(bunrui).notifier);
    viewModel.addSelectedAry(youtubeId: youtubeId);
  }

  ///
  Color _getSelectedBgColor({required String youtubeId}) {
    final state = _ref.watch(bunruiListProvider(bunrui));
    if (state.selectedList.contains(youtubeId)) {
      return Colors.greenAccent.withOpacity(0.3);
    } else {
      return Colors.black.withOpacity(0.1);
    }
  }

  ///
  void _uploadSpecialItems() async {
    final state = _ref.watch(bunruiListProvider(bunrui));
    final viewModel = _ref.watch(bunruiListProvider(bunrui).notifier);

    if (state.selectedList.isNotEmpty) {
      var _list = [];

      for (var element in state.selectedList) {
        var sp = (state.specialList.contains(element)) ? 0 : 1;
        _list.add("$element|$sp");
      }

      viewModel.uploadBunruiItems(
        flag: 'special',
        bunruiItems: _list,
        bunrui: bunrui,
      );
    }
  }

  ///
  void _uploadEraseItems() async {
    final state = _ref.watch(bunruiListProvider(bunrui));
    final viewModel = _ref.watch(bunruiListProvider(bunrui).notifier);

    if (state.selectedList.isNotEmpty) {
      bool _backHomeScreen = false;

      var _list = [];
      for (var element in state.selectedList) {
        _list.add("'$element'");
      }

      if (state.youtubeList.length == _list.length) {
        _backHomeScreen = true;
      }

      viewModel.uploadBunruiItems(
        flag: 'erase',
        bunruiItems: _list,
        bunrui: bunrui,
      );

      if (_backHomeScreen) {
        _goHomeScreen();
      }
    }
  }

  ///
  void _uploadDeleteItems() async {
    final state = _ref.watch(bunruiListProvider(bunrui));
    final viewModel = _ref.watch(bunruiListProvider(bunrui).notifier);

    if (state.selectedList.isNotEmpty) {
      bool _backHomeScreen = false;

      var _list = [];
      for (var element in state.selectedList) {
        _list.add("'$element'");
      }

      if (state.youtubeList.length == _list.length) {
        _backHomeScreen = true;
      }

      viewModel.uploadBunruiItems(
        flag: 'delete',
        bunruiItems: _list,
        bunrui: bunrui,
      );

      if (_backHomeScreen) {
        _goHomeScreen();
      }
    }
  }

  ///
  void _goHomeScreen() {
    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

final bunruiListProvider = StateNotifierProvider.autoDispose
    .family<BunruiListStateNotifier, BunruiListState, String>((ref, bunrui) {
  return BunruiListStateNotifier()..getVideoData(bunrui: bunrui);
});

//////////////////////////////////////////////////////////////////////////

class BunruiListStateNotifier extends StateNotifier<BunruiListState> {
  BunruiListStateNotifier()
      : super(
          const BunruiListState(
            youtubeList: [],
            specialList: [],
            selectedList: [],
          ),
        );

  ///
  void getVideoData({required String bunrui}) async {
    try {
      String url = "http://toyohide.work/BrainLog/api/getYoutubeList";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({"bunrui": bunrui});
      Response response =
          await post(Uri.parse(url), headers: headers, body: body);
      final youtubeData = youtubeDataFromJson(response.body);

      //-----------------------------------//
      final specialList = <String>[];
      for (var element in youtubeData.data) {
        if (element.special == '1') {
          specialList.add(element.youtubeId);
        }
      }
      //-----------------------------------//

      state = state.copyWith(
        youtubeList: youtubeData.data,
        specialList: specialList,
      );
    } catch (e) {
      throw e.toString();
    }
  }

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

    getVideoData(bunrui: bunrui);
  }
}
