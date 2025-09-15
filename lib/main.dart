// Flutter project by quanghuuxx (quanghuuxx@gmail.com)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quangth_hm_game_test/reading/view/reading_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ReadingScreen());
  }
}
