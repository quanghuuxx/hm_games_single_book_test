// Flutter project by quanghuuxx (quanghuuxx@gmail.com)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quangth_hm_game_test/shared/user_provider.dart';

class UnlockChapterBottomSheet extends ConsumerWidget {
  const UnlockChapterBottomSheet({super.key, required this.onUnlock});

  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 24),
          Text(
            'Chapter is locked, unlock this chapter with',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 24),
          Text.rich(
            TextSpan(
              text: '30',
              children: [TextSpan(text: ' coins', style: TextStyle(fontSize: 18, color: Colors.grey))],
              style: TextStyle(fontSize: 24),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: Colors.blueAccent,
              fixedSize: Size.fromHeight(56),
            ),

            onPressed: onUnlock,
            child: Text('Unlock', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          SizedBox(height: 16),
          Text.rich(
            TextSpan(
              text: 'Balance ',
              children: [
                TextSpan(
                  text: ref.watch(userProvider).coins.toString().padLeft(2, '0'),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' coins', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
