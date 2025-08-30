T? findMax<T extends Comparable<T>>(List<T> list) {
  if (list.isEmpty) return null;

  T max = list.first;
  for (int i = 1; i < list.length; i++) {
    if (list[i].compareTo(max) > 0) {
      max = list[i];
    }
  }
  return max;
}

void main() {
  // Implement a method, returning the maximum element from a `Comparable` list.
  // You must use generics to allow different types usage with that method.

  // Test with integers
  List<int> numbers = [3, 7, 2, 9, 1];
  print('Numbers: $numbers');
  print('Max number: ${findMax(numbers)}');
  print('');

  // Test with strings
  List<String> words = ['apple', 'zebra', 'banana', 'cherry'];
  print('Words: $words');
  print('Max word: ${findMax(words)}');
  print('');

  // Test with doubles
  List<double> decimals = [3.14, 2.71, 1.41, 9.81];
  print('Decimals: $decimals');
  print('Max decimal: ${findMax(decimals)}');
  print('');

  // Test with empty list
  List<int> empty = [];
  print('Empty list: $empty');
  print('Max from empty: ${findMax(empty)}');
}
