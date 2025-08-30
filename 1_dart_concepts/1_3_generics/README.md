Step 1.3: Generics
==================

**Estimated time**: 1 day

[Generics][1] represent the main form of [parametric polymorphism][2] in [Dart], allowing a single piece of code to be given a "generic" type, using variables in place of actual types, and then instantiated with particular types as needed.

> Generic types can save you the trouble of creating all these interfaces. Instead, you can create a single interface that takes a type parameter:
> ```dart
> abstract class Cache<T> {
>   T getByKey(String key);
>   void setByKey(String key, T value);
> }
> ```
> In this code, `T` is the stand-in type. It’s a placeholder that you can think of as a type that a developer will define later.

For better understanding of [generics][3] design in [Dart], their benefits and use-cases, read through the following articles:
- [Dart Docs: Generics][3]
- [Dart Tutorial: Dart Generics][4]
- [Monty Rasmussen: Generics in Dart and Flutter][5]
- [Shaiq Khan: Explore Generics In Dart & Flutter][6]




## Task

Implement a method, returning the maximum element from a `Comparable` list. You must use [generics][3] to allow different types usage with that method.




## Questions

After completing everything above, you should be able to answer (and understand why) the following questions:
- What are generics in [Dart]? Why are they useful?
- What is a type parameter? How can a type parameter be constrained?




## Answers

**What are generics in [Dart]? Why are they useful?**

Generics in Dart are a way to create reusable code that can work with different types while maintaining type safety. They use type parameters (like `T`, `E`, `K`, `V`) as placeholders for actual types that are specified when the generic is used.

Benefits of generics:
- **Type Safety**: Catch type-related errors at compile time rather than runtime
- **Code Reusability**: Write once, use with multiple types
- **Performance**: Avoid runtime type checks and casting
- **API Clarity**: Make intentions clear about what types are expected
- **IntelliSense Support**: Better IDE support with auto-completion and error detection

Example:
```dart
// Without generics - not type safe
class Box {
  dynamic value;
  Box(this.value);
}

// With generics - type safe and reusable
class Box<T> {
  T value;
  Box(this.value);
}

Box<String> stringBox = Box<String>("Hello");
Box<int> intBox = Box<int>(42);
```

**What is a type parameter? How can a type parameter be constrained?**

A type parameter is a placeholder for a type that will be specified later when the generic class, method, or function is used. Type parameters are typically represented by single uppercase letters like `T` (Type), `E` (Element), `K` (Key), `V` (Value).

Type parameters can be constrained using the `extends` keyword to limit which types can be used:

```dart
// Unconstrained type parameter
class Container<T> {
  T item;
  Container(this.item);
}

// Constrained type parameter - T must extend Comparable
T findMax<T extends Comparable<T>>(List<T> items) {
  if (items.isEmpty) throw ArgumentError('List cannot be empty');
  
  T max = items.first;
  for (T item in items) {
    if (item.compareTo(max) > 0) {
      max = item;
    }
  }
  return max;
}

// Usage examples:
findMax<int>([1, 5, 3, 9, 2]);
findMax<String>(['apple', 'banana', 'cherry']); 

Common constraint patterns:
- `T extends Object`: T must be a non-nullable type
- `T extends Comparable<T>`: T must be comparable to itself
- `T extends num`: T must be a number (int or double)
- `T extends MyBaseClass`: T must extend or implement MyBaseClass
