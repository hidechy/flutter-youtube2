import 'package:flutter/material.dart';

import '../../model/video.dart';
import 'video_list_item.dart';

class CalendarDisplayItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AlertDialog(
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: thisDateData.map(
              (value) {
                return Column(
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
                                        child: Text(value.bunrui),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    VideoListItem(
                      data: value,
                      linkDisplay: true,
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.redAccent.withOpacity(0.3),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
