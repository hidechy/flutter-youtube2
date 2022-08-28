import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart';

import '../model/video.dart';
import 'components/functions.dart';
import 'components/video_list_item.dart';

import '../utilities/utility.dart';

class SpecialVideoScreen extends ConsumerWidget {
  SpecialVideoScreen({Key? key}) : super(key: key);

  final ScrollController _controller = ScrollController();

  final Utility _utility = Utility();

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialVideoState = ref.watch(specialVideoProvider);

    var specialVideoData = makeSpecialVideoData(data: specialVideoState);

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
            onPressed: () {
              backHomeScreen(context: context);
            },
            icon: const Icon(Icons.close),
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
                child: GroupedListView<dynamic, dynamic>(
                  controller: _controller,
                  padding: EdgeInsets.zero,
                  elements: specialVideoState,
                  groupBy: (item) => item['group'],
                  groupSeparatorBuilder: (groupValue) {
                    return DefaultTextStyle(
                      style: const TextStyle(fontSize: 12),
                      child: Container(
                        color: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(groupValue),
                            Text(specialVideoData[groupValue]['count']
                                .toString()),
                          ],
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, item) {
                    return _displayItems(data: item['item']);
                  },
                  groupComparator: (group1, group2) => group1.compareTo(group2),
                  itemComparator: (item1, item2) =>
                      item1['date'].compareTo(item2['date']),
                  useStickyGroupSeparators: true,
                  floatingHeader: false,
                  order: GroupedListOrder.ASC,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Map<dynamic, dynamic> makeSpecialVideoData({required List data}) {
    Map<dynamic, dynamic> map = {};

    for (var i = 0; i < data.length; i++) {
      map[data[i]['bunrui']] = {
        'count': data[i]['count'],
        'item': data[i]['item'],
      };
    }

    return map;
  }

  ///
  Widget _displayItems({required data}) {
    List<Widget> list = [];

    for (var i = 0; i < data.length; i++) {
      list.add(
        Column(
          children: [
            VideoListItem(
              data: Video(
                youtubeId: data[i]['youtube_id'],
                title: data[i]['title'],
                getdate: data[i]['getdate'],
                url: data[i]['url'],
                pubdate: data[i]['pubdate'],
                channelId: data[i]['channel_id'],
                channelTitle: data[i]['channel_title'],
                playtime: data[i]['playtime'],
              ),
              linkDisplay: true,
            ),
            Divider(
              thickness: 2,
              color: Colors.redAccent.withOpacity(0.3),
            ),
          ],
        ),
      );
    }

    return Column(
      children: list,
    );
  }
}

//////////////////////////////////////////////////////////////////////
final specialVideoProvider =
    StateNotifierProvider.autoDispose<SpecialVideoStateNotifier, List<dynamic>>(
        (ref) {
  return SpecialVideoStateNotifier([])..getSpecialVideo();
});

class SpecialVideoStateNotifier extends StateNotifier<List<dynamic>> {
  SpecialVideoStateNotifier(List<dynamic> state) : super([]);

  void getSpecialVideo() async {
    String url = "http://toyohide.work/BrainLog/api/getSpecialVideo";
    Map<String, String> headers = {'content-type': 'application/json'};
    Response response = await post(Uri.parse(url), headers: headers);

    var specialVideo = jsonDecode(response.body);

    List<dynamic> _list = [];

    for (var i = 0; i < specialVideo['data'].length; i++) {
      List<Map<dynamic, dynamic>> _item = [];
      for (var j = 0; j < specialVideo['data'][i]['item'].length; j++) {
        Map _map2 = {};
        _map2['youtube_id'] =
            specialVideo['data'][i]['item'][j]['youtube_id'] ?? "";
        _map2['title'] = specialVideo['data'][i]['item'][j]['title'] ?? "";
        _map2['getdate'] = specialVideo['data'][i]['item'][j]['getdate'] ?? "";
        _map2['url'] = specialVideo['data'][i]['item'][j]['url'] ?? "";
        _map2['pubdate'] = specialVideo['data'][i]['item'][j]['pubdate'] ?? "";
        _map2['channel_id'] =
            specialVideo['data'][i]['item'][j]['channel_id'] ?? "";
        _map2['channel_title'] =
            specialVideo['data'][i]['item'][j]['channel_title'] ?? "";
        _map2['playtime'] =
            specialVideo['data'][i]['item'][j]['playtime'] ?? "";
        _map2['special'] = specialVideo['data'][i]['item'][j]['special'] ?? "";
        _item.add(_map2);
      }

      Map _map = {};
      _map['bunrui'] = specialVideo['data'][i]['bunrui'] ?? '';
      _map['count'] = specialVideo['data'][i]['count'] ?? 0;
      _map['item'] = _item;
      _map['group'] = specialVideo['data'][i]['bunrui'];
      _list.add(_map);
    }

    state = _list;
  }
}
