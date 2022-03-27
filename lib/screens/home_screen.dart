import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/bunrui.dart';
import '../model/youtube_data.dart';

import '../utilities/utility.dart';

import 'search_screen.dart';
import 'three_days_pickup_screen.dart';
import 'bunrui_setting_screen.dart';
import 'bunrui_list_screen.dart';

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
        leading: IconButton(
          onPressed: () => _goSearchScreen(context: context),
          icon: const Icon(Icons.search),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(FontAwesomeIcons.diceThree),
            onPressed: () => _goThreeDaysPickupScreen(context: context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _goHomeScreen(context: context),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(context: context),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final videoBunrui = ref.watch(videoBunruiProvider);

              final videoList = ref.watch(videoSearchProvider);

              return Column(
                children: [
                  Expanded(
                    child: _bunruiButtonList(
                      context: context,
                      videoBunrui: videoBunrui,
                    ),
                  ),
                  if (videoList.isNotEmpty)
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
      _list.add(
        Card(
          color: Colors.black.withOpacity(0.1),
          child: ListTile(
            onTap: () => _goBunruiListScreen(
              context: context,
              bunrui: element,
            ),
            title: Text(element),
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BunruiListScreen(bunrui: bunrui),
      ),
    );
  }

  ///
  void _goHomeScreen({required BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(),
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
  void _goThreeDaysPickupScreen({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ThreeDaysPickupScreen(),
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
