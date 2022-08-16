// ignore_for_file: must_be_immutable

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/video.dart';
import '../utilities/utility.dart';
import '../view_model/youtube_list_view_model.dart';

import 'components/calendar_display_item.dart';
import 'components/functions.dart';

class CalendarGetScreen extends ConsumerWidget {
  CalendarGetScreen({Key? key}) : super(key: key);

  final Utility _utility = Utility();

  Map<DateTime, List> eventsList = {};

  late WidgetRef _ref;
  late BuildContext _context;

  ///
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;
    _context = context;

    final focusDayState = ref.watch(focusDayProvider);
    final focusDayViewModel = ref.watch(focusDayProvider.notifier);
    focusDayViewModel.setDateTime(dateTime: DateTime.now());

    final selectedDayViewModel = ref.watch(selectedDayProvider.notifier);

    final videoHistoryState = ref.watch(videoHistoryProvider);

    //--------------------------------------------- event
    var keepYmd = '';
    for (var i = 0; i < videoHistoryState.length; i++) {
      var exGetDate = videoHistoryState[i].getdate.toString().split(' ');

      if (exGetDate[0] != keepYmd) {
        eventsList[DateTime.parse(exGetDate[0])] = [];
      }

      eventsList[DateTime.parse(exGetDate[0])]?.add(exGetDate[0]);

      keepYmd = exGetDate[0];
    }

    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventsList);

    List getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }
    //--------------------------------------------- event

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
          _utility.getBackGround(),
          Column(
            children: [
              TableCalendar(
                eventLoader: getEventForDay,

                ///
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(color: Colors.transparent),
                  selectedDecoration: BoxDecoration(
                    color: Colors.indigo,
                    shape: BoxShape.circle,
                  ),

                  ///
                  rangeHighlightColor: Color(0xFFBBDDFF),

                  ///
                  todayTextStyle: TextStyle(color: Color(0xFFFAFAFA)),
                  selectedTextStyle: TextStyle(color: Color(0xFFFAFAFA)),
                  rangeStartTextStyle: TextStyle(color: Color(0xFFFAFAFA)),
                  rangeEndTextStyle: TextStyle(color: Color(0xFFFAFAFA)),
                  disabledTextStyle: TextStyle(color: Colors.grey),
                  holidayTextStyle: TextStyle(color: Color(0xFF5C6BC0)),
                  weekendTextStyle: TextStyle(color: Colors.white),

                  ///
                  markerDecoration: BoxDecoration(color: Colors.white),
                  rangeStartDecoration: BoxDecoration(color: Color(0xFF6699FF)),
                  rangeEndDecoration: BoxDecoration(color: Color(0xFF6699FF)),
                  holidayDecoration: BoxDecoration(
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Color(0xFF9FA8DA),
                      ),
                    ),
                  ),
                ),

                ///
                headerStyle: const HeaderStyle(formatButtonVisible: false),
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: focusDayState,

                ///
                selectedDayPredicate: (day) {
                  return isSameDay(ref.watch(selectedDayProvider), day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  selectedDayViewModel.setDateTime(dateTime: selectedDay);
                  focusDayViewModel.setDateTime(dateTime: focusedDay);

                  onDayPressed(date: selectedDay);
                },

                onPageChanged: (focusedDay) {
                  focusedDay = focusedDay;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  void onDayPressed({required DateTime date}) {
    var exDate = date.toString().split(' ');

    final videoHistoryState = _ref.watch(videoHistoryProvider);

    List<Video> thisDateData = [];
    for (var i = 0; i < videoHistoryState.length; i++) {
      if (exDate[0].replaceAll('-', '') == videoHistoryState[i].getdate) {
        thisDateData.add(videoHistoryState[i]);
      }
    }

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
        return Dialog(
          backgroundColor: Colors.blueGrey.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          insetPadding: EdgeInsets.all(30),
          child: CalendarDisplayItem(
            pubget: 'get',
            date: exDate[0],
            thisDateData: thisDateData,
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////

final focusDayProvider =
    StateNotifierProvider.autoDispose<FocusDayStateNotifier, DateTime>((ref) {
  return FocusDayStateNotifier();
});

class FocusDayStateNotifier extends StateNotifier<DateTime> {
  FocusDayStateNotifier() : super(DateTime.now());

  ///
  void setDateTime({required DateTime dateTime}) async {
    state = dateTime;
  }
}

////////////////////////////////////////////////////////////

final selectedDayProvider =
    StateNotifierProvider.autoDispose<SelectedDayStateNotifier, DateTime>(
        (ref) {
  return SelectedDayStateNotifier();
});

class SelectedDayStateNotifier extends StateNotifier<DateTime> {
  SelectedDayStateNotifier() : super(DateTime.now());

  ///
  void setDateTime({required DateTime dateTime}) async {
    state = dateTime;
  }
}
