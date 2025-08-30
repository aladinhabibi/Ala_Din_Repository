extension DateTimeFormatting on DateTime {
  String toFormattedString() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return '${year}.${twoDigits(month)}.${twoDigits(day)} '
        '${twoDigits(hour)}:${twoDigits(minute)}:${twoDigits(second)}';
  }
}

void main() {
  // Implement an extension on [DateTime], returning a [String] in format of
  // `YYYY.MM.DD hh:mm:ss` (e.g. `2023.01.01 00:00:00`).

  var now = DateTime.now();
  print('Current time: ${now.toFormattedString()}');

  var specificDate = DateTime(2023, 1, 1, 0, 0, 0);
  print('New Year: ${specificDate.toFormattedString()}');

  var anotherDate = DateTime(2024, 12, 25, 15, 30, 45);
  print('Christmas: ${anotherDate.toFormattedString()}');
}
