// Flutter project by quanghuuxx (quanghuuxx@gmail.com)

import 'package:equatable/equatable.dart';

class StoryDetail extends Equatable {
  final int id;
  final String title;
  final List<String> tags;
  final List<ChapterDetail> chapters;

  const StoryDetail({required this.id, required this.title, required this.tags, required this.chapters});

  factory StoryDetail.fromJson(Map<String, dynamic> json) {
    return StoryDetail(
      id: json['id'],
      title: json['title'],
      tags: List<String>.from(json['tags']),
      chapters: List<ChapterDetail>.from(json['chapters'].map((x) => ChapterDetail.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [id, title, tags, chapters];

  StoryDetail copyWith({int? id, String? title, List<String>? tags, List<ChapterDetail>? chapters}) {
    return StoryDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      tags: tags ?? this.tags,
      chapters: chapters ?? this.chapters,
    );
  }

  ChapterDetail getChapterByIndex(int index) {
    final chapter = chapters[index];
    if (index == 0 && !chapter.unlocked) {
      return chapters[index] = chapter.copyWith(unlocked: true);
    }

    return chapter;
  }
}

class ChapterDetail extends Equatable {
  final int orderNum;
  final String title;
  final String rewrittenText;
  final bool unlocked;

  const ChapterDetail({
    required this.orderNum,
    required this.title,
    required this.rewrittenText,
    this.unlocked = false,
  });

  factory ChapterDetail.fromJson(Map<String, dynamic> json) {
    return ChapterDetail(
      orderNum: json['order_num'],
      title: json['title'],
      rewrittenText: json['rewritten_text'],
      unlocked: json['unlocked'] ?? false,
    );
  }

  @override
  List<Object> get props => [orderNum, title, rewrittenText];

  ChapterDetail copyWith({int? orderNum, String? title, String? rewrittenText, bool? unlocked}) {
    return ChapterDetail(
      orderNum: orderNum ?? this.orderNum,
      title: title ?? this.title,
      rewrittenText: rewrittenText ?? this.rewrittenText,
      unlocked: unlocked ?? this.unlocked,
    );
  }
}
