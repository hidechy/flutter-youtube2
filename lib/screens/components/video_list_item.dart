import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtubeplayer2/model/youtube_data.dart';

class VideoListItem extends StatefulWidget {
  const VideoListItem({Key? key, required this.data}) : super(key: key);

  final Video data;

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  final List<String> _selectedList = [];

  @override
  Widget build(BuildContext context) {
    var year = widget.data.getdate.substring(0, 4);
    var month = widget.data.getdate.substring(4, 6);
    var day = widget.data.getdate.substring(6);

    return Card(
      color: Colors.black.withOpacity(0.1),
      child: ListTile(
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 180,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/no_image.png',
                      image:
                          'https://img.youtube.com/vi/${widget.data.youtubeId}/mqdefault.jpg',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: (widget.data.special == '1')
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
                      child: GestureDetector(
                        onTap: () =>
                            _openBrowser(youtubeId: widget.data.youtubeId),
                        child: const Icon(Icons.link),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.title),
                  const SizedBox(height: 5),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: widget.data.youtubeId),
                      const TextSpan(text: ' / '),
                      TextSpan(
                        text: widget.data.playtime,
                        style: const TextStyle(color: Colors.yellowAccent),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(widget.data.channelTitle),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: '$year-$month-$day'),
                        const TextSpan(text: ' / '),
                        TextSpan(
                          text: widget.data.pubdate,
                          style: const TextStyle(
                            color: Colors.yellowAccent,
                          ),
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
