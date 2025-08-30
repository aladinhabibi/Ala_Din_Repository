Step 0: Become familiar with Dart basics
========================================

**Estimated time**: 1 day

Read and firmly study the [Dart Overview], provided by the [Dart] team. Learn about the language basics (syntax, types, functions, classes, asynchronous programming).

Be sure to check out the [Effective Dart] guidelines for writing consistent [Dart] code.

Investigate the [Core Libraries] available in [Dart], and learn how to enable [Dart Packages] and dependencies to use in your [Dart] project. You may explore the [pub.dev] for community made packages.

To practice the theory you may pass the [Dart Cheatsheet].




## Questions

After completing the steps above, you should be able to answer (and understand why) the following questions:

- **What runtime [Dart] has? Does it use a GC (garbage collector)?**
  - Dart runs on the Dart VM (native) and compiles to JavaScript for the web. Memory is managed automatically with a generational garbage collector (young/old spaces).

- **What is [Dart] VM? How [Dart] works natively and in a browser, and why?**
  - Dart VM is a virtual machine that executes Dart with JIT during development (hot reload) and supports AOT-compiled native code in release. In browsers, Dart is compiled to JavaScript (via dart2js/DDC) because browsers don't ship a Dart VM.

- **What is JIT and AOT compilation? Which one [Dart] supports?**
  - JIT compiles at runtime (fast iteration, slower startup). AOT compiles ahead of time to machine code (fast startup, smaller, predictable). Dart supports both: JIT for dev; AOT for release/native. For web, Dart AOT-compiles to JS for production.

- **What statically typing means? What is a benefit of using it?**
  - Types are checked at compile time (sound null safety). Benefits: earlier error detection, better tooling/autocomplete, safer refactors, and more optimizable code.

- **What memory model [Dart] has? Is it single-threaded or multiple-threaded?**
  - Per-isolate heaps with no shared mutable state; isolates communicate via message passing. Each isolate has a single-threaded event loop, but multiple isolates can run in parallel on multiple cores.

- **Does [Dart] have asynchronous programming? Parallel programming?**
  - Yes: async/await, Futures, and Streams for asynchronous (non-blocking) code. Parallelism via isolates (including Flutter's compute), which can run concurrently across cores.

- **Is [Dart] OOP language? Does it have an inheritance?**
  - Yes: class-based OOP with single inheritance, mixins, abstract classes, implicit interfaces (implements), and extension methods.

Once you're done, notify your mentor/lead in the appropriate [PR (pull request)][PR] (checkmark this step in [README](../README.md)), and he will examine what you have learned.




[Core Libraries]: https://dart.dev/guides/libraries
[Dart]: https://dart.dev
[Dart Cheatsheet]: https://dart.dev/codelabs/dart-cheatsheet
[Dart Overview]: https://dart.dev/overview
[Dart Packages]: https://dart.dev/guides/packages
[Effective Dart]: https://dart.dev/guides/language/effective-dart
[PR]: https://help.github.com/articles/github-glossary#pull-request
[pub.dev]: https://pub.dev
