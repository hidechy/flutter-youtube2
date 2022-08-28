import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../model/video.dart';

import '../bunrui_list_screen.dart';
import 'video_list_item.dart';

class CalendarDisplayItem extends ConsumerWidget {
  const CalendarDisplayItem(
      {super.key,
      required this.thisDateData,
      required this.date,
      required this.pubget});

  final List<Video> thisDateData;
  final String date;
  final String pubget;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      title: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: Colors.yellowAccent.withOpacity(0.3),
        ),
        child: Text(
          '$pubget : $date',
          style: const TextStyle(fontSize: 14),
        ),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: thisDateData.map(
              (value) {
                return DefaultTextStyle(
                  style: const TextStyle(fontSize: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //

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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Expanded(child: Container()),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            (value.bunrui == 0)
                                                ? '-----'
                                                : value.bunrui,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BunruiListScreen(
                                                          bunrui: value.bunrui),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 50,
                                              child: const Text('Go'),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.yellowAccent
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //

                      VideoListItem(
                        data: value,
                        linkDisplay: false,
                      ),

                      //

                      GestureDetector(
                        onTap: () {
                          _openBrowser(youtubeId: value.youtubeId);
                        },
                        child: const Icon(Icons.link),
                      ),

                      const Divider(color: Colors.white),
                    ],
                  ),
                );
              },
            ).toList(),
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
