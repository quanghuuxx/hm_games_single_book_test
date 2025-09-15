// Flutter project by quanghuuxx (quanghuuxx@gmail.com)

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int coins;

  const User({required this.coins});

  User copyWith({
    int? coins,
  }) {
    return User(
      coins: coins ?? this.coins,
    );
  }

  @override
  List<Object> get props => [coins];
}
