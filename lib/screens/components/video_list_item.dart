import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/video.dart';

import 'dart:convert';

import 'package:http/http.dart';

class VideoListItem extends ConsumerWidget {
  VideoListItem({Key? key, required this.data, required this.linkDisplay})
      : super(key: key);

  final Video data;
  final bool linkDisplay;

  late WidgetRef _ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    var year = data.getdate.substring(0, 4);
    var month = data.getdate.substring(4, 6);
    var day = data.getdate.substring(6);

    return Stack(
      children: [
        Positioned(
          right: -60,
          top: -60,
          child: Container(
            padding: const EdgeInsets.all(60),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 10,
                color: Colors.redAccent.withOpacity(0.3),
              ),
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          left: -80,
          bottom: -80,
          child: Container(
            padding: const EdgeInsets.all(60),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 10,
                color: Colors.redAccent.withOpacity(0.3),
              ),
              color: Colors.transparent,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/no_image.png',
                        image:
                            'https://img.youtube.com/vi/${data.youtubeId}/mqdefault.jpg',
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 8),
                            child: (data.special == '1')
                                ? const Icon(
                                    Icons.star,
                                    color: Colors.greenAccent,
                                  )
                                : Icon(
                                    Icons.check_box_outline_blank,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                          ),
                          (linkDisplay)
                              ? Container(
                                  alignment: Alignment.topRight,
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => _openBrowser(
                                          youtubeId: data.youtubeId),
                                      child: const Icon(Icons.link),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(data.title),
              const SizedBox(height: 5),
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: data.youtubeId),
                  const TextSpan(text: ' / '),
                  TextSpan(
                    text: data.playtime,
                    style: const TextStyle(color: Colors.yellowAccent),
                  ),
                ]),
              ),
              const SizedBox(height: 5),
              Container(
                alignment: Alignment.topRight,
                child: Text(data.channelTitle),
              ),
              const SizedBox(height: 5),
              Container(
                alignment: Alignment.topRight,
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(text: '$year-$month-$day'),
                    const TextSpan(text: ' / '),
                    TextSpan(
                      text: data.pubdate,
                      style: const TextStyle(
                        color: Colors.yellowAccent,
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///
  void _openBrowser({required String youtubeId}) async {
    final updateVideoPlayedAtViewModel =
        _ref.watch(updateVideoPlayedAtProvider.notifier);

    var url = 'https://youtu.be/$youtubeId';

    if (await canLaunch(url)) {
      updateVideoPlayedAtViewModel.updateVideoPlayedAt(youtubeId: youtubeId);

      await launch(url);
    } else {}
  }
}

/////////////////////////////////////////////////////////////

final updateVideoPlayedAtProvider =
    StateNotifierProvider.autoDispose<UpdateVideoPlayedAtStateNotifier, int>(
        (ref) {
  return UpdateVideoPlayedAtStateNotifier(0);
});

class UpdateVideoPlayedAtStateNotifier extends StateNotifier<int> {
  UpdateVideoPlayedAtStateNotifier(int state) : super(state);

  ///
  void updateVideoPlayedAt({required String youtubeId}) async {
    Map<String, dynamic> _uploadData = {};
    _uploadData['youtube_id'] = youtubeId;
    _uploadData['date'] = DateTime.now().toString().split(' ')[0];

    String url = "http://toyohide.work/BrainLog/api/updateVideoPlayedAt";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode(_uploadData);
    await post(Uri.parse(url), headers: headers, body: body);
  }
}
