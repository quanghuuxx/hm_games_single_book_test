// Flutter project by quanghuuxx (quanghuuxx@gmail.com)

import 'dart:math' show Random, max;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quangth_hm_game_test/components/unlock_chapter_bottomsheet.dart';
import 'package:quangth_hm_game_test/reading/provider/reading_provider.dart';

import '../../models/story_detail.dart';

class ReadingScreen extends ConsumerStatefulWidget {
  const ReadingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  final PageController pageController = PageController();
  final PageStorageBucket bucket = PageStorageBucket();

  Axis scrollDirection = Axis.horizontal;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(readingProvider.notifier).fetchStoryDetail();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(readingProvider)
        .when(
          data: (story) {
            return Scaffold(
              appBar: AppBar(
                title: Text(story.title),
                centerTitle: true,
                actions: [
                  Switch(
                    value: scrollDirection == Axis.vertical,
                    activeColor: Colors.blueAccent,
                    thumbIcon: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Icon(Icons.vertical_distribute, color: Colors.white);
                      }
                      return const Icon(Icons.horizontal_distribute, color: Colors.white);
                    }),
                    onChanged: (v) {
                      setState(() {
                        scrollDirection = v ? Axis.vertical : Axis.horizontal;
                      });
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PageStorage(
                  bucket: bucket,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: story.chapters.length,
                    scrollDirection: scrollDirection,
                    onPageChanged: onPageChanged,
                    itemBuilder: (context, index) {
                      final chapter = story.getChapterByIndex(index);
                      if (!chapter.unlocked) {
                        return const _Placeholder(lines: 12);
                      }

                      return _ReadingBody(index: index, chapter: chapter);
                    },
                  ),
                ),
              ),
            );
          },
          error: (e, _) => Center(child: Text(e.toString())),
          loading:
              () => Material(child: Padding(padding: MediaQuery.paddingOf(context), child: _Placeholder.singleton)),
        );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void jumpToChapter(int index) {
    final chapters = ref.read(readingProvider).valueOrNull?.chapters;
    if (chapters?.isNotEmpty != true) return;

    if (index < 0 || index >= chapters!.length) return;

    pageController.animateToPage(index, duration: Durations.short4, curve: Curves.linear);
  }

  void onPageChanged(int index) {
    final chapter = ref.read(readingProvider).valueOrNull?.getChapterByIndex(index);
    if (chapter == null) return;

    if (!chapter.unlocked) {
      showModalBottomSheet(
        context: context,
        scrollControlDisabledMaxHeightRatio: .4,
        builder: (ctx) {
          return UnlockChapterBottomSheet(
            onUnlock: () {
              onUnlockChapter(chapter.orderNum);
            },
          );
        },
      ).then((result) {
        if (result != true) {
          pageController.previousPage(duration: Durations.short4, curve: Curves.linear);
        }
      });
    }
  }

  void onUnlockChapter(int chapterId) {
    try {
      final result = ref.read(readingProvider.notifier).unlockChapter(chapterId);
      if (!result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Not enough coins'),
            backgroundColor: Colors.redAccent,
            duration: Durations.extralong2,
          ),
        );
      }

      Navigator.pop(context, result);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent));
      Navigator.pop(context, false);
    }
  }
}

class _ReadingBody extends StatelessWidget {
  const _ReadingBody({required this.index, required this.chapter});

  final int index;
  final ChapterDetail chapter;

  @override
  Widget build(BuildContext context) {
    final readingState = context.findAncestorStateOfType<_ReadingScreenState>()!;
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (readingState.scrollDirection == Axis.horizontal) {
          return false;
        }

        if (notification.direction == ScrollDirection.forward &&
            notification.metrics.pixels <= notification.metrics.minScrollExtent) {
          readingState.jumpToChapter(index - 1);
        } else if (notification.direction == ScrollDirection.reverse &&
            notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
          readingState.jumpToChapter(index + 1);
        }
        return true;
      },
      child: SingleChildScrollView(
        key: PageStorageKey<String>('page_storage_chapter_${chapter.orderNum}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(chapter.title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(chapter.rewrittenText, style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text(
              'Chapter ${chapter.orderNum}',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  static const _Placeholder singleton = _Placeholder();

  final int lines;

  const _Placeholder({this.lines = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (i) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 2),
          width: max(Random().nextDouble(), .1) * MediaQuery.sizeOf(context).width,
          height: 24,
          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
        );
      }),
    );
  }
}
