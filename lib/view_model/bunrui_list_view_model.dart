import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../data/bunrui_list_state.dart';

import '../model/youtube_data.dart';

final bunruiListProvider = StateNotifierProvider.autoDispose
    .family<BunruiListStateNotifier, BunruiListState, String>((ref, bunrui) {
  return BunruiListStateNotifier()..getVideoData(bunrui: bunrui);
});

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
