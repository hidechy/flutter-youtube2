// ignore_for_file: must_be_immutable

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities/utility.dart';

import '../view_model/video_bunrui_view_model.dart';

import 'bunrui_list_screen.dart';
import 'bunrui_setting_screen.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  final Utility _utility = Utility();

  late BuildContext _context;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _context = context;

    final videoBunruiState = ref.watch(videoBunruiProvider);

    final videoSearchState = ref.watch(videoSearchProvider);
    final videoSearchViewModel = ref.watch(videoSearchProvider.notifier);

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

        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/calendar_get');
                  },
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      children: const [
                        Icon(Icons.calendar_today_sharp),
                        Text('Get'),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/calendar_publish');
                  },
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      children: const [
                        Icon(Icons.calendar_today_sharp),
                        Text('Publish'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
            onPressed: () {
              Navigator.pushNamed(context, '/recycle');
            },
          ),
          IconButton(
            icon: const Icon(Icons.star, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/special');
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/remove');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.yellowAccent),
            onPressed: () {
              videoSearchViewModel.getVideoData();

              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),

      //

      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(context: context),
          Column(
            children: [
              Expanded(
                child: _bunruiButtonList(videoBunrui: videoBunruiState),
              ),
              Column(
                children: [
                  getDotLine(),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent.withOpacity(0.3),
                      ),
                      onPressed: () {
                        _goBunruiSettingScreen(bunrui: 'undefined');
                      },
                      child: Row(
                        children: [
                          const Text('分類する'),
                          const SizedBox(width: 20),
                          Container(
                            width: 30,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              videoSearchState.length.toString(),
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget getDotLine() {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(
                    (constraints.constrainWidth() / 30).floor(),
                    (index) {
                      return const SizedBox(
                        width: 5,
                        height: 3,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 20,
          width: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
        )
      ],
    );
  }

  ///
  Widget _bunruiButtonList({required List<String> videoBunrui}) {
    if (videoBunrui.isEmpty) {
      return Container();
    }

    List<Widget> _list = [];

    for (var element in videoBunrui) {
      var exElement = (element).split('|');

      _list.add(
        InkWell(
          onTap: () {
            _goBunruiListScreen(bunrui: element);
          },
          child: Stack(
            children: [
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

              //

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

              //

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
  void _goBunruiSettingScreen({required String bunrui}) {
    Navigator.push(
      _context,
      MaterialPageRoute(
        builder: (_) {
          return BunruiSettingScreen(bunrui: bunrui);
        },
      ),
    );
  }

  ///
  void _goBunruiListScreen({required String bunrui}) {
    var exBunrui = (bunrui).split('|');

    Navigator.push(
      _context,
      MaterialPageRoute(
        builder: (_) {
          return BunruiListScreen(bunrui: exBunrui[0]);
        },
      ),
    );
  }
}
