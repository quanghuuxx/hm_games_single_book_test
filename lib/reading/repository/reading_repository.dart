// Flutter project by quanghuuxx (quanghuuxx@gmail.com)

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quangth_hm_game_test/models/story_detail.dart';

abstract class ReadingRepository {
  Future<StoryDetail> getStoryDetail();
}

class ReadingRepositoryImpl implements ReadingRepository {
  @override
  Future<StoryDetail> getStoryDetail() async {
    await Future.delayed(const Duration(seconds: 3));
    final rawJson = await rootBundle.loadString('assets/chapter_data.json');
    final json = jsonDecode(rawJson);
    return StoryDetail.fromJson(json);
  }
}
