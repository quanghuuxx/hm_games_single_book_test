// Flutter project by quanghuuxx (quanghuuxx@gmail.com)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quangth_hm_game_test/models/story_detail.dart';
import 'package:quangth_hm_game_test/reading/repository/reading_repository.dart';
import 'package:quangth_hm_game_test/shared/user_provider.dart';

final readingProvider = AutoDisposeNotifierProvider<ReadingProvider, AsyncValue<StoryDetail>>(
  () => ReadingProvider(ReadingRepositoryImpl()), //TODO: implement DI
);

class ReadingProvider extends AutoDisposeNotifier<AsyncValue<StoryDetail>> {
  final ReadingRepository _repository;

  ReadingProvider(this._repository);

  @override
  AsyncValue<StoryDetail> build() {
    return AsyncValue.loading();
  }

  Future<void> fetchStoryDetail() async {
    try {
      final storyDetail = await _repository.getStoryDetail();
      state = AsyncValue.data(storyDetail);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  bool unlockChapter(int chapterId) {
    final storyDetail = state.valueOrNull;
    if (storyDetail == null) throw Exception('Story detail is null');

    final user = ref.read(userProvider);
    if (user.coins < 30) {
      return false;
    }

    final list = List<ChapterDetail>.from(storyDetail.chapters);
    for (var i = 0; i < list.length; i++) {
      if (list[i].orderNum == chapterId) {
        list[i] = list[i].copyWith(unlocked: true);
      }
    }

    ref.read(userProvider.notifier).updateCoins(user.coins - 30);
    state = AsyncValue.data(storyDetail.copyWith(chapters: list));

    return true;
  }
}
