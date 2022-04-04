import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtubeplayer2/screens/components/video_list_item.dart';

import 'dart:convert';

import '../model/youtube_data.dart';
import '../model/video.dart';

import '../utilities/utility.dart';

import '../logic/logic.dart';

import 'home_screen.dart';

class BunruiListScreen extends StatefulWidget {
  const BunruiListScreen({Key? key, required this.bunrui}) : super(key: key);

  final String bunrui;

  @override
  _BunruiListScreenState createState() => _BunruiListScreenState();
}

class _BunruiListScreenState extends State<BunruiListScreen> {
  final Utility _utility = Utility();
  final _logic = Logic();

  List<Video> _youtube = [];

  final List<String> _selectedList = [];

  final List<String> _specialList = [];

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    ////////////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/getYoutubeList";
    Map<String, String> headers = {'content-type': 'application/json'};

    String body = '';
    switch (widget.bunrui) {
      case 'all':
        body = json.encode({"bunrui": ''});
        break;

      default:
        body = json.encode({"bunrui": widget.bunrui});
        break;
    }

    Response response =
        await post(Uri.parse(url), headers: headers, body: body);

    final youtubeData = youtubeDataFromJson(response.body);
    _youtube = youtubeData.data;
    ////////////////////////////////////////
    for (var element in _youtube) {
      if (element.special == '1') {
        _specialList.add(element.youtubeId);
      }
    }

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bunrui),
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
          _utility.getBackGround(context: context),
          Column(
            children: [
              Expanded(child: _movieList()),
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
  Widget _movieList() {
    return ListView.separated(
      itemCount: _youtube.length,
      itemBuilder: (context, int position) => _listItem(position: position),
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(color: Colors.white);
      },
    );
  }

  /// リストアイテム表示
  Widget _listItem({required int position}) {
    return Card(
      color: _getSelectedBgColor(youtubeId: _youtube[position].youtubeId),
      child: ListTile(
        leading: GestureDetector(
          onTap: () => _addSelectedAry(youtubeId: _youtube[position].youtubeId),
          child: const Icon(
            Icons.control_point,
            color: Colors.white,
          ),
        ),
        title: VideoListItem(
          data: Video(
            youtubeId: _youtube[position].youtubeId,
            title: _youtube[position].title,
            url: _youtube[position].url,
            channelId: _youtube[position].channelId,
            channelTitle: _youtube[position].channelTitle,
            playtime: _youtube[position].playtime,
            getdate: _youtube[position].getdate,
            pubdate: _youtube[position].pubdate,
            special: _youtube[position].special,
          ),
        ),
      ),
    );
  }

  ///
  void _addSelectedAry({youtubeId}) {
    if (_selectedList.contains(youtubeId)) {
      _selectedList.remove(youtubeId);
    } else {
      _selectedList.add(youtubeId);
    }

    setState(() {});
  }

  ///
  Color _getSelectedBgColor({youtubeId}) {
    if (_selectedList.contains(youtubeId)) {
      return Colors.greenAccent.withOpacity(0.3);
    } else {
      return Colors.black.withOpacity(0.1);
    }
  }

  ///
  void _uploadDeleteItems() async {
    bool _backHomeScreen = false;

    if (_selectedList.isNotEmpty) {
      var _list = [];
      for (var element in _selectedList) {
        _list.add("'$element'");
      }

      if (_youtube.length == _list.length) {
        _backHomeScreen = true;
      }

      await _logic.uploadBunruiItems(
        bunrui: 'delete',
        bunruiItems: _list,
      );
    }

    (_backHomeScreen) ? _goHomeScreen() : _goBunruiListScreen();
  }

  ///
  void _uploadEraseItems() async {
    bool _backHomeScreen = false;

    if (_selectedList.isNotEmpty) {
      var _list = [];
      for (var element in _selectedList) {
        _list.add("'$element'");
      }

      if (_youtube.length == _list.length) {
        _backHomeScreen = true;
      }

      await _logic.uploadBunruiItems(
        bunrui: 'erase',
        bunruiItems: _list,
      );
    }

    (_backHomeScreen) ? _goHomeScreen() : _goBunruiListScreen();
  }

  ///
  void _openBrowser({required String youtubeId}) async {
    var url = 'https://youtu.be/$youtubeId';

    if (await canLaunch(url)) {
      await launch(url);
    } else {}
  }

  ///
  void _uploadSpecialItems() async {
    if (_selectedList.isNotEmpty) {
      var _list = [];
      for (var element in _selectedList) {
        var sp = (_specialList.contains(element)) ? 0 : 1;

        _list.add("$element|$sp");
      }

      await _logic.uploadBunruiItems(
        bunrui: 'special',
        bunruiItems: _list,
      );
    }

    _goBunruiListScreen();
  }

  ///////////////////////////////////////////////////////
  void _goBunruiListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BunruiListScreen(
          bunrui: widget.bunrui,
        ),
      ),
    );
  }

  ///
  void _goHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
  }
}
