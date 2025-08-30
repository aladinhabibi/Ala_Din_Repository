import 'dart:io' if (dart.library.html) 'dart:html' as platform;

abstract class CustomDateTime {
  int get microseconds;
  DateTime get dateTime;

  factory CustomDateTime.now() {
    if (platform.Platform?.isAndroid == true ||
        platform.Platform?.isIOS == true ||
        platform.Platform?.isLinux == true ||
        platform.Platform?.isMacOS == true ||
        platform.Platform?.isWindows == true) {
      return NativeDateTime.now();
    } else {
      return WebDateTime.now();
    }
  }
}

class NativeDateTime implements CustomDateTime {
  final DateTime _dateTime;
  final int _microseconds;

  NativeDateTime._(this._dateTime, this._microseconds);

  factory NativeDateTime.now() {
    final now = DateTime.now();
    // Native platforms can access higher precision
    final microseconds = now.microsecondsSinceEpoch % 1000;
    return NativeDateTime._(now, microseconds);
  }

  @override
  int get microseconds => _microseconds;

  @override
  DateTime get dateTime => _dateTime;

  @override
  String toString() =>
      'NativeDateTime(${_dateTime.toIso8601String()}.${_microseconds.toString().padLeft(3, '0')})';
}

class WebDateTime implements CustomDateTime {
  final DateTime _dateTime;
  final int _microseconds;

  WebDateTime._(this._dateTime, this._microseconds);

  factory WebDateTime.now() {
    final now = DateTime.now();
    // Web platform has limited precision, simulate microseconds
    final microseconds = (now.millisecond * 1000) + (now.millisecond % 10);
    return WebDateTime._(now, microseconds % 1000);
  }

  @override
  int get microseconds => _microseconds;

  @override
  DateTime get dateTime => _dateTime;

  @override
  String toString() =>
      'WebDateTime(${_dateTime.toIso8601String()}.${_microseconds.toString().padLeft(3, '0')})';
}

void main() {
  // Create a native and web implementations for a custom [DateTime], supporting
  // microseconds. Use conditional compilation to export the class for general
  // use on any platform.

  print('Creating CustomDateTime instances:');

  for (int i = 0; i < 3; i++) {
    final customDateTime = CustomDateTime.now();
    print('Instance $i: $customDateTime');
    print('  DateTime: ${customDateTime.dateTime}');
    print('  Microseconds: ${customDateTime.microseconds}');
    print('');

    // Small delay to show different timestamps
    Future.delayed(Duration(milliseconds: 10));
  }
}
