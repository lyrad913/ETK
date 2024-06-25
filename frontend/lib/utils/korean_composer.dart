import 'package:logger/logger.dart';

class KoreanComposer {
  static const int _baseCode = 0xAC00;
  static const int _choseongBase = 0x1100;
  static const int _jungseongBase = 0x1161;
  static const int _jongseongBase = 0x11A7;
  static const int _numJungseong = 21;
  static const int _numJongseong = 28;
  static final logger = Logger();

  // static int _composeSyllable(int choseong, int jungseong, int? jongseong) {
  //   return _baseCode +
  //       (choseong - _choseongBase) * _numJungseong * _numJongseong +
  //       (jungseong - _jungseongBase) * _numJongseong +
  //       (jongseong == null ? 0 : jongseong - _jongseongBase);
  // }

  static String combine(String text) {
    final List<int> chars = text.runes.toList();
    if (chars.isEmpty) return text;

    final List<int> result = [];
    int? choseong;
    int? jungseong;
    int? jongseong;

    for (final char in chars) {
      if (_isChoseong(char)) {
        // 이미 초성, 중성, 종성이 있는 경우 현재 음절을 완성하여 result에 추가
        if (choseong != null && jungseong != null) {
          result.add(_composeSyllable(choseong, jungseong, jongseong));
          choseong = char;
          jungseong = null;
          jongseong = null;
        } else {
          if (choseong != null) {
            result.add(choseong);
          }
          choseong = char;
        }
      } else if (_isJungseong(char)) {
        if (choseong != null) {
          if (jungseong != null) {
            // 이미 중성이 있는 경우 음절을 완성하고 새로운 중성을 시작
            result.add(_composeSyllable(choseong, jungseong, jongseong));
            choseong = null;
          }
          jungseong = char;
        } else {
          result.add(char);
        }
      } else if (_isJongseong(char)) {
        if (choseong != null && jungseong != null) {
          if (jongseong != null) {
            // 이미 종성이 있는 경우 음절을 완성하고 새로운 종성을 시작
            result.add(_composeSyllable(choseong, jungseong, jongseong));
            choseong = null;
            jungseong = null;
          }
          jongseong = char;
        } else {
          result.add(char);
        }
      } else {
        if (choseong != null && jungseong != null) {
          result.add(_composeSyllable(choseong, jungseong, jongseong));
          choseong = null;
          jungseong = null;
          jongseong = null;
        } else if (choseong != null) {
          result.add(choseong);
        } else if (jungseong != null) {
          result.add(jungseong);
        }
        result.add(char);
      }
    }

    // 마지막 남은 음절을 결과에 추가
    if (choseong != null && jungseong != null) {
      result.add(_composeSyllable(choseong, jungseong, jongseong));
    } else if (choseong != null) {
      result.add(choseong);
    } else if (jungseong != null) {
      result.add(jungseong);
    }

    return String.fromCharCodes(result);
  }

  static int _composeSyllable(int choseong, int jungseong, int? jongseong) {
    return _baseCode +
        (choseong - _choseongBase) * _numJungseong * _numJongseong +
        (jungseong - _jungseongBase) * _numJongseong +
        (jongseong == null ? 0 : jongseong - _jongseongBase);
  }

  static bool _isChoseong(int char) =>
      _choseongBase <= char && char < _choseongBase + 19;

  static bool _isJungseong(int char) =>
      _jungseongBase <= char && char < _jungseongBase + _numJungseong;

  static bool _isJongseong(int char) =>
      _jongseongBase <= char && char < _jongseongBase + _numJongseong;

  static bool _isHangul(int char) =>
      _baseCode <= char && char < _baseCode + 11172;
}
