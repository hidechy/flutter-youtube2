// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/video.dart';
import '../utilities/utility.dart';
import '../view_model/youtube_list_view_model.dart';

import 'components/calendar_display_item.dart';

import 'components/functions.dart';

class CalendarGetScreen extends ConsumerWidget {
  CalendarGetScreen({Key? key}) : super(key: key);

  final DateTime _currentDate = DateTime.now();

  final EventList<Event> _markedDateMap = EventList(events: {});

  final Utility _utility = Utility();

  List<Video> videoList = [];

  late BuildContext _context;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _context = context;

    ////////////////////////////////
    var exCurrentDate = _currentDate.toString().split(' ');

    var exDate = exCurrentDate[0].split('-');

    final videoHistoryState = ref.watch(videoHistoryProvider);
    videoList = videoHistoryState;

    for (var i = 0; i < videoHistoryState.length; i++) {
      var year = videoHistoryState[i].getdate.substring(0, 4);
      var exGetDate = [year];

      if (exGetDate[0] == exDate[0]) {
        _markedDateMap.add(
          DateTime.parse(videoHistoryState[i].getdate),
          Event(
            date: DateTime.parse(videoHistoryState[i].getdate),
            icon: const Icon(Icons.star),
          ),
        );
      }
    }

    ////////////////////////////////

    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Calendar'),
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
            onPressed: () {
              backHomeScreen(context: context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(context: context),
          Column(
            children: [
              Expanded(
                child: CalendarCarousel<Event>(
                  minSelectedDate: DateTime(2022, 1, 1),
                  markedDatesMap: _markedDateMap,
                  locale: 'JA',
                  todayBorderColor: Colors.orangeAccent.withOpacity(0.8),
                  todayButtonColor: Colors.orangeAccent.withOpacity(0.1),
                  selectedDayButtonColor: Colors.greenAccent.withOpacity(0.1),
                  thisMonthDayBorderColor: Colors.grey,
                  weekendTextStyle:
                      const TextStyle(fontSize: 16.0, color: Colors.red),
                  weekdayTextStyle: const TextStyle(color: Colors.grey),
                  dayButtonColor: Colors.black.withOpacity(0.3),
                  onDayPressed: onDayPressed,
                  weekFormat: false,
                  selectedDateTime: _currentDate,
                  daysHaveCircularBorder: false,
                  customGridViewPhysics: const NeverScrollableScrollPhysics(),
                  daysTextStyle:
                      const TextStyle(fontSize: 16.0, color: Colors.white),
                  todayTextStyle:
                      const TextStyle(fontSize: 16.0, color: Colors.white),
                  headerTextStyle: const TextStyle(fontSize: 18.0),
                  onCalendarChanged: onCalendarChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  void onDayPressed(DateTime date, List<Event> events) {
    var exDate = date.toString().split(' ');

    final thisDateData = getThisDateData(date: exDate[0]);

    if (thisDateData.isEmpty) {
      Fluttertoast.showToast(
        msg: "No Data.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.yellowAccent.withOpacity(0.3),
      );

      return;
    }

    showDialog(
      context: _context,
      builder: (_) {
        return CalendarDisplayItem(
          pubget: 'get',
          date: exDate[0],
          thisDateData: thisDateData,
        );
      },
    );
  }

  ///
  List<Video> getThisDateData({required String date}) {
    List<Video> list = [];

    for (var i = 0; i < videoList.length; i++) {
      if (date.replaceAll('-', '') == videoList[i].getdate) {
        list.add(videoList[i]);
      }
    }

    return list;
  }

  ///
  void onCalendarChanged(DateTime date) async {}
}
