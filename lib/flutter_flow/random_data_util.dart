import 'dart:math';

import 'package:flutter/material.dart';

final _random = Random();

int randomInteger(int min, int max) {
  return _random.nextInt(max - min + 1) + min;
}

double randomDouble(double min, double max) {
  return _random.nextDouble() * (max - min) + min;
}

String randomString(
  int minLength,
  int maxLength,
  bool lowercaseAz,
  bool uppercaseAz,
  bool digits,
) {
  var chars = '';
  if (lowercaseAz) {
    chars += 'abcdefghijklmnopqrstuvwxyz';
  }
  if (uppercaseAz) {
    chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  }
  if (digits) {
    chars += '0123456789';
  }
  return List.generate(randomInteger(minLength, maxLength),
      (index) => chars[_random.nextInt(chars.length)]).join();
}

DateTime randomDate() {
  return DateTime.fromMillisecondsSinceEpoch(
      randomInteger(0, 1735689600) * 1000);
}

String randomImageUrl(int width, int height) {
  return 'https://picsum.photos/seed/${_random.nextInt(1000)}/$width/$height';
}

Color randomColor() {
  return Color.fromARGB(
      255, _random.nextInt(255), _random.nextInt(255), _random.nextInt(255));
}
