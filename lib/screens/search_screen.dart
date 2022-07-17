// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../model/bunrui.dart';
import '../model/youtube_data.dart';
import '../model/video.dart';

import '../utilities/utility.dart';

import './components/video_list_item.dart';
import 'bunrui_list_screen.dart';

//////////////////////////////////////////////////////////////////////////
class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final Utility _utility = Utility();

  final TextEditingController _searchTextController = TextEditingController();

  late BuildContext _context;

  ///
  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Search'),
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
          Column(
            children: [
              Row(
                children: [
                  //(5)
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      return GestureDetector(
                        onTap: () {
                          _searchTextController.clear();

                          ref.watch(bunruiSettingProvider.state).state = "";

                          //これはクリアしない
                          // _sText = "";
                          //これはクリアしない
                        },
                        child: const Icon(Icons.clear),
                      );
                    },
                  ),
                  //(5)

                  const SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(fontSize: 13),
                      controller: _searchTextController,
                    ),
                  ),

                  //(1)
                  Consumer(builder: (context, ref, child) {
                    final bunruiSetting =
                        ref.watch(bunruiSettingProvider.state).state;

                    return ElevatedButton(
                      onPressed: () {
                        if (_searchTextController.text == "") {
                          // Fluttertoast.showToast(
                          //   msg: "検索ワードが入力されていません。",
                          //   toastLength: Toast.LENGTH_SHORT,
                          //   gravity: ToastGravity.CENTER,
                          // );

                          return;
                        }

                        ref.watch(videoSearchProvider.notifier).getVideoData(
                              searchText: _searchTextController.text,
                              searchBunrui: bunruiSetting,
                            );
                      },
                      child: const Text('Search'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent.withOpacity(0.3),
                      ),
                    );
                  }),
                  //(1)
                ],
              ),

              //----------------------------------------------------

              //(2)
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final bunruiSetting =
                      ref.watch(bunruiSettingProvider.state).state;

                  final bunrui = ref.watch(videoBunruiProvider);

                  List<DropdownMenuItem<String>> _dropdownBunrui = [];

                  _dropdownBunrui.add(
                    const DropdownMenuItem(
                      value: '',
                      child: Text(''),
                    ),
                  );

                  bunrui.map(
                    (val) {
                      var exVal = (val).split('|');

                      _dropdownBunrui.add(
                        DropdownMenuItem(
                          value: exVal[0],
                          child: Text(
                            exVal[0],
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      );
                    },
                  ).toList();

                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.topRight,
                        child: DropdownButton(
                          dropdownColor: Colors.black.withOpacity(0.1),
                          items: _dropdownBunrui,
                          value: bunruiSetting,
                          onChanged: (value) {
                            ref.watch(bunruiSettingProvider.state).state =
                                value.toString();
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              //(2)

              //----------------------------------------------------

              Divider(
                color: Colors.redAccent.withOpacity(0.3),
                thickness: 2,
              ),
              Expanded(
                //(3)
                child: Consumer(
                  builder: (context, ref, child) {
                    final videoList = ref.watch(videoSearchProvider);

                    return ListView.separated(
                      itemBuilder: (context, index) =>
                          _listItem(video: videoList[index]),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(color: Colors.white),
                      itemCount: ref.watch(videoSearchProvider).length,
                    );
                  },
                ),
                //(3)
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _listItem({required Video video}) {
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
                        //(4)
                        child: Consumer(builder: (context, ref, child) {
                          final bunruiSetting =
                              ref.watch(bunruiSettingProvider.state).state;

                          final searchWord =
                              ref.watch(searchWordProvider.state).state;

                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                ref
                                    .watch(videoSearchProvider.notifier)
                                    .eraseBunrui(
                                      youtubeId: video.youtubeId,
                                      searchText: searchWord,
                                      searchBunrui: bunruiSetting,
                                    );
                              },
                              child: Container(
                                width: 50,
                                child: const Text('Del'),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          );
                        }),
                        //(4)
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          alignment: Alignment.center,
                          child: (video.bunrui == 0)
                              ? const Text('----------')
                              : Text(video.bunrui),
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
                                      BunruiListScreen(bunrui: video.bunrui),
                                ),
                              );
                            },
                            child: Container(
                              width: 50,
                              child: const Text('Go'),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.yellowAccent.withOpacity(0.5),
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
  return VideoSearchStateNotifier([]);
});

//////////////////////////////////////////////////////////////////////////
class VideoSearchStateNotifier extends StateNotifier<List<Video>> {
  VideoSearchStateNotifier(List<Video> state) : super(state);

  ///
  void getVideoData({
    required String searchText,
    required String searchBunrui,
  }) async {
    try {
      String url = "http://toyohide.work/BrainLog/api/getYoutubeList";
      Map<String, String> headers = {'content-type': 'application/json'};

      String body = "";
      if (searchBunrui == "") {
        body = json.encode({"bunrui": "search", "word": searchText});
      } else {
        body = json.encode({
          "bunrui": "search",
          "word": searchText,
          "searchBunrui": searchBunrui,
        });
      }

      Response response =
          await post(Uri.parse(url), headers: headers, body: body);
      final youtubeData = youtubeDataFromJson(response.body);
      state = youtubeData.data;
    } catch (e) {
      throw e.toString();
    }
  }

  ///
  void eraseBunrui(
      {required String youtubeId,
      required String searchText,
      required String searchBunrui}) async {
    try {
      List bunruiItems = [];
      bunruiItems.add("'$youtubeId'");

      Map<String, dynamic> _uploadData = {};
      _uploadData['bunrui'] = 'erase';
      _uploadData['youtube_id'] = bunruiItems.join(',');

      String url = "http://toyohide.work/BrainLog/api/bunruiYoutubeData";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode(_uploadData);

      await post(Uri.parse(url), headers: headers, body: body);

      getVideoData(
        searchText: searchText,
        searchBunrui: searchBunrui,
      );
    } catch (e) {
      throw e.toString();
    }
  }
}

//////////////////////////////////////////////////////////////////////////
final searchWordProvider = StateProvider.autoDispose((ref) => '');

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
final bunruiSettingProvider = StateProvider.autoDispose((ref) => '');
