import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/calendar_get_screen.dart';
import 'screens/calendar_publish_screen.dart';
import 'screens/remove_video_select_screen.dart';
import 'screens/search_screen.dart';
import 'screens/special_video_screen.dart';
import 'screens/video_recycling_screen.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      routes: <String, WidgetBuilder>{
        '/': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/special': (context) => SpecialVideoScreen(),
        '/remove': (context) => RemoveVideoSelectScreen(),
        '/recycle': (context) => VideoRecyclingScreen(),
        '/calendar_publish': (context) => CalendarPublishScreen(),
        '/calendar_get': (context) => CalendarGetScreen(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
