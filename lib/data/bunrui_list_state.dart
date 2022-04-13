import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/video.dart';

part 'bunrui_list_state.freezed.dart';

@freezed
class BunruiListState with _$BunruiListState {
  const factory BunruiListState({
    required List<Video> youtubeList,
    required List<String> specialList,
    required List<String> selectedList,
  }) = _BunruiListState;
}
