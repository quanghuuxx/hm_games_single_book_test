// Flutter project by quanghuuxx (quanghuuxx@gmail.com)

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

class UserProvider extends Notifier<User> {
  @override
  User build() {
    return User(coins: 335); // not enough coins to unlock last chapter
  }

  void updateCoins(int coins) {
    state = state.copyWith(coins: coins);
  }
}

final userProvider = NotifierProvider<UserProvider, User>(UserProvider.new);
