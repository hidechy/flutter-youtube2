import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../data/bunrui_list_state.dart';

import '../model/video.dart';
import '../model/youtube_data.dart';

import '../utilities/utility.dart';

import '../logic/logic.dart';

import 'home_screen.dart';

import 'components/video_list_item.dart';

class BunruiListScreen extends ConsumerWidget {
  BunruiListScreen({Key? key, required this.bunrui}) : super(key: key);

  final String bunrui;

  late WidgetRef _ref;

  final Utility _utility = Utility();
  final _logic = Logic();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

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
            onPressed: () => _goHomeScreen(context: context),
          ),
        ],
      ),
      body: Column(
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
                    onPressed: () => _uploadSpecialItems(context: context),
                    child: const Text('選出変更'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent.withOpacity(0.3),
                    ),
                    onPressed: () {},
//    onPressed: () => _uploadEraseItems(),
                    child: const Text('分類消去'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent.withOpacity(0.3),
                    ),
                    onPressed: () {},
//    onPressed: () => _uploadDeleteItems(),
                    child: const Text('削除'),
                  ),
                ),
              ],
            ),
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
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(color: Colors.white);
      },
    );
  }

  ///
  Widget _listItem({required Video video}) {
    return Card(
      color: _getSelectedBgColor(youtubeId: video.youtubeId),
      child: ListTile(
        leading: GestureDetector(
          onTap: () => _addSelectedAry(youtubeId: video.youtubeId),
          child: const Icon(
            Icons.control_point,
            color: Colors.white,
          ),
        ),
        title: DefaultTextStyle(
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
  void _uploadSpecialItems({required BuildContext context}) async {
    final state = _ref.watch(bunruiListProvider(bunrui));

    if (state.selectedList.isNotEmpty) {
      var _list = [];

      for (var element in state.selectedList) {
        var sp = (state.specialList.contains(element)) ? 0 : 1;
        _list.add("$element|$sp");
      }

      await _logic.uploadBunruiItems(
        bunrui: 'special',
        bunruiItems: _list,
      );
    }

    await new Future.delayed(
      new Duration(seconds: 2),
    );

    _goBunruiListScreen(context: context);
  }

///////////////////////////////////////////////////////

  ///
  void _goHomeScreen({required BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
  }

  void _goBunruiListScreen({required BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BunruiListScreen(
          bunrui: bunrui,
        ),
      ),
    );
  }
}

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
}
