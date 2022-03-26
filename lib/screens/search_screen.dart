// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/bunrui.dart';
import '../model/youtube_data.dart';
import '../utilities/utility.dart';

//////////////////////////////////////////////////////////////////////////
class SearchScreen extends StatelessWidget {
  final Utility _utility = Utility();

  final TextEditingController _searchTextController = TextEditingController();

  SearchScreen({Key? key}) : super(key: key);

  String _sText = "";

  ///
  @override
  Widget build(BuildContext context) {
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
                  GestureDetector(
                    onTap: () {
                      _searchTextController.clear();

                      //これはクリアしない
                      // _sText = "";
                      //これはクリアしない
                    },
                    child: const Icon(Icons.clear),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(fontSize: 13),
                      controller: _searchTextController,
                    ),
                  ),

                  //①
                  Consumer(builder: (context, ref, child) {
                    final bunruiSetting =
                        ref.watch(bunruiSettingProvider.state).state;

                    return ElevatedButton(
                      onPressed: () {
                        if (_searchTextController.text == "") {
                          Fluttertoast.showToast(
                            msg: "検索ワードが入力されていません。",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );

                          return;
                        }

                        _sText = _searchTextController.text;

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
                  //①
                ],
              ),

              //----------------------------------------------------

              //②
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

                  bunrui
                      .map(
                        (val) => _dropdownBunrui.add(
                          DropdownMenuItem(
                            value: val,
                            child: Text(
                              val,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      )
                      .toList();

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
              //②

              //----------------------------------------------------

              Divider(
                color: Colors.redAccent.withOpacity(0.3),
                thickness: 2,
              ),
              Expanded(
                //③
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
                //③
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _listItem({required Video video}) {
    var date = video.getdate;
    var year = date.substring(0, 4);
    var month = date.substring(4, 6);
    var day = date.substring(6);

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
                          child: (video.bunrui == 0)
                              ? const Text('----------')
                              : Text(video.bunrui),
                        ),
                      ),

                      //④
                      Consumer(builder: (context, ref, child) {
                        final bunruiSetting =
                            ref.watch(bunruiSettingProvider.state).state;

                        return GestureDetector(
                          onTap: () {
                            ref.watch(videoSearchProvider.notifier).eraseBunrui(
                                  youtubeId: video.youtubeId,
                                  searchText: _sText,
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
                        );
                      }),
                      //④

                      const SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 180,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/no_image.png',
                      image: 'https://img.youtube'
                          '.com/vi/${video.youtubeId}/mqdefault.jpg',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: (video.special == '1')
                        ? const Icon(
                            Icons.star,
                            color: Colors.greenAccent,
                          )
                        : Icon(
                            Icons.check_box_outline_blank,
                            color: Colors.black.withOpacity(0.2),
                          ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                _openBrowser(youtubeId: video.youtubeId),
                            child: const Icon(Icons.link),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title),
                  const SizedBox(height: 5),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: video.youtubeId),
                      const TextSpan(text: ' / '),
                      TextSpan(
                        text: video.playtime,
                        style: const TextStyle(color: Colors.yellowAccent),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(video.channelTitle),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: '$year-$month-$day'),
                        const TextSpan(text: ' / '),
                        TextSpan(
                          text: video.pubdate,
                          style: const TextStyle(color: Colors.yellowAccent),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _openBrowser({required String youtubeId}) async {
    var url = 'https://youtu.be/$youtubeId';

    if (await canLaunch(url)) {
      await launch(url);
    } else {}
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

final bunruiSettingProvider = StateProvider.autoDispose((ref) => '');
