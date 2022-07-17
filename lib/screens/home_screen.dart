import 'dart:convert';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:youtubeplayer2/screens/video_recycling_screen.dart';

import '../model/bunrui.dart';
import '../model/youtube_data.dart';
import '../model/video.dart';

import '../utilities/utility.dart';

import 'search_screen.dart';
import 'bunrui_setting_screen.dart';
import 'bunrui_list_screen.dart';
import 'special_video_screen.dart';

import 'remove_video_select_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final Utility _utility = Utility();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Category'),
        backgroundColor: Colors.redAccent.withOpacity(0.3),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: const Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: const <Widget>[],
      ),

      //

      floatingActionButton: FabCircularMenu(
        ringColor: Colors.redAccent.withOpacity(0.3),
        fabOpenColor: Colors.redAccent.withOpacity(0.3),
        fabCloseColor: Colors.pinkAccent.withOpacity(0.3),
        ringWidth: 10,
        ringDiameter: 250,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.recycling, color: Colors.purpleAccent),
            onPressed: () => _goVideoRecyclingScreen(context: context),
          ),
          IconButton(
            icon: const Icon(Icons.star, color: Colors.white),
            onPressed: () => _goSpecialVideoScreen(context: context),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward, color: Colors.white),
            onPressed: () => _goRemoveVideoSelectScreen(context: context),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _goSearchScreen(context: context),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final videoBunruiViewModel =
                  ref.watch(videoBunruiProvider.notifier);

              return IconButton(
                icon: const Icon(Icons.refresh, color: Colors.yellowAccent),
                onPressed: () {
                  videoBunruiViewModel.getVideoBunrui();
                },
              );
            },
          ),
        ],
      ),

      //

      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(context: context),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final videoBunrui = ref.watch(videoBunruiProvider);

              return Column(
                children: [
                  Expanded(
                    child: _bunruiButtonList(
                      context: context,
                      videoBunrui: videoBunrui,
                    ),
                  ),
                  Column(
                    children: [
                      const Divider(
                        color: Colors.redAccent,
                        thickness: 3,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent.withOpacity(0.3),
                          ),
                          onPressed: () => _goBunruiSettingScreen(
                              context: context, bunrui: 'undefined'),
                          child: const Text('分類する'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  ///
  Widget _bunruiButtonList({
    required List<String> videoBunrui,
    required BuildContext context,
  }) {
    if (videoBunrui.isEmpty) {
      return Container();
    }

    List<Widget> _list = [];

    for (var element in videoBunrui) {
      var exElement = (element).split('|');

      _list.add(
        InkWell(
          onTap: () => _goBunruiListScreen(
            context: context,
            bunrui: element,
          ),
          child: Stack(
            children: [
              //--------------------
              // ずれた半円

              Positioned(
                right: -50,
                top: -40,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 5,
                      color: Colors.redAccent.withOpacity(0.5),
                    ),
                    color: Colors.transparent,
                  ),
                ),
              ),

              Positioned(
                left: -50,
                bottom: -40,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 5,
                      color: Colors.redAccent.withOpacity(0.5),
                    ),
                    color: Colors.transparent,
                  ),
                ),
              ),

              //--------------------

              Container(
                padding: const EdgeInsets.only(top: 20, left: 50, bottom: 20),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                ),
                width: double.infinity,
                child: Text(
                  exElement[0],
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _list,
      ),
    );
  }

  /////////////////////////////////////
  ///
  void _goBunruiSettingScreen({
    required String bunrui,
    required BuildContext context,
  }) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BunruiSettingScreen(bunrui: bunrui),
      ),
    );
  }

  ///
  void _goBunruiListScreen({
    required String bunrui,
    required BuildContext context,
  }) {
    var exBunrui = (bunrui).split('|');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BunruiListScreen(bunrui: exBunrui[0]),
      ),
    );
  }

  ///
  void _goSearchScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(),
      ),
    );
  }

  ///
  void _goSpecialVideoScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SpecialVideoScreen(),
      ),
    );
  }

  ///
  void _goRemoveVideoSelectScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RemoveVideoSelectScreen(),
      ),
    );
  }

  ///
  void _goVideoRecyclingScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoRecyclingScreen(),
      ),
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
final videoSearchProvider =
    StateNotifierProvider.autoDispose<VideoSearchStateNotifier, List<Video>>(
        (ref) {
  return VideoSearchStateNotifier([])..getVideoData();
});

//////////////////////////////////////////////////////////////////////////
class VideoSearchStateNotifier extends StateNotifier<List<Video>> {
  VideoSearchStateNotifier(List<Video> state) : super(state);

  ///
  void getVideoData() async {
    try {
      String url = "http://toyohide.work/BrainLog/api/getYoutubeList";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({"bunrui": 'blank'});
      Response response =
          await post(Uri.parse(url), headers: headers, body: body);
      final youtubeData = youtubeDataFromJson(response.body);
      state = youtubeData.data;
    } catch (e) {
      throw e.toString();
    }
  }
}
