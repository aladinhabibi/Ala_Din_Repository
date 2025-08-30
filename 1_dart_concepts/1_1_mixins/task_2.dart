abstract class TextElement {
  final String content;
  TextElement(this.content);

  @override
  String toString() => '${runtimeType}(\'$content\')';
}

class Text extends TextElement {
  Text(super.content);
}

class Link extends TextElement {
  Link(super.content);
}

extension LinkParser on String {
  List<TextElement> parseLinks() {
    // Regex to match URLs 
    final urlRegex = RegExp(
      r'(?:https?://)?(?:www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(?:\.[a-zA-Z]{2,})?(?:/[^\s]*)?',
    );

    List<TextElement> result = [];
    int lastEnd = 0;

    for (final match in urlRegex.allMatches(this)) {
      
      // Add text before the link
      if (match.start > lastEnd) {
        final textBefore = substring(lastEnd, match.start);
        if (textBefore.isNotEmpty) {
          result.add(Text(textBefore));
        }
      }

      // Add the link
      result.add(Link(match.group(0)!));
      lastEnd = match.end;
    }

    // Add remaining text after the last link
    if (lastEnd < length) {
      final textAfter = substring(lastEnd);
      if (textAfter.isNotEmpty) {
        result.add(Text(textAfter));
      }
    }

    // If no links found, return the entire string as text
    if (result.isEmpty) {
      result.add(Text(this));
    }

    return result;
  }
}

void main() {
  // Implement an extension on [String], parsing links from a text.
  //
  // Extension should return a [List] of texts and links, e.g.:
  // - `Hello, google.com, yay` ->
  //   [Text('Hello, '), Link('google.com'), Text(', yay')].

  final text1 = 'Hello, google.com, yay';
  print('Input: "$text1"');
  print('Output: ${text1.parseLinks()}');
  print('');

  final text2 = 'Visit https://dart.dev and www.flutter.dev for more info!';
  print('Input: "$text2"');
  print('Output: ${text2.parseLinks()}');
  print('');

  final text3 = 'No links here, just plain text.';
  print('Input: "$text3"');
  print('Output: ${text3.parseLinks()}');
  print('');

  final text4 = 'github.com is great, also check stackoverflow.com/questions';
  print('Input: "$text4"');
  print('Output: ${text4.parseLinks()}');
}
