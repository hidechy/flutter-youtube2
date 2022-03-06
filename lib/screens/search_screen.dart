// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  Consumer(
                    builder: (context, ref, child) => ElevatedButton(
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
                            searchText: _searchTextController.text);
                      },
                      child: const Text('Search'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent.withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
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
                      Consumer(
                        builder: (context, ref, child) => GestureDetector(
                          onTap: () {
                            ref.watch(videoSearchProvider.notifier).eraseBunrui(
                                  youtubeId: video.youtubeId,
                                  searchText: _sText,
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
                      ),
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
  void getVideoData({required String searchText}) async {
    try {
      String url = "http://toyohide.work/BrainLog/api/getYoutubeList";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({"bunrui": "search", "word": searchText});
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
      {required String youtubeId, required String searchText}) async {
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

      getVideoData(searchText: searchText);
    } catch (e) {
      throw e.toString();
    }
  }
}
